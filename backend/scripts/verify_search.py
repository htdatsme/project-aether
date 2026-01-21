import sys
import os

sys.path.append(os.path.join(os.path.dirname(__file__), '..'))

from app.services.vector_engine import VectorEngine
from app.core.db import get_db
from dotenv import load_dotenv

load_dotenv()

def verify_search():
    print("Initializing Vector Engine...")
    engine = VectorEngine()
    supabase = get_db()
    
    # Debug: Check DB count
    try:
        count_res = supabase.table("scent_profiles").select("id", count="exact").execute()
        print(f"Total Scent Profiles in DB: {count_res.count}")
    except Exception as e:
        print(f"Error counting DB: {e}")

    query = "Devastation"
    print(f"Generating embedding for query: '{query}'...")
    embedding = engine.get_embedding(query)
    
    if not embedding:
        print("Failed to generate embedding.")
        return

    print(f"Embedding generated. Searching Supabase with threshold 0.0...")
    # LOWER THRESHOLD to 0.0 to see anything
    results = engine.search_scents(embedding, match_threshold=0.0, match_count=3)
    
    print("\n--- Search Results ---")
    if not results:
        print("No matches found even with threshold 0.0.")
    else:
        for i, res in enumerate(results):
            print(f"{i+1}. {res['name']} (Similarity: {res['similarity']:.4f})")
            print(f"   Description: {res['description'][:100]}...")
            
    print("\n--- Verification Complete ---")

if __name__ == "__main__":
    verify_search()
