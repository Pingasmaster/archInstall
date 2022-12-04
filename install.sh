#!/bin/bash
DIR=~/Downloads/balena*
if not [ -f "$DIR" ]; then
    cd ~/Downloads/
    wget https://github.com/balena-io/etcher/releases/download/v1.10.6/balenaEtcher-1.10.6-x64.AppImage
    sudo chmod 777 ~/Downloads/balenaEtcher-1.10.6-x64.AppImage
    ~/Downloads/balenaEtcher-1.10.6-x64.AppImage
fi
echo "Download the latest arch iso, and flash it with balena."
xdg-open https://archlinux.org/releng/releases/
