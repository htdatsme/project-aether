# Git & Version Control Strategy

## 🎯 The "Undo Button" Protocol
We use a strict branching strategy to ensure we never break the main app.

## 1. Branching Rules
- **`main`**: The "Production" code. This must ALWAYS work.
- **`dev`**: The "Staging" code. We combine features here.
- **`feature/[name]`**: Where the Agent works (e.g., `feature/scent-engine`).

## 2. The Agent's Workflow
1.  **Start:** `git checkout -b feature/[task-name]`
2.  **Work:** Implement the feature.
3.  **Save:** `git commit -m "feat: [description of change]"`
4.  **Verify:** Run tests.
5.  **Merge:** Only merge to `main` if tests pass.

## 3. Emergency Rollback
If the app breaks, the Agent must immediately execute:
- `git checkout main` (Go back to safety)
- `git log` (Find the last working version)
