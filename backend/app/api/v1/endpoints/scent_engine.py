from fastapi import APIRouter, HTTPException
from pydantic import BaseModel, Field
from typing import List, Dict, Any, Optional
from app.services.vector_engine import VectorEngine

router = APIRouter()

class VibeAnalysisRequest(BaseModel):
    # Matches the JSON sent from Flutter
    text_prompt: str = Field(alias="query")
    image_base64: Optional[str] = None # New Field

@router.post("/analyze-vibe")
async def analyze_vibe(request: VibeAnalysisRequest) -> Dict[str, Any]:
    """
    Multimodal Endpoint: Accepts Text + Optional Image.
    """
    try:
        vector_engine = VectorEngine()

        # Call the new Multimodal Engine
        analysis = vector_engine.analyze_vibe(
            text=request.text_prompt,
            image_base64=request.image_base64
        )

        if not analysis or not analysis.get("matches"):
             return {
                "scent_name": "Santal 33",
                "match_reason": "The Oracle is cloudy. Defaulting to a classic.",
                "ai_reasoning": "The cosmic currents are shifting; this timeless wood steady your path.",
                "theme_colors": ["#1A1A1A", "#D4AF37"], # Gold & Charcoal
                "related_scents": []
            }

        best_match = analysis["matches"][0]
        metadata = best_match.get("metadata", {})
        
        # Extract colors from metadata or provide dynamic defaults
        theme_colors = metadata.get("theme_colors", ["#000000", "#FFFFFF"])
        
        # If the fallback is still the placeholder, let's make it smarter based on the name
        if theme_colors == ["#000000", "#FFFFFF"]:
            name_lower = best_match["name"].lower()
            if "acqua" in name_lower or "fresh" in name_lower:
                theme_colors = ["#E0F7FA", "#006064"] # Teal
            elif "black" in name_lower or "oud" in name_lower or "dark" in name_lower:
                theme_colors = ["#1A1A1A", "#4A3728"] # Deep Earth/Charcoal
            elif "soleil" in name_lower or "gold" in name_lower:
                theme_colors = ["#FFF8E1", "#D4AF37"] # Gold/Cream

        return {
            "scent_name": best_match["name"],
            "scent_id": best_match["id"], # VITAL: Return ID for the Moat
            "match_reason": best_match["description"], 
            "ai_reasoning": analysis.get("reasoning", ""), 
            "theme_colors": theme_colors,
            "related_scents": [m["name"] for m in analysis["matches"][1:]]
        }

    except Exception as e:
        print(f"Error in analyze_vibe: {e}")
        return {
            "scent_name": "Santal 33",
            "match_reason": "An error occurred in the Ether.",
            "ai_reasoning": "A temporal rift has occurred.",
            "theme_colors": ["#1A1A1A", "#D4AF37"],
            "error": str(e)
        }

class RevealRequest(BaseModel):
    scent_id: str
    user_vibe_description: str # We re-vectorize this to store the "Truth"

@router.post("/blind-date-reveal")
async def blind_date_reveal(request: RevealRequest):
    """
    The Data Moat: Logs that the user verified this scent match.
    """
    try:
        engine = VectorEngine()
        # Re-vectorize the vibe description to ensure we store the mathematical intent
        # In a production app, we might pass the vector directly, but text is safer to transport
        vector = engine.get_embedding(request.user_vibe_description)
        
        if vector:
            engine.log_reveal(user_vibe=vector, revealed_scent_id=request.scent_id)
            return {"status": "success", "message": "Ground Truth Logged"}
        else:
            raise HTTPException(status_code=500, detail="Failed to vectorize user vibe")
            
    except Exception as e:
        print(f"Error logging reveal: {e}")
        # We don't block the UI if logging fails, but we should know
        return {"status": "partial_success", "error": str(e)}