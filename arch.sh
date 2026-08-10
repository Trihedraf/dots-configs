#!/bin/bash
optList=$(getopt -o fg:h --long fingerprint,gui:,help -n 'arch.sh' -- "$@")
eval set -- "$optList"

guiInstall=0
fingerprintInstall=0

while true; do
    case "$1" in
        -f | --fingerprint)
            fingerprintInstall="1"
            shift
        ;;
        -g | --gui)
            guiInstall="1"
            shift
        ;;
        -h | --help)
            printf "Usage: %s: [OPTION]\n" "$0"
            printf "    -h,--help           This help\n\n"
            printf "    -f,--fingerprint    Enable Framework fingerprint setup.\n"
            printf "    -g,--gui            Enable GUI apps install.\n"
            exit 2
        ;;
        *)
            break
        ;;
    esac
done

sudo pacman -Syy --noconfirm --needed git wget

if [ -d "$HOME/git/linux.confs" ]; then
    cd "$HOME/git/linux.confs" || exit
    git pull
else
    git clone https://github.com/Trihedraf/linux.confs "$HOME/git/linux.confs"
fi

if [ -d "$HOME/git/linux.confs" ]; then
    "$HOME/git/linux.confs/scripts/configFiles.sh" -t || printf "terminal app configurations failed"
    "$HOME/git/linux.confs/scripts/shellConf.sh" || printf "shell configuration failed"
    if [ "$guiInstall" = 1 ]; then
        "$HOME/git/linux.confs/scripts/fontInstall.sh" || printf "font install failed"
        "$HOME/git/linux.confs/scripts/configFiles.sh" -g || printf "desktop app configurations failed"
    fi
    if [ "$fingerprintInstall" = 1 ]; then
        "$HOME/git/linux.confs/scripts/frameworkArchFingerprintSetup.sh" || printf "fingerprint setup failed"
    fi
    if cd "$HOME/git/linux.confs"; then
        sudo cp -rv ./archlinux/etc/* /etc/
    fi
fi

sudo pacman -Syy --noconfirm --needed \
amd-ucode \
arch-wiki-docs \
arch-wiki-lite \
base-devel \
bash-completion \
bat \
btop \
cmake \
devtools \
dmidecode \
docker \
docker-buildx \
docker-compose \
efibootmgr \
ethtool \
fail2ban \
fastfetch \
github-cli \
gnutls lib32-gnutls \
htop \
intel-ucode \
iperf3 \
kitty-terminfo \
linux-tools \
man-db \
man-pages \
micro \
mingw-w64 \
msmtp \
nano \
ncurses \
lib32-ncurses \
net-tools \
nfs-utils \
nmap \
openssh \
pv \
samba \
screen \
shellcheck \
smartmontools \
superfile \
sqlite lib32-sqlite \
syncthing \
tar \
terminus-font \
tree \
tldr \
tmux \
trash-cli \
ufw \
unzip \
wget \
wikiman \
zip \

if command -v docker > /dev/null 2>&1; then
    sudo systemctl enable --now docker.socket
fi

if [ "$guiInstall" = 1 ]; then
    # Libraries for GUI
    sudo pacman -Syy --noconfirm --needed \
    alsa-lib lib32-alsa-lib \
    alsa-plugins lib32-alsa-plugins \
    alsa-utils \
    flatpak \
    gamemode lib32-gamemode \
    gamescope \
    giflib lib32-giflib \
    gst-plugins-base-libs \
    gtk3 lib32-gtk3 \
    libgcrypt lib32-libgcrypt \
    libgpg-error lib32-libgpg-error \
    libjpeg-turbo lib32-libjpeg-turbo \
    libldap lib32-libldap \
    libpng lib32-libpng \
    libpulse lib32-libpulse \
    libva lib32-libva \
    libxcomposite lib32-libxcomposite \
    libxinerama lib32-libxinerama \
    libxslt lib32-libxslt \
    mesa lib32-mesa \
    mpg123 lib32-mpg123 \
    ocl-icd lib32-ocl-icd \
    openal lib32-openal \
    opencl-icd-loader lib32-opencl-icd-loader \
    protontricks \
    sdl2-compat lib32-sdl2-compat \
    sdl3 lib32-sdl3 \
    v4l-utils lib32-v4l-utils \
    vkd3d lib32-vkd3d \
    vulkan-icd-loader lib32-vulkan-icd-loader \
    vulkan-radeon lib32-vulkan-radeon \
    wine \
    wine-gecko \
    wine-mono \
    winetricks

    # GUI Applications
    sudo pacman -Syy --noconfirm --needed \
    alacritty \
    discord \
    ghostty \
    goverlay \
    keepassxc \
    kitty \
    libreoffice-fresh \
    lutris \
    mangohud lib32-mangohud \
    obsidian \
    steam \
    umu-launcher \
    virt-manager \
    xclip \
    wl-clipboard

    # ART GUI Applications
    sudo pacman -Syy --noconfirm --needed \
    brave-bin \
    github-desktop-plus-bin \
    visual-studio-code-bin

    sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo && echo "Flathub repo added"

fi
