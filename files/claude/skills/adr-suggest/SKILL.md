---
name: adr-suggest
description: Detect when a session has produced an architectural/technical decision worth recording, and suggest the user run `/adr <slug>` to capture it. Use proactively at natural decision points — end of a grill-me session, after resolving a choice between named alternatives, after the user says "let's go with X", "we'll standardize on Y", "I've decided…", or after a planning discussion that resolved multiple branches. Do NOT use for local/tactical choices, work already heading into an OpenSpec change or PRD, or decisions the user has explicitly waved off documenting.
---

Recognize ADR-worthy moments and nudge the user — don't write the ADR yourself, don't invoke `/adr` automatically.

## When to fire

Fire when **both** of these hold:

1. A decision was resolved — the user landed on a choice, even if the reasoning was implicit, half-spoken, or worked out through waffling. You don't need an articulated "why" to fire; the `/adr` interview will surface it. Signals include: "let's go with X", "we'll use Y", "I've decided…", "ok, X it is", or visible convergence after weighing options.
2. The decision has durable consequences — constrains future work, is hard to reverse, or sets a boundary/contract/standard. Examples: framework/library choice, schema shape, module boundary, protocol, tooling standard, deprecation, naming convention adopted repo-wide.

Skip the fire if the decision is already being captured elsewhere this session (OpenSpec change, PRD, RFC issue).

When firing, sketch a probable "why" from whatever context you have — even partial — so the user sees the suggestion is grounded. If you genuinely have no signal on the reasoning, still fire; just say so ("reasoning not yet captured — `/adr` will walk through it").

## When to skip

- Local/tactical choices (variable names, one-off fix path, internal refactor with no API change).
- Decision was reversed or superseded within the same session.
- User explicitly said they don't want to document it, or this is a throwaway/spike.
- You'd be firing a second time for the same decision.

## What to output

One short message at the end of the relevant turn. Do not preamble. Do not list every decision exhaustively. Format:

> **ADR-worthy decision spotted:** <one-sentence summary of the decision and why it matters>.
> Run `/adr <suggested-slug>` to record it.

If multiple distinct decisions came up (e.g. end of a `grill-me` session), list up to 3 as a bulleted set with suggested slugs each. More than 3 means you're being too eager — pick the top ones by durability/blast-radius.

## Slug guidance

- kebab-case, imperative or noun phrase, 2–5 words
- Good: `switch-to-pnpm`, `use-postgres-row-level-security`, `single-tenant-per-schema`
- Bad: `decision-1`, `pnpm`, `the-package-manager-thing`

## Stop there

After the suggestion, stop. The user will run `/adr` if they want it. Do not start drafting the ADR and do not ask follow-up questions about it.

Don't re-suggest the **same** decision on later turns — once nudged, it's the user's call. But new, distinct decisions later in the same session *should* trigger fresh suggestions; the skill is meant to fire as often as genuinely new ADR-worthy decisions arise.
