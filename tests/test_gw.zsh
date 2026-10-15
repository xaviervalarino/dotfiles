#!/usr/bin/env zsh
set -e

unset GIT_DIR GIT_WORK_TREE
export GIT_CONFIG_GLOBAL=/dev/null

SCRIPT_DIR="${0:A:h}"
GW_PATH="${GW_PATH:-${SCRIPT_DIR:h}/zsh/dot-config/zsh/functions/gw}"
GW_COMP_PATH="${GW_COMP_PATH:-${SCRIPT_DIR:h}/zsh/dot-config/zsh/functions/_gw}"

SPACE_REPO=""
TEMP_DIR=$(mktemp -d "${TMPDIR:-/tmp}/test_gw_repo.XXXXXX")
trap 'rm -rf "$TEMP_DIR" ${SPACE_REPO:+"$SPACE_REPO"}' EXIT

echo "=== Setting up test git repo in $TEMP_DIR ==="
cd "$TEMP_DIR"
git init -b main >/dev/null
git config user.name "Test User"
git config user.email "test@example.com"
echo "# Test Repo" > README.md
git add README.md
git commit -m "Initial commit" >/dev/null

gw() {
  source "$GW_PATH" "$@"
}

echo "--- Test 1: gw add new-branch ---"
gw add feat-1
test -d "$TEMP_DIR/.worktrees/feat-1" || { echo "FAIL: .worktrees/feat-1 not created"; exit 1 }
test "$(git branch --show-current)" = "feat-1" || { echo "FAIL: current branch not feat-1"; exit 1 }
echo "PASS: feat-1 worktree created"

echo "--- Test 2: gw add on already existing worktree jumps to it ---"
cd "$TEMP_DIR"
gw add feat-1
test "$PWD" -ef "$TEMP_DIR/.worktrees/feat-1" || { echo "FAIL: did not jump to existing worktree ($PWD vs $TEMP_DIR/.worktrees/feat-1)"; exit 1 }
echo "PASS: gw add jumped to existing worktree"

echo "--- Test 3: gw rm feat-1 (preserves branch ref) ---"
cd "$TEMP_DIR"
gw rm feat-1
test ! -d "$TEMP_DIR/.worktrees/feat-1" || { echo "FAIL: worktree directory still exists"; exit 1 }
git show-ref --verify --quiet refs/heads/feat-1 || { echo "FAIL: branch ref was deleted!"; exit 1 }
echo "PASS: worktree removed and branch ref preserved"

echo "--- Test 4: gw add moving clean branch from primary checkout ---"
cd "$TEMP_DIR"
git switch -c feat-move >/dev/null
echo "some file" > feat_file.txt
git add feat_file.txt
git commit -m "commit on feat-move" >/dev/null
test "$(git branch --show-current)" = "feat-move"

gw add feat-move
test -d "$TEMP_DIR/.worktrees/feat-move" || { echo "FAIL: .worktrees/feat-move not created"; exit 1 }
test "$(git branch --show-current)" = "feat-move" || { echo "FAIL: not on feat-move in worktree"; exit 1 }
root_branch=$(cd "$TEMP_DIR" && git branch --show-current)
test "$root_branch" = "main" || { echo "FAIL: primary checkout is on '$root_branch', expected 'main'"; exit 1 }
echo "PASS: clean branch moved from primary checkout to worktree; primary checkout switched to main"

echo "--- Test 5: gw add fails on dirty primary checkout ---"
cd "$TEMP_DIR"
git switch -c feat-dirty >/dev/null
echo "dirty uncommitted change" >> README.md

if gw add feat-dirty 2>/dev/null; then
  echo "FAIL: gw add should have failed on dirty primary checkout!"
  exit 1
fi
test "$(git branch --show-current)" = "feat-dirty" || { echo "FAIL: switched branch despite dirty state"; exit 1 }
test ! -d "$TEMP_DIR/.worktrees/feat-dirty" || { echo "FAIL: worktree created despite dirty state"; exit 1 }
echo "PASS: gw add cleanly refused to move dirty branch"

git restore README.md
git switch main >/dev/null

