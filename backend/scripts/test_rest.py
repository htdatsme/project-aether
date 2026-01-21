import httpx
import json

token = "ya29.a0AUMWg_I2BH2NW8ZT7fDs2Wr3M_6QG9eqXTpknokchCRaEpIEP2z1UwR_LD6RFz4B2fjSTdxn03KjKbghkHjX7qtQpvopoiPOQvKIkkDGk1GMy5pjKxl3zA3PeA_EYM1TtQfgdzGzy6PCc8WJsx5KGVIIEJZNAM7v6nid-pE0JHlDPe-Z0hfqqcIHQD8NNabIcdzAdS9dgG5ccAaCgYKAakSARASFQHGX2Mi3NIQzSyseKO7mpHa-rCkSg0213"
url = "https://us-central1-aiplatform.googleapis.com/v1/projects/project-aether-777/locations/us-central1/publishers/google/models/text-embedding-004:predict"
headers = {
    "Authorization": f"Bearer {token}",
    "Content-Type": "application/json"
}
data = {
    "instances": [{"content": "hello world"}]
}

print(f"Testing API access for project: project-aether-777")
try:
    response = httpx.post(url, headers=headers, json=data)
    print(f"Status: {response.status_code}")
    print(f"Body: {response.text}")
except Exception as e:
    print(f"Error: {e}")
