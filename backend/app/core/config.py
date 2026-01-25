import os
from dotenv import load_dotenv

# Load local .env file for development (if it exists)
load_dotenv()

class Settings:
    PROJECT_NAME: str = "Project Aether"
    PROJECT_VERSION: str = "1.0.0"
    
    # 1. Try to get secrets from Environment Variables (Dev)
    # 2. If not found, try to read from Google Cloud Secret Mounts (Prod)
    @property
    def SUPABASE_URL(self):
        return self._get_secret("SUPABASE_URL")

    @property
    def SUPABASE_KEY(self):
        # We use the Service Role Key on the backend for admin rights
        return self._get_secret("SUPABASE_SERVICE_ROLE_KEY")

    def _get_secret(self, name):
        # Check environment variable first (Local Dev)
        env_val = os.getenv(name)
        if env_val:
            return env_val
            
        # Check Google Cloud Secret Mount (Production)
        # We will mount secrets to /secrets/NAME in Cloud Run later
        try:
            with open(f"/secrets/{name}", "r") as f:
                return f.read().strip()
        except FileNotFoundError:
            return None

settings = Settings()