installpackages() {
    while read package; do
        cecho blue "[START] Installing $package"
        sudo nala install -y "$package"
        cecho green "[DONE] Installing $package"
    done <~/cyborg/ubuntu/packages.txt

    cecho blue "[START] INSTALL uv"
    curl -LsSf https://astral.sh/uv/install.sh | sh

    cecho blue "[START] INSTALL rustup"
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

    cecho blue "[START] INSTALL brave"
    curl -fsS https://dl.brave.com/install.sh | sh

    cecho blue "[START] INSTALL starship"
    curl -sS https://starship.rs/install.sh | sh -s -- -y

    cecho blue "[START] INSTALL mako"
    chsh -s "$(which zsh)"
    cecho blue "[START] INSTALL swappy"
    chsh -s "$(which zsh)"
    cecho blue "[START] INSTALL transcrypt"
    chsh -s "$(which zsh)"
    cecho blue "[START] INSTALL fonts"
    chsh -s "$(which zsh)"
    cecho blue "[START] INSTALL brave"
    chsh -s "$(which zsh)"
    cecho blue "[START] INSTALL brave"
    chsh -s "$(which zsh)"
}
install_deb_packages() {
    [ ! -d "Downloads" ] && mkdir -p Downloads && cd Downloads || return 1
    packages=(
        "https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb"
        "https://github.com/fastfetch-cli/fastfetch/releases/download/2.32.1/fastfetch-linux-amd64.deb"
        "https://github.com/dandavison/delta/releases/download/0.18.2/git-delta-musl_0.18.2_amd64.deb"
        "https://github.com/obsidianmd/obsidian-releases/releases/download/v1.7.7/obsidian_1.7.7_amd64.deb"
        "https://downloads.slack-edge.com/desktop-releases/linux/x64/4.41.105/slack-desktop-4.41.105-amd64.deb"
    )
    # Loop through each package URL
    for url in "${packages[@]}"; do
        filename=$(basename "${url%%\?*}") # Handle filenames with query parameters
        if [ ! -f "$filename" ]; then
            cecho blue "Downloading $filename..."
            wget -O "$filename" "$url"
        else
            echo "$filename already exists, skipping download."
        fi
        cecho green "Installing $filename..."
        sudo nala install -y "$filename"
    done
}
install_mako() {
    git clone https://github.com/emersion/mako.git
    cd mako || return 1
    meson build
    ninja -C build
    sudo ninja -C build install
    cd || return 1
}
# main entrypoint
launch_setup() {
    installpackages
}
