#!/usr/bin/env zsh
#------------------------------------------------------------------------------
# fzf Git Fuzzy Completion
# Context-aware completion triggered by '**' for git and 'g' alias commands.
#------------------------------------------------------------------------------

_fzf_complete_git_post() {
  local item
  while IFS= read -r item; do
    [[ -z "$item" ]] && continue
    case "$item" in
      *[[:space:]\(\)\[\]\'\"]*) echo -n "${(qqq)item} " ;;
      *) echo -n "$item " ;;
    esac
  done
}

_fzf_complete_g_post() {
  _fzf_complete_git_post "$@"
}

_fzf_complete_git() {
  # Fallback to standard path completion if outside a git work tree
  if ! git rev-parse --is-inside-work-tree &>/dev/null; then
    _fzf_path_completion "$prefix" "$1"
    return
  fi

  local -a tokens
  tokens=(${(z)1})

  # Find the git subcommand, skipping global flags (e.g. -C <path>, -c <k=v>)
  local subcmd=""
  local subcmd_idx=0
  local i
  for (( i=2; i<=${#tokens}; i++ )); do
    case "${tokens[i]}" in
      -C|-c) (( i++ )) ;;
      --git-dir=*|--work-tree=*) ;;
      --git-dir|--work-tree) (( i++ )) ;;
      -*) ;;
      *)
        subcmd="${tokens[i]}"
        subcmd_idx=$i
        break
        ;;
    esac
  done

  # Extract arguments after the subcommand
  local -a subargs
  if (( subcmd_idx > 0 && subcmd_idx < ${#tokens} )); then
    subargs=(${tokens[$((subcmd_idx + 1)),-1]})
  else
    subargs=()
  fi

  # Dynamically resolve git aliases from gitconfig (e.g. co -> checkout, cached -> diff --cached)
  local depth=0
  while (( depth < 5 )); do
    local alias_val
    alias_val=$(git config --get "alias.$subcmd" 2>/dev/null)
    [[ -z "$alias_val" || "$alias_val" == '!'* ]] && break
    local -a alias_tokens
    alias_tokens=(${(z)alias_val})
    [[ -z "${alias_tokens[1]}" ]] && break
    subcmd="${alias_tokens[1]}"
    if (( ${#alias_tokens} > 1 )); then
      subargs=(${alias_tokens[2,-1]} ${subargs[@]})
    fi
    (( depth++ ))
  done

  # Fallback normalization for standard aliases
  case "$subcmd" in
    co) subcmd="checkout" ;;
    br) subcmd="branch" ;;
    st) subcmd="status" ;;
    up|ri) subcmd="rebase" ;;
    cached) subcmd="diff"; subargs=(--cached ${subargs[@]}) ;;
    unstage) subcmd="reset"; subargs=(HEAD -- ${subargs[@]}) ;;
    patch) subcmd="add"; subargs=(--patch ${subargs[@]}) ;;
    com|ammend|amend) subcmd="commit" ;;
  esac

  local has_dashdash=0
  local has_cached=0
  local has_staged_flag=0
  local commit_ref=""

  if (( ${subargs[(I)--]} )); then
    has_dashdash=1
  fi

  if [[ "${tokens[subcmd_idx]}" == "cached" ]] || (( ${subargs[(I)--cached]} || ${subargs[(I)--staged]} )); then
    has_cached=1
  fi

  if (( ${subargs[(I)--staged]} || ${subargs[(I)-S]} )); then
    has_staged_flag=1
  fi

  # Detect any revision or branch passed before '--'
  local arg
  for arg in "${subargs[@]}"; do
    [[ "$arg" == "--" ]] && break
    [[ "$arg" == -* ]] && continue
    if git rev-parse --verify --quiet "$arg" &>/dev/null; then
      commit_ref="$arg"
      break
    fi
  done

  local -a fzf_opts=(-m)
  local -a candidates=()
  local preview_cmd=""

  case "$subcmd" in
    diff)
      if (( has_cached )); then
        candidates=(${(f)"$(git diff --cached --name-only --relative 2>/dev/null)"})
        preview_cmd='git diff --cached --color=always -- {}'
      elif [[ -n "$commit_ref" ]]; then
        candidates=(${(f)"$(git diff "$commit_ref" --name-only --relative 2>/dev/null)"})
        preview_cmd="git diff --color=always ${(q)commit_ref} -- {}"
      else
        candidates=(${(f)"$(git diff --name-only --relative 2>/dev/null)"})
        preview_cmd='git diff --color=always -- {}'
        # Fallback to staged diffs if working tree diff is empty
        if (( ${#candidates} == 0 )); then
          candidates=(${(f)"$(git diff --cached --name-only --relative 2>/dev/null)"})
          preview_cmd='git diff --cached --color=always -- {}'
        fi
      fi
      ;;

    checkout)
      if (( has_dashdash )); then
        # git checkout -- <file> discards working tree changes
        candidates=(${(f)"$(git diff --name-only --relative 2>/dev/null)"})
        preview_cmd='git diff --color=always -- {}'
      else
        fzf_opts=(+m)
        candidates=(${(f)"$(git for-each-ref --sort=-committerdate --format='%(refname:short)' refs/heads/ refs/remotes/ 2>/dev/null | sed '/\/HEAD$/d')"})
        preview_cmd='git log --color=always --oneline --graph -n 20 {}'
      fi
      ;;

    switch)
      fzf_opts=(+m)
      candidates=(${(f)"$(git for-each-ref --sort=-committerdate --format='%(refname:short)' refs/heads/ refs/remotes/ 2>/dev/null | sed '/\/HEAD$/d')"})
      preview_cmd='git log --color=always --oneline --graph -n 20 {}'
      ;;

    branch)
      if (( ${subargs[(I)-d]} || ${subargs[(I)-D]} )); then
        # Branch deletion: local branches
        candidates=(${(f)"$(git for-each-ref --sort=-committerdate --format='%(refname:short)' refs/heads/ 2>/dev/null)"})
      elif (( ${subargs[(I)-r]} || ${subargs[(I)--remotes]} )); then
        candidates=(${(f)"$(git for-each-ref --sort=-committerdate --format='%(refname:short)' refs/remotes/ 2>/dev/null | sed '/\/HEAD$/d')"})
      else
        candidates=(${(f)"$(git for-each-ref --sort=-committerdate --format='%(refname:short)' refs/heads/ refs/remotes/ 2>/dev/null | sed '/\/HEAD$/d')"})
      fi
      preview_cmd='git log --color=always --oneline --graph -n 20 {}'
      ;;

    add)
      # Unstaged files (modified, deleted, and untracked)
      candidates=(${(f)"$({ git diff --name-only --relative 2>/dev/null; git ls-files --others --exclude-standard 2>/dev/null; } | sort -u)"})
      preview_cmd='if git diff --name-only --relative -- {} 2>/dev/null | grep -q .; then git diff --color=always -- {}; elif [[ -f {} ]]; then git diff --no-index --color=always /dev/null {} 2>/dev/null || cat {}; else echo "Deleted: {}"; fi'
      ;;

    restore)
      if (( has_staged_flag )); then
        candidates=(${(f)"$(git diff --cached --name-only --relative 2>/dev/null)"})
        preview_cmd='git diff --cached --color=always -- {}'
      else
        candidates=(${(f)"$(git diff --name-only --relative 2>/dev/null)"})
        preview_cmd='git diff --color=always -- {}'
        if (( ${#candidates} == 0 )); then
          candidates=(${(f)"$(git diff --cached --name-only --relative 2>/dev/null)"})
          preview_cmd='git diff --cached --color=always -- {}'
        fi
      fi
      ;;

    reset)
      if (( ${subargs[(I)--hard]} || ${subargs[(I)--soft]} || ${subargs[(I)--merge]} || ${subargs[(I)--keep]} )); then
        fzf_opts=(+m)
        candidates=(${(f)"$(git for-each-ref --sort=-committerdate --format='%(refname:short)' refs/heads/ refs/remotes/ 2>/dev/null | sed '/\/HEAD$/d')"})
        preview_cmd='git log --color=always --oneline --graph -n 20 {}'
      else
        candidates=(${(f)"$(git diff --cached --name-only --relative 2>/dev/null)"})
        preview_cmd='git diff --cached --color=always -- {}'
        if (( ${#candidates} == 0 )); then
          fzf_opts=(+m)
          candidates=(${(f)"$(git for-each-ref --sort=-committerdate --format='%(refname:short)' refs/heads/ refs/remotes/ 2>/dev/null | sed '/\/HEAD$/d')"})
          preview_cmd='git log --color=always --oneline --graph -n 20 {}'
        fi
      fi
      ;;

    log|show)
      if (( has_dashdash )); then
        candidates=(${(f)"$(git ls-files 2>/dev/null)"})
      else
        candidates=(${(f)"$(git for-each-ref --sort=-committerdate --format='%(refname:short)' refs/heads/ refs/remotes/ refs/tags/ 2>/dev/null | sed '/\/HEAD$/d')"})
        preview_cmd='git log --color=always --oneline --graph -n 20 {}'
      fi
      ;;

    rebase|merge)
      fzf_opts=(+m)
      candidates=(${(f)"$(git for-each-ref --sort=-committerdate --format='%(refname:short)' refs/heads/ refs/remotes/ 2>/dev/null | sed '/\/HEAD$/d')"})
      preview_cmd='git log --color=always --oneline --graph -n 20 {}'
      ;;

    stash)
      local is_apply=0
      local a
      for a in "${subargs[@]}"; do
        case "$a" in
          show|apply|pop|drop) is_apply=1; break ;;
        esac
      done
      if (( is_apply )); then
        fzf_opts=(+m)
        candidates=(${(f)"$(git stash list --format='%gd' 2>/dev/null)"})
        preview_cmd='git stash show -p --color=always {}'
      else
        candidates=(${(f)"$({ git diff --name-only --relative 2>/dev/null; git ls-files --others --exclude-standard 2>/dev/null; } | sort -u)"})
      fi
      ;;

    rm)
      candidates=(${(f)"$(git ls-files 2>/dev/null)"})
      ;;

    *)
      if (( has_dashdash )); then
        candidates=(${(f)"$({ git diff --name-only --relative 2>/dev/null; git ls-files 2>/dev/null; } | sort -u)"})
      fi
      ;;
  esac

  # Strip empty lines
  candidates=(${candidates:#})

  # Fallback to standard path completion if no git-specific candidates exist
  if (( ${#candidates} == 0 )); then
    _fzf_path_completion "$prefix" "$1"
    return
  fi

  if [[ -n "$preview_cmd" ]]; then
    fzf_opts+=(--preview "$preview_cmd" --preview-window 'right:60%:wrap')
  fi

  _fzf_complete "${fzf_opts[@]}" -- "$@" < <(printf '%s\n' "${candidates[@]}")
}

_fzf_complete_g() {
  _fzf_complete_git "$@"
}
