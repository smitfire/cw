# cw - Claude Worktree

Git worktrees + Claude Code + GitHub, unified.

## Install

### Homebrew (Recommended)

```bash
brew tap YOUR_USERNAME/cw
brew install cw
```

### Manual Install

```bash
curl -sL https://raw.githubusercontent.com/YOUR_USERNAME/cw/main/install.sh | bash
```

### From Source

```bash
git clone https://github.com/YOUR_USERNAME/cw.git
cd cw
cp bin/cw ~/.local/bin/
chmod +x ~/.local/bin/cw
```

## Quick Start

```bash
# Initialize project config (optional)
cw init

# Create a new worktree and open Claude
cw new feat/my-feature

# Switch to an existing worktree
cw go feat/other-feature

# See all worktrees with status
cw ls

# Create a PR from current branch
cw pr

# Full dashboard view
cw status
```

## Commands

| Command | Description |
|---------|-------------|
| `cw new <branch>` | Create worktree and open Claude session |
| `cw go <branch>` | Open existing worktree in terminal |
| `cw ls` | List all worktrees with status |
| `cw rm <branch>` | Remove a worktree |
| `cw pr` | Create PR from current branch |
| `cw prs` | Show all your open PRs |
| `cw sync [branch]` | Rebase on base branch |
| `cw status` | Full dashboard view |
| `cw ports` | Show port assignments |
| `cw init` | Create .worktreerc config |
| `cw prune` | Clean up stale worktrees |

## Options

### `cw new`

```bash
cw new feat/auth              # Create from default base branch
cw new feat/auth --from main  # Create from specific branch
cw new feat/auth --no-install # Skip package installation
cw new feat/auth --no-claude  # Don't auto-start Claude
```

### `cw pr`

```bash
cw pr                         # Create PR interactively
cw pr --draft                 # Create as draft PR
cw pr -t "Title" -b "Body"    # With title and body
```

## Features

- **Worktree Management** - Create, list, remove git worktrees with ease
- **Claude Integration** - Auto-opens Claude Code sessions in new terminal tabs
- **GitHub PRs** - Create, list, sync PRs without leaving terminal
- **Port Management** - Auto-assigns ports for parallel dev servers
- **Terminal Integration** - Works with Warp, iTerm2, Terminal.app, Kitty, and more
- **Cross-Platform** - Works on macOS and Linux

## Configuration

Run `cw init` in your project to create a `.worktreerc` config file:

```bash
# .worktreerc - Project configuration for cw
BASE_PORT=3000          # Starting port for dev servers
BASE_BRANCH=main        # Default PR target branch
AUTO_CLAUDE=true        # Auto-start Claude in new tabs
ENV_FILES=.env .env.local  # Files to copy to new worktrees
SYMLINK_DIRS=.claude    # Directories to symlink
POST_CREATE_HOOK=       # Command to run after creating worktree
```

### Port Management

Each worktree gets a unique port based on `BASE_PORT`:

```
main repo     → 3000
feat/auth     → 3001
feat/api      → 3002
```

View assignments with `cw ports`.

## Requirements

- **Git** - Obviously
- **GitHub CLI** (`gh`) - For PR features. Install: `brew install gh`
- **Claude Code** (`claude`) - Optional. For auto-starting Claude sessions

## Terminal Support

| Terminal | Tab Opening | Auto-Claude |
|----------|-------------|-------------|
| Warp | ✅ URI scheme | ✅ AppleScript |
| iTerm2 | ✅ AppleScript | ✅ |
| Terminal.app | ✅ AppleScript | ❌ |
| Kitty | ✅ Remote control | ✅ |
| GNOME Terminal | ✅ CLI | ✅ |
| Other | ❌ Manual | ❌ |

## Shell Completions

### Bash

Add to `~/.bashrc`:
```bash
source $(brew --prefix)/etc/bash_completion.d/cw
```

### Zsh

Usually automatic with oh-my-zsh. Or add to `~/.zshrc`:
```zsh
fpath=($(brew --prefix)/share/zsh/site-functions $fpath)
autoload -Uz compinit && compinit
```

### Fish

Automatic after Homebrew install.

## Examples

### Parallel Feature Development

```bash
# Start working on auth
cw new feat/auth
# Claude opens, you're coding...

# Need to review something else? Open another tab
cw go feat/api

# Back to auth
cw go feat/auth

# Done with auth, create PR
cw pr --draft

# Clean up
cw rm feat/auth
```

### Daily Workflow

```bash
# Morning: check status
cw status

# See what PRs need attention
cw prs

# Sync your branch with latest dev
cw sync

# Continue working
cw go feat/current-task
```

## How It Works

### Worktree Structure

```
your-repo/              # Main repository
your-repo__wt/          # Worktrees directory
├── feat-auth/          # feat/auth worktree
├── feat-api/           # feat/api worktree
└── fix-bug-123/        # fix/bug-123 worktree
```

### Port Assignment

Ports are tracked in `.worktree-ports` and automatically assigned based on your `BASE_PORT` setting.

## Troubleshooting

### "Claude not found"

Install Claude Code CLI: https://claude.ai/code

### "gh not authenticated"

Run `gh auth login` to authenticate with GitHub.

### Terminal tabs not opening

Your terminal may not be supported for programmatic tab opening. You'll see instructions to manually navigate.

## Contributing

Pull requests welcome! Please open an issue first to discuss what you'd like to change.

## License

MIT - see [LICENSE](LICENSE)
