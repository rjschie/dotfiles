---
name: adr
description: Create an Architecture Decision Record (ADR) by interviewing the user, then write it to docs/adr/. Use when user runs `/adr <slug>` or wants to record a technical/architectural decision.
---

Create an ADR documenting a technical decision. Try to gain the ADR context based on the conversation, otherwise interview the user to gain context.

## Process

1. **Read template.**: [ADR-FORMAT.md](./ADR-FORMAT.md) and gain understanding of process and instructions for creating ADRs
2. **Ensure context.** Either infer context from the conversation and confirm with user, or inteview the user about the ADR
3. **Write the ADR.**
4. **Update the index** (`docs/adr/README.md`) with the new entry.

## Notes

- Keep ADRs short. A page is plenty. If it's growing past two pages, the decision is probably actually multiple decisions.
- ADRs are immutable once accepted. To change a decision, write a new ADR with status `Supersedes NNNN` and update the old one's status to `Superseded by MMMM`.
- Don't include code snippets or file paths that will rot. Capture reasoning, not implementation.
