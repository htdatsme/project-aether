# Project Aether: Generative Olfactory Intelligence

![Status](https://img.shields.io/badge/Status-Live-success) ![Stack](https://img.shields.io/badge/Stack-Flutter%20%7C%20FastAPI%20%7C%20Vertex%20AI-blue) ![License](https://img.shields.io/badge/License-Proprietary-orange)

**Project Aether** is a neuromorphic AI system that translates abstract user inputs ("vibes," emotions, memories) into precise olfactory recommendations. Unlike traditional keyword search, Aether uses Large Language Models (LLM) to map the *latent semantic space* of human emotion to the chemical families of fragrance.

## 🚀 Live Demo
**[Launch The App](https://project-aether-626113.web.app)**

---

#🏗️ System Architecture

The system follows a decoupled microservice architecture designed for independent scaling of the "Brain" (Intelligence) and the "Face" (UI).

graph TD
    User[User Client] -->|HTTPS/REST| CDN[Firebase Hosting CDN]
    CDN -->|Loads| Flutter[Flutter Web App]
    
    subgraph "The Face (Frontend)"
        Flutter -->|State Mgmt| Riverpod[Riverpod Provider]
        Riverpod -->|Animation| VibeEngine[Generative Animation Layer]
    end
    
    Flutter -->|Async Request| CloudRun[Google Cloud Run]
    
    subgraph "The Brain (Backend)"
        CloudRun -->|FastAPI| API[Python Vibe Controller]
        API -->|Inference| Vertex[Vertex AI (Gemini Pro)]
        API -->|Extraction| Parser[JSON Structure Enforcer]
    end


Core Components

The Brain (Backend):

Container: Dockerized Python (FastAPI).

Compute: Google Cloud Run (Serverless, Auto-scaling to zero).

Intelligence: Google Vertex AI (Gemini Pro) via LangChain.

Function: Semantic analysis of user intent -> Fragrance profiling.

The Face (Frontend):

Framework: Flutter Web (Single Page Application).

Hosting: Firebase Hosting (Global Edge Caching).

UX: "Coalescing Bottle" generative animation engine using flutter_animate.

🛠️ Technology Stack

Component

Technology

Rationale

Frontend

Flutter (Dart)

Single codebase for Web/iOS/Android; High-fidelity rendering (Skia).

Backend

Python (FastAPI)

Native AI library support; Asynchronous concurrency.

AI Model

Gemini Pro (Vertex)

Multimodal capabilities; Enterprise data privacy compliance.

Infrastructure

GCP Cloud Run

Zero-ops management; Per-request billing; Instant scale.

State Mgmt

Riverpod

Compile-time safe dependency injection.

⚡ Quick Start (Developer Setup)

Prerequisites

Flutter SDK (3.x+)

Python 3.10+

Google Cloud SDK (gcloud)

Firebase CLI

1. Backend Setup (The Brain)

Navigate to the backend directory and activate the environment:

cd backend
python -m venv venv
# On Windows:
venv\Scripts\activate
# On Mac/Linux:
# source venv/bin/activate

pip install -r requirements.txt
uvicorn main:app --reload


2. Frontend Setup (The Face)

Navigate to the frontend directory and run the client:

cd frontend
flutter pub get
flutter run -d chrome


📦 Deployment Pipeline

Deploying the Backend

Logic and AI prompt updates are deployed to Google Cloud Run:

# Deploys the containerized service
gcloud run deploy aether-brain --source .


Deploying the Frontend

Visual and UI updates are compiled and pushed to Firebase CDN:

cd frontend
# 1. Compile Dart to optimized JavaScript
flutter build web --release

# 2. Push artifacts to Firebase Hosting
firebase deploy


🛣️ Roadmap & Scalability

[x] Phase 1 (Current): Generative matching logic & "Smart Switch" visualization.

[ ] Phase 2 (Data): Implementation of RAG (Retrieval-Augmented Generation) with Pinecone vector database for real-time inventory checks against 10,000+ SKUs.

[ ] Phase 3 (User): Auth implementation and "Scent Wardrobe" persistence.

© License

Proprietary & Confidential. Copyright © 2024 Project Aether. All Rights Reserved.