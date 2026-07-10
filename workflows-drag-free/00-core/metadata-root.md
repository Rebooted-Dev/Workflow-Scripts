---
id: metadata-root
kind: policy
status: active
---

# Metadata Root Policy

Project records live under one metadata root: `project/` in consumer projects and `00-project/` in Workflow-Scripts. Workflows must resolve that root before reading or writing plans, research, changelog, troubleshooting, debt, or completion records. If it is absent, direct the user to `../00-setup/01-setup-project.md`; do not create substitute record directories at repository root.
