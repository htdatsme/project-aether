from fastapi import FastAPI
from app.core import config
from fastapi.middleware.cors import CORSMiddleware
from app.api.v1.endpoints import scent_engine

app = FastAPI(title="Project Aether API", version="0.1.0")

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

app.include_router(scent_engine.router, prefix="/api/v1", tags=["scent-engine"])

@app.get("/")
def health_check():
    return {"status": "alive", "service": "project-aether"}
