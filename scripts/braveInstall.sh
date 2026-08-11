#!/bin/bash

ARCH=$(uname -m)
if [ "$ARCH" == "x86_64" ]; then
    ARCH="amd64"
elif [ "$ARCH" == "aarch64" ]; then
    ARCH="arm64"
fi

brave_url=$(curl -s https://api.github.com/repos/brave/brave-browser/releases/latest | jq -r ".assets[] | select(.name | test(\"brave-browser-.*linux-${ARCH}.zip$\")) | .browser_download_url" | grep -v sha)
brave_install="$HOME/.local/opt/brave"

latest=$(curl -s https://api.github.com/repos/brave/brave-browser/releases/latest | jq -r '.tag_name' | sed 's/^v//')
if [ -x "$HOME/.local/bin/brave" ]; then
    installed=$("$HOME/.local/bin/brave" --version 2>/dev/null | awk '{print $3}' | cut -d. -f2-)
    if [ -n "$installed" ] && [ "$installed" = "$latest" ]; then
        echo "Brave $installed is already the latest"
        exit 0
    fi
fi

mkdir -p "$HOME/.local/opt" "$HOME/.local/bin"
tmp_dir=$(mktemp -d "$HOME/.local/opt/.brave.XXXXXX")

echo "Downloading Brave $latest..."
curl -fSL "$brave_url" -o "$tmp_dir/brave.zip"
echo "Extracting Brave..."
unzip -q "$tmp_dir/brave.zip" -d "$tmp_dir/brave"
rm -f "$tmp_dir/brave.zip"

rm -rf "$brave_install"
mv "$tmp_dir/brave" "$brave_install"

ln -sf "$brave_install/brave" "$HOME/.local/bin/brave"

mkdir -p "$HOME/.local/share/applications" "$HOME/.local/share/icons/hicolor/256x256/apps"

cp "$brave_install/product_logo_256.png" "$HOME/.local/share/icons/hicolor/256x256/apps/brave.png"

cat > "$HOME/.local/share/applications/brave.desktop" <<EOF
[Desktop Entry]
Type=Application
Name=Brave
Comment=Web Browser
GenericName=Web Browser
Exec=$brave_install/brave %U
Icon=$HOME/.local/share/icons/hicolor/256x256/apps/brave.png
Terminal=false
Categories=Network;WebBrowser;
MimeType=x-scheme-handler/http;x-scheme-handler/https;text/html;x-scheme-handler/about;x-scheme-handler/ftp;x-scheme-handler/unknown;
StartupWMClass=brave-browser
StartupNotify=true
EOF

echo "Installed Brave $latest"
