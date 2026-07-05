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

# ── Environment variables (from .zshrc) ──
# Secret values live in ~/.config/fish/conf.d/secrets.fish (gitignored, sourced
# before this file). The lines below are commented indicators of which keys are
# expected there — the actual values are NOT stored in this tracked file:
#   set -gx OPENAI_API_KEY      "sk-or-v1-…"   → secrets.fish
#   set -gx OPENROUTER_API_KEY  "sk-or-v1-…"   → secrets.fish
#   set -gx HF_TOKEN            "hf_…"          → secrets.fish
set -gx OPENAI_API_BASE     "https://openrouter.ai/api/v1"
set -gx OPENROUTER_BASE_URL "https://openrouter.ai/api/v1"
set -gx VISION_MODEL        "google/gemini-2.5-flash"

# ── nvm (from .zprofile) ──
# nvm is a bash/zsh shell function and does NOT work natively in fish.
# To restore nvm, install a fish port, e.g. with Fisher:
#   fisher install jorgebucaran/nvm.fish
# then use `nvm use`, `nvm install`, etc.
set -gx NVM_DIR "$HOME/.nvm"

# ── "you have mail" for ~/Mail/inbox ──
# Each message is a directory; a message is "read" once it contains a `.read`
# marker file. Unread = an inbox subdir with no `.read` inside.
set -gx MAILDIR "$HOME/Mail/inbox"

function _mail_unread_count
    set -l n 0
    for d in $MAILDIR/*/
        test -e $d".read"; or set n (math $n + 1)
    end
    echo $n
end

# fish has no MAILCHECK/periodic, so re-scan on the prompt but throttle to
# once every 60s (cached in $MAIL_UNREAD).
function _mail_check --on-event fish_prompt
    set -l now (date +%s)
    if not set -q _mail_last_check; or test (math $now - $_mail_last_check) -ge 60
        set -g _mail_last_check $now
        set -g MAIL_UNREAD (_mail_unread_count)
        test $MAIL_UNREAD -gt 0; and set_color yellow; and echo "You have $MAIL_UNREAD new mail."; and set_color normal
    end
end

if status is-interactive
    set -g MAIL_UNREAD (_mail_unread_count)
    set -g _mail_last_check (date +%s)
    test $MAIL_UNREAD -gt 0; and set_color yellow; and echo "You have $MAIL_UNREAD new mail."; and set_color normal
end
