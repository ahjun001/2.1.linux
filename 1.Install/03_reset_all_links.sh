#!/usr/bin/env bash

: "
  03_reset_all_links.sh
  set links so that apps are seen in $PATH or as ,shorcuts that start with a comma ',';
  "

set -euo pipefail

MAIN_DIR=/home/perubu/Documents/Github/2.1.linux/1.Install
# shellcheck source=/dev/null
. "$MAIN_DIR"/01_set_env_variables.sh

$DBG $'\n'"${BASH_SOURCE[0]#/home/perubu/Documents/Github/}"

# util function to force to recreate possibly existing link and check that it is not broken
make_a_link() {
   if ! ln -sf "$my_orig" "$my_link" || [ ! -e "${my_link}" ]; then
      exit 1
   fi
}

# exiting if not sudo
if [ "$(id -u)" != "0" ]; then
   echo 'this script requires root privileges'
   exit 1
fi

# replace existing links
sudo find /usr/local/sbin/ -type l -delete


# link nvim with soft link in PATH
# my_orig='/opt/nvim-linux64/bin/nvim'
# my_link=/usr/local/sbin/nvim
# make_a_link

# link vim to Github vimrc
my_orig='/home/perubu/Documents/Github/3.c-install-n-utils/02_vim/vimrc'
my_link=/home/perubu/.vim/"$(basename $my_orig)"
make_a_link

# link nvim to Github vimrc
my_orig='/home/perubu/Documents/Github/3.c-install-n-utils/02_vim/vimrc'
my_link=/home/perubu/.config/nvim/init.vim
make_a_link

# link to Github .zshrc
my_orig='/home/perubu/Documents/Github/3.c-install-n-utils/02_zsh/.zshrc'
my_link=/home/perubu/"$(basename "$my_orig")"
make_a_link

# link to all Github bash scripts whose filename starts with ,
if ! find "$MAIN_DIR"/utils_pj/ \
   -type f -name ',*.sh' \
   -exec sudo ln -sf {} /usr/local/sbin/ \;; then
   exit 1
fi
# where the literal {} gets substituted by the filename and
# the literal \; is needed for find to know that the custom command ends there.

# put shellSpec in path
my_orig='/home/perubu/.local/lib/shellspec/shellspec'
my_link=/usr/local/sbin/"$(basename "$my_orig")"
make_a_link

# with new version of VSCode, this is probably not needed any longer
: && exit 0

# link to VSCode snippets
if ! find /home/perubu/Documents/Github/3.c-install-n-utils/02_code/User/snippets/ \
   -type f \
   -name '*.json' \
   -exec sudo ln \
   -sf {} /home/perubu/.config/Code/User/snippets/ \;; then
   exit 1
fi

# link to VSCode tasks.json
my_orig='/home/perubu/Documents/Github/3.c-install-n-utils/02_code/User/tasks.json'
my_link=/home/perubu/.config/Code/User/"$(basename "$my_orig")"
make_a_link
