#!/usr/bin/env bash
set -euo pipefail

Usage_exit() {
    cat <<EOF

Usage: ${0##*/} {list | fix} {p0 | p1 | p2}

EOF
    exit 1
}

[[ $# -eq 2 ]] || Usage_exit

mode="$1"
prio="$2"
# dirs=(~/Desktop ~/Downloads ~/Documents ~/Videos ~/Pictures ~/Music ~/Templates)
dirs=(/tmp/wip)

re_p0_ops='[&;|<>()$`]'
re_p2='[^a-zA-Z0-9._-]'

p0=() p1=() p2=()

# scan & classify once, exclusively (p0 > p1 > p2)
# -depth: children before parents, so stored paths stay valid when fixing
while IFS= read -r -d '' path; do
    base="${path##*/}"
    if [[ "$base" == -* ]] || [[ "$base" =~ [[:cntrl:]] ]] || [[ "$base" =~ $re_p0_ops ]]; then
        p0+=("$path")
    elif [[ "$base" == *' '* ]] ||
        [[ "$base" == *'*'* || "$base" == *'?'* || "$base" == *'['* || "$base" == *']'* ]] ||
        [[ "$base" == *"'"* || "$base" == *'"'* ]]; then
        p1+=("$path")
    elif [[ "$base" =~ $re_p2 ]]; then
        p2+=("$path")
    fi
done < <(find "${dirs[@]}" -mindepth 1 -depth -type d -print0 2>/dev/null)

case $prio in
p0)
    sel=("${p0[@]}")
    label='P0  dangerous (shell ops, ctrl chars, leading -)'
    ;;
p1)
    sel=("${p1[@]}")
    label='P1  annoying (spaces, globs, quotes)'
    ;;
p2)
    sel=("${p2[@]}")
    label='P2  cosmetic (non-ASCII, other non-portable)'
    ;;
*)
    echo 'priority can only be p0, p1, p2' >&2
    exit 1
    ;;
esac

case $mode in
list)
    if ((${#sel[@]})); then
        echo "── $label ──"
        printf '  %s\n' "${sel[@]}"
        echo "  count: ${#sel[@]}"
    else
        echo "All clear."
    fi
    ;;

fix)
    total=0
    for path in "${sel[@]}"; do
        dir="${path%/*}"
        base="${path##*/}"
        newbase="${base//[^a-zA-Z0-9._-]/_}"
        # leading '-' is in the allowed set but still dangerous → prefix with _
        if [[ "$newbase" == -* ]]; then
            newbase="_${newbase#-}"
        fi
        if [[ "$newbase" != "$base" ]]; then
            if [[ -e "$dir/$newbase" ]]; then
                echo "SKIP (exists): $path → $dir/$newbase" >&2
            else
                mv -- "$path" "$dir/$newbase"
                echo "RENAMED: $path → $dir/$newbase"
                total=$((total + 1)) # not ((total++)) — set -e!
            fi
        fi
    done
    echo "Done. $total directory(ies) renamed."
    ;;

*)
    echo 'mode can only be list or fix' >&2
    Usage_exit
    ;;
esac
