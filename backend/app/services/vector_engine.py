import vertexai
from vertexai.language_models import TextEmbeddingModel
from typing import List, Dict, Any, Optional
import os
from app.core.db import get_db

class VectorEngine:
    def __init__(self):
        self.project_id = os.getenv("GOOGLE_CLOUD_PROJECT")
        self.location = os.getenv("GOOGLE_CLOUD_LOCATION", "us-central1")
        
        if self.project_id:
            vertexai.init(project=self.project_id, location=self.location)
            # Initialize the model once
            self.model = TextEmbeddingModel.from_pretrained("text-embedding-004")

    def get_embedding(self, text: str) -> List[float]:
        """
        Generates text embedding using Vertex AI's text-embedding-004 model.
        """
        try:
            embeddings = self.model.get_embeddings([text])
            return embeddings[0].values
        except Exception as e:
            print(f"Error generating embedding: {e}")
            return []

    def search_scents(self, vector: List[float], match_threshold: float = 0.1, match_count: int = 5) -> List[Dict[str, Any]]:
        """
        Searches Supabase for similar scents using the 'match_scents' RPC function.
        """
        supabase = get_db()
        
        try:
            response = supabase.rpc("match_scents", {
                "query_embedding": vector,
                "match_threshold": match_threshold,
                "match_count": match_count
            }).execute()
            
            return response.data
            
        except Exception as e:
            print(f"Error searching scents in Supabase: {e}")
            return []

    def log_search(self, user_vibe: List[float], revealed_scent_id: str):
        """
        Logs the search (user_vibe + result) to the truth_labels table (The Moat).
        """
        supabase = get_db()
        try:
            data = {
                "user_vibe": user_vibe,
                "revealed_scent_id": revealed_scent_id
            }
            supabase.table("truth_labels").insert(data).execute()
        except Exception as e:
            print(f"Error logging to truth_labels: {e}")
