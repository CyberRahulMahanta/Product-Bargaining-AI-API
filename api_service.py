# api_service.py
from flask import session

from hybrid_bargain_ai import HybridBargainAI
from db_manager import DatabaseManager
from typing import Dict, Optional, List, Any
import uuid
from datetime import datetime
import json

class BargainingAPIService:
    """Service layer for Bargaining API"""
    
    def __init__(self):
        self.db = DatabaseManager()
        self.active_sessions: Dict[str, Dict[str, Any]] = {}
        self.session_timeout = 3600  # 1 hour timeout
        
    def create_session(self, product_id: int, customer_id: Optional[str] = None) -> Dict[str, Any]:
        try:
            print("\n========== CREATE SESSION START ==========")
            print(f"DEBUG product_id: {product_id}")
            print(f"DEBUG customer_id: {customer_id}")

            session_id = str(uuid.uuid4())
            print(f"DEBUG generated session_id: {session_id}")

            ai = HybridBargainAI(product_id, session_id)
            print("DEBUG HybridBargainAI initialized successfully")

            if customer_id:
                ai.customer_fingerprint = customer_id
                ai.customer_profile = self.db.get_or_create_customer_profile(customer_id)
                print(f"DEBUG customer profile loaded: {ai.customer_profile}")
            else:
                print("DEBUG customer_id not provided, skipping customer profile")

            product = self.db.get_product(product_id)
            print(f"DEBUG fetched product: {product}")

            if not product:
                raise Exception(f"Product not found for product_id={product_id}")

            product_info = self._format_product(product)
            print(f"DEBUG formatted product_info: {product_info}")

            conversation_id = self.db.create_conversation(
                session_id=session_id,
                product_id=product_id,
                initial_price=product['selling_price']
            )
            print(f"DEBUG conversation_id created: {conversation_id}")

            if not conversation_id:
                raise Exception("Conversation not created in database")

            ai.conversation_id = conversation_id
            print(f"DEBUG ai.conversation_id set to: {ai.conversation_id}")

            self.active_sessions[session_id] = {
                'ai': ai,
                'product_id': product_id,
                'created_at': datetime.now(),
                'last_active': datetime.now(),
                'customer_id': customer_id
            }
            print(f"DEBUG session stored in active_sessions: {session_id}")

            welcome = (
                f"Namaste ji! {product['name']} ke liye ₹{product['selling_price']:,.0f} hai. "
                f"Kaise madad kar sakta hoon?"
            )
            print(f"DEBUG welcome message: {welcome}")

            saved = self.db.add_message(
                conversation_id=conversation_id,
                turn_number=1,
                speaker="shopkeeper",
                message_text=welcome,
                extracted_price=float(product['selling_price']),
                intent="welcome"
            )
            print(f"DEBUG welcome message saved result: {saved}")

            if not saved:
                raise Exception("Welcome message not saved in database")

            ai.turn_count = 1
            print(f"DEBUG ai.turn_count set to: {ai.turn_count}")

            response_data = {
                'session_id': session_id,
                'conversation_id': conversation_id,
                'product': product_info,
                'initial_price': float(product['selling_price']),
                'welcome_message': welcome,
                'timestamp': datetime.now().isoformat()
            }

            print(f"DEBUG create_session response: {response_data}")
            print("========== CREATE SESSION SUCCESS ==========\n")

            return response_data

        except Exception as e:
            print("========== CREATE SESSION ERROR ==========")
            print(f"ERROR in create_session: {str(e)}")
            print("==========================================\n")
            raise Exception(f"Failed to create session: {str(e)}")
    
    def process_message(self, session_id: str, product_id: int, message: str) -> Dict[str, Any]:

        session = self._get_session(session_id)

        if not session:
            raise Exception("Session expired. Please restart negotiation.")

        if session['product_id'] != product_id:
            raise Exception("Product mismatch. Restart negotiation.")

        ai = session['ai']

        if not ai.conversation_id:
            raise Exception("Conversation ID missing")

        print("\n========== PROCESS MESSAGE START ==========")
        print(f"DEBUG message: {message}")

        # 👉 ONLY AI processes (NO DB SAVE HERE)
        status, price, response = ai.bargain(message)

        print(f"DEBUG AI response: {response}")
        print(f"DEBUG price: {price}")
        print(f"DEBUG status: {status}")

        # 👉 TURN NUMBER
        current_turn = ai.turn_count

        # ✅ SAVE CUSTOMER MESSAGE (ONCE)
        self.db.add_message(
            conversation_id=ai.conversation_id,
            turn_number=current_turn,
            speaker="customer",
            message_text=message,
            extracted_price=getattr(ai, "last_extracted_price", None),
            emotion=getattr(ai, "last_emotion", None),
            intent=getattr(ai, "last_intent", None)
        )

        # ✅ SAVE SHOPKEEPER MESSAGE (ONCE)
        self.db.add_message(
            conversation_id=ai.conversation_id,
            turn_number=current_turn,
            speaker="shopkeeper",
            message_text=response,
            extracted_price=float(price) if price else None,
            intent=status.lower() if status else None
        )

        session['last_active'] = datetime.now()

        # ✅ SAVE FINAL DEAL
        if status in ["ACCEPT", "REJECT", "WALK_AWAY"]:
            print("DEBUG saving final conversation result")

            self.db.complete_conversation(
                conversation_id=ai.conversation_id,
                final_price=float(price),
                status="completed" if status == "ACCEPT" else "failed"
            )

        print("========== PROCESS MESSAGE END ==========\n")

        return {
            'session_id': session_id,
            'conversation_id': ai.conversation_id,
            'turn_number': ai.turn_count,
            'shopkeeper_message': response,
            'current_price': float(price),
            'status': status,
            'patience': ai.patience,
            'strategy': ai.strategy,
            'customer_personality': ai.customer_personality.value if ai.customer_personality else 'unknown',
            'used_llm': getattr(ai, 'last_used_llm', False),
            'timestamp': datetime.now().isoformat()
        }
    
    def get_conversation_history(self, session_id: str) -> Dict[str, Any]:
        """Get conversation history"""
        
        session = self._get_session(session_id)
        if not session:
            raise Exception("Session not found or expired")
        
        ai = session['ai']
        
        # Get history from database
        messages = self.db.get_conversation_history(ai.conversation_id)
        
        # Get product info
        product = self._format_product(ai.product)
        
        # Format messages
        formatted_messages = []
        for msg in messages:
            formatted_messages.append({
                'turn_number': msg['turn_number'],
                'speaker': msg['speaker'],
                'message': msg['message_text'],
                'extracted_price': float(msg['extracted_price']) if msg['extracted_price'] else None,
                'emotion': msg['emotion'],
                'intent': msg['intent'],
                'timestamp': msg['created_at'].isoformat() if msg['created_at'] else None
            })
        
        return {
            'session_id': session_id,
            'product': product,
            'messages': formatted_messages,
            'current_price': float(ai.current_price),
            'turns_count': ai.turn_count,
            'status': self._get_conversation_status(ai.conversation_id)
        }
    
    def get_analytics(self, session_id: Optional[str] = None, product_id: Optional[int] = None) -> Dict[str, Any]:
        """Get analytics"""
        
        if session_id:
            session = self._get_session(session_id)
            if not session:
                raise Exception("Session not found or expired")
            
            ai = session['ai']
            analytics = ai.get_analytics()
            
            # Format product stats
            product_stats = analytics.get('product_stats', {})
            formatted_stats = {
                'total_negotiations': product_stats.get('total_negotiations', 0),
                'successful_deals': product_stats.get('successful_deals', 0),
                'success_rate': (product_stats.get('successful_deals', 0) / max(product_stats.get('total_negotiations', 1), 1)) * 100,
                'avg_final_price': float(product_stats.get('avg_final_price', 0)),
                'avg_turns': float(product_stats.get('avg_turns', 0)),
                'avg_duration': float(product_stats.get('avg_duration', 0)) if product_stats.get('avg_duration') else None
            }
            
            analytics['product_stats'] = formatted_stats
            return analytics
        
        elif product_id:
            # Get product-specific stats
            stats = self.db.get_negotiation_stats(product_id)
            product = self.db.get_product(product_id)
            
            return {
                'product_id': product_id,
                'product_name': product['name'] if product else 'Unknown',
                'product_stats': {
                    'total_negotiations': stats.get('total_negotiations', 0),
                    'successful_deals': stats.get('successful_deals', 0),
                    'success_rate': (stats.get('successful_deals', 0) / max(stats.get('total_negotiations', 1), 1)) * 100,
                    'avg_final_price': float(stats.get('avg_final_price', 0)),
                    'avg_turns': float(stats.get('avg_turns', 0)),
                    'avg_duration': float(stats.get('avg_duration', 0)) if stats.get('avg_duration') else None
                },
                'llm_usage': self.db.get_llm_usage_stats()
            }
        
        else:
            # Get overall stats
            stats = self.db.get_negotiation_stats()
            products = self.db.get_all_products()
            
            return {
                'overall_stats': {
                    'total_negotiations': stats.get('total_negotiations', 0),
                    'successful_deals': stats.get('successful_deals', 0),
                    'success_rate': (stats.get('successful_deals', 0) / max(stats.get('total_negotiations', 1), 1)) * 100,
                    'avg_final_price': float(stats.get('avg_final_price', 0)),
                    'avg_turns': float(stats.get('avg_turns', 0)),
                    'total_products': len(products)
                },
                'llm_usage': self.db.get_llm_usage_stats()
            }
    
    def get_products(self, category: Optional[str] = None) -> List[Dict[str, Any]]:
        """Get all products"""
        products = self.db.get_all_products()
        
        # Filter by category if specified
        if category:
            products = [p for p in products if p.get('category', '').lower() == category.lower()]
        
        # Format products
        formatted_products = []
        for product in products:
            formatted_products.append(self._format_product(product))
        
        return formatted_products
    
    def get_product(self, product_id: int) -> Dict[str, Any]:
        """Get single product"""
        product = self.db.get_product(product_id)
        if not product:
            raise Exception(f"Product {product_id} not found")
        
        return self._format_product(product)
    
    def reset_session(self, session_id: str) -> bool:
        """Reset a session"""
        if session_id in self.active_sessions:
            del self.active_sessions[session_id]
            return True
        return False
    
    def cleanup_expired_sessions(self):
        """Clean up expired sessions"""
        now = datetime.now()
        expired = []
        
        for session_id, session in self.active_sessions.items():
            if (now - session['last_active']).total_seconds() > self.session_timeout:
                expired.append(session_id)
        
        for session_id in expired:
            del self.active_sessions[session_id]
        
        return len(expired)
    
    def _get_session(self, session_id: str) -> Optional[Dict]:
        """Get active session"""
        session = self.active_sessions.get(session_id)
        if not session:
            return None
        
        # Check timeout
        if (datetime.now() - session['last_active']).total_seconds() > self.session_timeout:
            del self.active_sessions[session_id]
            return None
        
        return session
    
    def _format_product(self, product: Dict) -> Dict[str, Any]:
        """Format product for API response"""
        features = product.get('features', [])
        if isinstance(features, str):
            try:
                features = json.loads(features)
            except:
                features = []
        
        return {
            'id': product['id'],
            'name': product['name'],
            'description': product.get('description', ''),
            'selling_price': float(product['selling_price']),
            'min_price': float(product['min_price']),
            'category': product.get('category', 'General'),
            'brand': product.get('brand', 'Premium'),
            'features': features,
            'warranty': product.get('warranty', '1 Year'),
            'stock_quantity': product.get('stock_quantity', 0),
            'image_url': product.get('image_url', ''),
            'popularity_score': float(product.get('popularity_score', 0)),
                    # NEW FIELDS
            'available_colors': product.get('available_colors'),
            'rating': float(product.get('rating', 0)) if product.get('rating') else None,
            'review_count': int(product.get('review_count', 0)) if product.get('review_count') else None
        }
    
    def _get_conversation_status(self, conversation_id: int) -> str:
        """Get conversation status from database"""
        conn = self.db.get_connection()
        cursor = conn.cursor(dictionary=True)
        
        try:
            cursor.execute("SELECT status FROM conversations WHERE id = %s", (conversation_id,))
            result = cursor.fetchone()
            return result['status'] if result else 'unknown'
        finally:
            cursor.close()
            conn.close()

    # user details and authentication
    def fetch_user(self, firebase_uid):
        user = self.db.get_user_by_uid(firebase_uid)

        if not user:
            return {"success": False, "message": "User not found"}

        return {
            "success": True,
            "data": {
                "name": user["name"],
                "email": user["email"],
                "phone": user.get("phone", ""),
                "birthday": user.get("birthday", ""),
                "address": user.get("address", ""),
                "profile_image": user.get("profile_image", "")
            }
        }

    def register_user(self, data):
        self.db.create_user(data.firebase_uid, data.name, data.email)
        return {"success": True, "message": "User created"}
