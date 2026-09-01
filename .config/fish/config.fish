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
alias ai="codex --yolo"

set -gx EDITOR     "vim"
set -gx OPENAI_API_BASE     "https://openrouter.ai/api/v1"
set -gx OPENAI_BASE_URL     "https://openrouter.ai/api/v1"
set -gx OPENROUTER_BASE_URL "https://openrouter.ai/api/v1"

# ── Claude Code via OpenRouter ──
# Routes the `claude` CLI to OpenRouter's Anthropic-compatible endpoint.
# NB: claude appends /v1/messages to ANTHROPIC_BASE_URL, so the base is
# https://openrouter.ai/api (NOT /api/v1), and the key must be ANTHROPIC_API_KEY.
set -gx ANTHROPIC_BASE_URL        "https://openrouter.ai/api"
set -gx ANTHROPIC_API_KEY         "$OPENROUTER_API_KEY"
set -gx ANTHROPIC_MODEL           "anthropic/claude-sonnet-5"
set -gx ANTHROPIC_SMALL_FAST_MODEL "anthropic/claude-haiku-4.5"

# ── nvm (from .zprofile) ──
# nvm is a bash/zsh shell function and does NOT work natively in fish.
# To restore nvm, install a fish port, e.g. with Fisher:
#   fisher install jorgebucaran/nvm.fish
# then use `nvm use`, `nvm install`, etc.
set -gx NVM_DIR "$HOME/.nvm"
