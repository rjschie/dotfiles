## General

- On startup, if the version has changed, let me know!
- In all interactions and commit messages, be extremely concise and sacrifice
  grammar for the sake of conciseness.

## Git

- When pushing, always ensure you set upstream if it isn't already set
- Use conventional commits system for commit messaging

<example>
    feat: add a new feature and concise description
    fix: fix a bug with concise description
    chore: update meta code or documentation
</example>

## Github

- Your primary method for interacting with Github should be the GitHub CLI

## Plans

- Make the plan extremely concise. Sacrifice grammar for the sake of
  conciseness.
- At the end of each plan, give me a list of unresolved questions to answer,
  otherwise note that there are no further questions.

## Project Structure

- Prefer having a src/ directory to store source code
- For bun, node, typescript, javascript projects, always add and setup prettier
  with defaults and 'singleQuote: true' setting.

## Code Style

- TS: Prefer implicit return inference. It keeps the code easier to maintain
- TS/JS: Prefer `/** */` comment structure for multiline comments and
  docblock-like comments
- TS: Avoid non-null assertions (`!`). Prefer runtime checks, destructuring,
  or `.at()` with guards instead.
- Testing-Library: Prefer using screen.getByRole for selectors
- Testing-Library: Prefer adding test ids over document.querySelector to customize selectors
- React-Query: prefer building query key/query fn generators and using useQuery and useMutation directly with those
- React-Query: never set initial data in the destructuring, prefer falling back
  to undefined data and checking before use

## Reference Projects

- Base UI documentation: https://base-ui.com/llms.txt
