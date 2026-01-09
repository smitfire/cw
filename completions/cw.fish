# cw - Claude Worktree completion for Fish
# https://github.com/YOUR_USERNAME/cw

# Disable file completion
complete -c cw -f

# Commands
complete -c cw -n __fish_use_subcommand -a new -d 'Create worktree and open Claude session'
complete -c cw -n __fish_use_subcommand -a go -d 'Open existing worktree in terminal'
complete -c cw -n __fish_use_subcommand -a ls -d 'List all worktrees with status'
complete -c cw -n __fish_use_subcommand -a rm -d 'Remove a worktree'
complete -c cw -n __fish_use_subcommand -a pr -d 'Create PR from current branch'
complete -c cw -n __fish_use_subcommand -a prs -d 'Show all your open PRs'
complete -c cw -n __fish_use_subcommand -a sync -d 'Rebase on base branch'
complete -c cw -n __fish_use_subcommand -a status -d 'Full dashboard view'
complete -c cw -n __fish_use_subcommand -a ports -d 'Show port assignments'
complete -c cw -n __fish_use_subcommand -a init -d 'Create .worktreerc config'
complete -c cw -n __fish_use_subcommand -a prune -d 'Clean up stale worktrees'
complete -c cw -n __fish_use_subcommand -a version -d 'Show version info'
complete -c cw -n __fish_use_subcommand -a help -d 'Show help'

# new command options
complete -c cw -n '__fish_seen_subcommand_from new' -l from -d 'Base branch for new branch' -xa '(__fish_git_branches)'
complete -c cw -n '__fish_seen_subcommand_from new' -l no-install -d 'Skip package installation'
complete -c cw -n '__fish_seen_subcommand_from new' -l no-claude -d 'Do not auto-start Claude'
complete -c cw -n '__fish_seen_subcommand_from new' -xa '(__fish_git_branches)'

# go command options
complete -c cw -n '__fish_seen_subcommand_from go' -l no-claude -d 'Do not auto-start Claude'
complete -c cw -n '__fish_seen_subcommand_from go' -xa '(__cw_worktree_branches)'

# rm command
complete -c cw -n '__fish_seen_subcommand_from rm' -xa '(__cw_worktree_branches)'

# pr command options
complete -c cw -n '__fish_seen_subcommand_from pr' -l draft -s d -d 'Create as draft PR'
complete -c cw -n '__fish_seen_subcommand_from pr' -l title -s t -d 'PR title'
complete -c cw -n '__fish_seen_subcommand_from pr' -l body -s b -d 'PR body'

# sync command
complete -c cw -n '__fish_seen_subcommand_from sync' -xa '(__fish_git_branches)'

# Helper function for worktree branches
function __cw_worktree_branches
  set -l root (git rev-parse --show-toplevel 2>/dev/null)
  set -l wt_base "$root"__wt
  if test -d "$wt_base"
    for dir in (ls -1 "$wt_base" 2>/dev/null)
      echo (string replace -a '-' '/' $dir)
    end
  end
end
