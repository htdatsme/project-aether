import vertexai
from vertexai.language_models import TextEmbeddingModel
from vertexai.generative_models import GenerativeModel, Part, Image
from typing import List, Dict, Any, Optional
import os
import base64
from app.core.db import get_db

class VectorEngine:
    def __init__(self):
        self.project_id = os.getenv("GOOGLE_CLOUD_PROJECT")
        self.location = os.getenv("GOOGLE_CLOUD_LOCATION", "us-central1")
        
        # Initialize Vertex AI
        if self.project_id:
            vertexai.init(project=self.project_id, location=self.location)
            # 1. The Reasoner: Gemini 1.5 Flash (Fast, Multimodal)
            self.generative_model = GenerativeModel("gemini-1.5-flash-001")
            # 2. The Mapper: Text Embedding (Converts reasoning to vectors)
            self.embedding_model = TextEmbeddingModel.from_pretrained("text-embedding-004")

    def analyze_vibe(self, text: str, image_base64: Optional[str] = None) -> Dict[str, Any]:
        """
        Multimodal Chain-of-Thought:
        1. If Image: Look at image + text -> Extract 'Vibe Description'.
        2. If Text only: Just use text.
        3. Vectorize the 'Vibe Description'.
        4. Search Database.
        """
        try:
            vibe_description = ""
            
            if image_base64:
                # Multimodal Analysis
                try:
                    image_part = Part.from_data(
                        mime_type="image/jpeg",
                        data=base64.b64decode(image_base64)
                    )
                    prompt = f"""
                    You are a luxury fragrance expert (The Nose). 
                    Analyze this image and the user's thought: "{text}".
                    Describe the olfactory 'vibe' of this visual. 
                    Focus on: Lighting, Texture, Mood, Season, and Color Palette.
                    Do NOT name specific perfumes. Just describe the aesthetic essence in 2 sentences.
                    """
                    response = self.generative_model.generate_content([image_part, prompt])
                    vibe_description = response.text
                    print(f"👁️ Visual Vibe Extracted: {vibe_description}")
                except Exception as img_e:
                    print(f"Image processing error: {img_e}")
                    vibe_description = text # Fallback
            else:
                vibe_description = text

            # Step 2: Vectorization
            embedding = self.get_embedding(vibe_description)
            if not embedding:
                return {}

            # Step 3: Search
            matches = self.search_scents(embedding)
            
            return {
                "reasoning": vibe_description,
                "matches": matches
            }

        except Exception as e:
            print(f"Error in analyze_vibe: {e}")
            return {}

    def get_embedding(self, text: str) -> List[float]:
        try:
            embeddings = self.embedding_model.get_embeddings([text])
            return embeddings[0].values
        except Exception as e:
            print(f"Error generating embedding: {e}")
            return []

    def search_scents(self, vector: List[float], match_threshold: float = 0.5, match_count: int = 3) -> List[Dict[str, Any]]:
        supabase = get_db()
        try:
            response = supabase.rpc("match_scents", {
                "query_embedding": vector,
                "match_threshold": match_threshold,
                "match_count": match_count
            }).execute()
            return response.data
        except Exception as e:
            print(f"Error searching Supabase: {e}")
            return []

    def log_search(self, user_vibe: List[float], revealed_scent_id: str):
        # Legacy logging (optional, kept for backward compatibility)
        pass

    def log_reveal(self, scent_id: str, vibe_vector: List[float]):
        """
        Phase 3: The Data Moat.
        Logs the verified match to the 'truth_labels' table.
        """
        supabase = get_db()
        try:
            data = {
                "scent_id": scent_id,
                "user_vibe_vector": vibe_vector,
                "interaction_type": "blind_date_reveal"
                # user_id is handled by RLS if auth is enabled
            }
            # Use service_role key logic in config.py if we need admin write,
            # but for now standard client works if RLS policy allows authenticated insert
            supabase.table("truth_labels").insert(data).execute()
            print(f"✅ MOAT: Logged ground truth for {scent_id}")
        except Exception as e:
            print(f"❌ Error logging to truth_labels: {e}")