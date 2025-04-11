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
post_install() {
    echo "Change shell to use ZSH"
    chsh -s "$(which zsh)"

    echo "Chosing stable rust toolchain release"
    rustup default stable

    echo "Installing multiple uv python versions"
    py_versions=(
        "3.12"
        "3.11"
        "3.10"
        "3.9"
        "3.8"
        "3.7"
    )
    uv python install "${py_versions[@]}"

    echo "Installing TPM"
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

    echo "transcrypt decryption"
    decrypt_secrets

    echo "Linking dots"
    link_dotfiles

    echo "install tmux plugins"
    sh ~/.tmux/plugins/tpm/bin/install_plugins

    echo "link tmuxifier layouts"
    cd ~/dotfiles/ || return 1
    stow tmuxifier
    cd || return 1
}
decrypt_secrets() {
    cd ~/dotfiles/ || return 1
    transcrypt -y -p "$pswd"
    cd || return 1
}

link_dotfiles() {
    cd ~/dotfiles/ || return 1
    dotfiles=(
        "nvim"
        "alacritty"
        "kitty"
        "zsh"
        "bin"
        "fnott"
        "git"
        "nwg-look"
        "nwg-drawer"
        "starship"
        "swaylock"
        "waybar"
        "assets"
        "cava"
        "direnv"
        "fuzzel"
        "zellij"
        "leetcode"
        "ruff"
        "ssh"
        "tmux"
        "wofi"
    )
    stow "${dotfiles[@]}"
    cd || return 1
}

# main entrypoint
launch_setup() {
    install_AUR_helper
    installpackages
    post_install
}
