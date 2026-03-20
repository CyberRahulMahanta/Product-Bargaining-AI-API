# main.py
from fastapi import FastAPI, HTTPException, BackgroundTasks, Depends
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import JSONResponse
from typing import Optional, List
import uvicorn
from datetime import datetime
import logging
import os
from api_models import *
from api_service import BargainingAPIService
from fastapi.staticfiles import StaticFiles
from config import Config
from db_manager import DatabaseManager
from fastapi import Depends
from api_models import CreateUserRequest

db_manager = DatabaseManager()

# Configure logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

# Initialize FastAPI app
app = FastAPI(
    title="Hybrid Bargaining AI API",
    description="API for AI-powered bargaining system with Hinglish support",
    version="1.0.0"
)

# Add CORS middleware for Android app
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # In production, replace with your app's domain
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Serve the products folder at /products URL
app.mount("/products", StaticFiles(directory="products"), name="products")
print("Serving products from:", os.path.abspath("products"))
print("Files:", os.listdir("products"))
# Initialize service
service = BargainingAPIService()

from contextlib import asynccontextmanager

@asynccontextmanager
async def lifespan(app_: FastAPI):
    logger.info("Starting Bargaining AI API...")
    yield
    logger.info("Shutting down Bargaining AI API...")


# Middleware for request logging
@app.middleware("http")
async def log_requests(request, call_next):
    start_time = datetime.now()
    response = await call_next(request)
    process_time = (datetime.now() - start_time).total_seconds()
    logger.info(f"{request.method} {request.url.path} - {response.status_code} - {process_time:.3f}s")
    return response

# Health check endpoint
@app.get("/health", tags=["Health"])
async def health_check():
    """Check if API is running"""
    return {
        "status": "healthy",
        "timestamp": datetime.now().isoformat(),
        "version": "1.0.0"
    }

# User details endpoints

# 🔹 GET USER
@app.get("/user/{firebase_uid}")
def get_user(firebase_uid: str):
    user = db_manager.get_user_by_uid(firebase_uid)
    if user:
        return {
            "success": True,
            "data": user
        }
    return {
        "success": False,
        "message": "User not found"
    }

# 🔹 CREATE USER
@app.post("/user")
def create_user_api(data: CreateUserRequest):
    return service.register_user(data)

# Product endpoints
@app.get("/api/products", tags=["Products"])
async def get_products(category: Optional[str] = None):
    """Get all available products"""
    try:
        products = service.get_products(category)
        # If products are Pydantic models, convert them to dict
        products_list = [p.dict() if hasattr(p, "dict") else p for p in products]
        return JSONResponse(content=products_list)
    except Exception as e:
        logger.error(f"Error getting products: {e}")
        return JSONResponse(content=[])

@app.get("/api/products/{product_id}", response_model=ApiResponse, tags=["Products"])
async def get_product(product_id: int):
    """Get product details by ID"""
    try:
        product = service.get_product(product_id)
        return ApiResponse(
            success=True,
            message="Product found",
            data=product
        )
    except Exception as e:
        logger.error(f"Error getting product {product_id}: {e}")
        return ApiResponse(
            success=False,
            message="Product not found",
            error=str(e)
        )

# Negotiation endpoints
@app.post("/api/negotiation/start", response_model=ApiResponse, tags=["Negotiation"])
async def start_negotiation(request: StartNegotiationRequest):
    """Start a new negotiation session"""
    try:
        result = service.create_session(request.product_id, request.customer_id)
        return ApiResponse(
            success=True,
            message="Negotiation started successfully",
            data=result
        )
    except Exception as e:
        logger.error(f"Error starting negotiation: {e}")
        return ApiResponse(
            success=False,
            message="Failed to start negotiation",
            error=str(e)
        )

@app.post("/api/negotiation/message", response_model=ApiResponse, tags=["Negotiation"])
async def send_message(request: BargainRequest):
    """Send a message in the negotiation"""
    try:
        result = service.process_message(
            session_id=request.session_id,
            product_id=request.product_id,
            message=request.message
        )
        return ApiResponse(
            success=True,
            message="Message processed successfully",
            data=result
        )
    except Exception as e:
        logger.error(f"Error processing message: {e}")
        return ApiResponse(
            success=False,
            message="Failed to process message",
            error=str(e)
        )

@app.get("/api/negotiation/history/{session_id}", response_model=ApiResponse, tags=["Negotiation"])
async def get_history(session_id: str):
    """Get conversation history for a session"""
    try:
        history = service.get_conversation_history(session_id)
        return ApiResponse(
            success=True,
            message="History retrieved successfully",
            data=history
        )
    except Exception as e:
        logger.error(f"Error getting history: {e}")
        return ApiResponse(
            success=False,
            message="Failed to get history",
            error=str(e)
        )

