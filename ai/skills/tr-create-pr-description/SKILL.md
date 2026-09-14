---
name: tr-create-pr-description
description: "Trigger: PR description, pull request description, PR template, escribir PR, crear PR, descripción de PR. Generate the description for an existing GitHub PR, by number, following Taskrabbit conventions."
argument-hint: <pr-number>
model: haiku
context: fork
background: false
allowed-tools: Bash(gh pr view:*), Bash(gh pr diff:*), Read, Glob
---

# Create PR Description

Generate the description for PR #$ARGUMENTS.

## Activation Contract

Activate when:
- The user asks for a PR description, PR template, or resumen de PR for an existing PR
- Reviewing an existing PR description for completeness

Do NOT activate for:
- Writing the code changes themselves
- Commit messages
- Issue creation

## Hard Rules

1. This skill always works against the PR passed as a parameter. If `$ARGUMENTS` is empty, do no work and return only the line `No PR number provided. Invoke as /tr-create-pr-description <pr-number>.` — this runs in a forked subagent, so there is no way to ask the user interactively.
2. Never read the local working tree, the current branch, or local commits. The checkout may not correspond to the PR.
3. Inspect the diff before writing — never guess.
4. Take the Jira ticket ID from the PR's `headRefName` (first `[A-Z]+-\d+` segment) and prefix the title as `[TICKET-ID] `.
5. If `.github/PULL_REQUEST_TEMPLATE/` exists, use its structure. It is the source of truth.
6. Keep the description factual and scoped to what the PR actually does.
7. Output only. Never write: no `gh pr edit`, no `gh pr create`, no files.

## Execution Steps

1. Run `gh pr view $ARGUMENTS --json title,body,url,baseRefName,headRefName,commits` for context.
2. Run `gh pr diff $ARGUMENTS` for the full diff.
3. Extract the ticket ID from `headRefName`.
4. If the PR already has a body, treat it as a draft to improve, not as ground truth — the diff wins on any disagreement.
5. If `.github/PULL_REQUEST_TEMPLATE/` exists, read it and follow its sections.
6. Return the title and body as a single copy-pasteable markdown block. This runs in a forked subagent, so the final text is the deliverable the user sees — no preamble, no commentary about the process.

## Output Contract

Return:
- Jira ticket ID extracted from `headRefName`
- PR title: `[TICKET-ID] ` + imperative description (max 72 chars)
- PR body following the template, or the fallback structure if none exists

## References

- `.github/PULL_REQUEST_TEMPLATE/` — source of truth for description structure
- Branch convention: `TICKET-ID-description` (e.g. `BOOKING-4363-Fix-broken-Grid...`)
