import os
from supabase import create_client, Client
from app.core.config import settings # <--- CHANGED

# Use the settings object we just created
url = settings.SUPABASE_URL
key = settings.SUPABASE_KEY

if not url or not key:
    print("WARNING: Supabase credentials missing. Check .env or Secret Manager.")
    # We don't crash yet, to allow build steps to pass
    
# Only create client if keys exist
supabase: Client = create_client(url, key) if url and key else None

def get_db() -> Client:
    """Dependency to get Supabase client."""
    if not supabase:
        raise ValueError("Database connection not initialized")
    return supabase