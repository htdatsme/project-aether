# Data Strategy: The "Olfactory Zeitgeist" Asset

## 🎯 The Valuation Thesis
Our primary value to LVMH is NOT just the app, but the **"Synesthetic Data Moat"**[cite: 51]. We must structure data to generate the "Olfactory Zeitgeist Report"[cite: 116].

## 1. The Core Data Assets
### A. The "Scent-Sona" Graph
We must track the relationship between **Abstract Inputs** and **Olfactive Outputs**.
- **Input Vector:** High-dimensional representation of user Vibe (Image/Audio).
- **Output Vector:** High-dimensional representation of Scent Clusters.
- **The "Bridge":** The `vibe_logs` table must record the exact distance/similarity score between these two vectors.

### B. The "Blind Date" Metrics [cite: 100]
We must track "Unbiased Preference":
- `bond_score`: How long a user interacts with a scent description *before* reveal.
- `reveal_conversion`: % of users who scan QR code after bonding.

## 2. Data Schema for Syndication [cite: 17]
To support R&D acceleration for LVMH Maisons (Dior, Guerlain), our schema must support queries like:
- *"Show me trending notes for 'Goth Aesthetic' users in Tokyo vs. Paris."* [cite: 19]
- *"Correlate 'Velvet Texture' preferences with 'Sandalwood' notes."* [cite: 51]

## 3. Vector Strategy
- **Embedding Model:** Multimodal (Text/Image) embeddings via Vertex AI.
- **Dimensions:** 768 dimensions.
- **Index:** ScaNN (Scalable Nearest Neighbors) for low-latency search.
