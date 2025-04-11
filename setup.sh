#!/bin/bash
# -----------------------------------------------------
# -----------------------------------------------------
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
echo "Cyborg Setup"
echo -e "${NONE}"
echo ""
read -rp "Enter Master Password" pswd
echo "Password is : $pswd "
cloneRepos() {
    git clone --depth 1 https://github.com/H-ADJI/dotfiles
    git clone --depth 1 https://github.com/H-ADJI/cyborg
}
DISTRO=$(awk '/^ID=/' /etc/*-release | awk -F'=' '{ print tolower($2) }')
if [ "$DISTRO" = "arch" ]; then
    sudo pacman -Syu
    toInstall=(
        "base-devel"
        "wget"
        "git"
        "go"
    )
    sudo pacman -S --noconfirm --noprogressbar --needed --disable-download-timeout "${toInstall[@]}"
    cloneRepos
    source ~/cyborg/lib/arch-setup.sh
else
    sudo apt update
    sudo apt upgrade -y
    toInstall=(
        "git"
        "nala"
    )
    sudo apt install -y "${toInstall[@]}"
    cloneRepos
    source ~/cyborg/lib/ubuntu-setup.sh
fi

launch_setup

# -----------------------------------------------------
# -----------------------------------------------------
GREEN='\033[0;32m'
NONE='\033[0m'
# Prompt
echo -e "${GREEN}"
cat <<"EOF"
▗▄▄▄▖▗▖  ▗▖ ▗▄▄▖▗▄▄▄▖▗▄▖ ▗▖   ▗▖    ▗▄▖▗▄▄▄▖▗▄▄▄▖ ▗▄▖ ▗▖  ▗▖    ▗▄▄▄  ▗▄▖ ▗▖  ▗▖▗▄▄▄▖
  █  ▐▛▚▖▐▌▐▌     █ ▐▌ ▐▌▐▌   ▐▌   ▐▌ ▐▌ █    █  ▐▌ ▐▌▐▛▚▖▐▌    ▐▌  █▐▌ ▐▌▐▛▚▖▐▌▐▌
  █  ▐▌ ▝▜▌ ▝▀▚▖  █ ▐▛▀▜▌▐▌   ▐▌   ▐▛▀▜▌ █    █  ▐▌ ▐▌▐▌ ▝▜▌    ▐▌  █▐▌ ▐▌▐▌ ▝▜▌▐▛▀▀▘
▗▄█▄▖▐▌  ▐▌▗▄▄▞▘  █ ▐▌ ▐▌▐▙▄▄▖▐▙▄▄▖▐▌ ▐▌ █  ▗▄█▄▖▝▚▄▞▘▐▌  ▐▌    ▐▙▄▄▀▝▚▄▞▘▐▌  ▐▌▐▙▄▄▖
EOF
echo -e "${NONE}"
