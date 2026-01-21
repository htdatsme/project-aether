import pytest
from fastapi.testclient import TestClient
from unittest.mock import MagicMock, patch
from app.main import app

client = TestClient(app)

@patch("app.api.v1.endpoints.scent_engine.VectorEngine")
def test_analyze_vibe_success(mock_vector_engine):
    # Setup mock
    mock_engine_instance = MagicMock()
    mock_engine_instance.get_embedding.return_value = [0.1, 0.2, 0.3]
    mock_engine_instance.search_scents.return_value = [
        {"id": "scent_1", "distance": 0.9},
        {"id": "scent_2", "distance": 0.8}
    ]
    mock_vector_engine.return_value = mock_engine_instance

    response = client.post(
        "/api/v1/analyze-vibe",
        json={"text_prompt": "fresh morning in the woods"}
    )

    assert response.status_code == 200
    data = response.json()
    assert len(data) == 2
    assert data[0]["id"] == "scent_1"
    assert data[1]["id"] == "scent_2"
    
    # Verify calls
    mock_engine_instance.get_embedding.assert_called_once_with("fresh morning in the woods")
    mock_engine_instance.search_scents.assert_called_once_with([0.1, 0.2, 0.3])

@patch("app.api.v1.endpoints.scent_engine.VectorEngine")
def test_analyze_vibe_error(mock_vector_engine):
    # Setup mock to raise an exception
    mock_engine_instance = MagicMock()
    mock_engine_instance.get_embedding.side_effect = Exception("Vertex AI Error")
    mock_vector_engine.return_value = mock_engine_instance

    response = client.post(
        "/api/v1/analyze-vibe",
        json={"text_prompt": "error case"}
    )

    assert response.status_code == 500
    assert response.json()["detail"] == "Vertex AI Error"
