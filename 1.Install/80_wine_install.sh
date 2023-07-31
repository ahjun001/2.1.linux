#!/usr/bin/env bash

# mintinstall
#install wine-hq
# from https://wiki.winehq.org/Ubuntu
sudo dpkg --add-architecture i386
wget -P /tmp -nc https://dl.winehq.org/wine-builds/winehq.key
sudo apt-key add /tmp/winehq.key
sudo add-apt-repository 'deb https://dl.winehq.org/wine-builds/ubuntu/ focal main'
sudo apt update
sudo apt install --install-recommends winehq-stable
sudo apt update
winecfg # important to start with this command so as to trigger Mono & Gecko downloads
wine --version

exit
if ! command -v wechat; then
    wget -P /tmp https://dldir1.qq.com/weixin/Windows/WeChatSetup.exe
    playonlinux /tmp/WeChatSetup.exe
fi
# install wine, playonlinux,
# sudo dpkg --add-architecture i386
# mintinstall

# install wine APPs
printf '\nInstall Wenlin, WeChat\n, Internet Explorer'

## sudo apt update
