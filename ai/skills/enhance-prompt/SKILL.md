---
name: enhance-prompt
description: "Trigger: enhance this prompt, mejora este prompt, improve my request. Rewrites vague requests into structured, actionable prompts with numbered steps and lightweight context."
license: Apache-2.0
metadata:
  author: maycomayco
  version: "1.0"
---

Rewrites a vague instruction into a structured, executable prompt — the same shape Auggie CLI's built-in Prompt Enhancer (Ctrl+P) produces — using only a lightweight scan of the workspace (no deep codebase search).

## Activation Contract

Load when the user explicitly asks to enhance, improve, or rewrite a prompt. See Decision Gates for branching.

## Hard Rules

- Do NOT trigger silently on every vague message — only when explicitly requested.
- Do NOT fabricate specific file paths, function names, or library names not actually seen in the workspace scan.
- Do NOT execute the enhanced prompt without asking the user first. Always present it and ask whether to proceed, edit, or discard.
- Do NOT use this skill as a replacement for deep codebase search on complex tasks.
- Do NOT pad or lengthen prompts that are already clear and actionable.

## Decision Gates

| Situation | Action |
|---|---|
| User explicitly says "enhance this prompt", "mejora este prompt", "improve my request", or names this skill | Load and execute |
| User request is vague but did not ask for enhancement | Ask once: enhance or execute directly? |
| User request is already specific and actionable | Say so; do not manufacture filler steps |

## Execution Steps

1. **Capture the raw input** — the literal text the user wants enhanced (it may be quoted, or may be their previous message).
2. **Lightweight context scan** (fast, no deep retrieval):
   - `view` the workspace root and any directory that seems obviously relevant to a keyword in the prompt (e.g. "login" → look for an `auth`/`login` folder), one or two levels deep.
   - Infer the stack/conventions from what's visible (package.json, folder names, obvious framework cues) — do not run `codebase-retrieval` or open individual source files for this. This is a guess pass, not research.
   - If nothing relevant surfaces in the quick scan, proceed without file references rather than escalating to deeper search.
3. **Produce the enhanced prompt** using this exact shape:

   ```
   [One-sentence rephrased objective — specific and actionable]

   1. [Concrete step, referencing a likely file/dir if the scan found one]
   2. [Concrete step]
   3. ...
   4-6 steps total, ordered logically (investigate → implement → verify)

   Context: [1-3 sentences: relevant conventions/stack inferred from the scan, edge cases to consider, or how this likely relates to existing code. Omit if the scan found nothing useful — do not invent details.]
   ```

   Rules for filling this template:
   - Never fabricate specific file paths, function names, or library names you didn't actually see in the scan. If uncertain, phrase the step generically ("locate the component responsible for X") instead of guessing a path.
   - Keep steps concrete and verifiable, not generic filler ("look into it", "make it better").
   - Always include a verification/testing step when the request involves code changes.
   - Keep the whole thing tight — this is a better-scoped instruction, not a spec document.

4. **Present the result to the user** as the enhanced prompt, and ask whether to proceed with it as-is, edit it further, or discard it. Do not silently start executing the enhanced prompt unless the user's original message already asked you to both enhance AND execute.

## Output Contract

Return the enhanced prompt using the template format defined in Execution Steps. After presenting it, ask whether to proceed as-is, edit further, or discard. Do not execute unless the user's original message already asked for both enhancement and execution.

## References

None.
