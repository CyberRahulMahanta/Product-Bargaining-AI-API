# api_models.py
from pydantic import BaseModel, Field
from typing import Optional, List, Dict, Any
from enum import Enum

class User(BaseModel):
    name: str
    email: str
    phone: str
    birthday: str
    address: str
    profile_image: str

class UserResponse(BaseModel):
    success: bool
    data: User

class CreateUserRequest(BaseModel):
    firebase_uid: str
    name: str
    email: str
    
class UserUpdate(BaseModel):
    name: str
    email: str
    phone: Optional[str] = None
    birthday: Optional[str] = None
    address: Optional[str] = None

class MessageRole(str, Enum):
    USER = "user"
    SHOPKEEPER = "shopkeeper"
    SYSTEM = "system"

class BargainRequest(BaseModel):
    """Request model for bargaining"""
    session_id: str
    product_id: int
    message: str
    customer_id: Optional[str] = None
    language: Optional[str] = "hinglish"

class BargainResponse(BaseModel):
    """Response model for bargaining"""
    session_id: str
    conversation_id: int
    turn_number: int
    shopkeeper_message: str
    current_price: float
    status: str  # COUNTER, ACCEPT, WALK_AWAY, CONTINUE
    patience: int
    strategy: str
    customer_personality: str
    used_llm: bool
    timestamp: str

class ProductInfo(BaseModel):
    """Product information model"""
    id: int
    name: str
    description: Optional[str] = None
    selling_price: float
    min_price: float
    category: str
    brand: Optional[str] = None
    features: List[str] = []
    warranty: Optional[str] = None
    stock_quantity: int
    image_url: Optional[str] = None
    popularity_score: float
    available_colors: Optional[str] = None
    rating: Optional[float] = None
    review_count: Optional[int] = None

class ConversationMessage(BaseModel):
    """Conversation message model"""
    turn_number: int
    speaker: str
    message: str
    extracted_price: Optional[float] = None
    emotion: Optional[str] = None
    intent: Optional[str] = None
    timestamp: str

class ConversationHistoryResponse(BaseModel):
    """Conversation history response"""
    session_id: str
    product: ProductInfo
    messages: List[ConversationMessage]
    current_price: float
    turns_count: int
    status: str

class NegotiationStats(BaseModel):
    """Negotiation statistics"""
    total_negotiations: int
    successful_deals: int
    success_rate: float
    avg_final_price: float
    avg_turns: float
    avg_duration: Optional[float] = None
    total_discount_given: Optional[float] = None

class AnalyticsResponse(BaseModel):
    """Analytics response"""
    conversation_summary: Dict[str, Any]
    product_stats: NegotiationStats
    llm_usage: List[Dict[str, Any]]

class StartNegotiationRequest(BaseModel):
    """Start new negotiation request"""
    product_id: int
    customer_id: Optional[str] = None
    language: Optional[str] = "hinglish"

class StartNegotiationResponse(BaseModel):
    """Start new negotiation response"""
    session_id: str
    conversation_id: int
    product: ProductInfo
    initial_price: float
    welcome_message: str
    timestamp: str

class ResetNegotiationRequest(BaseModel):
    """Reset negotiation request"""
    session_id: str

class ApiResponse(BaseModel):
    """Generic API response"""
    success: bool
    message: str
    data: Optional[Any] = None
    error: Optional[str] = None