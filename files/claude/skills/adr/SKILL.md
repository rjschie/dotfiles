---
name: adr
description: Create an Architecture Decision Record (ADR) by interviewing the user, then write it to docs/adr/. Use when user runs `/adr <slug>` or wants to record a technical/architectural decision.
---

Create an ADR documenting a technical decision. Slug from the command argument (e.g. `/adr switch-to-pnpm` → slug `switch-to-pnpm`). If no slug given, suggest one based on context.

## Process

1. **Locate or create `docs/adr/`**. If missing, create it. If an `adr/` lives elsewhere in the repo, use that instead.

2. **Determine the next number**. Scan existing files matching `NNNN-*.md`, take max + 1, zero-pad to 4 digits. If none exist, start at `0001`. Also create `docs/adr/README.md` as an index if it doesn't exist (one-line entries: `- [NNNN](NNNN-slug.md) — Title`).

3. **Interview the user, one question at a time.** For each, give your recommended answer based on conversation context and codebase exploration so they can just confirm. Skip questions you can already answer confidently from context — don't ask things you already know.

   Ask in this order:
   1. **Title** — short imperative phrase ("Switch from npm to pnpm"). Derive from slug; confirm.
   2. **Context** — what situation/problem/forces are prompting this? What's true about the codebase or constraints today that makes this decision necessary now? (Explore the repo if helpful rather than asking.)
   3. **Options considered** — what alternatives were on the table? For each, the main tradeoff. If there's only one real option, say so and skip.
   4. **Decision** — what's being chosen, and the core reasoning (1–3 sentences).
   5. **Consequences** — what gets better, what gets worse, what's now harder or constrained. Be honest about downsides; an ADR with only upsides is suspicious.
   6. **Status** — default `Accepted`. Other options: `Proposed`, `Superseded by NNNN`, `Deprecated`. Usually just `Accepted` unless user indicates otherwise.

4. **Write the file** to `docs/adr/NNNN-slug.md` using the template below.

5. **Update the index** (`docs/adr/README.md`) with the new entry.

6. **Report** the path and offer to `git add` it (don't commit unless asked).

## Template

```markdown
# NNNN. <Title>

- **Status**: <Accepted|Proposed|Superseded by NNNN|Deprecated>
- **Date**: <YYYY-MM-DD>

## Context

<What's the situation? What forces are at play — technical, organizational, constraints? Why are we deciding this now?>

## Options Considered

<Omit this section if there was only one real option.>

### Option A: <name>

- Pros: ...
- Cons: ...

### Option B: <name>

- Pros: ...
- Cons: ...

## Decision

<What we're doing and why. 1–3 sentences. Active voice: "We will use pnpm…">

## Consequences

**Positive**

- ...

**Negative**

- ...

**Neutral**

- ...
```

## Notes

- Keep ADRs short. A page is plenty. If it's growing past two pages, the decision is probably actually multiple decisions.
- ADRs are immutable once accepted. To change a decision, write a new ADR with status `Supersedes NNNN` and update the old one's status to `Superseded by MMMM`.
- Don't include code snippets or file paths that will rot. Capture reasoning, not implementation.
