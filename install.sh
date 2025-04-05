#!/bin/bash
clear

# -----------------------------------------------------
# Repositories
# -----------------------------------------------------
dotfiles_repo="H-ADJI/dotfiles"
setup_repo="H-ADJI/cyborg"
# -----------------------------------------------------
# Download Folder
# -----------------------------------------------------
download_folder="$HOME/.cyborg"
mkdir -p "$download_folder"
_workdir() {
    cd "$download_folder" || return 1
}
# -----------------------------------------------------
# Lib Folder
# -----------------------------------------------------
lib_folder="$download_folder/cyborg/lib"
# -----------------------------------------------------
# System update and basic utilities
# -----------------------------------------------------
_workdir
sudo pacman -Syu --noconfirm
sudo pacman -S ---noconfirm -needed curl git base-devel
git clone https://aur.archlinux.org/yay-bin.git "$download_folder"
cd "${download_folder}/yay-bin" || return 1
makepkg -si --noconfirm
