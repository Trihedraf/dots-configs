#!/bin/bash

sudo sh -c 'echo "" > /etc/motd'

sudo dpkg --add-architecture i386
sudo apt-get update || exit
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y nala || exit
sudo DEBIAN_FRONTEND=noninteractive nala install -y \
build-essential \
cmake \
fastfetch \
git \
gh \
iperf3 \
jq \
micro \
multitail \
net-tools \
pipx \
screen \
shellcheck \
smpq \
trash-cli \
tree \
unzip \
zip \
|| exit

if ! command -v docker > /dev/null 2>&1; then
    curl -fsSL get.docker.com | sh && sudo usermod -aG docker "$(whoami)"
fi

if git clone https://github.com/Trihedraf/linux.confs "$HOME/git/linux.confs"; then
    "$HOME/git/linux.confs/scripts/spfInstall.sh"
    "$HOME/git/linux.confs/scripts/configFiles.sh" -t || printf "terminal app configurations failed"
    "$HOME/git/linux.confs/scripts/shellConf.sh" || printf "shell configuration failed"
    if cd "$HOME/git/linux.confs"; then
        if sudo cp -rv ./debian-trixie/etc/* /etc/; then
            sudo rm /etc/apt/sources.list && sudo nala update
        fi
    fi
fi