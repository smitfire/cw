#!/bin/bash
# cw installer - Claude Worktree CLI
# Usage: curl -sL https://raw.githubusercontent.com/YOUR_USERNAME/cw/main/install.sh | bash

set -e

REPO="YOUR_USERNAME/cw"
INSTALL_DIR="${CW_INSTALL_DIR:-$HOME/.local/bin}"
VERSION="${CW_VERSION:-main}"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

info() { echo -e "${CYAN}$1${NC}"; }
success() { echo -e "${GREEN}✓ $1${NC}"; }
warn() { echo -e "${YELLOW}⚠ $1${NC}"; }
error() { echo -e "${RED}✗ $1${NC}"; exit 1; }

# Check for required commands
command -v curl >/dev/null 2>&1 || error "curl is required but not installed"
command -v git >/dev/null 2>&1 || error "git is required but not installed"

echo ""
echo -e "${CYAN}╭─────────────────────────────────────╮${NC}"
echo -e "${CYAN}│     cw - Claude Worktree CLI        │${NC}"
echo -e "${CYAN}╰─────────────────────────────────────╯${NC}"
echo ""

info "Installing cw to ${INSTALL_DIR}..."

# Create install directory
mkdir -p "$INSTALL_DIR"

# Download the script
DOWNLOAD_URL="https://raw.githubusercontent.com/${REPO}/${VERSION}/bin/cw"
info "Downloading from ${DOWNLOAD_URL}..."

if curl -fsSL "$DOWNLOAD_URL" -o "${INSTALL_DIR}/cw"; then
  chmod +x "${INSTALL_DIR}/cw"
  success "Installed cw to ${INSTALL_DIR}/cw"
else
  error "Failed to download cw. Check your internet connection and try again."
fi

# Check if install dir is in PATH
if [[ ":$PATH:" != *":$INSTALL_DIR:"* ]]; then
  echo ""
  warn "Directory not in PATH"
  echo ""
  echo "Add to your shell config:"
  echo ""

  # Detect shell
  SHELL_NAME=$(basename "$SHELL")
  case "$SHELL_NAME" in
    bash)
      echo "  echo 'export PATH=\"\$HOME/.local/bin:\$PATH\"' >> ~/.bashrc"
      echo "  source ~/.bashrc"
      ;;
    zsh)
      echo "  echo 'export PATH=\"\$HOME/.local/bin:\$PATH\"' >> ~/.zshrc"
      echo "  source ~/.zshrc"
      ;;
    fish)
      echo "  fish_add_path ~/.local/bin"
      ;;
    *)
      echo "  export PATH=\"\$HOME/.local/bin:\$PATH\""
      ;;
  esac
  echo ""
fi

# Optional: Install shell completions
install_completions() {
  local shell_name="$1"
  local comp_dir
  local comp_url
  local comp_file

  case "$shell_name" in
    bash)
      comp_dir="${BASH_COMPLETION_USER_DIR:-$HOME/.local/share/bash-completion/completions}"
      comp_url="https://raw.githubusercontent.com/${REPO}/${VERSION}/completions/cw.bash"
      comp_file="cw"
      ;;
    zsh)
      comp_dir="${HOME}/.zsh/completions"
      comp_url="https://raw.githubusercontent.com/${REPO}/${VERSION}/completions/cw.zsh"
      comp_file="_cw"
      ;;
    fish)
      comp_dir="${HOME}/.config/fish/completions"
      comp_url="https://raw.githubusercontent.com/${REPO}/${VERSION}/completions/cw.fish"
      comp_file="cw.fish"
      ;;
    *)
      return 1
      ;;
  esac

  mkdir -p "$comp_dir"
  if curl -fsSL "$comp_url" -o "${comp_dir}/${comp_file}" 2>/dev/null; then
    success "Installed ${shell_name} completions"
    return 0
  fi
  return 1
}

echo ""
info "Installing shell completions..."

SHELL_NAME=$(basename "$SHELL")
install_completions "$SHELL_NAME" || warn "Could not install completions for $SHELL_NAME"

# Check for optional dependencies
echo ""
info "Checking dependencies..."

if command -v gh >/dev/null 2>&1; then
  success "GitHub CLI (gh) found"
else
  warn "GitHub CLI (gh) not found - PR features won't work"
  echo "  Install: brew install gh"
fi

if command -v claude >/dev/null 2>&1; then
  success "Claude Code CLI found"
else
  warn "Claude Code CLI not found - auto-Claude features won't work"
  echo "  Install: https://claude.ai/code"
fi

echo ""
echo -e "${GREEN}╭─────────────────────────────────────╮${NC}"
echo -e "${GREEN}│         Installation complete!      │${NC}"
echo -e "${GREEN}╰─────────────────────────────────────╯${NC}"
echo ""
echo "Get started:"
echo "  cw help           # Show all commands"
echo "  cw init           # Setup project config"
echo "  cw new feat/test  # Create your first worktree"
echo ""
