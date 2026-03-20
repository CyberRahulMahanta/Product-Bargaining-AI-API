# db_manager.py
import mysql.connector
from mysql.connector import pooling, Error
import json
import uuid
from datetime import datetime
from typing import Dict, List, Optional, Any, Tuple
import decimal

class DatabaseManager:
    """Advanced database manager with connection pooling"""
    
    _instance = None
    _connection_pool = None
    
    def __new__(cls):
        if cls._instance is None:
            cls._instance = super(DatabaseManager, cls).__new__(cls)
            cls._instance._initialize_pool()
        return cls._instance
    
    def _initialize_pool(self):
        """Initialize database connection pool"""
        try:
            self._connection_pool = pooling.MySQLConnectionPool(
                pool_name="bargain_pool",
                pool_size=10,
                pool_reset_session=True,
                host="localhost",
                user="root",
                password="",  # Your MySQL password
                database="bargain_ai_hybrid",
                autocommit=True
            )
            print("✅ Database connection pool initialized")
        except Error as e:
            print(f"❌ Database connection failed: {e}")
            raise
    
    def get_connection(self):
        """Get connection from pool"""
        return self._connection_pool.get_connection()
    
    # PRODUCT OPERATIONS
    def get_product(self, product_id: int) -> Optional[Dict]:
        """Get product details"""
        conn = self.get_connection()
        cursor = conn.cursor(dictionary=True)

        try:
            cursor.execute("""
                SELECT p.*,
                    (SELECT AVG(final_price) FROM conversations
                        WHERE product_id = p.id AND status = 'completed') as avg_selling_price,
                    (SELECT COUNT(*) FROM conversations
                        WHERE product_id = p.id) as total_negotiations
                FROM products p
                WHERE p.id = %s
            """, (product_id,))

            product = cursor.fetchone()

            if product:
                # Convert Decimal prices to float
                product['selling_price'] = float(product['selling_price'])
                product['min_price'] = float(product['min_price'])
                if product.get('cost_price'):
                    product['cost_price'] = float(product['cost_price'])
                if product.get('avg_selling_price'):
                    product['avg_selling_price'] = float(product['avg_selling_price'])

                if product.get('features'):
                    product['features'] = json.loads(product['features'])

            return product
            
        except Error as e:
            print(f"❌ Error getting product: {e}")
            return None
        finally:
            cursor.close()
            conn.close()
    
    def get_all_products(self) -> List[Dict]:
        """Get all products"""
        conn = self.get_connection()
        cursor = conn.cursor(dictionary=True)
        
        try:
            cursor.execute("SELECT * FROM products ORDER BY popularity_score DESC")
            products = cursor.fetchall()
            
            for product in products:
                if product.get('features'):
                    product['features'] = json.loads(product['features'])
            
            return products
            
        except Error as e:
            print(f"❌ Error getting products: {e}")
            return []
        finally:
            cursor.close()
            conn.close()
    
    # User details and authentication
    def get_user_by_uid(self, firebase_uid):
        conn = self.get_connection()
        cursor = conn.cursor(dictionary=True)

        try:
            query = "SELECT * FROM users WHERE firebase_uid = %s"
            cursor.execute(query, (firebase_uid,))
            return cursor.fetchone()

        except Error as e:
            print(f"❌ Error fetching user: {e}")
            return None

        finally:
            cursor.close()
            conn.close()

    def create_user(self, firebase_uid, name, email):
        conn = self.get_connection()
        cursor = conn.cursor()

        try:
            # check if exists
            cursor.execute("SELECT * FROM users WHERE firebase_uid = %s", (firebase_uid,))
            if cursor.fetchone():
                return True

            query = """
            INSERT INTO users (firebase_uid, name, email)
            VALUES (%s, %s, %s)
            """
            cursor.execute(query, (firebase_uid, name, email))
            conn.commit()

            return True

        except Error as e:
            print(f"❌ Error creating user: {e}")
            conn.rollback()
            return False

        finally:
            cursor.close()
            conn.close()
    
    # CONVERSATION OPERATIONS
    def create_conversation(self, session_id: str, product_id: int, initial_price: float) -> Optional[int]:
        """Start new conversation"""
        conn = self.get_connection()
        cursor = conn.cursor()
        
        try:
            cursor.execute("""
                INSERT INTO conversations 
                (session_id, product_id, initial_price, status, created_at) 
                VALUES (%s, %s, %s, 'active', NOW())
            """, (session_id, product_id, initial_price))
            
            conversation_id = cursor.lastrowid
            conn.commit()
            
            return conversation_id
            
        except Error as e:
            print(f"❌ Error creating conversation: {e}")
            conn.rollback()
            return None
        finally:
            cursor.close()
            conn.close()
    
    def add_message(self, conversation_id: int, turn_number: int, speaker: str, 
                message_text: str, extracted_price: Optional[float] = None,
                emotion: Optional[str] = None, intent: Optional[str] = None,
                used_llm: bool = False) -> bool:
        """Add message to conversation"""
        conn = self.get_connection()
        cursor = conn.cursor()
        
        try:
            cursor.execute("""
                INSERT INTO conversation_messages 
                (conversation_id, turn_number, speaker, message_text, 
                extracted_price, emotion, intent, used_llm, created_at)
                VALUES (%s, %s, %s, %s, %s, %s, %s, %s, NOW())
            """, (conversation_id, turn_number, speaker, message_text, 
                extracted_price, emotion, intent, used_llm))
            
            # Update conversation turn count
            cursor.execute("""
                UPDATE conversations 
                SET turns_count = %s 
                WHERE id = %s
            """, (turn_number, conversation_id))
            
            conn.commit()
            return True
            
        except Error as e:
            print(f"❌ Error adding message: {e}")
            conn.rollback()
            return False
        finally:
            cursor.close()
            conn.close()
    
    def complete_conversation(self, conversation_id: int, final_price: float, 
                            status: str = 'completed') -> bool:
        """Mark conversation as completed"""
        conn = self.get_connection()
        cursor = conn.cursor()
        
        try:
            cursor.execute("""
                UPDATE conversations 
                SET final_price = %s, status = %s, ended_at = NOW(),
                    duration_seconds = TIMESTAMPDIFF(SECOND, created_at, NOW())
                WHERE id = %s
            """, (final_price, status, conversation_id))
            
            conn.commit()
            return True
            
        except Error as e:
            print(f"❌ Error completing conversation: {e}")
            conn.rollback()
            return False
        finally:
            cursor.close()
            conn.close()
    
    def get_conversation_history(self, conversation_id: int) -> List[Dict]:
        """Get conversation history"""
        conn = self.get_connection()
        cursor = conn.cursor(dictionary=True)
        
        try:
            cursor.execute("""
                SELECT * FROM conversation_messages 
                WHERE conversation_id = %s 
                ORDER BY turn_number
            """, (conversation_id,))
            
            return cursor.fetchall()
            
        except Error as e:
            print(f"❌ Error getting conversation history: {e}")
            return []
        finally:
            cursor.close()
            conn.close()
    
    # NEGOTIATION PATTERNS
    def get_patterns(self, pattern_type: Optional[str] = None) -> List[Dict]:
        """Get negotiation patterns"""
        conn = self.get_connection()
        cursor = conn.cursor(dictionary=True)
        
        try:
            if pattern_type:
                cursor.execute("""
                    SELECT * FROM negotiation_patterns 
                    WHERE pattern_type = %s AND is_active = TRUE
                    ORDER BY success_rate DESC
                """, (pattern_type,))
            else:
                cursor.execute("""
                    SELECT * FROM negotiation_patterns 
                    WHERE is_active = TRUE 
                    ORDER BY success_rate DESC
                """)
            
            return cursor.fetchall()
            
        except Error as e:
            print(f"❌ Error getting patterns: {e}")
            return []
        finally:
            cursor.close()
            conn.close()
    
    def update_pattern_success(self, pattern_id: int, success: bool) -> bool:
        """Update pattern success rate"""
        conn = self.get_connection()
        cursor = conn.cursor()
        
        try:
            # Get current values
            cursor.execute("""
                SELECT use_count, success_rate FROM negotiation_patterns 
                WHERE id = %s
            """, (pattern_id,))
            
            result = cursor.fetchone()
            if not result:
                return False
            
            use_count, success_rate = result
            
            # Update success rate using Bayesian average
            new_use_count = use_count + 1
            success_value = 1 if success else 0
            new_success_rate = ((success_rate * use_count) + success_value) / new_use_count
            
            cursor.execute("""
                UPDATE negotiation_patterns 
                SET use_count = %s, success_rate = %s, last_used = NOW()
                WHERE id = %s
            """, (new_use_count, new_success_rate, pattern_id))
            
            conn.commit()
            return True
            
        except Error as e:
            print(f"❌ Error updating pattern: {e}")
            conn.rollback()
            return False
        finally:
            cursor.close()
            conn.close()
    
    def add_pattern(self, pattern_type: str, pattern_text: str, 
                response_template: str) -> bool:
        """Add new negotiation pattern"""
        conn = self.get_connection()
        cursor = conn.cursor()
        
        try:
            cursor.execute("""
                INSERT INTO negotiation_patterns 
                (pattern_type, pattern_text, response_template, created_at)
                VALUES (%s, %s, %s, NOW())
            """, (pattern_type, pattern_text, response_template))
            
            conn.commit()
            return True
            
        except Error as e:
            print(f"❌ Error adding pattern: {e}")
            conn.rollback()
            return False
        finally:
            cursor.close()
            conn.close()
    
    # LLM USAGE TRACKING
    def log_llm_usage(self, conversation_id: int, turn_number: int, 
                    provider: str, model: str, prompt_tokens: int = None,
                    completion_tokens: int = None, cost: float = None,
                    response_time_ms: int = None, success: bool = True,
                    error_message: str = None) -> bool:
        """Log LLM API usage"""
        conn = self.get_connection()
        cursor = conn.cursor()
        
        try:
            cursor.execute("""
                INSERT INTO llm_usage 
                (conversation_id, turn_number, provider, model, 
                prompt_tokens, completion_tokens, cost, response_time_ms,
                success, error_message, created_at)
                VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, NOW())
            """, (conversation_id, turn_number, provider, model,
                prompt_tokens, completion_tokens, cost, response_time_ms,
                success, error_message))
            
            conn.commit()
            return True
            
        except Error as e:
            print(f"❌ Error logging LLM usage: {e}")
            conn.rollback()
            return False
        finally:
            cursor.close()
            conn.close()
    
    # ANALYTICS
    def get_negotiation_stats(self, product_id: Optional[int] = None) -> Dict:
        """Get negotiation statistics"""
        conn = self.get_connection()
        cursor = conn.cursor(dictionary=True)
        
        try:
            if product_id:
                cursor.execute("""
                    SELECT 
                        COUNT(*) as total_negotiations,
                        SUM(CASE WHEN status = 'completed' THEN 1 ELSE 0 END) as successful_deals,
                        AVG(final_price) as avg_final_price,
                        AVG(turns_count) as avg_turns,
                        AVG(duration_seconds) as avg_duration
                    FROM conversations 
                    WHERE product_id = %s
                """, (product_id,))
            else:
                cursor.execute("""
                    SELECT 
                        COUNT(*) as total_negotiations,
                        SUM(CASE WHEN status = 'completed' THEN 1 ELSE 0 END) as successful_deals,
                        AVG(final_price) as avg_final_price,
                        AVG(turns_count) as avg_turns,
                        AVG(duration_seconds) as avg_duration
                    FROM conversations
                """)
            
            return cursor.fetchone() or {}
            
        except Error as e:
            print(f"❌ Error getting stats: {e}")
            return {}
        finally:
            cursor.close()
            conn.close()
    
    def get_llm_usage_stats(self) -> Dict:
        """Get LLM usage statistics"""
        conn = self.get_connection()
        cursor = conn.cursor(dictionary=True)
        
        try:
            cursor.execute("""
                SELECT 
                    provider,
                    model,
                    COUNT(*) as total_calls,
                    SUM(CASE WHEN success = TRUE THEN 1 ELSE 0 END) as successful_calls,
                    AVG(response_time_ms) as avg_response_time,
                    SUM(cost) as total_cost
                FROM llm_usage 
                GROUP BY provider, model
            """)
            
            return cursor.fetchall()
            
        except Error as e:
            print(f"❌ Error getting LLM stats: {e}")
            return []
        finally:
            cursor.close()
            conn.close()
    
    # CUSTOMER PROFILES
    def get_or_create_customer_profile(self, fingerprint: str) -> Dict:
        """Get or create customer profile"""
        conn = self.get_connection()
        cursor = conn.cursor(dictionary=True)
        
        try:
            cursor.execute("""
                SELECT * FROM customer_profiles 
                WHERE fingerprint = %s
            """, (fingerprint,))
            
            profile = cursor.fetchone()
            
            if not profile:
                cursor.execute("""
                    INSERT INTO customer_profiles (fingerprint, created_at)
                    VALUES (%s, NOW())
                """, (fingerprint,))
                
                profile_id = cursor.lastrowid
                conn.commit()
                
                cursor.execute("SELECT * FROM customer_profiles WHERE id = %s", (profile_id,))
                profile = cursor.fetchone()
            
            return profile
            
        except Error as e:
            print(f"❌ Error getting customer profile: {e}")
            return {}
        finally:
            cursor.close()
            conn.close()
    
    def update_customer_profile(self, fingerprint: str, success: bool) -> bool:
        """Update customer profile after negotiation"""
        conn = self.get_connection()
        cursor = conn.cursor()
        
        try:
            cursor.execute("""
                UPDATE customer_profiles 
                SET total_negotiations = total_negotiations + 1,
                    successful_negotiations = successful_negotiations + %s,
                    last_seen = NOW()
                WHERE fingerprint = %s
            """, (1 if success else 0, fingerprint))
            
            conn.commit()
            return True
            
        except Error as e:
            print(f"❌ Error updating customer profile: {e}")
            conn.rollback()
            return False
        finally:
            cursor.close()
            conn.close()