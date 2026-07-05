function js-where --description 'Show where openjiuwen resolves for JS (.venv, no sync) and its branch'
    set -l repo ~/jiuwenswarm
    set -l py $repo/.venv/bin/python

    if not test -x $py
        echo "js-where: $py not found — is the venv created?" >&2
        return 1
    end

    # Use the .venv interpreter directly (NOT `uv run`, which would sync first) so
    # this reflects exactly what `.venv/bin/jiuwenswarm-start` will import.
    set -l file ($py -c "import openjiuwen, os; print(os.path.realpath(openjiuwen.__file__))" 2>/dev/null)
    if test -z "$file"
        echo "js-where: could not import openjiuwen from $py" >&2
        return 1
    end

    # openjiuwen/__init__.py -> package root is two dirs up
    set -l srcdir (dirname (dirname $file))
    echo "openjiuwen : $file"

    if string match -q '*/site-packages/*' $file
        echo "source     : site-packages  ⚠️  NOT the editable ~/agent-core override"
        echo "             (run 'uv sync --extra distribute' to relink)"
        return 1
    end

    echo "source dir : $srcdir"
    if git -C $srcdir rev-parse --git-dir >/dev/null 2>&1
        set -l branch (git -C $srcdir rev-parse --abbrev-ref HEAD 2>/dev/null)
        set -l sha (git -C $srcdir rev-parse --short HEAD 2>/dev/null)
        set -l dirty ""
        test -n (git -C $srcdir status --porcelain 2>/dev/null | string collect); and set dirty " (dirty)"
        echo "branch     : $branch @ $sha$dirty"
    else
        echo "branch     : (not a git checkout)"
    end
end