@app.post("/api/negotiation/reset", response_model=ApiResponse, tags=["Negotiation"])
async def reset_negotiation(request: ResetNegotiationRequest):
    """Reset a negotiation session"""
    try:
        success = service.reset_session(request.session_id)
        if success:
            return ApiResponse(
                success=True,
                message="Session reset successfully"
            )
        else:
            return ApiResponse(
                success=False,
                message="Session not found"
            )
    except Exception as e:
        logger.error(f"Error resetting session: {e}")
        return ApiResponse(
            success=False,
            message="Failed to reset session",
            error=str(e)
        )

# Analytics endpoints
@app.get("/api/analytics", response_model=ApiResponse, tags=["Analytics"])
async def get_analytics(
    session_id: Optional[str] = None,
    product_id: Optional[int] = None
):
    """Get analytics data"""
    try:
        analytics = service.get_analytics(session_id, product_id)
        return ApiResponse(
            success=True,
            message="Analytics retrieved successfully",
            data=analytics
        )
    except Exception as e:
        logger.error(f"Error getting analytics: {e}")
        return ApiResponse(
            success=False,
            message="Failed to get analytics",
            error=str(e)
        )

@app.get("/api/analytics/product/{product_id}", response_model=ApiResponse, tags=["Analytics"])
async def get_product_analytics(product_id: int):
    """Get analytics for a specific product"""
    try:
        analytics = service.get_analytics(None, product_id)
        return ApiResponse(
            success=True,
            message="Product analytics retrieved successfully",
            data=analytics
        )
    except Exception as e:
        logger.error(f"Error getting product analytics: {e}")
        return ApiResponse(
            success=False,
            message="Failed to get product analytics",
            error=str(e)
        )

# Pattern management endpoints
@app.get("/api/patterns", response_model=ApiResponse, tags=["Patterns"])
async def get_patterns(pattern_type: Optional[str] = None):
    """Get negotiation patterns"""
    try:
        patterns = service.db.get_patterns(pattern_type)
        return ApiResponse(
            success=True,
            message=f"Found {len(patterns)} patterns",
            data=patterns
        )
    except Exception as e:
        logger.error(f"Error getting patterns: {e}")
        return ApiResponse(
            success=False,
            message="Failed to get patterns",
            error=str(e)
        )

@app.post("/api/patterns", response_model=ApiResponse, tags=["Patterns"])
async def add_pattern(
    pattern_type: str,
    pattern_text: str,
    response_template: str
):
    """Add a new negotiation pattern"""
    try:
        success = service.db.add_pattern(pattern_type, pattern_text, response_template)
        if success:
            return ApiResponse(
                success=True,
                message="Pattern added successfully"
            )
        else:
            return ApiResponse(
                success=False,
                message="Failed to add pattern"
            )
    except Exception as e:
        logger.error(f"Error adding pattern: {e}")
        return ApiResponse(
            success=False,
            message="Failed to add pattern",
            error=str(e)
        )

# Admin endpoints
@app.post("/api/admin/cleanup", response_model=ApiResponse, tags=["Admin"])
async def cleanup_sessions(background_tasks: BackgroundTasks):
    """Clean up expired sessions"""
    try:
        background_tasks.add_task(service.cleanup_expired_sessions)
        return ApiResponse(
            success=True,
            message="Cleanup task scheduled"
        )
    except Exception as e:
        logger.error(f"Error scheduling cleanup: {e}")
        return ApiResponse(
            success=False,
            message="Failed to schedule cleanup",
            error=str(e)
        )

@app.get("/api/admin/stats", response_model=ApiResponse, tags=["Admin"])
async def get_system_stats():
    """Get system statistics"""
    try:
        active_sessions = len(service.active_sessions)
        total_conversations = service.db.get_negotiation_stats().get('total_negotiations', 0)
        
        return ApiResponse(
            success=True,
            message="System stats retrieved",
            data={
                "active_sessions": active_sessions,
                "total_conversations": total_conversations,
                "timestamp": datetime.now().isoformat()
            }
        )
    except Exception as e:
        logger.error(f"Error getting system stats: {e}")
        return ApiResponse(
            success=False,
            message="Failed to get system stats",
            error=str(e)
        )

# Error handler
@app.exception_handler(HTTPException)
async def http_exception_handler(request, exc):
    return JSONResponse(
        status_code=exc.status_code,
        content=ApiResponse(
            success=False,
            message="HTTP Exception",
            error=str(exc.detail)
        ).model_dump()
    )
    
@app.exception_handler(Exception)
async def general_exception_handler(request, exc):
    logger.error(f"Unhandled exception: {exc}")
    return JSONResponse(
        status_code=500,
        content=ApiResponse(
            success=False,
            message="Internal server error",
            error=str(exc)
        ).model_dump()
    )

if __name__ == "__main__":
    uvicorn.run(
        "main:app",
        host="0.0.0.0",
        port=8000,
        reload=True,
        log_level="info"
    )