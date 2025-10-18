# colored echo
cecho() {
    local color=$1
    shift
    echo
    case $color in
        red) echo -e "\033[0;31m$*\033[0m" ;;
        green) echo -e "\033[0;32m$*\033[0m" ;;
        yellow) echo -e "\033[1;33m$*\033[0m" ;;
        blue) echo -e "\033[0;34m$*\033[0m" ;;
        *) echo "$*" ;;
    esac
    echo
}

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
cecho green "Cloning setup repos"
cecho blue "-> Cloning DOTFILES"
[ ! -d "dotfiles" ] && git clone https://github.com/H-ADJI/dotfiles
cecho blue "-> Cloning CYBORG"
[ ! -d "cyborg" ] && git clone https://github.com/H-ADJI/cyborg
cd cyborg || exit 1
chmod +x install.sh

cecho green "Dotfiles and Cyborg Repositories Downloaded"
cecho blue "Installation script can be run using : cyborg/install.sh"
exec install.sh
