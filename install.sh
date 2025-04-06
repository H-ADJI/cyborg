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
# Check if command exists
_checkCommandExists() {
    package="$1"
    if ! command -v "$package" >/dev/null; then
        return 1
    else
        return 0
    fi
}

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
    git clone git clone --depth 1 --branch next https://aur.archlinux.org/yay.git "$download_folder/yay"
    cd "$download_folder/yay" || return 1
    makepkg -si --noconfirm
    cd "$download_folder" || return 1
}
# -----------------------------------------------------
# System update and basic utilities
# -----------------------------------------------------
# Required packages for the installer
packages=(
    "base-devel"
    "wget"
    "gum"
    "git"
    "go"
)
# Some colors
GREEN='\033[0;32m'
NONE='\033[0m'
# Prompt
echo -e "${GREEN}"
cat <<"EOF"
   ____         __       ____
  /  _/__  ___ / /____ _/ / /__ ____
 _/ // _ \(_-</ __/ _ `/ / / -_) __/
/___/_//_/___/\__/\_,_/_/_/\__/_/
EOF
echo "Cyborg Arch Setup"
echo -e "${NONE}"

while true; do
    read "DO YOU WANT TO START THE INSTALLATION NOW? (Yy/Nn): " yn
    case $yn in
        [Yy]*)
            echo ":: Installation started."
            echo
            break
            ;;
        [Nn]*)
            echo ":: Installation canceled"
            exit
            ;;
        *)
            echo ":: Please answer yes or no."
            ;;
    esac
done

sudo pacman -Sy
# Install required packages
echo ":: Checking that required packages are installed..."
_installPackages "${packages[@]}"

# Install yay if needed
if _checkCommandExists "yay"; then
    echo ":: yay is already installed"
else
    echo ":: The installer requires yay. yay will be installed now"
    _installYay
fi
echo
