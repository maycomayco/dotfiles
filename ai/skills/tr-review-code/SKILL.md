---
name: tr-review-code
description: "Trigger: code review, revisar PR, review de código, revisar cambios. Review a GitHub PR, or the current uncommitted local changes if no PR number is given, using the tr-code-reviewer subagent."
argument-hint: "[pr-number]"
allowed-tools: Agent, Bash(gh pr view:*), Bash(gh pr diff:*), Bash(git diff:*), Bash(git status:*)
---

# Code Review

If `$ARGUMENTS` is provided, review PR #$ARGUMENTS:

1. Run `gh pr view $ARGUMENTS --json title,body,url,baseRefName,headRefName` to get PR context.
2. Run `gh pr diff $ARGUMENTS` to get the full diff.

If `$ARGUMENTS` is empty, review the uncommitted changes in the local working tree instead:

1. Run `git diff HEAD` to get the diff of everything staged and unstaged.
2. Run `git status --short` to also list untracked new files, since `git diff` won't show those.

Then, regardless of mode:

1. Invoke the `tr-code-reviewer` subagent with the available title/description (PR mode) and the diff. The review must stay scoped to the changed files/lines.
2. Present the subagent's review output to the user, following its Review Output Template. Do not post it as a PR comment.
