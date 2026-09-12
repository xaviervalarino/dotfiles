# Global Preferences & Agent Guidelines

## 1. Communication & Interaction Style (ADHD-Friendly)
- **Bite-Sized & Scannable:** Use concise bullet points instead of dense paragraphs.
- **Bold Key Information:** Highlight **actions**, **files**, and **decisions** to make skimming effortless.
- **Direct Answers First:** State the conclusion or result in the first sentence. Avoid unnecessary preambles or theoretical background.
- **One Step at a Time:** Focus on the immediate next action. Do not overwhelm with multi-step plans unless explicitly requested.
- **Low Cognitive Load:** Present one decision or choice at a time. Never ask multiple open-ended questions in a single response.
- **Clear Decisions:** When choices are needed, offer 2–3 clear options, recommend one with **(Recommended)**, and explain the difference in one sentence.
- **Clear Checkpoints:** Use `[DONE]` for completed tasks and `[NEXT]` for the immediate upcoming step. Confirm milestones before moving forward.
- **Direct & Concise:** No pleasantries, throat-clearing, or conversational filler.
- **Script/Command Transparency:** Succinctly state the target and purpose before executing any script or command.
- **Stay on Target:** Stick strictly to the task at hand. Do not explore tangential refactors or rabbit holes without asking first.
- **Disambiguate Generic Filenames:** When referencing or editing files with common/generic names (`settings.json`, `page.tsx`, `layout.tsx`, `index.html`, `route.ts`, `config.json`), always verify or specify the exact directory, path, or surface (e.g., VS Code vs Agent settings) before making assumptions or changes.

## 2. Git & Commit Style
- **No Conventional Commits:** Do not use `feat:`, `fix:`, `chore:`, etc.
- **Natural & Descriptive:** Write clear, concise, plain-language commit messages.
- **Under 50 Characters:** Keep commit subject lines under 50 characters to avoid gitlint prompts.
- **Pre-Commit Verification:** Run project linter or type check on modified files before asking to commit.

## 3. Git Worktrees Setup
> [!NOTE]
> **Pending Stale:** This section is temporary and will become obsolete once the `xv/worktree-setup-rules` PR (`.agents/rules/worktrees.md`) merges into `greenline` `main`. Once merged, rely on the repository's native rules and remove this section.
- **Worktree Location:** Place in `.claude/worktrees/<name>` to stay contained and gitignored.
- **Symlink Environment:** Symlink local configs (`ln -sf <main-repo>/.env .env`).
- **Dependencies:** Run `yarn install` in worktree root (never symlink root `node_modules` across worktrees; yarn installs fast via cache and sets up Husky).
- **Package Builds & Codegen:** Run `yarn build:packages && yarn gen` to keep workspace packages and GraphQL types self-contained and isolated from other branches.
- **Cwd over `git -C`:** Never use `git -C <path>`. Always set the command execution directory (`Cwd`) directly to the worktree to preserve prefix-matched tool permissions and prevent approval prompts.
- **Worktree Cleanup:** Remove worktrees (`git worktree remove`) once a feature branch PR merges to avoid stale workspaces.

## 4. Tool Execution & Terminal Safety
- **Native File Tools First:** Always use native tools (`write_to_file`, `replace_file_content`) to create and edit files. Never use shell redirects (`cat >`, `echo >`, `sed`) or subshells that risk sandbox blocks and PTY corruption.
- **Clean Foreground Execution:** Run shell commands synchronously. Avoid backgrounding (`&`) or multi-command chains across external paths.
- **TTY Recovery:** If terminal input or echo ever breaks, run `stty sane` to restore standard terminal mode.

## 5. Toolchain & Configuration Invariants
- **Native Plugin Options First:** Check native plugin/theme configurations before writing manual monkey-patches or workarounds.
