function __check_nvm --on-variable PWD --description 'Switch node version per .nvmrc'
    test -f .nvmrc; or return

    set -l target (string trim < .nvmrc)
    test -z "$target"; and return

    # Strip an optional leading "v" so comparisons are consistent
    set -l target_v (string replace -r '^v' '' -- $target)

    # Current version; empty when node isn't installed
    set -l current (node -v 2>/dev/null | string replace -r '^v' '')

    # Case 1: already on a version that satisfies the target (prefix match).
    # e.g. target "18" matches current "18.17.0", target "18.17" matches "18.17.0"
    if test -n "$current"; and string match -q -- "$target_v*" $current
        return
    end

    # Case 2: target already installed → switch
    set -l installed (nvm list 2>/dev/null | string match -r '\d+\.\d+\.\d+')
    for v in $installed
        if string match -q -- "$target_v*" $v
            nvm use $target
            return
        end
    end

    # Case 3: install it
    nvm install $target
end
