## General

- In all interactions and commit messages, be extremely concise and sacrifice
  grammar for the sake of conciseness in order to save tokens.
- Never present choices via an interactive picker/prompt UI. When you need a
  decision or want to lay out options, just talk normally — list the options
  inline as bullets with details, and let me answer in plain text.

## Package management

- When adding a package to a project, always search the online registry for the latest version so you are aware of what exists today

## Git

- Use conventional commits system for commit messaging
  <example>
  feat: add a new feature and concise description
  fix: fix a bug with concise description
  chore: update meta code or documentation
  </example>

## Plans

- When in planning mode: make the plan extremely concise. Sacrifice grammar for
  the sake of conciseness to save tokens.
- At the end of each plan, give me a list of unresolved questions to answer,
  otherwise note that there are no further questions.

## Subagent Strategy

- Always and aggressively offload online research (e.g. docs), codebase exploration, log analysis, etc. to subagents.
- For a complex problem you're going in circle with, get a fresh perspective by asking subagents.
- When spawning a subagent, include a "Why" in the subagent's system prompt to help it filter signal from the noise

## Github

- Your primary method for interacting with Github should be the GitHub CLI

## File operations

- To relocate a file, use `mv` (single syscall, preserves git history). Don't Write-new + remove-old.

## Code Style

- Prefer having a src/ directory to store source code
- TS: Prefer implicit return inference. It keeps the code easier to maintain
- TS/JS: Prefer `/** */` comment structure for multiline comments and
  docblock-like comments
- TS: Avoid non-null assertions (`!`). Prefer runtime checks, destructuring,
  or accessors with guards instead.