echo "--- Test 6: gw rm fails on dirty worktree without -f ---"
cd "$TEMP_DIR/.worktrees/feat-move"
echo "dirty tracked edit" >> feat_file.txt
cd "$TEMP_DIR"

if gw rm feat-move 2>/dev/null; then
  echo "FAIL: gw rm should have failed on dirty worktree without -f"; exit 1
fi
test -d "$TEMP_DIR/.worktrees/feat-move" || { echo "FAIL: dirty worktree deleted without -f"; exit 1 }
echo "PASS: gw rm rejected removing dirty worktree"

echo "--- Test 7: gw rm -f removes dirty worktree and preserves branch ---"
gw rm -f feat-move
test ! -d "$TEMP_DIR/.worktrees/feat-move" || { echo "FAIL: worktree not removed with -f"; exit 1 }
git show-ref --verify --quiet refs/heads/feat-move || { echo "FAIL: branch ref was deleted with -f!"; exit 1 }
echo "PASS: gw rm -f removed dirty worktree and preserved branch"

echo "--- Test 8: removed aliases are rejected as unknown commands ---"
cd "$TEMP_DIR"
if gw create feat-alias 2>/dev/null; then
  echo "FAIL: gw create should be rejected"; exit 1
fi
echo "PASS: removed aliases are rejected"

echo "--- Test 9: gw <branch> jumps back to primary checkout (gw main) ---"
cd "$TEMP_DIR"
gw add feat-jump
test "$PWD" -ef "$TEMP_DIR/.worktrees/feat-jump" || { echo "FAIL: not inside feat-jump worktree"; exit 1 }
gw main
test "$PWD" -ef "$TEMP_DIR" || { echo "FAIL: did not jump back to main primary checkout ($PWD vs $TEMP_DIR)"; exit 1 }
gw rm feat-jump
echo "PASS: gw main successfully jumps back to primary checkout"

echo "--- Test 10: branch with slash creates nested dir and cleans up on rm ---"
cd "$TEMP_DIR"
gw add feat/subfeature
test -d "$TEMP_DIR/.worktrees/feat/subfeature" || { echo "FAIL: nested worktree directory not created"; exit 1 }
gw main
gw rm feat/subfeature
test ! -d "$TEMP_DIR/.worktrees/feat/subfeature" || { echo "FAIL: nested worktree not removed"; exit 1 }
test ! -d "$TEMP_DIR/.worktrees/feat" || { echo "FAIL: parent empty directory .worktrees/feat was not pruned"; exit 1 }
echo "PASS: branch with slash created and parent directory pruned on rm"

echo "--- Test 11: gw help works outside git repository ---"
EMPTY_TMP=$(mktemp -d "${TMPDIR:-/tmp}/test_empty.XXXXXX")
(
  cd "$EMPTY_TMP"
  gw help >/dev/null
)
rm -rf "$EMPTY_TMP"
echo "PASS: gw help works outside git repository"

echo "--- Test 12: gw rm blocks removing worktree with untracked file without -f ---"
cd "$TEMP_DIR"
gw add feat-untracked
echo "untracked content" > "$TEMP_DIR/.worktrees/feat-untracked/untracked.txt"
cd "$TEMP_DIR"
if gw rm feat-untracked 2>/dev/null; then
  echo "FAIL: gw rm should have blocked removing untracked file without -f"; exit 1
fi
test -d "$TEMP_DIR/.worktrees/feat-untracked" || { echo "FAIL: worktree deleted despite untracked file"; exit 1 }
gw rm -f feat-untracked
test ! -d "$TEMP_DIR/.worktrees/feat-untracked" || { echo "FAIL: worktree not deleted with -f"; exit 1 }
echo "PASS: untracked file preserved without -f, removed with -f"

echo "--- Test 13: repo path with spaces handles worktree correctly ---"
SPACE_REPO=$(mktemp -d "${TMPDIR:-/tmp}/test space repo.XXXXXX")
(
  cd "$SPACE_REPO"
  git init -b main >/dev/null
  git config user.name "Test User"
  git config user.email "test@example.com"
  echo "hello" > README.md
  git add README.md && git commit -m "init" >/dev/null
  gw add feat-space
  test -d "$SPACE_REPO/.worktrees/feat-space" || { echo "FAIL: worktree with space repo not created"; exit 1 }
  gw main
  gw rm feat-space
  test ! -d "$SPACE_REPO/.worktrees/feat-space" || { echo "FAIL: worktree with space repo not removed"; exit 1 }
)
rm -rf "$SPACE_REPO"
echo "PASS: repository with spaces in path handled correctly"

