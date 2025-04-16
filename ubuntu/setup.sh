installpackages() {
    while read package; do
        cecho blue "[START] Installing $package"
        sudo nala install -y "$package"
        cecho green "[DONE] Installing $package"
    done <~/cyborg/ubuntu/packages.txt
    cecho blue "[START] INSTALL brave"
    chsh -s "$(which zsh)"
    cecho blue "[START] INSTALL mako"
    chsh -s "$(which zsh)"
    cecho blue "[START] INSTALL rustup"
    chsh -s "$(which zsh)"
    cecho blue "[START] INSTALL starship"
    chsh -s "$(which zsh)"
    cecho blue "[START] INSTALL swappy"
    chsh -s "$(which zsh)"
    cecho blue "[START] INSTALL transcrypt"
    chsh -s "$(which zsh)"
    cecho blue "[START] INSTALL fonts"
    chsh -s "$(which zsh)"
    cecho blue "[START] INSTALL uv"
    chsh -s "$(which zsh)"
    cecho blue "[START] INSTALL brave"
    chsh -s "$(which zsh)"
    cecho blue "[START] INSTALL brave"
    chsh -s "$(which zsh)"
    cecho blue "[START] INSTALL brave"
    chsh -s "$(which zsh)"
}
# main entrypoint
launch_setup() {
    installpackages
}
