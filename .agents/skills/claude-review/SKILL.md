---
name: claude-review
description: >-
  Use this skill ONLY when the user explicitly requests a code review, sanity check,
  or second opinion using Claude Code (claude -p) with the claude-fable-5[1m] model.
---

# Claude Code Peer Review (`claude-review`)

Invokes Claude Code in headless print mode (`-p`) with the `claude-fable-5[1m]` model to provide an objective second-opinion code review and sanity check on code changes.

## Triggering Policy: Explicit User Request Only

> [!IMPORTANT]
> **Never Proactive:** Do NOT run Claude Code automatically, speculatively, or during "done?" checks.
> Only run when the user **explicitly** asks to consult Claude (e.g., *"have claude review this"*, *"check with fable"*, *"run claude-review"*). This prevents burning tokens without direct user intent.

## Effort Levels

- **Default:** `--effort medium` (standard code review, balanced token usage).
- **Deep Analysis:** `--effort high` or `--effort xhigh` when the user requests deep reasoning, rigorous edge-case hunting, or complex architectural critique.
- **Maximum:** `--effort max` for critical system-level or security evaluations.

## Guidelines & Invariants

1. **Auto-Approvable Command Shapes**
   - **Never use command substitutions** like `$(git diff)` inside quotes—they break prefix-matching and trigger manual approval prompts.
   - Claude Code has native tools to inspect `git status` and `git diff` itself.
   - Always specify model and effort explicitly: `--model "claude-fable-5[1m]" --effort <level>`.

2. **Standard Review Commands**

   - **Review Unstaged / Working Tree Changes (Default Medium Effort):**
     ```bash
     claude -p "Review unstaged git changes in this repository. Identify subtle bugs, edge cases, shell quirks, or regressions. Focus strictly on actionable findings." --model "claude-fable-5[1m]" --effort medium
     ```

   - **Deep / High-Effort Review (When Requested):**
     ```bash
     claude -p "Perform a deep, rigorous review of unstaged git changes in this repository. Scrutinize subtle failure modes, platform-specific edge cases, and latent bugs." --model "claude-fable-5[1m]" --effort high
     ```

   - **Review a Specific File or Target:**
     ```bash
     claude -p "Review recent changes to <filepath>. Check for edge cases, correctness, and performance implications." --model "claude-fable-5[1m]" --effort medium
     ```

   - **Review Staged Changes:**
     ```bash
     claude -p "Review staged git changes (git diff --staged). Check for subtle edge cases, safety, and correctness." --model "claude-fable-5[1m]" --effort medium
     ```

3. **Output Synthesis (Bite-Sized & Scannable)**
   - Do not dump raw CLI output.
   - Categorize findings into:
     - **Verified Bugs / Regressions:** Flaws that break functionality or introduce crashes/deadlocks.
     - **Latent Edge Cases / Trade-offs:** Environmental quirks, redirection behavior, or subtle interactions.
     - **Recommended Fixes:** Concrete, single-sentence solutions.
