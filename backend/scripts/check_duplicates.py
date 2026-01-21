import os
from supabase import create_client, Client
from dotenv import load_dotenv
from collections import Counter

load_dotenv()

SUPABASE_URL = os.getenv("SUPABASE_URL")
SUPABASE_KEY = os.getenv("SUPABASE_SERVICE_ROLE_KEY")

supabase: Client = create_client(SUPABASE_URL, SUPABASE_KEY)

response = supabase.table("scent_profiles").select("name").execute()
names = [row['name'] for row in response.data]
counts = Counter(names)
duplicates = [name for name, count in counts.items() if count > 1]

if duplicates:
    print(f"Found duplicates: {duplicates}")
else:
    print("No duplicates found.")
