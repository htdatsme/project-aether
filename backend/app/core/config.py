import os
from dotenv import load_dotenv

load_dotenv()

class Settings:
    PROJECT_NAME: str = "Project Aether"
    PROJECT_VERSION: str = "0.1.0"
    
settings = Settings()
