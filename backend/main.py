from fastapi import FastAPI
from pydantic import BaseModel
from typing import List, Optional
import os

from app.vector_search import AetherVectorSearch

app = FastAPI(title="Project Aether API", version="0.1.0")
search_engine = AetherVectorSearch()

class ScentQuery(BaseModel):
    preferences: List[str]
    mood: Optional[str] = None

@app.get("/")
async def root():
    return {"message": "Welcome to Project Aether API", "status": "online"}

@app.post("/match")
async def match_scent(query: ScentQuery):
    # 1. Convert query to embedding (Mocked for now)
    query_text = " ".join(query.preferences) + (f" {query.mood}" if query.mood else "")
    embedding = search_engine.get_embedding(query_text)
    
    # 2. Search Vertex AI
    matches = search_engine.search_similar_scents(embedding)
    
    # 3. Format and return
    if not matches:
        return {"matches": [{"name": "L'Eau d'Issey", "brand": "Issey Miyake", "score": 0.95}]}
        
    return {"matches": matches}

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)
