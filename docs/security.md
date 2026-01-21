# Security & Governance Policy

## 1. Access Control
- **Database:** Row Level Security (RLS) must be enabled on ALL Supabase tables. Users can only read/write their own data.
- **Backend:** Cloud Run service account must have "Least Privilege" access to Vertex AI and Secret Manager.

## 2. Input Validation
- **Backend:** All Python endpoints must use Pydantic models for request validation.
- **Frontend:** Strict Dart typing. No `dynamic` types allowed to prevent runtime crashes.

## 3. Audit Logging
- Log all "Vibe Analysis" requests for debugging, but anonymize User IDs in logs.
