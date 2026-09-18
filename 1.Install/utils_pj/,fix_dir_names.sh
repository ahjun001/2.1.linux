#!/usr/bin/env bash
set -euo pipefail

Usage_exit() {
    cat <<EOF

Usage: ${0##*/} {list | fix}

EOF
    exit 1
}

[[ $# -eq 1 ]] || Usage_exit

mode="$1"
# dirs=(~/Desktop ~/Downloads ~/Documents ~/Videos ~/Pictures ~/Music ~/Templates)
dirs=(/tmp/wip)

# Characters replaced with '_': exactly the union of the old P0+P1 sets.
#   ] [ [ :cntrl:] & ; | < > ( ) $ ` ' " * ? and space
# All non-ASCII characters (ü, ï, 中, 文…) can never match → preserved.
bad_chars="[][:cntrl:][&;|<>()\$\`'\"*? ]"

clean_name() { # $1 = current name → echoes target name
    local n="$1"
    n="${n#"${n%%[![:space:]]*}"}" # strip leading blanks (space, tab, newline, CR…)
    n="${n//$bad_chars/_}"         # replace ONLY dangerous/annoying chars
    if [[ -z $n || $n == . || $n == .. ]]; then
        n='_' # name was nothing but blanks
    fi
    if [[ $n == -* ]]; then # leading '-' still dangerous → prefix _
        n="_${n#-}"
    fi
    printf '%s' "$n"
}
paths=() targets=()

# -depth: children before parents, so stored paths stay valid while fixing
while IFS= read -r -d '' path; do
    base="${path##*/}"
    newbase="$(clean_name "$base")"
    if [[ "$newbase" != "$base" ]]; then # keep $base quoted! (see notes)
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
    total=0
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
