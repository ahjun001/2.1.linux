#!/usr/bin/env bash

# post install script to install favorite environment, apps, and settings

set -euo pipefail

# shellcheck source=/dev/null
. ./01_set_env_variables.sh

# remove previous log
rm -f "$INSTALL_LOG"

# speed up Linux Package Manager
# bash ./02_speed_up_dnf_n_apt.sh || cat  "$INSTALL_LOG"

# install expressvpn package available in "$SOURCE_DIR"
# bash ./02_expressvpn.sh || cat  "$INSTALL_LOG"

# modify grub2 to save default, show count down, install theme
# bash ./02_grub2.sh || cat  "$INSTALL_LOG"

# install vim
bash ./02_vim/02_vim.sh || cat "$INSTALL_LOG"

# install nvim
bash ./02_vim/02_nvim.sh || cat "$INSTALL_LOG"

# install vscode
bash ./02_code/02_code.sh || cat "$INSTALL_LOG"

# install git, required to install zsh & oh-my-zsh
bash ./02_git.sh || cat "$INSTALL_LOG"

# install zsh & oh-my-zsh
# bash ./02_zsh/02_zsh.sh || cat "$INSTALL_LOG"

# install shellspec
bash ./02_shellspec.sh || cat "$INSTALL_LOG"

# mount data partition
# bash ./02_mount_data.sh || cat "$INSTALL_LOG"

# update repositories, possibly on data partition
# bash ./02_update_repos.sh x   to be fixed which data partition?

# reset all links
sudo ./03_reset_all_links.sh || cat "$INSTALL_LOG"

# install google-chrome
# shellcheck source=/dev/null
. ,google-chrome_update.sh || cat "$INSTALL_LOG"

# install brave
bash ./02_brave.sh || cat "$INSTALL_LOG"

# install pipx (required to install python apps)
bash ./02_pipx.sh || cat "$INSTALL_LOG"

# install yt-dlp, requires pipx
bash ./02_yt-dlp.sh || cat "$INSTALL_LOG"

# install tldr, requires pipx
bash ./02_tldr.sh || cat "$INSTALL_LOG"

# install Chinese input
bash ./02_fcitx.sh || cat "$INSTALL_LOG"

# Fedora only but there might be better WebApp systems than this one
# install nodeJS & npm, pre-requisites for nativefier -- which transforms websites into web apps
# bash ./02_npm.sh || cat "$INSTALL_LOG"

# install natifvefier, transforms websites into web apps
# bash ./02_nativefier.sh

# install gimp
bash ./02_gimp.sh x || cat "$INSTALL_LOG"

# install httrack, copy websites to computer & browse locally
bash ./02_httrack.sh

# install printer driver
bash ./02_install_printer_driver.sh

cat "$INSTALL_LOG"
