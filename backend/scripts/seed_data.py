import os
import sys
import io
# Force UTF-8 encoding for stdout to handle emojis on Windows
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8', line_buffering=True)
print("DEBUG: Script started.", flush=True)

import asyncio
from typing import List, Dict
import vertexai
from vertexai.language_models import TextEmbeddingModel
from supabase import create_client, Client
from dotenv import load_dotenv

# Load environment variables
load_dotenv()

# Configuration
SUPABASE_URL = os.getenv("SUPABASE_URL")
SUPABASE_KEY = os.getenv("SUPABASE_SERVICE_ROLE_KEY")
PROJECT_ID = os.getenv("GOOGLE_CLOUD_PROJECT")
REGION = "us-central1" # Adjust if necessary

if not SUPABASE_URL or not SUPABASE_KEY:
    raise ValueError("SUPABASE_URL and SUPABASE_KEY must be set in .env")

# Initialize Clients
supabase: Client = create_client(SUPABASE_URL, SUPABASE_KEY)

# Initialize Vertex AI
# We might need to handle authentication implicitly via GOOGLE_APPLICATION_CREDENTIALS
# or explicitly if PROJECT_ID is provided. 
# Assuming GOOGLE_APPLICATION_CREDENTIALS is set as per requirements.
if PROJECT_ID:
    vertexai.init(project=PROJECT_ID, location=REGION)
else:
    vertexai.init(location=REGION) # Fallback, relies on default project

def get_embedding(text: str) -> List[float]:
    """Generates an embedding for the given text using Vertex AI."""
    model = TextEmbeddingModel.from_pretrained("text-embedding-004")
    embeddings = model.get_embeddings([text])
    return embeddings[0].values

async def seed_data():
    print("🔮 Initializing The Brain Transplant...")

    inventory = [
        {
            "brand": "Giorgio Armani",
            "name": "Acqua Di Gio",
            "description": "A fresh, aquatic fragrance with notes of calabrian bergamot, neroli, and green tangerine. Captures the essence of the Mediterranean ocean breeze and clean water."
        },
        {
            "brand": "Tom Ford",
            "name": "Black Orchid",
            "description": "A luxurious and sensual fragrance of rich, dark accords and an alluring potion of black orchids and spice. Modern, timeless, and deeply mysterious."
        },
        {
            "brand": "Le Labo",
            "name": "Santal 33",
            "description": "A woody aromatic fragrance with violet accord, cardamom, iris, and ambrox. Smoky wood alloy, musky and leathery notes. An open fire under the stars."
        },
        {
            "brand": "Maison Kurkdjian",
            "name": "Baccarat Rouge 540",
            "description": "Luminous and sophisticated, laying on the skin like an amber, floral and woody breeze. A poetic alchemy of jasmine and saffron."
        },
        {
            "brand": "Acqua di Parma",
            "name": "Colonia",
            "description": "A bright, citrus, timeless, quiet luxury fragrance with notes of italian lemon, rosemary, sandalwood, and patchouli. The Italian sun and abstracta captured in a bottle."
        },
        {
            "brand": "Tom Ford",
            "name": "Soleil Blanc",
            "description": "A sultry solar floral amber fragrance with notes of Bergamot, ylang ylang, a seductive and umami combination of Cardamom, patchouli, ginger, pink pepper and coco de mer. A solar fragrance that can take you to the beach or an incredible savory experience."
        },
        {
            "brand": "Acqua di Parma",
            "name": "Note di Colonia IV",
            "description": "A floral oriental fragrance inspired by Giacomo Puccini's opera Manon Lescaut, with notes of green mandarin, sensual orange blossom, turkish rose, and an enveloping opoponax, labdanum and patchouli. It represents love at first sight, specifically the fluttery bright emotions that come with it, along with a suppressed but enveloping sense knowing subconsciously that this love will lead to one's devastation."
        }
    ]

    print(f"📦 Found {len(inventory)} items in the Proprietary Inventory.")

    for item in inventory:
        print(f"🧬 Generating embedding for: {item['name']}...")
        try:
            embedding = get_embedding(item["description"])
            
            data = {
                "brand": item["brand"],
                "name": item["name"],
                "description": item["description"],
                "embedding": embedding
            }

            print(f"💾 Inserting {item['name']} into The Vault...")
            response = supabase.table("scent_profiles").insert(data).execute()
            # Note: supabase-py v2+ returns a response object with .data, not directly the data or .start
            
            if response.data:
                print(f"✅ Successfully inserted {item['name']}")
            else:
                 print(f"⚠️ Warning: No data returned for {item['name']}")

        except Exception as e:
            print(f"❌ Error processing {item['name']}: {e}")

    print("✨ The Brain Transplant is complete. The Aether is ready.")

if __name__ == "__main__":
    asyncio.run(seed_data())
