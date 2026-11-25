# From an Idea to an Autonomous Build

This guide is for starting a future project with an agent. You can begin with a rough idea. The sustained-build workflow comes after there is an agreed outcome and plan; it does not itself provide automatic continuation.

## 1. Describe the idea

Explain who it is for, the problem and what you imagine the first experience could be. Ask the agent to help develop the idea:

> I have an idea for [idea]. Help me explore the problem, the intended user and a small first version. Ask the most useful questions step by step, and label assumptions. Do not build yet.

## 2. Set up the project through guided intake

Give the agent [Guided Project Intake](../00-project-setup/13-guided-project-intake.md). It checks existing documents, asks focused questions, drafts appropriate project context and uses the existing [project setup workflow](../00-project-setup/01-setup-project.md) when needed.

> Use `Workflow-Scripts/00-project-setup/13-guided-project-intake.md` to help me establish this project. Use what I have already told you, ask only the important remaining questions, and propose sensible assumptions for me to correct.

The agent should preserve existing files and distinguish confirmed facts from provisional assumptions. A project may use a shared checkout instead of a nested one; point the agent to the location actually available. Use a Workflow-Scripts checkout that contains these files.

## 3. Research and plan

Use [Research and Plan](../01-planning-and-organizing/00-research-and-plan.md):

> Research this project and prepare a proportionate implementation plan using `Workflow-Scripts/01-planning-and-organizing/00-research-and-plan.md`. Investigate existing code and relevant options, identify risks, and distinguish verified facts from assumptions.

## 4. Test a critical unknown, if needed

For uncertain APIs, hardware, performance, interaction or other feasibility risks, authorize a small POC with explicit pass/fail checks. Record limitations. A straightforward idea may not need a separate POC.

## 5. Review and finalise the plan

Use [Plan Review and Finalisation](../01-planning-and-organizing/03-plan-review-and-finalise.md) on the plan. Review the first release's scope, trade-offs, costs, safety and real-world acceptance. Confirm the implementation outcome you want.

## 6. Start sustained implementation

Refer to [Sustained Autonomous Execution](../02-code-build/05-sustained-autonomous-execution.md):

> Use `Workflow-Scripts/02-code-build/05-sustained-autonomous-execution.md` to implement the agreed plan at [path]. Set a persistent goal to fully implement, test and verify it. Keep evidence and open acceptance current. [Optionally specify a budget and review checkpoints.]

If the optional `sustained-build` Codex skill has been installed and discovered, the shorter invocation is:

> `$sustained-build [plan path]`

Explicit invocation requests the sustained build and a persistent goal if supported. The skill follows the same workflow and respects the plan and authorization boundaries. It does not grant permission for deployment, paid calls or messaging. If the runtime lacks persistent goals, the agent can work in the current turn and leave a handoff but cannot promise automatic continuation. A skill must be installed in a discoverable location, and a new session may be needed for discovery.

## 7. Check progress and steer

At important milestones ask:

> Compare the work against the main user journey. What is implemented, what has been verified, what remains, and are we still focused on the highest-value work?

Ask for resource usage and scope review if the run grows. To stop ongoing work, explicitly request that the goal be paused; a progress request alone is not a pause.

## 8. Verify the real outcome

Ask for an audit of requirements and the actual candidate, separating automated tests, simulations, real-provider checks, hardware and human acceptance. Try the main journey and make the remaining product decisions. A plan checker or test count is not proof of real-world acceptance.
