#!/bin/bash

sudo sh -c 'echo "" > /etc/motd'

sudo dpkg --add-architecture i386
sudo apt-get update || exit
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y nala || exit
sudo DEBIAN_FRONTEND=noninteractive nala install -y \
curl \
git \
micro \
tmux \
unzip \
zip \
|| exit

if ! command -v docker > /dev/null 2>&1; then
    curl -fsSL get.docker.com | sh && sudo usermod -aG docker "$(whoami)"
fi

if [ -d "$HOME/git/linux.confs" ]; then
    git -C "$HOME/git/linux.confs" pull
else
    git clone https://github.com/Trihedraf/linux.confs "$HOME/git/linux.confs" || exit
fi

"$HOME/git/linux.confs/scripts/spfInstall.sh"
"$HOME/git/linux.confs/scripts/configFiles.sh" -t || printf "terminal app configurations failed"
"$HOME/git/linux.confs/scripts/shellConf.sh" || printf "shell configuration failed"
if cd "$HOME/git/linux.confs"; then
    if sudo cp -rv ./debian-trixie/etc/* /etc/; then
        [ -f /etc/apt/sources.list ] && sudo rm /etc/apt/sources.list
        sudo nala update
    fi
fi
