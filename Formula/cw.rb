class Cw < Formula
  desc "Claude Worktree - Git worktrees + Claude Code + GitHub integration"
  homepage "https://github.com/smitfire/cw"
  url "https://github.com/smitfire/cw/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "fa9f9393bf1d277add6514cbc4df31c4315a73320a9c2e61c4005b772dfb48c8"
  license "MIT"
  head "https://github.com/smitfire/cw.git", branch: "main"

  depends_on "gh" => :recommended

  def install
    bin.install "bin/cw"

    # Install shell completions
    bash_completion.install "completions/cw.bash" => "cw"
    zsh_completion.install "completions/cw.zsh" => "_cw"
    fish_completion.install "completions/cw.fish"
  end

  def caveats
    <<~EOS
      cw has been installed!

      Quick start:
        cw init           # Setup project config
        cw new feat/test  # Create your first worktree

      Optional dependencies:
        - gh (GitHub CLI) - installed via Homebrew dependency
        - claude (Claude Code CLI) - https://claude.ai/code

      Shell completions have been installed for bash, zsh, and fish.
      You may need to restart your shell or run:
        source #{bash_completion}/cw      # bash
        # zsh completions are automatic
        # fish completions are automatic
    EOS
  end

  test do
    assert_match "cw v", shell_output("#{bin}/cw --version")
    assert_match "Claude Worktree", shell_output("#{bin}/cw help")
  end
end
