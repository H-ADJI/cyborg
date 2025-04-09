_checkCommandExists() {
    package="$1"
    if ! command -v "$package" >/dev/null; then
        return 1
    else
        return 0
    fi
}
_installYay() {
    git clone --depth 1 https://aur.archlinux.org/yay.git
    cd "yay" || return 1
    makepkg -si --noconfirm
    cd || return 1
}

install_AUR_helper() {
    if _checkCommandExists "yay"; then
        echo ":: yay is already installed"
    else
        echo ":: The installer requires yay. yay will be installed now"
        _installYay
    fi
}
installpackages() {
    yay -S --noconfirm --noprogressbar --needed --disable-download-timeout $(<~/cyborg/lib/arch-packages.txt)
}
dotfiles() {
    echo
}
# main entrypoint
launch_setup() {
    install_AUR_helper
    installpackages
}
