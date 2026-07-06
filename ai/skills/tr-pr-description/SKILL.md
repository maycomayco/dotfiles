---
name: tr-pr-description
description: "Trigger: PR description, pull request description, PR template, escribir PR, crear PR. Generate pull request descriptions following team conventions."
---

# PR Description Skill

## Activation Contract

Generate or review a PR description when:
- A branch has commits ready for a PR and no description exists yet
- The user explicitly asks for a PR description, PR template, or resumen de PR
- Reviewing an existing PR description for completeness

Do NOT activate for:
- Writing code changes themselves
- General commit messages
- Issue creation

## Hard Rules

1. Inspect the diff before writing — never guess.
2. Extract the Jira ticket ID from the branch name (first `[A-Z]+-\d+` segment) and prefix the title as `[TICKET-ID] `.
3. If `.github/PULL_REQUEST_TEMPLATE/` exists, use its structure. It is the source of truth.
4. Keep descriptions factual and scoped to what the PR actually does.

## Execution Steps

1. Detect base branch (usually `main` or `master`).
2. Extract ticket ID from branch name.
3. Run `git log --oneline <base>...HEAD` and `git diff <base>...HEAD --stat`.
4. If `.github/PULL_REQUEST_TEMPLATE/` exists, read it and generate the description following its sections.
5. Present the description to the user for review.

## Output Contract

Return:
- Jira ticket ID extracted from branch
- PR title: `[TICKET-ID] ` + imperative description (max 72 chars)
- PR body following template or fallback structure

## References

- `.github/PULL_REQUEST_TEMPLATE/` — source of truth for description structure
- Branch convention: `TICKET-ID-description` (e.g. `BOOKING-4363-Fix-broken-Grid...`)
