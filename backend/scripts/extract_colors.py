
import sys
import os
from PIL import Image
from sklearn.cluster import KMeans
import numpy as np

def extract_colors(image_path, n_colors=5):
    try:
        # Load image
        img = Image.open(image_path)
        img = img.resize((150, 150))  # Resize for speed
        img = img.convert('RGB')
        
        # Convert to numpy array
        img_array = np.array(img)
        img_array = img_array.reshape((img_array.shape[0] * img_array.shape[1], 3))
        
        # Use KMeans to find dominant colors
        kmeans = KMeans(n_clusters=n_colors, random_state=42)
        kmeans.fit(img_array)
        
        colors = kmeans.cluster_centers_
        
        # Convert to hex
        hex_colors = []
        for color in colors:
            hex_colors.append('#{:02x}{:02x}{:02x}'.format(int(color[0]), int(color[1]), int(color[2])))
            
        return hex_colors
    except Exception as e:
        return [f"Error: {e}"]

if __name__ == "__main__":
    # Paths from user metadata
    # uploaded_image_0 (Reference A - Teal)
    # uploaded_image_1 (Reference B - Amber)
    base_path = r"C:\Users\kuros\.gemini\antigravity\brain\5a6f830b-cb94-4405-a03b-cf3d6e6b2086"
    
    # These filenames come from the metadata in the prompt
    img_files = {
        "Reference A (Teal)": "uploaded_image_0_1767664815850.jpg",
        "Reference B (Amber)": "uploaded_image_1_1767664815850.jpg"
    }

    print("--- Color Extraction Results ---")
    for name, filename in img_files.items():
        path = os.path.join(base_path, filename)
        if os.path.exists(path):
            print(f"\nAnalyzing {name}...")
            colors = extract_colors(path)
            print(f"Dominant Colors: {', '.join(colors)}")
        else:
            print(f"\nFile not found: {path} (Base: {base_path}, Filename: {filename})")
