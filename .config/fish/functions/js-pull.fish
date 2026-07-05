function js-pull --description 'Sync develop from origin, rebase current branch onto it, keep openjiuwen editable (~/agent-core)'
    set -l repo ~/jiuwenswarm
    set -l core ~/agent-core
    set -l override 'openjiuwen = { path = "/Users/cirnovsky/agent-core", editable = true }'

    # Optional base branch (default: develop)
    set -l base $argv[1]
    test -z "$base"; and set base develop

    pushd $repo; or return 1
    set -l cur (git rev-parse --abbrev-ref HEAD)
    set -l gd (git rev-parse --git-dir)

    # uv.lock is generated and churns on develop — discard local edits so it isn't dragged
    # through the rebase; we regenerate it from pyproject at the end.
    git checkout -- uv.lock 2>/dev/null

    # 1. Sync the base branch to origin, then rebase current branch onto it.
    #    --autostash sets aside the [tool.uv.sources] override (and any WIP) for the rebase.
    if test "$cur" = "$base"
        # Already on the base branch: fetch, then rebase it onto origin/base.
        if not git fetch origin
            echo "js-pull: git fetch failed" >&2; popd; return 1
        end
        git rebase --autostash origin/$base
    else
        # Fast-forward local base to origin/base WITHOUT checking it out.
        if not git fetch origin $base:$base
            echo "js-pull: could not fast-forward '$base' to origin/$base (diverged?). Resolve manually." >&2
            popd; return 1
        end
        git rebase --autostash $base
    end

    # 2. Disambiguate the outcome.
    #    (a) Rebase itself stopped on conflicts (mid-rebase).
    if test -d $gd/rebase-merge -o -d $gd/rebase-apply
        echo "js-pull: rebase stopped on conflicts. Resolve, then 'git rebase --continue' (or --abort)," >&2
        echo "        then run 'uv sync --extra distribute' to relink openjiuwen." >&2
        popd; return 1
    end
    #    (b) Override didn't survive (autostash failed to restore pyproject) — do NOT sync, or it reverts.
    if not grep -qF "$override" pyproject.toml
        echo "js-pull: openjiuwen override not in pyproject.toml (autostash conflict on pyproject?)." >&2
        echo "        Check 'git stash list', restore the [tool.uv.sources] openjiuwen line, then 'uv sync --extra distribute'." >&2
        popd; return 1
    end

    # 3. Re-derive the lock with the editable openjiuwen override (safe even if autostash left
    #    other files conflicted, since the override applied cleanly to pyproject).
    uv sync --extra distribute

    #    (c) Autostash reapply conflicted on some file (e.g. one develop stopped tracking).
    #        The rebase + relink are fine; WIP is safe in the retained stash — only these need hands.
    set -l conflicts (git diff --name-only --diff-filter=U)
    if test (count $conflicts) -gt 0
        echo "js-pull: rebased onto '$base' and openjiuwen relinked, BUT autostash reapply conflicted on:" >&2
        for f in $conflicts
            echo "          $f" >&2
        end
        echo "        Your WIP is preserved in the retained stash ('git stash list')." >&2
        echo "        Resolve the file(s) above, then 'git stash drop' (its other changes already applied)." >&2
        popd; return 1
    end

    echo "js-pull: '$cur' rebased onto '$base' ("(git rev-parse --short $base 2>/dev/null)")"
    echo "js-pull: openjiuwen ->" (uv run python -c "import openjiuwen; print(openjiuwen.__file__)" 2>/dev/null)
    echo "js-pull: ~/agent-core on branch" (git -C $core rev-parse --abbrev-ref HEAD 2>/dev/null)
    popd
end
