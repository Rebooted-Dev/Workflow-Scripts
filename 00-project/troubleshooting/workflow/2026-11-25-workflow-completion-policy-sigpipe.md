# Completion policy check fails on an existing phrase
**Date:** 2026-11-25
**Category:** workflow
**Status:** FIXED

## Symptom
The pre-commit policy check reported that the terminal gate lacked `verified plan tasks`, despite the phrase being present; a producer-side broken pipe was also reported.

## Root cause
With `pipefail` enabled, `grep -q` can exit early after finding the phrase, causing `printf` in the pipeline to fail with SIGPIPE and the condition to report a missing phrase.

## Fix
Pass the extracted step to grep using a here-string, avoiding the producer pipe.

## Verification
The validator passes on the existing gate. The self-test also removes the required phrase in an isolated copy and confirms that validation fails with the expected diagnostic.

## Notes/Lessons
Keep missing-content failures separate from shell pipeline failures.

The subsequent artifact-lifecycle hook used the same early-exit pipeline pattern and similarly reported a missing column that existed. Its searches now consume their complete input, and its early-exit awk reads via a here-string. The existing artifact-lifecycle mutation self-test passes, including the missing-relationship case.
