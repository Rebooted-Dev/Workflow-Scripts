# Workflow: Code Optimization

## Purpose
Perform a structured analysis to identify performance bottlenecks, resource inefficiencies, and optimization opportunities, then file a report in `plans/` (project root).

## Inputs
- Repository root.
- Any user-specified focus areas (optional).
- Performance requirements or benchmarks (optional).

## Prioritization Rule
- Score each finding with severity (S0–S3) and priority (P0–P3).
- Present the report ordered by priority (P0 to P3), then severity within each priority.
- Performance issues typically map to S1/S2 severity and P1/P2 priority unless they cause outages or critical user impact.
- Use the shared rubric: `../00-meta/severity-priority-rubric.md`.

## Steps
1. Scan the codebase using parallel agents. Each agent should read files in parallel batches (read multiple files concurrently, not sequentially):
   - Agent 1: Scan for performance bottlenecks (read implementation files, algorithms, data structures in parallel)
   - Agent 2: Scan for resource inefficiencies (read memory usage, file I/O, network calls, database queries in parallel)
   - Agent 3: Scan for optimization opportunities (read loops, recursive calls, caching opportunities in parallel)
   - Agent 4: Scan for scalability concerns (read concurrent operations, state management, bottlenecks in parallel)
   - Agent 5: Analyze build and bundle size (read build configs, dependencies, bundle analysis in parallel)
   Agents should batch read files (e.g., read 5-10 files concurrently per agent) to maximize throughput.

2. For each optimization finding, capture:
   - file path and line reference
   - current performance characteristics (if measurable)
   - observed behavior and impact (latency, throughput, resource usage)
   - severity (S0–S3) and priority (P0–P3) with rationale
   - suggested optimization approach with expected improvement
   - verification step (how to measure the improvement)
   - potential risks or trade-offs of the optimization

3. Group and order findings by priority, then severity. Performance issues should be prioritized as:
   - P0: Critical performance issues causing outages, timeouts, or blocking user workflows
   - P1: High-impact performance issues affecting user experience significantly
   - P2: Medium-impact optimizations that would improve efficiency
   - P3: Low-impact optimizations or micro-optimizations

4. Add a summary with:
   - Top P0/P1 performance risks and immediate action items
   - Overall performance posture assessment
   - Recommended optimization roadmap
   - Expected impact of addressing high-priority items

5. Save the report to `plans/` (project root) with a dated filename (e.g., `code-optimization-YYYY-MM-DD-HH-MM.md`).

## Output Requirements
- Report title, date/time, scope, and summary.
- Optimization findings with evidence and actionable improvements.
- No unverified claims or assumptions.
- Each finding should include:
  - Clear performance issue description
  - Evidence of the performance impact (metrics, benchmarks, or analysis)
  - Impact assessment (user experience, resource usage, scalability)
  - Optimization approach with code examples when applicable
  - Testing/verification approach to measure improvement
  - Risk assessment for the optimization

## Optimization Focus Areas
- Algorithm complexity and efficiency
- Database query optimization
- Network request batching and caching
- Memory usage and leaks
- Bundle size and code splitting
- Rendering performance (for UI code)
- Concurrent operations and race conditions
- Unnecessary computations and redundant operations
- Resource pooling and reuse
- Lazy loading and code splitting opportunities

## Acceptance Criteria
- Every item includes a file/line reference, evidence, and rationale.
- Items are ordered by priority (P0 to P3) and severity within each priority.
- Severity and priority are consistent and justified per the rubric.
- Critical performance issues (P0/S0-S1) are clearly flagged and prioritized.
- The report is self-contained and reproducible.
- Findings are actionable with specific optimization guidance.
- Expected improvements are quantified when possible.

## Notes
- Use parallel agents to accelerate scanning, but verify findings directly.
- When reading files, agents should read multiple files concurrently (parallel batch reading) rather than sequentially to maximize speed.
- Do not modify source code in this workflow; only produce the optimization report.
- Consider both code-level optimizations and architectural performance improvements.
- Focus on measurable improvements rather than speculative optimizations.
- For critical findings, provide immediate mitigation steps even if full optimization requires more time.
