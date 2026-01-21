import sys
import os

# Add the backend directory to sys.path to resolve app modules
sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))

from app.core.db import get_db

def init_db():
    db = get_db()
    
    print("Initializing Database Verification...")
    
    # Test Data
    test_scent = {
        "name": "Test Scent 001",
        "brand": "Antigravity Labs",
        "description": "A test scent to verify DB connection.",
        "embedding": [0.1] * 768, # Dummy 768-dim vector
        "metadata": {"note": "This is a test"}
    }
    
    try:
        # Insert
        print(f"Attempting to insert: {test_scent['name']}")
        # Note: 'embedding' might need special handling if not using a client that auto-converts.
        # But Supabase Python client usually handles lists for vectors if pgvector is set up.
        response = db.table("scent_profiles").insert(test_scent).execute()
        
        if response.data:
            print("Successfully inserted test scent.")
            inserted_id = response.data[0]['id']
            
            # Read back
            print(f"Attempting to read back ID: {inserted_id}")
            read_response = db.table("scent_profiles").select("*").eq("id", inserted_id).execute()
            
            if read_response.data:
                print(f"Successfully retrieved: {read_response.data[0]['name']}")
                
                # Cleanup (Optional, but good for consistent testing)
                # db.table("scent_profiles").delete().eq("id", inserted_id).execute()
                # print("Cleanup complete.")
            else:
                print("Failed to retrieve data.")
                
        else:
            print("Failed to insert data. Response:", response)
            
    except Exception as e:
        print(f"Error during verification: {e}")
        print("\nPossible causes:")
        print("1. 'scent_profiles' table does not exist. (Did you run schema.sql?)")
        print("2. RLS policies might be blocking insert (if not using service role key, but usually anon/authenticated setup).")
        print("3. Vector extension not enabled.")

if __name__ == "__main__":
    init_db()
