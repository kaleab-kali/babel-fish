# Agent Workflow Notes

These notes capture repository-specific working rules for coding agents.

## Git And Pull Requests

- Use small, reviewable pull requests.
- Use branch names that describe the functional change, not internal phases.
- Use commit messages and pull request titles that describe the functional change.
- Do not use phase-style names such as "phase 1" or "foundation phase".
- Merge pull requests with normal merge commits only unless the maintainer explicitly asks for another strategy.
- Do not squash-merge pull requests unless the maintainer explicitly asks for it.
- Do not delete local or remote branches after merge unless the maintainer explicitly asks for branch deletion.
- Keep commits clean and focused.

## Attribution

- Do not add AI co-author footers.
- Do not add Claude, Codex, or other assistant attribution to commits, pull requests, or source files unless the maintainer explicitly asks for it.

## Verification

- Run appropriate checks before each pull request and after each meaningful stage.
- Include verification steps in the pull request body.
- For documentation-only changes, run whitespace and diff hygiene checks.
- For Dart or Flutter changes, run formatting, analyzer, and tests once those tools are available.

## Project Priorities

- Keep the public README focused on the project, not internal planning notes.
- Keep fixture mode working without network access, API keys, or real user audio.
- Do not commit secrets, provider keys, real recordings, or private transcripts.
- Build in small increments toward an open-source-ready Flutter and Dart monorepo.
