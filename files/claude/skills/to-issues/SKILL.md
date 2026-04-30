---
name: to-issues
description: Break a plan, spec, or PRD into independently-grabbable issue files using tracer-bullet vertical slices. Use when user wants to convert a plan into issues, create implementation tickets, or break down work into issues.
---

# To Issues

Break a plan into independently-grabbable issue files using vertical slices (tracer bullets).

## Process

### 1. Gather context

Work from whatever is already in the conversation context. If the user passes a PRD file as an argument (e.g. `@docs/prds/<slug>/PRD.md`), read it for additional context.

Determine the PRD slug:
- If a PRD path was passed, derive slug from the path.
- Else if a PRD was just created in this session, use that slug.
- Else ask the user.

### 2. Explore the codebase (optional)

If you have not already explored the codebase, do so to understand the current state of the code.

### 3. Draft vertical slices

Break the plan into **tracer bullet** issues. Each issue is a thin vertical slice that cuts through ALL integration layers end-to-end, NOT a horizontal slice of one layer.

Slices may be 'HITL' or 'AFK'. HITL slices require human interaction, such as an architectural decision or a design review. AFK slices can be implemented and merged without human interaction. Prefer AFK over HITL where possible.

<vertical-slice-rules>
- Each slice delivers a narrow but COMPLETE path through every layer (schema, API, UI, tests)
- A completed slice is demoable or verifiable on its own
- Prefer many thin slices over few thick ones
</vertical-slice-rules>

### 4. Quiz the user

Present the proposed breakdown as a numbered list. For each slice, show:

- **Title**: short descriptive name
- **Type**: HITL / AFK
- **Blocked by**: which other slices (if any) must complete first
- **User stories covered**: which user stories this addresses (if the source material has them)

Ask the user:

- Does the granularity feel right? (too coarse / too fine)
- Are the dependency relationships correct?
- Should any slices be merged or split further?
- Are the correct slices marked as HITL and AFK?

Iterate until the user approves the breakdown.

### 5. Create the issue files in relevant PRD folder

For each approved slice, create an issue in `docs/prds/<prd-slug>/issues/<NNN-issue-slug>.md`. `mkdir -p` the directory.

`NNN` is zero-padded 3 digits, assigned in dependency order (blockers get lower numbers). For slices with no dependencies, fall back to creation order. Create files in that same order so "Blocked by" refs point at already-written files.

<issue-template>
## Context

See [PRD](../PRD.md) for full product context.

## What to build

A concise description of this vertical slice. Describe the end-to-end behavior, not layer-by-layer implementation.

## Acceptance criteria

- [ ] Criterion 1
- [ ] Criterion 2
- [ ] Criterion 3

## Blocked by

- [`<NNN-issue-slug>.md`](./<NNN-issue-slug>.md) (if any)

Or "None - can start immediately" if no blockers.

</issue-template>
