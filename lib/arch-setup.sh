# -----------------------------------------------------
# Download Folder
# -----------------------------------------------------
download_folder="$HOME/.cyborg"
mkdir -p "$download_folder"
if [ ! -d "$download_folder" ]; then
    mkdir -p "$download_folder"
fi
_checkCommandExists() {
    package="$1"
    if ! command -v "$package" >/dev/null; then
        return 1
    else
        return 0
    fi
}
_installYay() {
    git clone git clone --depth 1 --branch next https://aur.archlinux.org/yay.git "$download_folder"
    cd "$download_folder/yay" || return 1
    makepkg -si --noconfirm
    cd "$download_folder" || return 1
}

installPackageManager() {
    if _checkCommandExists "yay"; then
        echo ":: yay is already installed"
    else
        echo ":: The installer requires yay. yay will be installed now"
        _installYay
    fi
}
installpackages() {
    yay -S --noconfirm --noprogressbar --needed --disable-download-timeout $(<arch-packages.txt)
}
# main entrypoint
launch_setup() {
    installPackageManager
}
