cloneRepos() {
    git clone --depth 1 https://github.com/H-ADJI/dotfiles
    git clone --depth 1 https://github.com/H-ADJI/cyborg
}
cd cyborg || return 1
chmod +x install.sh

NONE='\033[0m'
echo -e "${GREEN}"
echo "Dotfiles and Cyborg Repositories Downloaded"
echo "installation script can be run using : ./install.sh"
echo -e "${NONE}"
