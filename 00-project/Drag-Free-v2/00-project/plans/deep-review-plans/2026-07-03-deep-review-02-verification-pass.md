# Workflow: Deep Review — Independent Verification Pass

## Purpose
Independently re-check every finding of a deep-review report against the live worktree, correct the record (including the report's own errors), and append a dated verification addendum to the same report — so downstream remediation planning starts from verified facts, not first-pass claims.

## When to Run
- After every deep-review (or single-lens review) report, **before** findings feed a remediation plan.
- Preferably in a **different session and/or different model** than the one that wrote the report — the pass exists to catch the first reviewer's blind spots, so don't share its context.
- Also worth re-running when significant time has passed and the report will be acted on now: the worktree may have moved (findings fixed, new files added).

## Inputs
- Path to the deep-review report (in the resolved `research/` directory).
- Repository root of the reviewed repo.

## Ground Rules
- **Read-only except the report.** The only file modified is the report itself (addendum appended). Never "helpfully fix" a finding while verifying it.
- The verifier's job is **adversarial toward the report**, not toward the repo: hunt for overclaims, undercounts, stale paths, and findings the worktree has already invalidated.
- Verification uses the same evidence discipline as the review pass: run the command, quote the output. "Still looks wrong to me" is not a verification.

## Steps

### 1. Re-establish context
- Read the report fully. Read the repo's current state for every file the report cites (files may have changed since the review — note the current git HEAD / date).
- Check the report's own arithmetic and metadata first: do the executive-summary counts match the consolidated index? Do the section references resolve? First-pass reports miscount their own findings more often than expected.

### 2. Verify every finding
For each finding, in index order:
1. Locate the cited behavior in the **current** worktree using the anchor quote (not the line number — lines drift).
2. Re-run the finding's verification/evidence command where one exists; run the "confirming command" for anything the review pass left **PLAUSIBLE**.
3. Assign one status:

| Status | Meaning |
|--------|---------|
| **Verified** | Behavior reproduced / claim checked true against current worktree |
| **Verified with correction** | Core finding stands but a sub-claim, location, count, or severity rationale was wrong — state the correction explicitly |
| **Not reproduced** | Could not confirm; keep listed with the attempted command and why it's inconclusive |
| **Stale / already fixed** | Worktree has changed since the review; cite the fixing commit or the current state |
| **Withdrawn** | The original finding was simply wrong — say why, plainly |

4. If verification reveals a **new** finding, add it with a fresh ID and full Phase-3 template fields, marked "found during verification."

### 3. Correct the record
- Fix the executive summary's counts and top-risk lists if statuses changed them.
- Where the original report overclaimed ("all line references verified"), narrow the claim to what is actually true now.
- Upgrade/downgrade evidence tiers: PLAUSIBLE findings whose confirming command was now run become CONFIRMED or Withdrawn — no finding should remain PLAUSIBLE after this pass unless its check is genuinely blocked (say what blocks it).

### 4. Append the addendum
Append to the report (do not rewrite its body — the original text is part of the record):

```markdown
### §2.N Independent Verification Update — {model}, YYYY-MM-DD

Re-checked against the current worktree (HEAD: <short-sha or date>).

**Corrections to the original report:**
- <count/metadata/sub-claim corrections, one bullet each; "none" if none>

**Finding verification status:**

| Finding | Status | Verification note |
|---|---|---|
| 001 | Verified | <command or observation, one line> |
| ... | ... | ... |

**New findings during verification:** <IDs + one-liners, or "none">
**Remaining PLAUSIBLE items and what blocks them:** <or "none">
```

Also update the report header's **Status:** line (e.g., "Independently verified and corrected on YYYY-MM-DD; see §2.N").

### 5. Hand off
- If any P0/P1 finding is **Verified**, recommend proceeding to `01-Planning & Organizing/02-finalise-plan.md` with the verified subset.
- If material corrections were made, note in the addendum whether the original pass's method (not just its findings) needs adjusting — feed that back into the review-pass instructions.

## Acceptance Criteria
- Every finding in the consolidated index has exactly one status row in the addendum.
- Every status is backed by a command run or a current-worktree observation quoted in the note.
- Report counts, header status, and top-risk lists are consistent with the statuses.
- The original report body is unmodified; all changes live in the addendum and header status line.
- Zero findings left PLAUSIBLE without a stated blocker.

## Related Workflows
- `2026-07-03-deep-review-01-review-pass.md` — produces the input report.
- `2026-07-03-deep-review-00-overview.md` — ground rules shared by both passes.
- `01-Planning & Organizing/01-plan-review.md` — the same independent-second-look principle applied to plans.
