#!/usr/bin/env bash
# shellcheck disable=SC1090,SC1091

# post install script to install favorite environment, apps, and settings

set -euo pipefail

. ~/Documents/Github/2.1.Linux/1.Install/01_set_env_variables.sh

$DBG now in "${BASH_SOURCE[0]}"

# speed up Linux Package Manager
. ./02_speed_up_dnf_n_apt.sh

# as a prerequesite install all paakages that are not included in the default distribution
# and install siomply with the package manager

for APP in git; do
    if command -v "$APP" >/dev/null; then
        $DBG "$0" "$APP" is already installed
        continue
    fi

    case $ID in
    fedora)
        sudo dnf install $APP
        ;;
    linuxmint | ubuntu)
        sudo apt install $APP
        ;;
    *)
        echo "Distribution $ID not recognized, exiting ..."
        exit 1
        ;;
    esac
done

# install vim
PKG_DIR=~/Documents/Github/2.1.Vim
[[ -d $PKG_DIR ]] || git clone https://github.com/ahjun001/2.1.Vim $PKG_DIR
bash "$PKG_DIR"/1.Install/install_pj.sh

# install nvim
# PKG_DIR=~/Documents/Github/2.2.Nvim
# [[ -d $PKG_DIR ]] || git clone https://github.com/ahjun001/2.2.Nvim $PKG_DIR
# . "$PKG_DIR"/1.Install/install_pj.sh

# install vscode
PKG_DIR=~/Documents/Github/2.2.VSCode
[[ -d $PKG_DIR ]] || git clone https://github.com/ahjun001/2.2.VSCode $PKG_DIR
. "$PKG_DIR"/1.Install/install_pj.sh

: && exit

# install git, required to install zsh & oh-my-zsh
. ./02_git.sh

# install zsh & oh-my-zsh
# . ./02_zsh/02_zsh.sh

# install shellspec
. ./02_shellspec.sh

# mount data partition
# . ./02_mount_data.sh

# update repositories, possibly on data partition
# . ./02_update_repos.sh x   to be fixed which data partition?

# reset all links
sudo ./03_reset_all_links.sh

# install google-chrome
# shellcheck source=/dev/null
. ,google-chrome_update.sh

# install brave
. ./02_brave.sh

# install pipx (required to install python apps)
. ./02_pipx.sh

# install yt-dlp, requires pipx
. ./02_yt-dlp.sh

# install tldr, requires pipx
. ./02_tldr.sh

# install Chinese input
. ./02_fcitx.sh

# Fedora only but there might be better WebApp systems than this one
# install nodeJS & npm, pre-requisites for nativefier -- which transforms websites into web apps
# . ./02_npm.sh

# install natifvefier, transforms websites into web apps
# . ./02_nativefier.sh

# install gimp
. ./02_gimp.sh x

# install httrack, copy websites to computer & browse locally
. ./02_httrack.sh

# install printer driver for TST setup
. ./02_install_printer_driver.sh

cat "$INSTALL_LOG"
