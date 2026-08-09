#!/bin/sh
mkdir -p "$HOME/.local/share/fonts/commitmono-nerd" "$HOME/.local/share/fonts/meslo-lgs-nerd" "$HOME/.local/share/fonts/ubuntu-mono-nerd"
curl -fsSL https://github.com/ryanoasis/nerd-fonts/releases/latest/download/CommitMono.tar.xz | tar -xJvf - --wildcards -C "$HOME/.local/share/fonts/commitmono-nerd" "CommitMonoNerdFontMono-*.otf"
printf "CommitMono Nerd Font has been installed.\n"
curl -fsSL https://github.com/ryanoasis/nerd-fonts/releases/latest/download/Meslo.tar.xz | tar -xJvf - --wildcards -C "$HOME/.local/share/fonts/meslo-lgs-nerd" "MesloLGSNerdFontMono-*.ttf"
printf "Meslo Nerd Font has been installed.\n"
curl -fsSL https://github.com/ryanoasis/nerd-fonts/releases/latest/download/UbuntuMono.tar.xz | tar -xJvf - --wildcards -C "$HOME/.local/share/fonts/ubuntu-mono-nerd" "UbuntuMonoNerdFontMono-*.ttf"
printf "Ubuntu Mono Nerd Font has been installed.\n"
