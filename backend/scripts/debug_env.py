import os
from dotenv import load_dotenv

load_dotenv()
project_id = os.getenv("GOOGLE_CLOUD_PROJECT")
print(f"Raw: {project_id}")
print(f"Repr: {repr(project_id)}")
