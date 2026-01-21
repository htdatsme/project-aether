# Deployment Runbook

## 🎯 How to Ship
This document defines the exact commands to deploy the app to Google Cloud.

## 1. Backend (Cloud Run)
- **Build:** `gcloud builds submit --tag gcr.io/[project-id]/aether-backend`
- **Deploy:** `gcloud run deploy aether-backend --image gcr.io/[project-id]/aether-backend --platform managed --allow-unauthenticated`
- **Secrets:** Ensure `VERTEX_API_KEY` is attached via `--set-secrets`.

## 2. Frontend (Firebase Hosting / App Distribution)
- **Web Build:** `flutter build web --release`
- **Deploy Web:** `firebase deploy --only hosting`
- **Mobile Beta:** `flutter build apk` -> Upload to Firebase App Distribution.

## 3. Database Migrations (Supabase)
- **Command:** `supabase db push`
- **Safety:** NEVER run this on production without a backup (`supabase db dump`).
