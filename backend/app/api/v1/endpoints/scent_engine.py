from fastapi import APIRouter, HTTPException
from pydantic import BaseModel, Field
from typing import List, Dict, Any, Optional
from app.services.vector_engine import VectorEngine

router = APIRouter()

class VibeAnalysisRequest(BaseModel):
    # Frontend sends 'query', we map it to 'text_prompt'
    text_prompt: str = Field(alias="query")

@router.post("/analyze-vibe")
async def analyze_vibe(request: VibeAnalysisRequest) -> Dict[str, Any]:
    """
    Analyze the "vibe" of a text prompt and return recommended scents.
    Uses Vector Search (Vertex AI + Supabase).
    """
    try:
        text = request.text_prompt.lower()
        vector_engine = VectorEngine()

        # Step 1: Generate Embedding
        query_vector = vector_engine.get_embedding(text)
        if not query_vector:
             raise HTTPException(status_code=500, detail="Failed to generate embedding")

        # Step 2: Search Supabase
        # We want the best match (limit=1) but fetch a few more to populate "related_scents"
        matches = vector_engine.search_scents(query_vector, match_count=3)

        if not matches:
             # Fallback if DB is empty or no matches found
             return {
                "scent_name": "Santal 33",
                "match_reason": "An iconic, woody fragrance that defies expectation (Fallback).",
                "theme_colors": ["#C0C0C0", "#FFFFFF"],
                "related_scents": []
            }

        best_match = matches[0]
        
        # Step 3: Format Result
        # The DB returns {id, name, description, similarity}
        result = {
            "scent_name": best_match["name"],
            "match_reason": best_match["description"],
            # TODO: Future enhancement - extract colors from metadata or generate them
            "theme_colors": ["#000000", "#FFFFFF"], # Placeholder Black/White for now
            "related_scents": [m["name"] for m in matches[1:]] # The next 2 matches
        }

        # Step 4: The Moat (Log the search)
        vector_engine.log_search(query_vector, best_match["id"])

        return result

    except Exception as e:
        print(f"Error in analyze_vibe: {e}")
        # Return a safe fallback rather than crashing
        return {
            "scent_name": "Santal 33",
            "match_reason": "An iconic, woody fragrance that defies expectation.",
            "error": str(e)
        }
