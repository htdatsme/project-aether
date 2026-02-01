from fastapi import APIRouter, HTTPException
from pydantic import BaseModel, Field
from typing import List, Dict, Any, Optional
from app.services.vector_engine import VectorEngine

router = APIRouter()

# --- Request Models ---

class VibeAnalysisRequest(BaseModel):
    # Frontend sends 'query', we map it to 'text_prompt'
    text_prompt: str = Field(alias="query")
    # Phase 2: Visual Intelligence (Optional Image)
    image_base64: Optional[str] = None

class RevealRequest(BaseModel):
    # Phase 3: The Data Moat (Ground Truth)
    scent_id: str
    user_vibe_description: str # We re-vectorize this to capture the specific "vibe" that triggered the sale

# --- Endpoints ---

@router.post("/analyze-vibe")
async def analyze_vibe(request: VibeAnalysisRequest) -> Dict[str, Any]:
    """
    Phase 2: Multimodal Vibe Analysis (Text + Image).
    """
    try:
        text = request.text_prompt.lower()
        vector_engine = VectorEngine()

        # Step 1: Analyze (Text + Optional Image)
        # This now uses Gemini Vision if an image is provided
        analysis = vector_engine.analyze_vibe(text, request.image_base64)
        
        if not analysis or not analysis.get("matches"):
             return {
                "scent_name": "Santal 33",
                "match_reason": "The Oracle is cloudy. Defaulting to a classic.",
                "theme_colors": ["#C0C0C0", "#FFFFFF"],
                "related_scents": []
            }

        best_match = analysis["matches"][0]
        
        # Step 2: Format Result
        return {
            "scent_id": best_match.get("id"), # Crucial for the Data Moat later
            "scent_name": best_match["name"],
            "match_reason": best_match["description"],
            "ai_reasoning": analysis.get("reasoning", ""),
            "theme_colors": ["#000000", "#FFFFFF"], # Placeholder until we implement extraction
            "related_scents": [m["name"] for m in analysis["matches"][1:]]
        }

    except Exception as e:
        print(f"Error in analyze_vibe: {e}")
        return {
            "scent_name": "Santal 33",
            "match_reason": "An error occurred in the Ether.",
            "error": str(e)
        }

@router.post("/blind-date-reveal")
async def reveal_match(request: RevealRequest):
    """
    Phase 3: The Data Moat.
    Logs that a user 'revealed' the bottle, confirming the vibe match.
    """
    try:
        vector_engine = VectorEngine()
        
        # 1. Re-vectorize the vibe. 
        # (We do this here to ensure the vector stored in 'truth_labels' is mathematically consistent)
        vibe_vector = vector_engine.get_embedding(request.user_vibe_description)
        
        # 2. Log to Supabase 'truth_labels'
        vector_engine.log_reveal(request.scent_id, vibe_vector)
        
        return {"status": "recorded", "message": "Ground Truth captured."}
    except Exception as e:
        print(f"MOAT ERROR: {e}")
        # We don't want to crash the app if logging fails, but we should know about it
        raise HTTPException(status_code=500, detail=str(e))