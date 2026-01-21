# System Architecture & Technical Standards

## 1. High-Level Architecture
- **Pattern:** Vertical AI System (Headless Brain + Generative Face).
- **Hosting:** Google Cloud Run (Serverless).

## 2. Tech Stack
- **Frontend:** Flutter (Riverpod, flutter_animate).
- **Backend:** Python (FastAPI, Vertex AI).
- **Database:** Supabase (PostgreSQL).

## 3. Data Schema (The Asset)
- **`scent_profiles`:** Inventory embeddings (768d).
- **`vibe_logs`:** Raw input logs (Images/Text).
- **`truth_labels` (The Moat):**
    - Stores the link between **Vibe Input** and **Verified Reveal**.
    - This is the training dataset for our proprietary model.

## 4. Security
- **RLS:** Enabled on all tables.
- **Secrets:** Managed via Google Secret Manager.