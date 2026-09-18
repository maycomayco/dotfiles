---
name: tr-review-full
description: "Trigger: review completo, full review, deep review, revisar contra el spec, verificar que implementa el ticket, review antes de mergear. Three-axis review of one diff — code quality (tr-code-reviewer), spec conformance against the Speckit spec or the Jira ticket (tr-spec-reviewer), and React/Next performance from the Vercel rule set (tr-perf-reviewer) — run in parallel and merged into a single numbered report with one verdict. Use this instead of tr-review-code when the review must also check the change against its spec or ticket."
argument-hint: "[pr-number] [spec-path]"
allowed-tools: Agent, Read, Grep, Glob, Bash(gh pr view:*), Bash(gh pr diff:*), Bash(git fetch:*), Bash(git merge-base:*), Bash(git rev-parse:*), Bash(git diff:*), Bash(git status:*), Bash(git log:*), Bash(git branch:*), Bash(git ls-files:*), Bash(cat:*), Bash(ls:*), mcp__claude_ai_Atlassian__getJiraIssue
---

# Full Review — code quality + spec conformance

Three sub-agents read **one** diff in parallel, then you merge their findings
into a single report.

- `tr-code-reviewer` — correctness, readability, architecture, security,
  plus the tr_web conventions (a11y headings, casts, Meadow tokens, Contentful
  guards, test style).
- `tr-spec-reviewer` — missing requirements, scope creep, wrong
  implementations, and defects in the spec itself.
- `tr-perf-reviewer` — the Vercel react-best-practices rule set,
  filtered to the app's detected Next version and router paradigm. **Advisory:
  its findings never change the verdict.**

Neither sub-agent has shell access. **You** resolve the diff and the spec and
pass them in. Resolve the diff **once** and give both agents the identical
payload — if they review different diffs, the merged report is worthless.

For a quick single-axis pass with no spec, use `/tr-review-code` instead.

## Step 1 — Resolve the diff

### PR mode (`$1` is a number)

1. `gh pr view $1 --json title,body,url,baseRefName,headRefName,commits`
2. `gh pr diff $1`

The PR's own base is the fixed point; do not recompute it.

### Local mode (no arguments)

The fixed point is the **merge-base against `origin/main`**, never local `main`
— a stale local `main` has already produced a 196-file diff of somebody else's
merged work.

1. `git fetch origin main`
2. `git merge-base HEAD origin/main` → call it `$FP`
3. `git rev-parse --verify $FP` — if it does not resolve, stop and report. Do
   not spawn agents against a broken ref.
4. `git log $FP..HEAD --oneline` — the commit list. An **empty** list means
   the branch has no commits yet and every change is uncommitted; say that in
   the payload rather than passing the agents no context at all.
5. `git diff $FP` — **two-dot against the merge-base commit**, so the payload
   covers committed branch work _and_ staged _and_ unstaged changes in one go.
6. `git ls-files --others --exclude-standard` for the untracked files — **not**
   `git status --short`, which collapses an entire new directory into a single
   `?? dir/` entry and silently hides every file inside it. `Read` each one and
   append its contents to the payload as a synthetic added-file hunk: `git diff`
   never shows new files, and the review must cover them.
   Skip `specs/**` here — the Speckit folder is the spec axis's input, not code
   under review.
7. If the combined payload is empty, stop and say there is nothing to review.

## Step 2 — Resolve the spec

Resolve it yourself. Only ask the user when the signals disagree or come up
empty.

1. **The feature folder.** `cat .specify/feature.json` → `feature_directory`
   (e.g. `specs/024-rich-text-tabs`). Confirm `spec.md` and `tasks.md` exist in
   it.
2. **The ticket.** Extract `[A-Z]+-\d+` from the branch name
   (`git branch --show-current`; e.g. `maycomayco/MAP-2324-rich-text-tabs-MGP`
   → `MAP-2324`), or from the PR title/body in PR mode. Fetch it with
   `getJiraIssue`.
3. **Cross-check the two.** `.specify/feature.json` is a mutable pointer that
   is routinely edited and left stale — treat agreement as the signal, not the
   file alone. The slug of the feature folder should plausibly match the branch
   and the ticket title.

