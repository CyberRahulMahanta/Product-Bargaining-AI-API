# api_service.py
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
        """Create a new bargaining session"""
        try:
            # Generate unique session ID
            session_id = str(uuid.uuid4())
            
            # Initialize AI
            ai = HybridBargainAI(product_id, session_id)
            
            # Store customer ID if provided
            if customer_id:
                ai.customer_fingerprint = customer_id
                ai.customer_profile = self.db.get_or_create_customer_profile(customer_id)
            
            # Store session with product info
            self.active_sessions[session_id] = {
                'ai': ai,
                'product_id': product_id,
                'created_at': datetime.now(),
                'last_active': datetime.now(),
                'customer_id': customer_id
            }
            
            # Get product info
            product = self.db.get_product(product_id)
            
            # Format product for response
            product_info = self._format_product(product)
            
            # Welcome message
            welcome = f"Namaste ji! {product['name']} ke liye ₹{product['selling_price']:,.0f} hai. Kaise madad kar sakta hoon?"
            
            return {
                'session_id': session_id,
                'conversation_id': ai.conversation_id,
                'product': product_info,
                'initial_price': float(product['selling_price']),
                'welcome_message': welcome,
                'timestamp': datetime.now().isoformat()
            }
            
        except Exception as e:
            raise Exception(f"Failed to create session: {str(e)}")
    
    def process_message(self, session_id: str, product_id: int, message: str) -> Dict[str, Any]:
        """Process a bargaining message - requires both session_id and product_id"""
        
        # Get session
        session = self._get_session(session_id)
        
        # If session doesn't exist, create a new one
        if not session:
            print(f"Session {session_id} not found, creating new session for product {product_id}")
            session_data = self.create_session(product_id)
            session_id = session_data['session_id']
            session = self._get_session(session_id)
        
        # Verify product matches
        if session['product_id'] != product_id:
            # If product doesn't match, create new session for this product
            print(f"Product mismatch: session has {session['product_id']}, request has {product_id}. Creating new session.")
            session_data = self.create_session(product_id)
            session_id = session_data['session_id']
            session = self._get_session(session_id)
        
        ai = session['ai']
        
        # Process bargaining
        status, price, response = ai.bargain(message)
        
        # Update last active
        session['last_active'] = datetime.now()
        
        # Get conversation summary
        summary = ai.get_conversation_summary()
        
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
