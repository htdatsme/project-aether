# PLAN_PHASE_2.md: The Multimodal Brain
**Objective:** Upgrade the AI to understand Images (Vision) + Text.
**Status:** 🟡 Ready to Start
**Owner:** Fractional CTO (Agent)

---

## 1. The Strategy
LVMH sells aesthetics, not just words. If a user uploads a photo of a **velvet dress in a dimly lit jazz club**, the AI must see:
* **Visuals:** Dark red, shadows, soft texture.
* **Vibe:** Romantic, mysterious, vintage.
* **Scent Translation:** Rose, Tobacco, Leather (Not "Citrus").

## 2. Backend Upgrade (Python)
We need to change `scent_engine.py` to accept images.

* **Action:** Update the `/analyze-vibe` endpoint to accept a `Base64` image string.
* **AI Model:** Switch from `text-embedding-004` (Text Only) to **Gemini 1.5 Flash** (Multimodal) for the reasoning step, then vectorize the output.

## 3. Frontend Upgrade (Flutter)
We need to give the user a camera button.

* **File:** `frontend/lib/features/vibe_engine/input_screen.dart`
* **Action:** Add a "Upload Image" button next to the text input.
* **Logic:** Convert the selected image to Base64 and send it to the new backend endpoint.

---

## 4. Execution Steps

### Step 1: Backend Dependencies
*Run in `backend/` terminal:*
```bash
# We need libraries to handle image processing
pip install pillow python-multipart