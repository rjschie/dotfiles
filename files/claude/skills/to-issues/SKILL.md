---
name: to-issues
description: Break a plan, PRD, or OpenSpec change into independently-grabbable issues on the project issue tracker using tracer-bullet vertical slices. Use when user wants to convert a plan/PRD/OpenSpec change into issues, turn an `openspec/changes/<id>/tasks.md` into tracked work, create implementation tickets, or break down work into issues.
---

# To Issues

Break a plan into independently-grabbable issues using vertical slices (tracer bullets).

The issue tracker and triage label vocabulary should have been provided to you — run `/setup-matt-pocock-skills` if not.

## Process

### 1. Gather context

Work from whatever is already in the conversation context. Detect which **source mode** applies — they are mutually exclusive, pick the most specific:

- **OpenSpec change**: an `openspec/changes/<change-id>/` directory exists for the work in scope (either referenced in conversation, passed as arg, or the only active change). Read `proposal.md`, `tasks.md`, and every `specs/<capability>/spec.md` delta. Treat `proposal.md` as the "why", spec deltas as the contract, and `tasks.md` as a hint — NOT the final issue list (see step 3).
- **Issue reference**: user passes an issue number/URL/path. Fetch it from the issue tracker; read body and comments. Set this issue as the parent.
- **PRD / plan in conversation**: e.g. output of `/to-prd` or `/grill-with-docs`. Use it directly.
- **Bare conversation**: synthesize from the conversation so far.

Capture in your working notes: source mode, parent issue (if any), domain glossary terms used, relevant ADRs.

### 2. Explore the codebase (optional)

If you have not already explored the codebase, do so to understand the current state of the code. Issue titles and descriptions should use the project's domain glossary vocabulary, and respect ADRs in the area you're touching.

### 3. Draft vertical slices

Break the plan into **tracer bullet** issues. Each issue is a thin vertical slice that cuts through ALL integration layers end-to-end, NOT a horizontal slice of one layer.

Slices may be 'HITL' or 'AFK'. HITL slices require human interaction, such as an architectural decision or a design review. AFK slices can be implemented and merged without human interaction. Prefer AFK over HITL where possible.

<vertical-slice-rules>
- Each slice delivers a narrow but COMPLETE path through every layer (schema, API, UI, tests)
- A completed slice is demoable or verifiable on its own
- Prefer many thin slices over few thick ones
</vertical-slice-rules>

<openspec-reslicing>
If source mode is **OpenSpec change**, do NOT map `tasks.md` items 1:1 to issues. OpenSpec task lists are typically grouped by layer (e.g. "1. Schema", "2. API", "3. UI"); issues from this skill must be vertical. Re-slice as follows:

- Group tasks across layers by the **user-visible behavior** they jointly enable (use the spec deltas' scenarios as the unit of value).
- Each issue should pull one scenario (or a small cluster of related scenarios) end-to-end through whichever layers `tasks.md` touches.
- It is OK — and expected — for one issue to reference task items from multiple top-level sections of `tasks.md`. Record every covered item verbatim in the issue's `Source` section (see template) so closers can tick them back in `tasks.md` on merge.
- If a task is pure scaffolding with no user-visible behavior (e.g. "add migration table"), fold it into the first slice that needs it rather than making it its own issue.
  </openspec-reslicing>

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
- (OpenSpec only) Confirm coverage: list every `tasks.md` item ID and which slice owns it. Flag any unassigned tasks and ask whether they should be folded in, deferred, or dropped.

Iterate until the user approves the breakdown.

### 5. Publish the issues to the issue tracker

For each approved slice, publish a new issue to the issue tracker. Use the issue body template below. Apply the `needs-triage` triage label so each issue enters the normal triage flow.

Publish issues in dependency order (blockers first) so you can reference real issue identifiers in the "Blocked by" field.

<issue-template>
\-\-\-
parent: <#id> (optional) reference to the parent issue on the issue tracker (if the source was an existing issue, otherwise omit this section).
blocked by: <#id> (optional) reference to the blocking ticket (if any)
\-\-\-

## Source

(OpenSpec mode only)

- **Change**: `openspec/changes/<change-id>/`
- **Spec deltas**: `specs/<capability>/spec.md` — list each
- **tasks.md items**: list every covered item by its exact path + checkbox text, e.g.
  - `1.2 Add migration for foo_table`
  - `3.1 Wire POST /foos endpoint`
  - `4.3 Render Foo list in dashboard`

When this issue is closed/merged, the closer MUST tick those exact items in `openspec/changes/<change-id>/tasks.md` (and only those) in the same PR. This linkage is the contract that keeps the openspec change in sync with delivery.

## What to build

A concise description of this vertical slice. Describe the end-to-end behavior, not layer-by-layer implementation.

## Why

One or two sentences pulled from the source (PRD goal, openspec proposal "Why", or parent issue). Enough that a fresh contributor can grab the issue without re-reading the source.

## Acceptance criteria

Phrase as observable behavior. In OpenSpec mode, derive these from the relevant spec scenarios — quote or paraphrase them.

- [ ] Criterion 1
- [ ] Criterion 2
- [ ] Criterion 3

## Out of scope

Anything a reader might reasonably assume is included but isn't (deferred to another slice or change). Omit if nothing notable.

</issue-template>

Do NOT close or modify any parent issue.
