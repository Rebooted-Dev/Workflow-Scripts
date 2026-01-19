I want you to refactor my AGENTS.md file to follow progressive disclosure principles.

Follow these steps:

1. **Find contradictions**: Identify any instructions that conflict with each other. For each contradiction, ask me which version I want to keep.

2. **Identify the essentials**: Extract only what belongs in the root AGENTS.md:
   - One-sentence project description
   - Core architectural decisions that affect the entire codebase
   - High-level coding standards that apply everywhere
   - Key workflows that every agent should follow
   - Important "never do" rules
   - Links to deeper documentation

   Everything else should be moved out.

3. **Move everything else to dedicated files**: Create a docs/agents/ folder (or similar) and move the rest of the content into focused, specific files. Examples of good files:
   - agents/project-overview.md
   - agents/testing-strategy.md
   - agents/ui-component-rules.md
   - agents/api-layer-guidelines.md
   - agents/database-conventions.md
   - agents/naming-conventions.md
   - agents/error-handling.md

   Create clear, descriptive filenames.

4. **Link from root**: In the root AGENTS.md, add clean links to these deeper files with a one-sentence description of what each contains.

5. **Remove duplication and noise**: Eliminate anything that's repeated, outdated, or overly verbose. Be ruthless about keeping the root file lean.

6. **Output format**: Show me:
   - The proposed new root AGENTS.md content
   - A list of new files to create with their suggested paths and a short summary of what goes in each
   - Any questions/clarifications you need from me before proceeding

After I approve or give feedback, make the actual file changes.