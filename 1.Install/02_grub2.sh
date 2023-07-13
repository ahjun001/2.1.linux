#!/usr/bin/env bash

# 02_grub2.sh
# modify grub2 to save default, show count down, install theme

set -euo pipefail
IFS=$'\n\t'
# shellcheck source=/dev/null
. ./01_set_env_variables.sh

# run with arg x to perform, u  to undo; argument is required to comply with set -u
case $# in
0) ACT=x ;; # used when editing modular script
1) case $1 in
    x | u) ACT=$1 ;;
    *) echo "argument when launching $0 should be 'x' or 'u'" && exit 1 ;;
    esac ;;
*) echo "error launching $0 : too many arguments" && exit 1 ;;
esac

# make an early copy of /etc/default/grub and monitor changes
G_FILE=/etc/default/grub
[ -f $G_FILE.bak ] || sudo cp ${G_FILE} ${G_FILE}.bak
G_MODIFIED=false

# GRUB_SAVEDEFAULT=true is not in /etc/default/grub at install
if grep 'GRUB_SAVEDEFAULT=true' "$G_FILE"; then
    case $ACT in
    x) [ "$MY_TRACE" = true ] && echo "GRUB_SAVEDEFAULT=true already in $G_FILE : nothing to do" ;;
    u) sudo sed -i '/GRUB_SAVEDEFAULT/d' $G_FILE && echo "GRUB_SAVEDEFAULT line deleted in $G_FILE" && G_MODIFIED=true ;;
    *) echo "Should never happen" && exit 1 ;;
    esac
else
    case $ACT in
    x) echo GRUB_SAVEDEFAULT=true | sudo tee -a "$G_FILE" && [ "$MY_TRACE" = true ] && echo "GRUB_SAVEDEFAULT=true added to $G_FILE" && G_MODIFIED=true ;;
    u) echo "GRUB_SAVEDEFAULT was not found in $G_FILE : nothing to do" ;;
    *) echo "Should never happen" && exit 1 ;;
    esac
fi

# GRUB_TERMINAL_OUTPUT='console' is in /etc/default/grub at install.  needs to be commented out to get theme working
if grep '^GRUB_TERMINAL_OUTPUT' "$G_FILE"; then
    case $ACT in
    x) sudo sed -i '/^GRUB_TERMINAL_OUTPUT/s/^/# /' "$G_FILE" && echo "GRUB_TERMINAL_OUTPUT commented out in $G_FILE" && G_MODIFIED=true ;;
    u) [ "$MY_TRACE" = true ] && echo "GRUB_TERMINAL_OUTPUT is already active in $G_FILE : nothing to do" ;;
    *) echo "Should never happen" && exit 1 ;;
    esac
else
    case $ACT in
    x) [ "$MY_TRACE" = true ] && echo "GRUB_TERMINAL_OUTPUT is not active in $G_FILE : nothing to do" ;;
    u) sudo sed -i '/# GRUB_TERMINAL_OUTPUT/s/# //' "$G_FILE" && echo "GRUB_TERMINAL_OUTPUT line activated in $G_FILE" && G_MODIFIED=true ;;
    *) echo "Should never happen" && exit 1 ;;
    esac
fi

# copy a theme to the new install and activate it in /etc/default/grub
THEME_DIRS=/usr/share/grub/themes/
MY_TH_DIR=grub2-theme-breeze
case $ACT in
x)
    if [ -d "$THEME_DIRS" ]; then
        [ "$MY_TRACE" = true ] && echo "$THEME_DIRS exists already ; nothing to do"
    else
        sudo mkdir -v "$THEME_DIRS"
    fi
    if [ -d "$THEME_DIRS$MY_TH_DIR" ]; then
        [ "$MY_TRACE" = true ] && echo "$THEME_DIRS$MY_TH_DIR exists already ; nothing to do"
    else
        sudo cp -r "$SOURCE_DIR"'Local resources TBU/themes/'"$MY_TH_DIR" "$THEME_DIRS" && [ "$MY_TRACE" = true ] && echo "$THEME_DIRS$MY_TH_DIR was copied in $THEME_DIRS"
    fi
    ;;
u)
    if [ -d "$THEME_DIRS$MY_TH_DIR" ]; then
        sudo rm -rv "$THEME_DIRS$MY_TH_DIR"
    else
        [ "$MY_TRACE" = true ] && echo "$THEME_DIRS$MY_TH_DIR does not exist ; nothing to do"
    fi
    if [ -d "$THEME_DIRS" ]; then
        sudo rmdir -v --ignore-fail-on-non-empty "$THEME_DIRS"
    else
        [ "$MY_TRACE" = true ] && echo "$THEME_DIRS does not exist ; nothing to do"
    fi
    ;;
*) echo "Should never happen" && exit 1 ;;
esac

# GRUB_THEME is not in /etc/default/grub at install
if grep 'GRUB_THEME' "$G_FILE"; then
    case $ACT in
    x) [ "$MY_TRACE" = true ] && echo "GRUB_THEME already in $G_FILE : nothing to do" ;;
    u) sudo sed -i '/GRUB_THEME/d' $G_FILE && echo "GRUB_THEME line deleted in $G_FILE" && G_MODIFIED=true ;;
    *) echo "Should never happen" && exit 1 ;;
    esac
else
    case $ACT in
    x) echo GRUB_THEME="/usr/share/grub/themes/$MY_TH_DIR/breeze/theme.txt" | sudo tee -a "$G_FILE" && [ "$MY_TRACE" = true ] && echo "GRUB_THEME added to $G_FILE" && G_MODIFIED=true ;;
    u) echo "GRUB_THEME was not found in $G_FILE : nothing to do" ;;
    *) echo "Should never happen" && exit 1 ;;
    esac
fi

[ "$MY_TRACE" = true ] && (diff $G_FILE $G_FILE.bak || true)

if [ "$LAUNCH_APP" = true ] && [ $G_MODIFIED = true ]; then
    case $ID in
    fedora)
        # sudo rm /boot/efi/EFI/fedora/grub.cfg
        # sudo rm /boot/grub2/grub.cfg
        # sudo dnf reinstall shim-* grub2-efi-* grub2-common
        sudo grub2-mkconfig -o /boot/grub2/grub.cfg
        ;;
    linuxmint | ubuntu)
        sudo update-grub
        ;;
    *)
        echo "Distribution $ID not recognized "
        exit 1
        ;;
    esac
fi
