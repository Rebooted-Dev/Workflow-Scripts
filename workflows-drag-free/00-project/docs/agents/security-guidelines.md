# Security Guidelines (workflows-drag-free)

- Do not commit secrets, API keys, or credentials into this tree.
- Treat external provider runs that send plan content off-machine as requiring **explicit user approval**.
- Prefer read-only discovery before any destructive cleanup of archives or git history.
