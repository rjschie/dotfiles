---
name: grill-with-docs
description: Grilling session that challenges your plan against the existing domain model, sharpens terminology, and updates documentation (CONTEXT.md, ADRs) inline as decisions crystallise. Use when user wants to stress-test a plan against their project's language and documented decisions.
---

<what-to-do>

If auto mode is active, exit it before continuing — this skill requires turn-by-turn user interaction.

Interview me **one question per turn**. Send a question, wait for my reply, then send the next. Never stack multiple questions in a single turn — not as a numbered list, not as "and also…", not as a follow-up in the same message.

Be **relentless across turns**: cover every aspect of this plan until we reach a shared understanding. Walk down each branch of the design tree, resolving dependencies between decisions one-by-one.

For the current question, propose your recommended answer so I can react to it.

If a question can be answered by exploring the codebase, explore the codebase instead.

This skill is the **single entry point** for any new work. At the end of the session, route the output to the right artifact (OpenSpec change, PRD/issues, or pure ADR) — see "Routing the outcome" below.

</what-to-do>

<supporting-info>

## Domain awareness

During codebase exploration, also look for existing documentation:

### File structure

Most repos have a single context:

```
/
├── CONTEXT.md
├── docs/
│   └── adr/
│       ├── 0001-event-sourced-orders.md
│       └── 0002-postgres-for-write-model.md
└── src/
```

If a `CONTEXT-MAP.md` exists at the root, the repo has multiple contexts. The map points to where each one lives:

```
/
├── CONTEXT-MAP.md
├── docs/
│   └── adr/                          ← system-wide decisions
├── src/
│   ├── ordering/
│   │   ├── CONTEXT.md
│   │   └── docs/adr/                 ← context-specific decisions
│   └── billing/
│       ├── CONTEXT.md
│       └── docs/adr/
```

Create files lazily — only when you have something to write. If no `CONTEXT.md` exists, create one when the first term is resolved. If no `docs/adr/` exists, create it when the first ADR is needed.

## During the session

### Challenge against the glossary

When the user uses a term that conflicts with the existing language in `CONTEXT.md`, call it out immediately. "Your glossary defines 'cancellation' as X, but you seem to mean Y — which is it?"

### Sharpen fuzzy language

When the user uses vague or overloaded terms, propose a precise canonical term. "You're saying 'account' — do you mean the Customer or the User? Those are different things."

### Discuss concrete scenarios

When domain relationships are being discussed, stress-test them with specific scenarios. Invent scenarios that probe edge cases and force the user to be precise about the boundaries between concepts.

### Cross-reference with code

When the user states how something works, check whether the code agrees. If you find a contradiction, surface it: "Your code cancels entire Orders, but you just said partial cancellation is possible — which is right?"

### Update CONTEXT.md inline

When a term is resolved, update `CONTEXT.md` right there. Don't batch these up — capture them as they happen. Use the format in [CONTEXT-FORMAT.md](./CONTEXT-FORMAT.md).

Don't couple `CONTEXT.md` to implementation details. Only include terms that are meaningful to domain experts.

### Detect OpenSpec early

At the start of the session, check whether `openspec/` exists at the repo root. If it does, the repo uses OpenSpec to track product capabilities as given/when/then specs:

- `openspec/specs/` — current capability specs
- `openspec/changes/` — inflight changes (deltas) to specs

Read any specs relevant to the area being grilled — they're additional source-of-truth alongside `CONTEXT.md` and ADRs. Cross-reference them when grilling: "spec X says the app does Y in this case — does your plan agree, contradict, or extend it?"

### Routing the outcome

Toward the end of the session, classify what was decided and announce the routing decision before writing anything:

1. **Behavioral / capability change** — the app does something new or different from a user's perspective.
   - If `openspec/` exists: draft a new change under `openspec/changes/<slug>/` with proposal + spec deltas (given/when/then). Hand off to `opsx:propose` / `opsx:ff` / `opsx:apply` for the formal artifact creation.
   - If `openspec/` does not exist: proceed to PRD/issues (next branch).
2. **Non-capability product work** — UI polish, infra, ops, refactors, dev-tooling. No spec delta makes sense.
   - Hand off to `to-prd` (writes a PRD to the issue tracker), then `to-issues` (breaks it into tracer-bullet issues).
3. **Pure architectural/technical decision** with no behavior change — e.g. "switch DB driver," "adopt new lint rule."
   - Just write an ADR (see below). No spec delta, no PRD.

CONTEXT.md updates and ADRs happen **inline during the grill** regardless of which branch — they aren't part of the routing decision.

State the chosen branch explicitly: "This is a behavioral change → I'll draft an OpenSpec change at `openspec/changes/<slug>/`." Then proceed.

### Offer ADRs sparingly

Only offer to create an ADR when all three are true:

1. **Hard to reverse** — the cost of changing your mind later is meaningful
2. **Surprising without context** — a future reader will wonder "why did they do it this way?"
3. **The result of a real trade-off** — there were genuine alternatives and you picked one for specific reasons

If any of the three is missing, skip the ADR. Use the format in [ADR-FORMAT.md](../adr/ADR-FORMAT.md).

</supporting-info>
