# API Contract: The "Intelligence Layer"

## 1. Core Endpoints

### `POST /api/v1/analyze-vibe`
- **Input:** `{ "text_prompt": "Rainy London" }`
- **Output:**
  - `scent_cluster`: List of scents.
  - `vibe_metadata`: Keywords (e.g., "Melancholy").
  - `ui_theme`: Suggests colors (Teal/Amber).

### `POST /api/v1/blind-date-reveal` (The Data Moat)
- **Purpose:** Logs that a user *verified* a scent match (Ground Truth).
- **Input:**
  - `scent_id`: UUID of the bottle revealed.
  - `user_vibe_vector`: The original search vector.
  - `timestamp`: UTC time.
- **Output:** `{ "status": "logged", "training_value": "high" }`

### `GET /api/v1/blind-date/{code}`
- **Purpose:** Retrieve scent details *without* revealing the brand name (for the unboxing phase).