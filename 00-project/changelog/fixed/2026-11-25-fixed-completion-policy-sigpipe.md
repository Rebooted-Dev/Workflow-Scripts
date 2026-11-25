# Fix completion policy check under pipefail
**Date:** 2026-11-25
**Type:** fixed

The completion-chain validator now checks the terminal step through a here-string, avoiding a false failure when grep exits before the pipe producer. Added a self-test for both the current valid policy and a missing required phrase.

The artifact-lifecycle validator also avoids early-closing quiet searches and an early-exit awk pipeline; its existing mutation self-test checks the valid template and missing required columns and other rules.
