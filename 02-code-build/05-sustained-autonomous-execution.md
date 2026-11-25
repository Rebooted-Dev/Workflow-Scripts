# Workflow: Sustained Autonomous Execution

## Purpose and when to use

Use this workflow when the user wants an agent to carry a substantial project from an agreed specification or implementation plan through implementation and verification over multiple turns. It is an orchestration layer around the existing [execution and confirmation workflow](03-execute-and-confirm.md), not a replacement for its verification or terminal gate.

Use a smaller workflow for a localized task. This workflow cannot create access, override project instructions, consent to paid services or deployment, or turn simulated tests into real-world acceptance.

## Inputs and outputs

**Inputs:** user-authorized objective, project/repository path, applicable instructions, plan and success criteria, relevant existing work, available tools, permissions and any user-set budget or checkpoint preferences.

**Outputs:** implemented and reviewed changes, a current plan and evidence trail, the applicable terminal-gate outcome, and a concise handoff that distinguishes verified outcomes from open work. A persistent goal is optional and runtime-dependent; the agent must not create one unless the user explicitly requests a goal.

## 1. Establish the operating boundary

1. Read the project instructions, product truth and applicable active learnings. Check the owning repositories, branches, untracked and modified files, ongoing work and required verification commands. Preserve concurrent work; choose isolation where appropriate.
2. Describe the user, main journey, intended outcome, non-goals and invariants. Identify decisions already made and resolve safe, routine choices from existing evidence. Ask for missing decisions only when they block dependent work; continue independent authorized work in the meantime.
3. Record what requires a person, special equipment, credentials, paid services, external writes or explicit authorization. Do not silently broaden authorization, change UI where restricted, deploy, publish or send messages contrary to applicable instructions.
4. Confirm resource constraints that the user has supplied, including budget, time and review checkpoints. Make usage and cost visibility part of the handoff. Do not invent a token budget or assume a goal's counter maps to billing.

## 2. Build a dependable starting point

1. Inventory existing code, prototypes, tests, research, design assets and relevant external integrations. Identify what is verified, what is a hypothesis and what must be tested in the intended environment. Cite the actual source and revision where useful.
2. Prove the highest-risk unknowns with a small, authorized spike when practical. Preserve useful baseline tests and record failures and limitations.
3. Create or reconcile a proportionate plan using the [plan contract](../00-Meta-Workflow/00-meta/plan-template.md) and the host's conventions. Include scope and exclusions, architecture boundaries, failure and recovery behavior, dependencies, task-sized steps, applicable verification commands, evidence locations and human acceptance. Map the primary user journey before optional refinements.
4. Reconcile contradictions and dependencies. Get a required design or product decision from its owner where applicable; do not represent an unreviewed design or a fallback as approved. Validate the plan using the host's rules, including `check-plan.sh --require-tier` when the shared plan contract applies.
5. Establish fast feedback: deterministic tests for core behavior, injectable boundaries for external systems, practical integration and smoke checks, and a way to reproduce the candidate. Mocks test simulated behavior only.

## 3. Authorize sustained work

The user's objective and authority govern the scope. If the user explicitly requests a persistent goal and the runtime provides one, set it to the full agreed outcome, including verification and references to the current plan. Use a token budget only when the user explicitly specifies one. Respect runtime-controlled goal status, budget and pause behavior.

If the runtime has no persistent goal, run the authorized work in the current turn and provide a durable handoff when interrupted or unable to continue. Do not claim automatic continuation is configured, and do not substitute a scheduled automation to track the active build.

Example goal wording to adapt and present or use only when the user explicitly requests a goal:

> Implement and verify the agreed project outcome described in `<plan path>`. Preserve its scope and product invariants. Continue through dependent implementation and appropriate testing; maintain current evidence, open issues and a reproducible checkpoint. Keep human, live-service and hardware acceptance open until actually performed. Respect project instructions, existing changes, permissions and any user-specified resource limits.

## 4. Execute in evidence-driven slices

Repeat until the authorized outcome is verified, a genuine blocker requires a person or external change, a runtime limit is reached, or the user pauses or changes direction:

1. Re-read the current objective and check the actual plan, code, Git state and last evidence; summaries are pointers, not proof. Select the highest-value unblocked step on the path to the main journey and its acceptance criteria.
2. Inspect the existing implementation before adding or changing behavior. Make a cohesive change within the authorized scope, preserving invariants and failure recovery.
3. Run focused, meaningful checks for the changed behavior. For bugs, add regression coverage when it fits. Fix a failure and rerun the affected checks. Run broader verification at meaningful integration boundaries and whenever new changes, failures or unresolved concerns justify it; avoid repeating unchanged expensive suites merely because a turn ended.
4. Update the plan in the same step its verification passes. Link concise evidence with revision, command, result and limitations; classify every open item using the host's rules. Record nontrivial fixes and learnings under the owning repository's conventions. Keep detailed logs in evidence files rather than repeatedly expanding the plan with full narratives.
5. Review the diff, sensitive data and side effects. Create a checkpoint only when authorized and appropriate; in a shared worktree verify that a commit or test actually represents its claimed candidate. Prefer a clean snapshot or isolated checkout for candidate-level verification.
6. Report material progress, uncertainty and the next decision or result. If no meaningful progress is possible, inspect the actual blocking condition; follow runtime rules for blocked, paused and budget-limited goals. A repeated observation or a successful narrow test is not evidence of overall completion.

Use skills when relevant and available: read their instructions, follow the applicable scope and precedence, and use the required tools. Delegate only when authorized and useful for independent work, with clear ownership and verification. Neither skill presence nor delegation is a substitute for product evidence.

## 5. Check alignment and prevent drift

At user-specified checkpoints, major integration boundaries or when the work is losing focus, compare completed work and remaining effort to the main user journey, priority, plan and resource constraints. Surface scope growth, repeated low-value fixes, increasing documentation overhead, unresolved approval dependencies and test gaps. Recommend a concrete adjustment when needed; do not silently reduce the objective or declare it complete. A progress report alone does not imply the user has paused or approved a scope change.

## 6. Confirm and hand off

Audit every committed requirement and success criterion against current source and evidence. Run the applicable project verification, tests and runtime smoke/acceptance checks on the candidate; record versions, conditions and limits. Distinguish unit, simulated integration, real-provider, real-device and human acceptance.

Apply the [execution and confirmation workflow](03-execute-and-confirm.md), including its mandatory terminal gate and plan validator, when this workflow is selected. If evidence is missing, keep the affected items open and use the gate's reconcile-only outcome; do not mark the overall plan complete. Report the candidate/revision, what works, checks actually run, remaining risks, blockers, human decisions and concrete next steps.

## Operational notes

- Continuous execution is a capability of the runtime and its goal mechanism, not a property of a Markdown plan or this file. Do not assume the same behavior across products or versions.
- A plan validator checks the document contract; it cannot prove tests, product behavior, accessibility or acceptance.
- Activity, commit counts and test counts are useful signals, not measures of completion or quality.
- Keep a single authoritative plan and use linked evidence. During long runs, reassess whether a detailed log or learning will help future work before adding more process overhead, while honoring the owning repository's rules.
