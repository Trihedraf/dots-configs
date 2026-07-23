#!/bin/bash

ARCH=$(uname -m)
if [ "$ARCH" == "x86_64" ]; then
    ARCH="amd64"
elif [ "$ARCH" == "aarch64" ]; then
    ARCH="arm64"
fi

gh_url=$(curl -s https://api.github.com/repos/cli/cli/releases/latest | jq -r ".assets[] | select(.name | test(\"linux_${ARCH}.tar.gz\")) | .browser_download_url" | grep -v sha)
curl -fsSL "$gh_url" | tar -xvzf - -C "$HOME/.local/bin" --strip-components 2 --no-anchored gh
