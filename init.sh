#!/bin/bash

DISTRO=$(awk '/^ID=/' /etc/*-release | awk -F'=' '{ print tolower($2) }')
if [ "$DISTRO" = "arch" ]; then
    sudo pacman -Syu --noconfirm
    toInstall=(
        "base-devel"
        "git"
        "vim"
        "go"
        "gum"
    )
    sudo pacman -S --noconfirm --noprogressbar --needed --disable-download-timeout "${toInstall[@]}"
else
    sudo apt update
    sudo apt upgrade -y
    toInstall=(
        "git"
        "vim"
        "nala"
    )
    sudo apt install -y "${toInstall[@]}"
fi
gum log -l info "Cloning setup repos"
gum log -l info "-> Cloning DOTFILES"
[ ! -d "dotfiles" ] && git clone https://github.com/H-ADJI/dotfiles
gum log -l info "-> Cloning CYBORG"
[ ! -d "cyborg" ] && git clone https://github.com/H-ADJI/cyborg
cd cyborg || exit 1
chmod +x install.sh

gum log -l info "Dotfiles and Cyborg Repositories Downloaded"
DISTRO=$(awk '/^ID=/' /etc/*-release | awk -F'=' '{ print tolower($2) }')
gum log -l info "Cyborg Setup For : $DISTRO"
if [ "$DISTRO" = "arch" ]; then
    dir="arch"
else
    dir="ubuntu"
fi
bash "$HOME/cyborg/$dir/setup.sh"