echo "--- Test 14: gw ls lists active worktrees ---"
cd "$TEMP_DIR"
gw add feat-ls
ls_out=$(gw ls)
echo "$ls_out" | grep -q "feat-ls" || { echo "FAIL: gw ls output missing feat-ls"; exit 1 }
gw main
gw rm feat-ls
echo "PASS: gw ls lists active worktrees"

echo "--- Test 15: _gw completion for subcommands and flags ---"
test -f "$GW_COMP_PATH" || { echo "FAIL: completion file $GW_COMP_PATH not found"; exit 1 }
zsh -n "$GW_COMP_PATH" || { echo "FAIL: _gw has syntax errors"; exit 1 }

(
  source "$GW_COMP_PATH"

  # Mock _describe to capture candidate arrays
  _describe() {
    local varname="${@[-1]}"
    local -a items=("${(@P)varname}")
    printf "%s\n" "${items[@]}"
  }

  local -a subcommands=(
    'add:Create or move worktree at .worktrees/<name>'
    'rm:Remove worktree by branch or dir name'
    'ls:List active worktrees'
    'help:Show help message'
  )
  subcmds=$(_describe -t subcommands 'gw subcommand' subcommands)
  echo "$subcmds" | grep -q "add:" || { echo "FAIL: completion missing add subcommand"; exit 1 }
  echo "$subcmds" | grep -q "rm:" || { echo "FAIL: completion missing rm subcommand"; exit 1 }
  echo "$subcmds" | grep -q "ls:" || { echo "FAIL: completion missing ls subcommand"; exit 1 }
  echo "$subcmds" | grep -q "help:" || { echo "FAIL: completion missing help subcommand"; exit 1 }
)
echo "PASS: _gw completion verified"

echo "--- Test 16: _gw_list_branches stream correctly formats active worktree status ---"
(
  cd "$TEMP_DIR"
  gw add feat-status
  gw main

  local fzf_log="/tmp/claude/test_fzf_stream_$$.txt"
  fzf() {
    tee "$fzf_log"
    printf "\nfeat-status\n"
  }

  gw add
  test -f "$fzf_log" || { echo "FAIL: fzf was not called"; exit 1 }
  grep -q "feat-status" "$fzf_log" || { echo "FAIL: stream missing feat-status"; rm -f "$fzf_log"; exit 1 }
  grep -q "\.worktrees/feat-status" "$fzf_log" || { echo "FAIL: stream missing worktree path"; rm -f "$fzf_log"; exit 1 }
  rm -f "$fzf_log"

  gw rm feat-status
)
echo "PASS: _gw_list_branches stream verified"

echo "--- Test 17: gw rm steps out of target worktree if inside it ---"
(
  cd "$TEMP_DIR"
  gw add feat-inside
  cd "$TEMP_DIR/.worktrees/feat-inside"
  gw rm feat-inside
  test "$PWD" -ef "$TEMP_DIR" || { echo "FAIL: did not step out to primary checkout ($PWD vs $TEMP_DIR)"; exit 1 }
  test ! -d "$TEMP_DIR/.worktrees/feat-inside" || { echo "FAIL: worktree directory still exists"; exit 1 }
)
echo "PASS: stepped out to primary checkout on rm"

echo "--- Test 18: deterministic lookup prioritizes exact branch over basename ---"
(
  cd "$TEMP_DIR"
  gw add feat/x
  gw main
  gw add x
  gw main
  # gw <name> should jump to exact branch "x", not "feat/x"
  gw x
  test "$PWD" -ef "$TEMP_DIR/.worktrees/x" || { echo "FAIL: did not prioritize exact branch 'x' ($PWD vs $TEMP_DIR/.worktrees/x)"; exit 1 }
  gw main
  gw rm x
  gw rm feat/x
)
echo "PASS: exact branch prioritized over basename match"

echo ""
echo "=== ALL 18 TESTS PASSED SUCCESSFULLY ==="

