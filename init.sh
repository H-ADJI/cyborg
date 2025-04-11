DISTRO=$(awk '/^ID=/' /etc/*-release | awk -F'=' '{ print tolower($2) }')
if [ "$DISTRO" = "arch" ]; then
    sudo pacman -Syu
    toInstall=(
        "base-devel"
        "git"
        "vim"
        "go"
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
git clone --depth 1 https://github.com/H-ADJI/dotfiles
git clone --depth 1 https://github.com/H-ADJI/cyborg
cd cyborg || exit 1
chmod +x install.sh

echo "Dotfiles and Cyborg Repositories Downloaded"
echo "Installation script can be run using : cyborg/install.sh"
