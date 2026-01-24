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
