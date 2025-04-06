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
# Create download_folder if not exists
if [ ! -d "$download_folder" ]; then
    mkdir -p "$download_folder"
fi
# -----------------------------------------------------
# Lib Folder
# -----------------------------------------------------
lib_folder="$download_folder/cyborg/lib"
# -----------------------------------------------------
# System update and basic utilities
# -----------------------------------------------------
sudo pacman -Sy
# Check if package is installed
_isInstalled() {
    package="$1"
    check="$(sudo pacman -Qs --color always "${package}" | grep "local" | grep "${package} ")"
    if [ -n "${check}" ]; then
        echo 0 #'0' means 'true' in Bash
        return #true
    fi
    echo 1 #'1' means 'false' in Bash
    return #false
}

# Install packages
_installPackages() {
    toInstall=()
    for pkg; do
        if [[ $(_isInstalled "${pkg}") == 0 ]]; then
            echo ":: ${pkg} is already installed."
            continue
        fi
        toInstall+=("${pkg}")
    done
    if [[ "${toInstall[*]}" == "" ]]; then
        return
    fi
    printf "Package not installed:\n%s\n" "${toInstall[@]}"
    sudo pacman --noconfirm -S "${toInstall[@]}"
}

_installYay() {
    _installPackages "base-devel"
    _installPackages "git"
    _installPackages "go"
    git clone https://aur.archlinux.org/yay.git "$download_folder/yay"
    cd "$download_folder/yay" || return 1
    makepkg -si --noconfirm
    cd "$download_folder" || return 1
}
_installYay
