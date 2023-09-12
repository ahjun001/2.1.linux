#!/usr/bin/env bash

xclip -o |
    sed '/\[sound:/s/ / ::/' |
    sed '/\[sound:/s/^/{{c::/' |
    sed -e '/\[sound:/{N;N;s/$/\}\}/}' |
    xclip -selection clipboard

[[ -L /usr/local/sbin/,kCloze_anki.sh ]] || sudo ln -fs ~/Documents/Github/2.1.linux/1.Install/utils_pj/,kCloze_anki.sh /usr/local/sbin/,kCloze_anki.sh
