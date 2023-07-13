#!/usr/bin/env bash
# shellcheck disable=SC3044

# manually install and run VPN, manually install if not present
if ! command -v expressvpn; then
    exit 1
fi
# while ! expressvpn status | grep Connected; do
#     expressvpn connect smart
# done

# set environment
# shellcheck source=/dev/null
. /etc/os-release

case $ID in
linuxmint | ubuntu)
    PKG_FMT='.deb'
    PKG_MGR='apt'
    ;;
fedora)
    PKG_FMT='.rpm'
    PKG_MGR='dnf'
    ;;
*)
    printf "\nPackage format not identified\n\nExiting ..."
    exit 1
    ;;
esac

# create a bash script to launch installed apps afterwards, pin to panel, install plugins if needed
printf "#!/usr/bin/env bash\n\nprintf 'Launch apps that have been previously installed\nPin to panel\nInstall plugins if needed'\n\n" >./check_n_pin.sh
chmod +x check_n_pin.sh

# run
set -x

# VSCode
if ! command -v code; then
    read -r -n 1 -s -p "Set firefox about:preferences Downloads to 'Always ask where to save files'

    Save in ${RESOURCES}
    
    Press any key to continue ..."
    for file in "${RESOURCES}"'code'*"$PKG_FMT" ]; do
        if [ -f "$file" ]; then break; fi
        exit
    done
    firefox https://code.visualstudio.com/Download
    find "${RESOURCES}" -maxdepth 1 -name "code*.deb" -print0 | xargs -0 -I{} sudo "$PKG_MGR" install {}
else
    printf 'echo "sign-in to install plugins"\ncode\n' >>./check_n_pin.sh
fi

# vim
if ! command -v vim; then
    if ! ../../vim/vim_MY_install.sh; then exit 1; fi
else
    echo 'vim' >>./check_n_pin.sh
fi

# nvim, required for VSCode neovim plugin to work
if ! command -v nvim; then
    if ! ../../vim/nvim_MY_install.sh; then exit 1; fi
else
    echo 'nvim' >>./check_n_pin.sh
fi

# zsh and oh-my-zsh
if ! command -v zsh; then
    sudo "$PKG_MGR" install zsh
    git clone https://github.com/jeffreytse/zsh-vi-mode i/plugins/zsh-vi-mode "$ZSH_CUSTOM"/plugins/zsh-vi-mode
    sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
    chsh
fi

# shellSpec
cli_command=shellspec
if ! command -v "$cli_command"; then
    oldwd='pwd'
    cd "$RESOURCES" || exit
    if ! wget -O- https://git.io/shellspec | sh; then exit 1; fi
    cd "$oldwd" || exit
else
    echo "shellspec -v" >>./check_n_pin.sh
fi

# reset links for vim, nvim, zsh, VSCode, shellSpec
if ! sudo ../reset\ all\ links.sh; then exit 1; fi

set +x && exit

# using mintinstall

[ -f ./check_n_pin.sh ] && rm ./check_n_pin.sh

# wine wechat, wenlin, iexplorer
if ! command -v wine; then
    timeshift --create --comments "before wine install"
    if ! ./wine_install.sh; then
        exit
    fi
else
    echo 'winecfg' >>./check_n_pin.sh
fi

# python
sudo "$PKG_MGR" install python3 python3-venv python3-pip

# brave
if ! command -v brave-browser; then
    old_wd=$(pwd)
    cd /tmp || exit 1
    sudo apt -y install curl software-properties-common apt-transport-https
    curl https://brave-browser-apt-release.s3.brave.com/brave-core.asc | gpg --dearmor >brave-core.gpg
    sudo install -o root -g root -m 644 brave-core.gpg /etc/apt/trusted.gpg.d/
    echo "deb [arch=amd64] https://brave-browser-apt-release.s3.brave.com/ stable main" | sudo tee /etc/apt/sources.list.d/brave-browser-release.list
    sudo "$PKG_MGR" update
    sudo "$PKG_MGR" install brave-browser
    cd "$old_wd" || exit 1
else
    echo 'brave-browser' >>./check_n_pin.sh
fi

# Chrome
if ! command -v google-chrome; then
    ,google-chrome_update.sh
else
    echo 'google-chrome' >>./check_n_pin.sh
fi

# inkscape
if ! command -v inkscape; then
    add-"$PKG_MGR"-repository ppa:inkscape.dev/stable
    sudo "$PKG_MGR" update
    sudo "$PKG_MGR" install inkscape
else
    echo "inkscape" >>./check_n_pin.sh
fi

# VMWare player
if ! vmware-player; then
    ./install_vmware_player.sh
fi

# webapp manager
echo 'add https://cnrtl.fr/definition/'
echo 'https://www.google.com'
echo 'https://leconjugueur.lefigaro.fr'
echo 'https://trello.com/b/qlpLmRO5/1perso'
echo 'https://web.whatsapp.com/'
echo 'https://www.youtube.com/'
webapp-manager

# anki, audacity
for cli_command in 'anki' 'audacity'; do
    if ! command -v "$cli_command"; then
        sudo "$PKG_MGR" install "$cli_command"
    else
        printf '%s' "$cli_command" >>check_n_pin.sh
    fi
done

printf """
thunderbird
transmission-gtk
baobab
libreoffice --writer
gnome-calculator
gnome-system-monitor
gnome-screenshot --interactive
""" >>check_n_pin.sh

set +x

# todo
# create corresponding test
# environment for distro  LxMt Kub WLC
# if shelltest don't provide better view, then loop

# mkdir -p ~/Documents/Github
# cd ~/Documents/Github

# create check_n_pin.sh as apps are installed
# group apps
# install difficult first and create a backup
