# cw - Claude Worktree

> Git worktrees + Claude Code + GitHub, unified.

```
┌─────────────────────────────────────────────────────────────┐
│  cw new feat/auth                                           │
│                                                             │
│  ✓ Created worktree at ../myapp__wt/feat-auth               │
│  ✓ Copied .env, .env.local                                  │
│  ✓ Linked .claude directory                                 │
│  ✓ Installed dependencies (pnpm)                            │
│  ✓ Assigned port 3001                                       │
│  ✓ Opening Warp tab...                                      │
│  ✓ Starting Claude Code session...                          │
└─────────────────────────────────────────────────────────────┘
```

## Why cw?

**The Problem:** Working on multiple features simultaneously with Claude Code is painful:
- Manually creating worktrees with long git commands
- Copying env files every time
- Figuring out which ports are free
- Opening terminals, navigating, starting Claude
- Losing track of what's where

**The Solution:** One command does it all.

## Install

```bash
brew tap smitfire/cw
brew install cw
```

<details>
<summary>Other installation methods</summary>

### curl installer
```bash
curl -sL https://raw.githubusercontent.com/smitfire/cw/main/install.sh | bash
```

### From source
```bash
git clone https://github.com/smitfire/cw.git
cd cw && cp bin/cw ~/.local/bin/ && chmod +x ~/.local/bin/cw
```
</details>

## Quick Start

```bash
cw init                    # One-time project setup
cw new feat/my-feature     # Create worktree → Claude opens automatically
```

That's it. You're coding.

---

## Use Cases

### 🔀 Parallel Feature Development

Work on multiple features without stashing or losing context:

```bash
# Start auth feature
cw new feat/auth
# Claude opens, you implement OAuth...

# Urgent bug? Open another worktree
cw new fix/critical-bug
# Fix it in isolation, no context switching

# Back to auth
cw go feat/auth
# Everything's exactly where you left it
```

### 🔍 Code Review While Coding

Review a PR without disrupting your work:

```bash
# You're deep in feat/dashboard
# Teammate asks for review on feat/api

cw new feat/api           # Opens their branch
# Review, test, approve

cw go feat/dashboard      # Back to your work instantly
```

### 🧪 Experiment Freely

Try risky changes without fear:

```bash
cw new experiment/new-arch --from main
# Go wild with refactoring
# If it works: cw pr
# If it doesn't: cw rm experiment/new-arch
# Main branch never touched
```

### 📊 Dashboard View

See everything at a glance:

```
$ cw status

╭──────────────────── WORKTREES ────────────────────╮
│                                                    │
│  main         → Clean                              │
│  feat/auth    → 3 files changed │ Port 3001        │
│  feat/api     → PR #42 (Draft)  │ Port 3002        │
│  fix/bug-123  → 1 ahead         │ Port 3003        │
│                                                    │
╰────────────────────────────────────────────────────╯

╭──────────────────── YOUR PRS ─────────────────────╮
│                                                    │
│  #42  feat/api      Draft    Add REST endpoints   │
│  #38  feat/search   Review   Full-text search     │
│                                                    │
╰────────────────────────────────────────────────────╯
```

---

## Commands

| Command | What it does |
|---------|--------------|
| `cw new <branch>` | Create worktree + open Claude |
| `cw go <branch>` | Jump to existing worktree |
| `cw ls` | List all worktrees |
| `cw rm <branch>` | Remove a worktree |
| `cw pr` | Create GitHub PR |
| `cw prs` | List your open PRs |
| `cw sync` | Rebase on base branch |
| `cw status` | Full dashboard |
| `cw ports` | Show port assignments |
| `cw prune` | Clean up stale worktrees |

### Options

```bash
cw new feat/auth --from main     # Branch from specific base
cw new feat/auth --no-install    # Skip package installation
cw new feat/auth --no-claude     # Don't auto-start Claude
cw pr --draft                    # Create draft PR
cw pr -t "Title" -b "Body"       # Set PR title and body
```

---

## Configuration

Run `cw init` to create `.worktreerc`:

```bash
# .worktreerc
BASE_PORT=3000              # Dev server ports start here
BASE_BRANCH=dev             # Default PR target
AUTO_CLAUDE=true            # Auto-start Claude in new tabs
ENV_FILES=.env .env.local   # Copy these to new worktrees
SYMLINK_DIRS=.claude        # Symlink these directories
```

### How Ports Work

Each worktree gets a unique port:

```
main repo     → 3000 (BASE_PORT)
feat/auth     → 3001
feat/api      → 3002
fix/bug-123   → 3003
```

No more port conflicts. Run `cw ports` to see assignments.

---

## Terminal Support

| Terminal | Auto-open tabs | Auto-start Claude |
|----------|----------------|-------------------|
| Warp | ✅ | ✅ |
| iTerm2 | ✅ | ✅ |
| Terminal.app | ✅ | ❌ |
| Kitty | ✅ | ✅ |
| GNOME Terminal | ✅ | ✅ |
| Other | ❌ (prints path) | ❌ |

---

## How It Works

```
your-project/                    # Main repo (stay clean)
your-project__wt/                # All worktrees live here
├── feat-auth/                   # feat/auth branch
│   ├── .env                     # Copied from main
│   ├── .claude -> ../../.claude # Symlinked
│   └── ...
├── feat-api/
└── fix-bug-123/
```

- Worktrees share git history (fast creation)
- Each has its own working directory (no conflicts)
- Env files copied, config directories symlinked

---

## Requirements

- **Git** 2.15+ (for worktree features)
- **GitHub CLI** (`gh`) - for PR features
- **Claude Code** (`claude`) - optional, for auto-start

```bash
# Install dependencies
brew install gh
gh auth login
```

---

## Tips

**Naming Convention:** Use prefixes for organization
```bash
feat/    # New features
fix/     # Bug fixes
exp/     # Experiments
refactor/# Refactoring
```

**Quick Cleanup:** Remove all merged worktrees
```bash
cw prune
```

**Check What's Open:**
```bash
cw ls    # Quick list
cw status # Full dashboard
```

---

## Contributing

PRs welcome! Please open an issue first to discuss changes.

```bash
git clone https://github.com/smitfire/cw.git
cd cw
# Tests use BATS
brew install bats-core
bats tests/
```

## License

MIT
