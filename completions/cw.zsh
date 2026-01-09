#compdef cw

# cw - Claude Worktree completion for Zsh
# https://github.com/YOUR_USERNAME/cw

_cw() {
  local -a commands
  commands=(
    'new:Create worktree and open Claude session'
    'go:Open existing worktree in terminal'
    'ls:List all worktrees with status'
    'rm:Remove a worktree'
    'pr:Create PR from current branch'
    'prs:Show all your open PRs'
    'sync:Rebase on base branch'
    'status:Full dashboard view'
    'ports:Show port assignments'
    'init:Create .worktreerc config'
    'prune:Clean up stale worktrees'
    'version:Show version info'
    'help:Show help'
  )

  local -a new_options
  new_options=(
    '--from[Base branch for new branch]:branch:_cw_branches'
    '--no-install[Skip package installation]'
    '--no-claude[Do not auto-start Claude]'
  )

  local -a go_options
  go_options=(
    '--no-claude[Do not auto-start Claude]'
  )

  local -a pr_options
  pr_options=(
    '--draft[Create as draft PR]'
    '-d[Create as draft PR]'
    '--title[PR title]:title'
    '-t[PR title]:title'
    '--body[PR body]:body'
    '-b[PR body]:body'
  )

  _arguments -C \
    '1: :->command' \
    '*: :->args'

  case $state in
    command)
      _describe 'command' commands
      ;;
    args)
      case $words[2] in
        new)
          _arguments \
            '1:branch:_cw_all_branches' \
            $new_options
          ;;
        go|rm)
          _arguments \
            '1:branch:_cw_worktree_branches' \
            $go_options
          ;;
        pr)
          _arguments $pr_options
          ;;
        sync)
          _arguments '1:branch:_cw_branches'
          ;;
      esac
      ;;
  esac
}

# Complete with local branches
_cw_branches() {
  local -a branches
  branches=(${(f)"$(git branch --format='%(refname:short)' 2>/dev/null)"})
  _describe 'branch' branches
}

# Complete with all branches (local + remote)
_cw_all_branches() {
  local -a branches
  branches=(${(f)"$(git branch -a --format='%(refname:short)' 2>/dev/null | sed 's|origin/||' | sort -u)"})
  _describe 'branch' branches
}

# Complete with worktree branches only
_cw_worktree_branches() {
  local -a branches
  local root
  root=$(git rev-parse --show-toplevel 2>/dev/null)
  local wt_base="${root}__wt"

  if [[ -d "$wt_base" ]]; then
    branches=(${(f)"$(ls -1 "$wt_base" 2>/dev/null | sed 's/-/\//g')"})
  fi
  _describe 'worktree branch' branches
}

_cw "$@"
