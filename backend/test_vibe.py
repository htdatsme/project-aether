
import sys
import os

# Ensure 'backend' is in the Python path so we can import 'app'
# Assuming this script is run from the project root or backend/ directory
current_dir = os.path.dirname(os.path.abspath(__file__))
parent_dir = os.path.dirname(current_dir)
if os.path.basename(current_dir) == 'backend':
    sys.path.append(current_dir) # Add backend/ to path
else:
    # If run from somewhere else, try to find backend
    sys.path.append(os.path.join(current_dir, 'backend'))

try:
    from app.services.vector_engine import VectorEngine
except ImportError:
    # Fallback if running from root without explicit path setup
    sys.path.append(os.getcwd() + '/backend')
    from app.services.vector_engine import VectorEngine

def test_embedding():
    input_text = 'Dark, moody, petrichor, rain on pavement'
    print(f"--- Testing Vibe: '{input_text}' ---")
    
    try:
        # Initialize engine
        engine = VectorEngine()
        
        # Get embedding
        vector = engine.get_embedding(input_text)
        
        # Output results
        print(f"\nSuccess! Generated vector of dimension: {len(vector)}")
        print(f"First 5 values: {vector[:5]}")
        
    except Exception as e:
        print(f"\nError: {e}")
        exit(1)

if __name__ == "__main__":
    test_embedding()
