# Design System: The "Digital Synesthesia" Language

## 🎯 Design Philosophy: "Quiet Tech"
Targeting LVMH means the technology must feel invisible.
- **No Loading Spinners:** Use fluid, morphing abstract shapes ("Molecular Coalescence").
- **Haptic Branding:** Every interaction must have a specific haptic weight.

## 1. The Generative Engine (Dynamic Theming)
The UI is not static; it is a living reflection of the `scent_profile`.

### A. Color Interpolation (The "Golden Hour" Palette)
* **Global Background:** `#FAF9F6` (Alabaster / Off-White).
* **Primary Text:** `#1A1A1A` (Charcoal).
* **Accents:** `#D4AF37` (Metallic Gold).
* **Vibe Gradients (Overlay Only):**
    * *Fresh:* `#E0F7FA` (Cyan Mist) -> `#006D77` (Deep Teal).
    * *Heavy:* `#FFF0F5` (Lavender Blush) -> `#450920` (Dark Amber).

### B. Physics & Gravity
We use `flutter_animate` to control the "weight".
- **Light Scents:** High bounce, fast duration (300ms).
- **Heavy Scents:** Low bounce, slow curves (800ms).

## 2. Core Components

### The "Molecular Cloud" (Results)
- A blurry, scaled-up widget that slowly sharpens into the bottle.
- **Shader Logic:** Uses `ImageFiltered` (Blur) + `Transform.scale`.

### The "Blind" Bottle (Data Capture)
- A 3D-rendered silhouette that is frosted.
- **Reveal:** "Press and Hold" triggers a white flash and dissolves the frost.

## 3. Typography Strategy ("Quinten" Aesthetic)
- **Headers:** **'Cinzel Decorative'** (Google Font).
    - *Usage:* Headlines, Titles.
    - *Style:* Weight 700, LetterSpacing 1.5.
- **Body:** **'Cormorant Garamond'** (Google Font).
    - *Usage:* Descriptions, Input Text.
    - *Style:* Italic, Size 18+.