# Workflow: Guided Project Intake

## Purpose

Turn a rough idea into a usable, evidence-labeled project foundation and an appropriate handoff to research and planning. Use for a new project or an existing project that needs its intent and operating context clarified. This is an intake and documentation workflow; implement application code only when separately authorized.

## Start with what exists

Read the user's description, supplied material, existing project files and applicable agent instructions. Check the repository and working-tree state; preserve existing content and ongoing work. Identify the canonical project facts, product documents and existing setup before creating anything. Determine whether the user wants exploration, a prototype or a more substantial project; right-size the resulting documents.

## Guide the conversation

1. Summarize the idea in plain language and start with the most consequential unresolved question: usually who the user is, what problem they have, or what a first successful experience looks like. Ask one question at a time by default; combine a few closely related short questions when helpful. Adapt to answers rather than following a fixed questionnaire.
2. Continue independently with research, inventory or safe drafting while waiting where possible. For optional choices offer a recommendation and reasonable alternatives; explicitly label assumptions and invite corrections. Do not wait for optional answers indefinitely; follow the current agent runtime's user-input and timing rules.
3. Resolve only decisions needed for the current stage: user and journey, success, scope and exclusions, important constraints and safety/privacy needs, likely environment and any real-world acceptance. Ask the user when intent, consent, cost, irreversible decisions or a meaningful trade-off cannot be inferred. Record unknowns; never represent guesses as user decisions, verified facts or approval.
4. Keep the cognitive load low: use ordinary language, explain why a question matters, avoid repeating answered questions and show a short evolving summary. The user can add, correct or skip optional details.

## Populate and reconcile documents

- If project infrastructure is missing, apply the relevant parts of [project setup](01-setup-project.md) with the user's scope and existing host instructions. Reuse the project's existing conventions, never replace populated indexes, and record the real repository layout. Do not create accounts, repositories, credentials or paid services unless authorized.
- Draft or update the appropriate existing source of truth for project facts, agent rules and a brief: often `PROJECT.md`, `AGENTS.md`, and a short idea or research document. Create only artifacts that help this project; avoid duplicate competing sources. Mark inferred statements as proposals or assumptions and link their evidence.
- For UI/product projects follow the applicable product-design setup and interview process. In particular, do not invent an authoritative `PRODUCT.md`; obtain the user input required by [project scaffold guidance](skills/03-project-scaffold.md).
- When the project is ready for more detailed work, hand off to [research and planning](../01-planning-and-organizing/00-research-and-plan.md). If a critical uncertainty merits a POC, propose or conduct it only within the user's authorized scope. Never create an implementation plan as complete without its applicable review and verification.

## Handoff

Summarize the user's idea, documents created or updated, confirmed decisions, provisional assumptions and open questions. Identify a concrete next step and whether implementation or a persistent build goal has been authorized. This workflow does not itself authorize application implementation, deployment or a persistent goal.
