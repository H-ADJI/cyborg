#!/bin/bash
_checkCommandExists() {
    package="$1"
    if ! command -v "$package" >/dev/null; then
        return 1
    else
        return 0
    fi
}
_installYay() {
    [ ! -d "yay" ] && git clone --depth 1 https://aur.archlinux.org/yay.git
    cd "yay" || return 1
    makepkg -si --noconfirm
    cd || return 1
}
install_AUR_helper() {
    if _checkCommandExists "yay"; then
        cecho blue ":: yay is already installed"
    else
        cecho green ":: The installer requires yay. yay will be installed now"
        _installYay
    fi
}
installpackages() {
    while read package; do
        cecho blue "[START] Installing $package"
        yay -Sq --noconfirm --noprogressbar --needed --disable-download-timeout "$package"
        cecho green "[DONE] Installing $package"
    done <~/cyborg/arch/packages.txt
}
post_install() {
    cecho blue "[START] Copy greetd config / sessions"
    sudo cp -r ~/dotfiles/greetd/ /etc
    cecho green "[DONE] Copy greetd config / sessions"

    cecho blue "[START] Change shell to use ZSH"
    chsh -s "$(which zsh)"
    cecho green "[DONE] Change shell to use ZSH"

    cecho blue "[START] Chosing stable rust toolchain release"
    rustup default stable
    cecho green "[DONE] Chosing stable rust toolchain release"

    cecho blue "[START] installing multiple uv python versions"
    py_versions=(
        "3.12"
        "3.11"
        "3.10"
        "3.9"
    )
    uv python install "${py_versions[@]}"
    cecho green "[DONE] Installing multiple uv python versions"

    cecho blue "[START] Copying assets"
    cp -r ~/dotfiles/assets ~/.config/
    cecho green "[DONE] Copying assets"

    cecho blue "[START] Installing TPM"
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
    cecho green "[DONE] Installing TPM"

    cecho blue "[START] Installing spicetify"
    # TODO: fix spotify install
    sudo chmod a+wr /opt/spotify
    sudo chmod a+wr /opt/spotify/Apps -R
    curl -fsSL https://raw.githubusercontent.com/spicetify/cli/main/install.sh | sh
    curl -fsSL https://raw.githubusercontent.com/spicetify/marketplace/main/resources/install.sh | sh
    cecho green "[DONE] Installing spicetify"

    cecho blue "[START] transcrypt decryption"
    decrypt_secrets
    cecho green "[DONE] transcrypt decryption"

    cecho blue "[START] Linking dots"
    link_dotfiles
    cecho green "[DONE] Linking dots"

    cecho blue "[START] install tmux plugins"
    sh ~/.tmux/plugins/tpm/bin/install_plugins
    cecho blue "[DONE] install tmux plugins"

    cecho blue "[START] link tmuxifier layouts"
    cd ~/dotfiles/ || return 1
    stow tmuxifier
    cd || return 1
    cecho green "[DONE] link tmuxifier layouts"

    cecho blue "[START] ssh setup"
    ssh_setup
    cecho green "[DONE] ssh setup"

    cecho blue "[START] docker post install steps"
    docker_post_install
    cecho green "[DONE] docker post install steps"

    cecho blue "[START] Clone some repos"
    personal_repos
    cecho green "[DONE] Clone some repos"

    cecho blue "[START] Set timezone"
    sudo timedatectl set-timezone Europe/Paris
    cecho green "[DONE] Set timezone"

    cecho blue "[START] Enable docker service"
    sudo systemctl enable docker.service
    cecho green "[DONE] Enable docker service"

    cecho blue "[START] Enable NetworkManager service"
    sudo systemctl enable NetworkManager.service
    cecho green "[DONE] Enable NetworkManager service"

    cecho blue "[START] Enable bluetooth service"
    sudo systemctl enable bluetooth.service
    cecho green "[DONE] Enable bluetooth service"

    cecho blue "[START] Enable greetd display manager service"
    sudo systemctl enable greetd.service -f
    cecho green "[DONE] Enable greetd display manager service"

    cecho blue "[START] Default apps"
    xdg-mime default mupdf.desktop application/pdf
    # xdg-mime default feh.desktop image/png
    xdg-mime default imv.desktop image/jpg
    # xdg-mime default gthumb.desktop image/png
    xdg-mime default brave-browser.desktop text/plain
    xdg-mime default brave-browser.desktop application/octet-stream
    cecho green "[DONE] Default apps"
}
decrypt_secrets() {
    cd ~/dotfiles/ || return 1
    VERIFY=1
    STORED_HASH=$(cat lock.secure)
    while true; do
        MASTER_PASSWORD=$(
            gum input --prompt "Master Password> " --password
        )
        COMPUTED_HASH=$(echo -n "$MASTER_PASSWORD" | argon2 "08061999" -r)
        if [ "$VERIFY" -eq 0 ]; then
            break
        fi
        if [ "$COMPUTED_HASH" = "$STORED_HASH" ]; then
            gum log -l info "✅ Correct password"
            break
        else
            gum log -l error "❌ Wrong password, try again"
        fi
    done
    transcrypt -y -p "$MASTER_PASSWORD"
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
        "gtklock"
        "mako"
        "starship"
        "gtk-3.0"
        "sway"
        "waybar"
        "cava"
        "direnv"
        "fuzzel"
        "zellij"
        "leetcode"
        "ruff"
        "ssh"
        "tmux"
        "wofi"
        "fastfetch"
        "systemd"
    )
    stow --adopt "${dotfiles[@]}"
    cd || return 1
}
docker_post_install() {
    sudo groupadd docker
    sudo usermod -aG docker "$USER"
}
ssh_setup() {
    local ssh_private_key="$HOME/.ssh/ssh_git"
    eval "$(ssh-agent -s)"
    chmod 600 "$ssh_private_key"
    ssh-add "$ssh_private_key"

}
personal_repos() {
    projects=(
        "neurogenesis"
        "secondBrain"
        "dicli"
        "presentations"
        ".dotfiles"
    )
    for PROJECT in "${projects[@]}"; do
        [ ! -d "$PROJECT" ] && git clone "git@github.com:H-ADJI/$PROJECT.git"
    done
    cd ~/dotfiles/ || return 1
    git remote remove origin
    git remote add origin git@github.com:H-ADJI/dotfiles.git
    cd ~/cyborg/ || return 1
    git remote remove origin
    git remote add origin git@github.com:H-ADJI/cyborg.git
    cd || exit 1
}

# main entrypoint
launch_setup() {
    install_AUR_helper
    installpackages
    post_install
}
