# Quality Assurance (QA) Strategy

## 🎯 The "Zero-Regression" Standard
We cannot sell to LVMH if the app crashes. Every new feature must pass these three gates before we consider it "Done".

## 1. Automated Testing Gates
- **Unit Tests (Backend):** Every API endpoint (e.g., `/analyze-vibe`) must have a corresponding `test_*.py` file in `backend/tests/`.
- **Widget Tests (Frontend):** Every "Vibe" animation must have a Flutter widget test to ensure it renders without error.
- **The "Gold Standard" Command:**
    - Backend: `pytest` must return 100% pass.
    - Frontend: `flutter test` must return 100% pass.

## 2. The "Vibe Check" Protocol (Manual QA)
Since we are building "Generative UI", code tests aren't enough.
- **Visual Verification:** For every UI change, the Agent must launch the Browser Preview and verify:
    1.  Does the gradient animation run at 60fps?
    2.  Does the haptic feedback trigger correctly?
    3.  Does the text remain legible against dynamic backgrounds?

## 3. Security Scanning
- Run `dart pub outdated` and `pip list --outdated` weekly to check for security vulnerabilities in dependencies.
