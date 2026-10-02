if status is-interactive
    # Commands to run in interactive sessions can go here
end

# ── Homebrew (from .zprofile: eval "$(brew shellenv)") ──
/opt/homebrew/bin/brew shellenv fish | source

# ── PATH (from .zshrc / .zprofile) ──
# fish_add_path prepends; the LAST call ends up first, matching the zsh order.
fish_add_path /opt/homebrew/bin
fish_add_path /opt/homebrew/opt/llvm/bin
fish_add_path /opt/homebrew/opt/make/libexec/gnubin
fish_add_path --append ~/.local/bin   # added by pipx

# ── Rust / cargo (from .zshenv: . "$HOME/.cargo/env") ──
test -f ~/.cargo/env.fish && source ~/.cargo/env.fish

# ── Aliases (from .zshrc) ──
alias ai="claude --dangerously-skip-permissions"

set -gx EDITOR     "vim"
set -gx OPENAI_API_BASE     "https://openrouter.ai/api/v1"
set -gx OPENAI_BASE_URL     "https://openrouter.ai/api/v1"
set -gx OPENROUTER_BASE_URL "https://openrouter.ai/api/v1"

set -gx WORLD_KEY "8zkycZkIF4KgbLnhZ8quh60caaWV2GTX"

# ── nvm (from .zprofile) ──
# nvm is a bash/zsh shell function and does NOT work natively in fish.
# To restore nvm, install a fish port, e.g. with Fisher:
#   fisher install jorgebucaran/nvm.fish
# then use `nvm use`, `nvm install`, etc.
set -gx NVM_DIR "$HOME/.nvm"
