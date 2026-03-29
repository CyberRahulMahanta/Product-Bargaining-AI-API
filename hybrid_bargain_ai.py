# hybrid_bargain_ai.py
import re
import json
import random
import decimal
import hashlib
from datetime import datetime
from typing import Dict, List, Tuple, Optional, Union, Any
from enum import Enum
from textblob import TextBlob
import requests
from db_manager import DatabaseManager

class AIProvider(Enum):
    RULE_BASED = "rule_based"
    OPENROUTER = "openrouter"
    GEMINI = "gemini"
    OPENAI = "openai"
    OLLAMA = "ollama"

class CustomerPersonality(Enum):
    AGGRESSIVE = "aggressive"
    POLITE = "polite"
    HESITANT = "hesitant"
    COMPARISON = "comparison"
    IMPULSE = "impulse"

class HybridBargainAI:
    """Complete Hybrid Bargaining AI System"""
    
    def __init__(self, product_id: int, session_id: str = None):
        self.db = DatabaseManager()
        self.product_id = product_id
        
        # Get product details
        self.product = self.db.get_product(product_id)
        if not self.product:
            raise ValueError(f"Product {product_id} not found")

        # Current state (prices are already floats from database)
        self.current_price = self.product['selling_price']
        self.min_price = self.product['min_price']
        self.cost_price = self.product.get('cost_price', self.min_price * 0.7)

        # Initialize session
        self.session_id = session_id or self.generate_session_id()
        self.conversation_id = None
        self.start_conversation()
        
        # AI Configuration
        self.use_llm = False  # Temporarily disable LLM due to API limits
        self.llm_threshold = 0.3  # Use LLM for 30% complex cases
        self.llm_provider = AIProvider.OPENROUTER  # Default provider
        
        # Customer tracking
        self.customer_fingerprint = None
        self.customer_profile = None
        self.customer_personality = CustomerPersonality.POLITE
        
        # Negotiation state
        self.turn_count = 0
        self.patience = 100
        self.concessions_made = []
        self.final_warning_given = False
        self.strategy = "friendly"
        
        # Load negotiation patterns from DB
        self.patterns = self.load_patterns()
        
        # LLM API configuration
        self.llm_config = {
            AIProvider.OPENROUTER: {
                'api_key': "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",  # Get from openrouter.ai
                'url': "https://openrouter.ai/api/v1/chat/completions",
                'model': "meta-llama/llama-3.2-3b-instruct:free",  # Free model available on OpenRouter
                'cost_per_token': 0.0000005  # Approximate cost
            },
            AIProvider.GEMINI: {
                'api_key': "AIzaSyCiNugq0PwDZI_mrkpF719z4Vh4ytdseUk",
                'url': "https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent",
                'cost_per_token': 0.0000025
            },
            AIProvider.OLLAMA: {
                'url': "http://localhost:11434/api/generate",
                'model': "llama3.2:3b",  # Local Ollama model
                'cost_per_token': 0.0  # Free, local model
            }
        }
        
        print(f"🤖 Hybrid AI Initialized: {self.product['name']}")
        print(f"💰 Price: ₹{self.current_price:,.0f} | Min: ₹{self.min_price:,.0f}")
        print(f"📊 Session: {self.session_id}")
    
    def generate_session_id(self) -> str:
        """Generate unique session ID"""
        return f"session_{int(datetime.now().timestamp())}_{random.randint(1000, 9999)}"
    
    def start_conversation(self):
        """Start new conversation in database"""
        self.conversation_id = self.db.create_conversation(
            self.session_id, 
            self.product_id, 
            self.current_price
        )
    
    def load_patterns(self) -> Dict:
        """Load negotiation patterns from database"""
        patterns = self.db.get_patterns()
        
        # Organize by type
        organized = {}
        for pattern in patterns:
            pattern_type = pattern['pattern_type']
            if pattern_type not in organized:
                organized[pattern_type] = []
            
            organized[pattern_type].append({
                'id': pattern['id'],
                'pattern': re.compile(pattern['pattern_text'], re.IGNORECASE),
                'template': pattern['response_template'],
                'success_rate': pattern['success_rate'],
                'use_count': pattern['use_count']
            })
        
        return organized
    
    def calculate_customer_fingerprint(self, user_text: str) -> str:
        """Create fingerprint for customer identification"""
        # Combine various factors for fingerprint
        fingerprint_data = f"{user_text[:50]}_{len(user_text)}_{hashlib.md5(user_text.encode()).hexdigest()[:8]}"
        return hashlib.sha256(fingerprint_data.encode()).hexdigest()[:16]
    
    def analyze_customer(self, user_text: str) -> Dict:
        """Analyze customer message and update profile"""
        
        # Create/update customer fingerprint
        self.customer_fingerprint = self.calculate_customer_fingerprint(user_text)
        self.customer_profile = self.db.get_or_create_customer_profile(self.customer_fingerprint)
        
        # Extract price
        offer = self.extract_price(user_text)
        
        # Sentiment analysis
        try:
            sentiment = TextBlob(user_text).sentiment.polarity
        except:
            sentiment = 0.0
        
        # Detect emotion
        emotion = "NEUTRAL"
        text_lower = user_text.lower()
        
        if sentiment > 0.3 or any(word in text_lower for word in ['please', 'kripya', 'shukriya']):
            emotion = "POLITE"
            self.customer_personality = CustomerPersonality.POLITE
        elif sentiment < -0.3 or any(word in text_lower for word in ['gussa', 'mahanga', 'loot']):
            emotion = "ANGRY"
            self.customer_personality = CustomerPersonality.AGGRESSIVE
        elif any(word in text_lower for word in ['sochta', 'dekhta', 'maybe']):
            emotion = "HESITANT"
            self.customer_personality = CustomerPersonality.HESITANT
        elif any(word in text_lower for word in ['market', 'online', 'amazon', 'compare']):
            emotion = "COMPARING"
            self.customer_personality = CustomerPersonality.COMPARISON
        
        # Detect intent using hardcoded patterns first
        intent = "negotiating"
        text_lower = user_text.lower()

        # Check for specific intents
        if any(word in text_lower for word in ['feature', 'features', 'kya features', 'kya hai']):
            intent = "features_query"
        elif any(word in text_lower for word in ['warranty', 'guarantee', 'kitne saal', 'kitne sal']):
            intent = "warranty_query"
        elif any(word in text_lower for word in ['bulk', 'do lene', 'multiple', 'kitne par']):
            intent = "bulk_purchase"
        elif any(word in text_lower for word in ['bye', 'nahi chahiye', 'walk away']):
            intent = "walk_away"
        elif any(word in text_lower for word in ['final', 'last price', 'last']):
            intent = "final_offer"
        elif any(word in text_lower for word in ['amazon', 'market', 'online', 'compare']):
            intent = "comparison"
        else:
            # Fall back to database patterns
            for pattern_type, patterns_list in self.patterns.items():
                for pattern_data in patterns_list:
                    if pattern_data['pattern'].search(user_text):
                        intent = pattern_type
                        break
        
        return {
            'offer': offer,
            'emotion': emotion,
            'sentiment': sentiment,
            'intent': intent,
            'personality': self.customer_personality,
            'text_length': len(user_text),
            'has_question': '?' in user_text
        }
    
    def extract_price(self, text: str) -> Optional[float]:
        """Extract price from text"""
        # Multiple pattern matching for robustness
        patterns = [
            r'₹?\s*(\d+(?:,\d+)*(?:\.\d+)?)',  # Standard ₹1000
            r'(\d+)\s*rupee',  # 1000 rupee
            r'price\s*(\d+)',  # price 1000
            r'give\s*(\d+)',   # give 1000
        ]
        
        for pattern in patterns:
            matches = re.findall(pattern, text, re.IGNORECASE)
            if matches:
                try:
                    price = float(matches[0].replace(',', ''))
                    if 0 < price < self.current_price * 5:  # Reasonable range
                        return price
                except:
                    continue
        
        return None
    
    def should_use_llm(self, analysis: Dict, user_text: str) -> bool:
        """Determine if we should use LLM for this turn"""
        
        # Always use rules for simple cases
        if analysis['intent'] in ['price_query', 'walk_away']:
            return False
        
        # Use LLM for complex cases
        complexity_score = 0
        
        # Factor 1: Text length (longer = more complex)
        if len(user_text) > 50:
            complexity_score += 0.3
        
        # Factor 2: Multiple conditions
        if 'but' in user_text.lower() or 'however' in user_text.lower():
            complexity_score += 0.2
        
        # Factor 3: Comparisons
        if analysis['personality'] == CustomerPersonality.COMPARISON:
            complexity_score += 0.2
        
        # Factor 4: Emotional complexity
        if analysis['emotion'] in ['ANGRY', 'FRUSTRATED']:
            complexity_score += 0.2
        
        # Factor 5: Questions about features
        if analysis['has_question'] and any(word in user_text.lower() for word in ['feature', 'spec', 'warranty']):
            complexity_score += 0.1
        
        # Random element to avoid patterns
        complexity_score += random.uniform(0, 0.1)
        
        return complexity_score >= self.llm_threshold
    
    def rule_based_response(self, analysis: Dict) -> Tuple[str, str, Optional[int]]:
        """Generate response using rule-based patterns"""
        
        user_text = analysis.get('context', '')
        offer = analysis['offer']
        intent = analysis['intent']
        emotion = analysis['emotion']
        
        # Find matching pattern
        matched_pattern = None
        pattern_id = None
        
        if intent in self.patterns:
            for pattern_data in self.patterns[intent]:
                if pattern_data['pattern'].search(user_text):
                    matched_pattern = pattern_data
                    pattern_id = pattern_data['id']
                    break
        
        # Calculate counter offer
        counter_offer = None
        if offer:
            counter_offer = self.calculate_counter_offer(offer, analysis)
            self.current_price = counter_offer
        
        # Generate response
        if matched_pattern:
            # Use pattern template
            if counter_offer:
                response = matched_pattern['template'].format(f"{counter_offer:,.0f}")
            else:
                response = matched_pattern['template'].format(f"{self.current_price:,.0f}")
            
            # Log pattern usage
            self.db.update_pattern_success(pattern_id, True)
            
        else:
            # Fallback responses
            if intent == 'features_query':
                features = self.product.get('features', [])
                if features:
                    features_text = ', '.join(features)
                    response = f"Bhai, isme {features_text} features hai. Bohot accha quality hai!"
                else:
                    response = "Bhai, yeh premium quality ka product hai. Sab features milte hai!"
            elif intent == 'warranty_query':
                warranty = self.product.get('warranty', '1 Year')
                response = f"Bhai, {warranty} warranty hai. Full guarantee!"
            elif intent == 'bulk_purchase':
                response = f"Bhai, bulk mein ₹{self.current_price * 0.9:,.0f} per piece de sakta hoon. Kitne chahiye?"
            elif intent == 'comparison':
                response = f"Bhai, yeh market mein best price hai. ₹{self.current_price:,.0f} se kam nahi ho sakta."
            elif intent == 'final_offer' and offer:
                if self.final_warning_given:
                    response = f"✅ Theek hai bhai! ₹{offer:,.0f} me deal!"
                else:
                    self.final_warning_given = True
                    response = f"⚠️ Bhai final bol rahe ho to ₹{self.current_price:,.0f} last price."
            elif offer:
                if counter_offer:
                    discount = float(self.product['selling_price']) - counter_offer
                    response = f"Bhai, ₹{counter_offer:,.0f} de sakta hoon. (₹{discount:,.0f} discount!)"
                else:
                    response = f"₹{self.current_price:,.0f} se kam nahi ho sakta bhai."
            else:
                response = f"Kitna de sakte ho bhai? Current price ₹{self.current_price:,.0f} hai."
        
        return response, intent, pattern_id
    
    def llm_based_response(self, analysis: Dict, conversation_history: List[Dict]) -> str:
        """Generate response using LLM API"""
        
        start_time = datetime.now()
        
        try:
            # Build prompt with context
            prompt = self.build_llm_prompt(analysis, conversation_history)
            
            # Call LLM API
            if self.llm_provider == AIProvider.OPENROUTER:
                response_text = self.call_openrouter(prompt)
            elif self.llm_provider == AIProvider.GEMINI:
                response_text = self.call_gemini(prompt)
            elif self.llm_provider == AIProvider.OLLAMA:
                response_text = self.call_ollama(prompt)
            else:
                raise ValueError(f"Unsupported provider: {self.llm_provider}")
            
            # Calculate cost and time
            response_time = (datetime.now() - start_time).total_seconds() * 1000
            estimated_tokens = len(prompt.split()) + len(response_text.split())
            cost = estimated_tokens * self.llm_config[self.llm_provider]['cost_per_token']
            
            # Log usage
            self.db.log_llm_usage(
                conversation_id=self.conversation_id,
                turn_number=self.turn_count,
                provider=self.llm_provider.value,
                model=self.llm_config[self.llm_provider]['model'],
                prompt_tokens=len(prompt.split()),
                completion_tokens=len(response_text.split()),
                cost=cost,
                response_time_ms=int(response_time),
                success=True
            )
            
            return response_text
            
        except Exception as e:
            # Log error
            self.db.log_llm_usage(
                conversation_id=self.conversation_id,
                turn_number=self.turn_count,
                provider=self.llm_provider.value,
                model=self.llm_config[self.llm_provider]['model'],
                success=False,
                error_message=str(e)
            )
            
            print(f"⚠️ LLM Error: {e}")
            # Fallback to rule-based
            return self.rule_based_response(analysis)[0]
    
    def build_llm_prompt(self, analysis: Dict, conversation_history: List[Dict]) -> str:
        """Build prompt for LLM"""
        
        history_text = "\n".join([
            f"{msg['speaker'].upper()}: {msg['message_text']}" 
            for msg in conversation_history[-5:]  # Last 5 messages
        ])
        
        prompt = f"""
        You are 'Raju', an experienced Indian shopkeeper in Delhi.
        
        PRODUCT DETAILS:
        Name: {self.product['name']}
        Brand: {self.product.get('brand', 'Premium')}
        Features: {', '.join(self.product.get('features', []))}
        Warranty: {self.product.get('warranty', '1 Year')}
        
        PRICING:
        Original Price: ₹{self.product['selling_price']:,.0f}
        Current Asking Price: ₹{self.current_price:,.0f}
        Minimum Acceptable Price: ₹{self.min_price:,.0f} (NEVER reveal this!)
        
        CUSTOMER ANALYSIS:
        Personality: {analysis['personality'].value}
        Emotion: {analysis['emotion']}
        Offer Made: {'₹' + str(analysis['offer']) if analysis['offer'] else 'None'}
        
        CONVERSATION HISTORY:
        {history_text}
        
        YOUR TASK:
        1. Respond naturally in Hinglish (Hindi + English mix)
        2. Use 'bhai', 'yaar', 'ji' appropriately
        3. If customer made an offer, counter with reasonable price
        4. Never go below ₹{self.min_price:,.0f}
        5. Be culturally authentic
        6. Keep response under 2 sentences
        
        RESPONSE ONLY (no explanations):
        """
        
        return prompt
    
    def call_openrouter(self, prompt: str) -> str:
        """Call OpenRouter API"""
        config = self.llm_config[AIProvider.OPENROUTER]
        
        headers = {
            "Authorization": f"Bearer {config['api_key']}",
            "Content-Type": "application/json",
            "HTTP-Referer": "http://localhost:3000",
            "X-Title": "Bargaining AI"
        }
        
        data = {
            "model": config['model'],
            "messages": [{"role": "user", "content": prompt}],
            "max_tokens": 150,
            "temperature": 0.7,
            "top_p": 0.8
        }
        
        response = requests.post(config['url'], headers=headers, json=data, timeout=10)
        
        if response.status_code == 200:
            result = response.json()
            return result["choices"][0]["message"]["content"]
        else:
            raise Exception(f"OpenRouter API Error: {response.status_code}")
    
    def call_gemini(self, prompt: str) -> str:
        """Call Gemini API (if you get new quota)"""
        config = self.llm_config[AIProvider.GEMINI]

        url = f"{config['url']}?key={config['api_key']}"

        data = {
            "contents": [{"parts": [{"text": prompt}]}],
            "generationConfig": {
                "temperature": 0.7,
                "maxOutputTokens": 150
            }
        }

        response = requests.post(url, json=data, timeout=10)

        if response.status_code == 200:
            result = response.json()
            return result["candidates"][0]["content"]["parts"][0]["text"]
        else:
            raise Exception(f"Gemini API Error: {response.status_code}")

    def call_ollama(self, prompt: str) -> str:
        """Call Ollama API (local, no limits)"""
        config = self.llm_config[AIProvider.OLLAMA]

        data = {
            "model": config['model'],
            "prompt": prompt,
            "stream": False,
            "options": {
                "temperature": 0.7,
                "num_predict": 150
            }
        }

        response = requests.post(config['url'], json=data, timeout=30)

        if response.status_code == 200:
            result = response.json()
            return result["response"]
        else:
            raise Exception(f"Ollama API Error: {response.status_code}")
    
    def calculate_counter_offer(self, customer_offer: float, analysis: Dict) -> float:
        """Calculate intelligent counter offer"""

        # Ensure all prices are floats
        current_price = float(self.current_price)
        min_price = float(self.min_price)
        cost_price = float(self.cost_price)
        customer_offer = float(customer_offer)

        if customer_offer >= current_price:
            return current_price

        gap = current_price - customer_offer

        # Factors influencing concession (more conservative)
        factors = {
            'patience': self.patience / 100,  # Less patience = more concession
            'personality': {
                CustomerPersonality.AGGRESSIVE: 0.05,
                CustomerPersonality.POLITE: 0.15,
                CustomerPersonality.HESITANT: 0.25,
                CustomerPersonality.COMPARISON: 0.1,
                CustomerPersonality.IMPULSE: 0.2
            }.get(analysis['personality'], 0.15),
            'turn': min(1.0, self.turn_count / 15),  # Later turns = more concession (slower progression)
            'margin': (current_price - cost_price) / current_price if current_price > 0 else 0,
            'emotion': {
                'ANGRY': 0.05,
                'POLITE': 0.15,
                'HESITANT': 0.25,
                'NEUTRAL': 0.1
            }.get(analysis['emotion'], 0.1)
        }

        # Weighted concession calculation (lower weights for conservatism)
        concession_rate = (
            0.25 * factors['personality'] +
            0.15 * factors['turn'] +
            0.15 * factors['emotion'] +
            0.15 * (1 - factors['patience']) +
            0.05 * factors['margin']
        )

        concession = gap * concession_rate

        # Limit maximum concession per turn (₹200-300 max)
        max_concession = min(300, current_price * 0.05)  # Max 5% or ₹300
        concession = min(concession, max_concession)

        new_price = current_price - concession

        # Ensure bounds (more conservative)
        new_price = max(new_price, min_price * 1.1)  # 10% above minimum
        new_price = min(new_price, current_price * 0.95)  # Max 5% drop per turn

        # Round to nearest ₹50 for more realistic pricing
        new_price = round(new_price / 50) * 50

        # Track concession
        self.concessions_made.append(current_price - new_price)

        return float(new_price)
    
    def bargain(self, user_text: str) -> Tuple[str, float, str]:
        """Main bargaining function - HYBRID SYSTEM"""
        
        self.turn_count += 1
        
        # Save customer message to DB
        analysis = self.analyze_customer(user_text)
        
        
        # Get conversation history for context
        conversation_history = self.db.get_conversation_history(self.conversation_id)
        
        # Decide: Use LLM or Rule-Based?
        use_llm = self.should_use_llm(analysis, user_text)
        
        if use_llm and self.use_llm:
            # Use LLM for complex response
            response = self.llm_based_response(analysis, conversation_history)
            used_llm = True
            provider = self.llm_provider.value
        else:
            # Use rule-based response
            response, intent, pattern_id = self.rule_based_response(analysis)
            used_llm = False
            provider = AIProvider.RULE_BASED.value
        
        # Update patience
        self.patience = max(0, self.patience - random.randint(5, 15))
        
        # Update strategy based on situation
        self.update_strategy(analysis)
        
        # Check for deal acceptance
        status = "COUNTER"
        if analysis['offer'] and analysis['offer'] >= self.current_price:
            self.current_price = analysis['offer']
            response = f"🎉 Wah bhai! Deal pakki! ₹{analysis['offer']:,.0f} me aapka!"
            status = "ACCEPT"
            
            
            # Update customer profile
            self.db.update_customer_profile(self.customer_fingerprint, success=True)
        
        # Check for walk away
        elif analysis['intent'] == 'walk_away':
            response = "Koi baat nahi bhai. Kabhi aur aana! 🙏"
            status = "WALK_AWAY"
            
            self.db.update_customer_profile(self.customer_fingerprint, success=False)
        
        
        return status, self.current_price, response
    
    def update_strategy(self, analysis: Dict):
        """Update bargaining strategy based on situation"""
        
        if self.patience < 30:
            self.strategy = "desperate"
        elif analysis['personality'] == CustomerPersonality.AGGRESSIVE:
            self.strategy = "hardball"
        elif analysis['personality'] == CustomerPersonality.COMPARISON:
            self.strategy = "value_focused"
        elif self.turn_count > 8:
            self.strategy = "time_pressure"
        else:
            self.strategy = "friendly"
    
    def get_conversation_summary(self) -> Dict:
        """Get summary of current conversation"""
        history = self.db.get_conversation_history(self.conversation_id)
        
        customer_messages = [msg for msg in history if msg['speaker'] == 'customer']
        shopkeeper_messages = [msg for msg in history if msg['speaker'] == 'shopkeeper']
        
        return {
            'session_id': self.session_id,
            'product': self.product['name'],
            'initial_price': self.product['selling_price'],
            'current_price': self.current_price,
            'min_price': self.min_price,
            'turns': self.turn_count,
            'patience': self.patience,
            'strategy': self.strategy,
            'customer_personality': self.customer_personality.value,
            'total_messages': len(history),
            'customer_messages': len(customer_messages),
            'shopkeeper_messages': len(shopkeeper_messages),
            'concessions_made': self.concessions_made,
            'final_warning_given': self.final_warning_given
        }
    
    def get_analytics(self) -> Dict:
        """Get analytics for current session"""
        stats = self.db.get_negotiation_stats(self.product_id)
        llm_stats = self.db.get_llm_usage_stats()
        
        return {
            'product_stats': stats,
            'llm_usage': llm_stats,
            'conversation_summary': self.get_conversation_summary()
        }