### Source precedence

Not every change has a Speckit folder — plenty of PRs in this repo are a Jira
ticket and nothing else. Walk this ladder and use the first source that
resolves. **A missing `specs/` folder is not a reason to ask, and never a
reason to skip the axis** — fall through.

| #   | Source                                                   | Mode to tell the agent                                                        |
| --- | -------------------------------------------------------- | ----------------------------------------------------------------------------- |
| 1   | `$2`, a spec path the user passed                        | `speckit` — overrides everything, skip the cross-check                        |
| 2   | Speckit folder that agrees with the branch/ticket        | `speckit`                                                                     |
| 3   | **The Jira ticket alone**                                | `ticket-only`                                                                 |
| 4   | The PR description alone (PR mode, no ticket, no folder) | `pr-only`, and say in the report that the requirements source is weak         |
| 5   | Nothing resolves                                         | skip `tr-spec-reviewer`, run the code axis alone, say so in the report header |

In `ticket-only` and `pr-only` mode the axis still runs and still blocks the
verdict — acceptance criteria in a ticket are binding. What changes is the
citation rule and the scope-creep threshold; the agent handles both, but you
**must** tell it which mode it is in, because it cannot tell from the payload.

**Ask the user only when the signals actually conflict:**

- the folder and the ticket point at different features;
- the diff plainly touches a feature other than the one the folder names;
- both a folder and a ticket resolve but the folder's `spec.md` is missing,
  so you cannot tell whether the folder is real or an abandoned stub.

Ask once, with what you found, and offer the candidates. If the user says
there is no spec, drop to the next rung of the ladder — a `no` to the Speckit
folder is not a `no` to the ticket.

## Step 2b — Detect the stack profile

Cheap, and the perf axis is wrong without it. **Detect it; never hardcode it** —
this repo will migrate to the App Router eventually and the filter must follow.

1. `cat apps/next/package.json` → the `next`, `react` and `react-dom` ranges.
   For what is actually installed, prefer
   `node -p "require('./node_modules/next/package.json').version"`.
2. Router paradigm: `ls -d apps/next/app` vs `ls -d apps/next/pages`. An `app/`
   directory means `app`; only `pages/` means `pages`.
3. Check the rule set exists: `~/.claude/skills/vercel-react-best-practices/`.
   If it is missing, skip the perf axis and say so in the report header — do not
   substitute your own performance opinions. The agent loads it itself via the
   `Skill` tool; you only confirm it is installed.

Pass it to `tr-perf-reviewer` as a literal block:

```
Stack profile (detected <date>):
  next: <installed version>
  react: <installed version>
  router: pages | app
```

At the time of writing this repo is Next 15.5.x / React 19.2.x / `pages`, which
suppresses the App Router / RSC rules. **Re-detect anyway.**

## Step 3 — Spawn all three agents in parallel

**One message, three `Agent` calls.** Running them sequentially wastes the
whole point. The perf axis is the cheap one — it is on `sonnet` and never
blocks — so it costs you nothing to include.

### `tr-code-reviewer`

Pass: the PR title and body (PR mode) or the commit list (local mode), and the
diff payload. Then append this brief, which is specific to this skill:

> In addition to your standard framework, check the **shape of the change**
> across the whole diff and report either as **Suggestion** unless the coupling
> is severe:
>
> - **Shotgun Surgery** — one logical change forced scattered edits across many
>   files. Recommend gathering what changes together into one module.
> - **Divergent Change** — one file or module edited for several unrelated
>   reasons. Recommend splitting so each module changes for one reason.
>
> Emit your normal Review Output Template. The caller will renumber your
> findings, so do not number them yourself.

Do **not** edit `tr-code-reviewer.md` to add this — it is shared with
`/tr-review-code`, which must stay unchanged.

### `tr-spec-reviewer`

