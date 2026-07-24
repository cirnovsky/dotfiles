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
set -gx NNN_RM "trash"
set -gx OPENAI_API_BASE     "https://openrouter.ai/api/v1"
set -gx OPENAI_BASE_URL     "https://openrouter.ai/api/v1"
set -gx OPENROUTER_BASE_URL "https://openrouter.ai/api/v1"
set -gx VISION_MODEL        "google/gemini-2.5-flash"

# ── nvm (from .zprofile) ──
# nvm is a bash/zsh shell function and does NOT work natively in fish.
# To restore nvm, install a fish port, e.g. with Fisher:
#   fisher install jorgebucaran/nvm.fish
# then use `nvm use`, `nvm install`, etc.
set -gx NVM_DIR "$HOME/.nvm"

# ── "you have mail" for ~/Mail/all/inbox ──
# Each message is a directory; a message is "read" once it contains a `.read`
# marker file. Unread = an inbox subdir with no `.read` inside.
set -gx MAILDIR "$HOME/Mail/all/inbox"

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

# ── background fetch: a launchd agent runs getmail every 5 min ──
# Installed once (first interactive shell that finds getmail); launchd then
# auto-loads it every login. So new mail arrives without opening Vim, and the
# "you have mail" check above sees it. `launchctl bootout gui/(id -u)/com.vim-mail.fetch`
# + rm the plist to stop it; edit StartInterval below to change the cadence.
set -l _mail_plist "$HOME/Library/LaunchAgents/com.vim-mail.fetch.plist"
if status is-interactive; and command -v getmail >/dev/null; and not test -e $_mail_plist
    mkdir -p (dirname $_mail_plist) "$HOME/Library/Logs"
    printf '<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0"><dict>
    <key>Label</key><string>com.vim-mail.fetch</string>
    <key>ProgramArguments</key>
    <array><string>%s</string><string>--getmaildir</string><string>%s/.getmail</string><string>--rcfile</string><string>getmailrc</string></array>
    <key>StartInterval</key><integer>300</integer>
    <key>RunAtLoad</key><true/>
    <key>StandardOutPath</key><string>%s/Library/Logs/vim-mail-fetch.log</string>
    <key>StandardErrorPath</key><string>%s/Library/Logs/vim-mail-fetch.log</string>
</dict></plist>\n' (command -v getmail) $HOME $HOME $HOME >$_mail_plist
    launchctl bootstrap gui/(id -u) $_mail_plist 2>/dev/null
end
