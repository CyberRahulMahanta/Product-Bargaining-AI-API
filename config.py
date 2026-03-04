# config.py
import os
from dotenv import load_dotenv

load_dotenv()

class Config:
    # API Keys
    GOOGLE_AI_API_KEY = os.getenv("GOOGLE_AI_API_KEY", "AIzaSyCiNugq0PwDZI_mrkpF719z4Vh4ytdseUk")
    
    # Database
    DB_HOST = os.getenv("DB_HOST", "localhost")
    DB_USER = os.getenv("DB_USER", "root")
    DB_PASSWORD = os.getenv("DB_PASSWORD", "")
    DB_NAME = os.getenv("DB_NAME", "bargain_ai_advanced")
    
    # AI Settings
    AI_MODEL = os.getenv("AI_MODEL", "gemini-1.5-pro")
    DEFAULT_TEMPERATURE = float(os.getenv("DEFAULT_TEMPERATURE", "0.7"))
    MAX_CONVERSATION_TURNS = int(os.getenv("MAX_CONVERSATION_TURNS", "20"))
    
    # Bargaining Parameters
    MIN_PROFIT_MARGIN = float(os.getenv("MIN_PROFIT_MARGIN", "0.15"))
    INITIAL_PATIENCE = int(os.getenv("INITIAL_PATIENCE", "100"))