#!/bin/bash
# cw - Claude Worktree completion for Bash
# https://github.com/smitfire/cw

_cw_completions() {
  local cur prev words cword
  _init_completion || return

  local commands="new go ls rm pr prs sync status ports init prune version help"

  if [[ $cword -eq 1 ]]; then
    COMPREPLY=($(compgen -W "$commands" -- "$cur"))
    return
  fi

  local cmd="${words[1]}"

  case "$cmd" in
    new)
      if [[ "$cur" == -* ]]; then
        COMPREPLY=($(compgen -W "--from --no-install --no-claude" -- "$cur"))
      elif [[ "$prev" == "--from" ]]; then
        local branches
        branches=$(git branch --format='%(refname:short)' 2>/dev/null)
        COMPREPLY=($(compgen -W "$branches" -- "$cur"))
      else
        local branches
        branches=$(git branch -a --format='%(refname:short)' 2>/dev/null | sed 's|origin/||' | sort -u)
        COMPREPLY=($(compgen -W "$branches" -- "$cur"))
      fi
      ;;
    go|rm)
      if [[ "$cur" == -* ]]; then
        COMPREPLY=($(compgen -W "--no-claude" -- "$cur"))
      else
        local root wt_base branches
        root=$(git rev-parse --show-toplevel 2>/dev/null)
        wt_base="${root}__wt"
        if [[ -d "$wt_base" ]]; then
          branches=$(ls -1 "$wt_base" 2>/dev/null | sed 's/-/\//g')
          COMPREPLY=($(compgen -W "$branches" -- "$cur"))
        fi
      fi
      ;;
    pr)
      if [[ "$cur" == -* ]]; then
        COMPREPLY=($(compgen -W "--draft -d --title -t --body -b" -- "$cur"))
      fi
      ;;
    sync)
      local branches
      branches=$(git branch --format='%(refname:short)' 2>/dev/null)
      COMPREPLY=($(compgen -W "$branches" -- "$cur"))
      ;;
  esac
}

complete -F _cw_completions cw
