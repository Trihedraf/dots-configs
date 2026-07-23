#!/bin/bash

release_url=$(curl -s https://api.github.com/repos/koalaman/shellcheck/releases/latest | jq -r ".assets[] | select(.name | test(\"linux.x86_64.tar.gz\")) | .browser_download_url" | grep -v sha)
curl -fsSL "$release_url" | tar -xvzf - -C "$HOME/.local/bin" --strip-components 1 --no-anchored shellcheck
