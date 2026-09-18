#!/usr/bin/env bash
# /home/perubu/Documents/Github/2.1.linux/1.Install/utils_pj/spec/,fix_dir_names.sh
# Unicode-safe: only ASCII shell-dangerous/annoying characters are replaced;
# everything else (ü, 中文, …) is preserved.
set -euo pipefail

Usage_exit() {
    cat <<EOF

Usage: ${0##*/} {list | fix} [dir...]

    dir...   optional target directories (default: /tmp/wip)

EOF
    exit 1
}

# Characters replaced with '_': the union of the old P0+P1 sets —
#   ] [ control-chars & ; | < > ( ) $ ` ' " * ? and space
# Non-ASCII characters can never match this set → always preserved.
bad_chars="[][:cntrl:][&;|<>()\$\`'\"*? ]"

clean_name() { # $1 = name → prints sanitized name
    local n="$1"
    n="${n#"${n%%[![:space:]]*}"}" # strip leading blanks (inner quotes = literal)
    # NB: $bad_chars is deliberately UNquoted — quoted would make it a literal
    # string to search for; unquoted makes it a pattern (what we want).
    # shellcheck disable=SC2295
    n="${n//$bad_chars/_}" # replace only dangerous/annoying chars
    if [[ -z $n || $n == . || $n == .. ]]; then
        n='_' # name was all blanks / dot-only
    fi
    if [[ $n == -* ]]; then # '-' is dangerous only in position 0
        n="_$n"             # prefix: demote the dash, keep the information
    fi
    printf '%s' "$n"
}

main() {
    (($# >= 1)) || Usage_exit
    local mode="$1"
    shift
    local dirs=("$@")
    ((${#dirs[@]})) || dirs=(~/Desktop ~/Downloads ~/Documents ~/Videos ~/Pictures ~/Music ~/Templates)
    # ((${#dirs[@]})) || dirs=(/tmp/wip)      # default target when none given

    local -a paths=() targets=()
    local path base newbase dir total=0 i

    # -depth: children before parents, so stored paths stay valid while fixing
    while IFS= read -r -d '' path; do
        base="${path##*/}"
        newbase="$(clean_name "$base")"
        if [[ "$newbase" != "$base" ]]; then # keep $base quoted (glob safety)
            paths+=("$path")
            targets+=("$newbase")
        fi
    done < <(find "${dirs[@]}" -mindepth 1 -depth -type d -print0)

    case $mode in

    list)
        if ((${#paths[@]})); then
            echo "── directories needing cleanup ──"
            for i in "${!paths[@]}"; do
                printf '  %q  →  %s\n' "${paths[i]}" "${targets[i]}"
            done
            echo "  count: ${#paths[@]}"
        else
            echo "All clear."
        fi
        ;;

    fix)
        for i in "${!paths[@]}"; do
            path="${paths[i]}"
            dir="${path%/*}"
            newbase="${targets[i]}"
            if [[ -e "$dir/$newbase" ]]; then
                echo "SKIP (exists): $path → $dir/$newbase" >&2
            else
                mv -- "$path" "$dir/$newbase"
                echo "RENAMED: $path → $dir/$newbase"
                total=$((total + 1))
            fi
        done
        echo "Done. $total directory(ies) renamed."
        ;;

    *)
        echo 'mode can only be list or fix' >&2
        Usage_exit
        ;;
    esac
}

# Execute only when run, not when sourced (shellspec sources this file
# to unit-test clean_name()).
if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
    main "$@"
fi
