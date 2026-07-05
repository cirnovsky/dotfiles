# ── minimal terminal todo list ──
# Same idea as the "you have mail" prompt hook: fish has no daemon, so we
# re-check on the prompt (throttled to 60s) and surface pending items.
#
#   todo                 list pending items (numbered)
#   todo add <text>      add a new item
#   todo done 2 5        tick off items #2 and #5 (moved to the done log)
#   todo log             show completed items
#   todo edit            open the raw list in $EDITOR
#   todo help
#
# Pending items live one-per-line in $TODO_FILE. Completing an item moves it
# (with a timestamp) to $TODO_DONE so there's a record.

set -q TODO_FILE; or set -gx TODO_FILE "$HOME/.todo"
set -q TODO_DONE; or set -gx TODO_DONE "$HOME/.todo.done"

function _todo_lines
    test -e $TODO_FILE; or return
    string match -rv '^\s*$' <$TODO_FILE
end

function _todo_show
    set -l items (_todo_lines)
    if test (count $items) -eq 0
        set_color green; echo "todo: all clear ✓"; set_color normal
        return
    end
    for i in (seq (count $items))
        printf '%2d. %s\n' $i $items[$i]
    end
end

function _todo_done
    set -l items (_todo_lines)
    test (count $items) -gt 0; or begin
        echo "todo: nothing to complete"; return
    end
    set -l stamp (date '+%Y-%m-%d %H:%M')
    set -l keep
    set -l did 0
    for i in (seq (count $items))
        if contains -- $i $argv
            printf '%s\tdone %s\n' "$items[$i]" $stamp >>$TODO_DONE
            set_color green; echo "✓ "$items[$i]; set_color normal
            set did 1
        else
            set -a keep $items[$i]
        end
    end
    test $did -eq 1; or echo "todo: no matching item numbers"
    if test (count $keep) -gt 0
        printf '%s\n' $keep >$TODO_FILE
    else
        echo -n "" >$TODO_FILE
    end
end

function _todo_help
    echo "todo — minimal terminal todo list"
    echo "  todo                list pending items"
    echo "  todo add <text>     add an item"
    echo "  todo done <n>...    complete item(s) by number"
    echo "  todo log            show completed items"
    echo "  todo edit           edit the raw list"
end

function todo -d "minimal terminal todo list"
    set -l cmd $argv[1]
    set -e argv[1]
    switch "$cmd"
        case '' list ls
            _todo_show
        case add a new
            test -n "$argv"; or begin
                echo "usage: todo add <text>"; return 1
            end
            echo (string join ' ' -- $argv) >>$TODO_FILE
            set_color green; echo "added: "(string join ' ' -- $argv); set_color normal
        case done do d rm x
            _todo_done $argv
        case log done-list dl
            test -e $TODO_DONE; and cat $TODO_DONE; or echo "todo: no completed items yet"
        case edit e
            eval $EDITOR $TODO_FILE
        case help -h --help
            _todo_help
        case '*'
            echo "todo: unknown subcommand '$cmd'"; _todo_help; return 1
    end
end

# tab-completions for the subcommands
complete -c todo -f
complete -c todo -n __fish_use_subcommand -a 'add done list log edit help'

# ── prompt reminder (throttled to once per 60s, like _mail_check) ──
function _todo_reminder --on-event fish_prompt
    set -l now (date +%s)
    if not set -q _todo_last_check; or test (math $now - $_todo_last_check) -ge 60
        set -g _todo_last_check $now
        set -g TODO_PENDING (count (_todo_lines))
        test $TODO_PENDING -gt 0; and set_color yellow
        and echo "todo: $TODO_PENDING pending (run `todo`)"
        and set_color normal
    end
end

if status is-interactive
    set -g TODO_PENDING (count (_todo_lines))
    set -g _todo_last_check (date +%s)
    test $TODO_PENDING -gt 0; and set_color yellow
    and echo "todo: $TODO_PENDING pending (run `todo`)"
    and set_color normal
end
