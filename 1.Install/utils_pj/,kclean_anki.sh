#!/usr/bin/env bash

xclip -o |
    sed 's/{{c.:://g' |
    sed 's/:://g' |
    sed 's/}}//g' |
    xclip -i -selection clipboard

[[ -L /usr/local/sbin/,kclean_anki.sh ]] || sudo ln -fs ~/Documents/Github/2.1.linux/1.Install/utils_pj/,kclean_anki.sh /usr/local/sbin/,kclean_anki.sh