Pass: the same diff payload, **the mode from the precedence ladder** (`speckit`
/ `ticket-only` / `pr-only`) — it cannot infer this and its citation and
scope-creep rules depend on it — plus whichever sources resolved: the paths of
`spec.md` and `tasks.md` (it can `Read` them itself), the fetched ticket
description pasted in full (it has no MCP access and cannot fetch Jira), and
anything the user said was out of scope for this change.

### `tr-perf-reviewer`

Pass: the same diff payload and the **stack profile block from Step 2b**
verbatim. Nothing else — it does not need the spec, the ticket, or the commit
list, and giving it those invites it to stray outside its rule set.

Skip this agent only when the rule-set path does not resolve.

## Step 4 — Merge into ONE report

The three axes come back separately; you emit a single report in
`tr-code-reviewer`'s style.

**Numbering is the contract.** One continuous numbered list running across all
severity sections — Critical first, then Important, then Suggestions — starting
at 1 and never restarting. The user references these numbers in follow-ups
("apply 2 and 5", `/wait-what 3`), so:

- never renumber after the fact within one report;
- tag every item with its axis — `[Code]`, `[Spec]` or `[Perf]` — so the origin
  survives the merge;
- if two agents found the same underlying issue, emit **one** item carrying
  both tags at the higher severity, and say both axes flagged it. `[Code]` and
  `[Perf]` overlap most often (both look at re-renders and expensive work); the
  code axis wins the wording, and cite the Vercel rule id alongside it.

### Verdict rule — state it, do not improvise it

**REQUEST CHANGES** if either holds:

- any **Critical** finding on either axis;
- any **Important** finding in the spec axis's _missing / partial_ or
  _implemented but wrong_ categories — shipping the wrong feature is a blocker
  even when the code is clean.

Otherwise **APPROVE**. Spec defects, scope creep, and code-axis Important
findings that are not Critical do not on their own block; call them out and let
the user decide.

**The perf axis never enters this calculation.** Not even its `Important`
findings. It is capped at advisory by design — a waterfall is worth knowing
about before you merge, but it is not a reason to withhold an approval, and a
`js-*` nit certainly is not. If the perf axis is the only axis with findings,
the verdict is **APPROVE** and the findings ride along as numbered suggestions.
Say so in one line rather than leaving the reader to infer it.

### Template

```markdown
## Full Review — <PR #N | local branch> vs <fixed point>

**Verdict:** APPROVE | REQUEST CHANGES
**Axes:** code + spec + perf
**Spec source:** `specs/NNN-slug` + `MAP-NNNN` | ticket-only `MAP-NNNN` | pr-only | none — spec axis skipped

### Critical

1. **[Code]** `file.tsx:41` — [issue and the recommended fix]
2. **[Spec]** `FR-014` "quoted requirement" — [gap and the fix]

### Important

3. **[Code+Spec]** ... [both axes flagged this]
4. **[Spec defect]** ... [fix belongs in the spec, not the code]

### Suggestions

5. **[Code]** ...
6. **[Perf]** `async-parallel` — [advisory; does not block]

### What's Done Well

- [At least one specific observation]

### Verification Story

- Diff reviewed: [N files, fixed point, whether untracked files were included]
- Spec source: [paths + ticket, or "none — spec axis skipped"]
- Stack profile: [detected values, and which perf rules it suppressed]
- Tests reviewed: [yes/no, observations]
- Not verified: [anything neither agent could check by reading — page-level
  heading trees, runtime behaviour, whether a `[x]` task landed in an earlier
  PR. Say so instead of assuming it passes.]
```

Omit any severity section with no findings, but keep the numbering continuous
across the ones that remain.

## Rules

1. Resolve the diff once; all three agents get the identical payload.
2. Validate the fixed point and a non-empty diff **before** spawning anything.
3. Spawn the three agents in a single message so they actually run in parallel.
   Detect the stack profile first — the perf agent cannot run without it.
4. Never post the review as a PR comment. It goes to the user only.
5. Never claim a build, test run, or lint pass was verified — no agent in this
   skill can run one.
6. Do not drop a finding just because another axis disagrees. Report both and
   say they disagree.
7. Never let the perf axis promote itself. If it returns a `Critical`, demote
   it to `Important` and note that the axis is capped.
