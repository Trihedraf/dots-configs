#!/bin/bash

ARCH=$(uname -m)
if [ "$ARCH" == "x86_64" ]; then
    ARCH="x64"
elif [ "$ARCH" == "aarch64" ]; then
    ARCH="arm64"
fi

vscode_url="https://code.visualstudio.com/sha/download?build=stable&os=linux-${ARCH}"
vscode_install="$HOME/.local/opt/vscode"

latest=$(curl -fsSL https://update.code.visualstudio.com/api/releases/stable | jq -r '.[0]')
if [ -x "$HOME/.local/bin/code" ]; then
    installed=$("$HOME/.local/bin/code" --version | head -n1)
    if [ "$installed" = "$latest" ]; then
        echo "VS Code $installed is already the latest"
        exit 0
    fi
fi

mkdir -p "$HOME/.local/opt" "$HOME/.local/bin"
tmp_dir=$(mktemp -d "$HOME/.local/opt/.vscode.XXXXXX")

echo "Downloading VS Code $latest..."
curl -fSL "$vscode_url" -o "$tmp_dir/vscode.tar.gz"
echo "Extracting VS Code..."
tar -xzf "$tmp_dir/vscode.tar.gz" -C "$tmp_dir" --strip-components 1
rm -f "$tmp_dir/vscode.tar.gz"

rm -rf "$vscode_install"
mv "$tmp_dir" "$vscode_install"

ln -sf "$vscode_install/bin/code" "$HOME/.local/bin/code"

mkdir -p "$HOME/.local/share/applications" "$HOME/.local/share/icons/hicolor/256x256/apps"

cp "$vscode_install/resources/app/resources/linux/code.png" "$HOME/.local/share/icons/hicolor/256x256/apps/vscode.png"

cat > "$HOME/.local/share/applications/code.desktop" <<EOF
[Desktop Entry]
Type=Application
Name=Visual Studio Code
Comment=Code Editing. Redefined.
GenericName=Text Editor
Exec=$vscode_install/bin/code %F
Icon=$HOME/.local/share/icons/hicolor/256x256/apps/vscode.png
Terminal=false
Categories=TextEditor;Development;IDE;
MimeType=text/plain;inode/directory;
Keywords=vscode;
EOF

echo "Installed VS Code $latest"
