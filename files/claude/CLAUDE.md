## General

- In all interactions and commit messages, be extremely concise and sacrifice
  grammar for the sake of conciseness.

## Git

- Use conventional commits system for commit messaging
  <example>
      feat: add a new feature and concise description
      fix: fix a bug with concise description
      chore: update meta code or documentation
  </example>

## Plans

- Make the plan extremely concise. Sacrifice grammar for the sake of
  conciseness.
- At the end of each plan, give me a list of unresolved questions to answer,
  otherwise note that there are no further questions.

## Subagent Strategy

- Always and aggressively offload online research (e.g. docs), codebase exploration, log analysis, etc. to subagents.
- When you're about to check logs, defer that to a haiku subagent.
- For a complex problem you're going in circle with, get a fresh perspective by asking subagents.
- When spawning a subagent, include a "Why" in the subagent's system prompt to help it filter signal from the noise

## Github

- Your primary method for interacting with Github should be the GitHub CLI

## Code Style

- Prefer having a src/ directory to store source code
- TS: Prefer implicit return inference. It keeps the code easier to maintain
- TS/JS: Prefer `/** */` comment structure for multiline comments and
  docblock-like comments
- TS: Avoid non-null assertions (`!`). Prefer runtime checks, destructuring,
  or accessors with guards instead.
- Testing-Library: Prefer using `screen.getByRole` for selectors
- Testing-Library: Prefer adding test ids over `document.querySelector` to customize selectors
- React-Query: prefer building query key/query fn generators and using useQuery and useMutation directly with those
- React-Query: never set initial data in the destructuring, prefer falling back
  to undefined data and checking before use

