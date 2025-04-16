installpackages() {
    while read package; do
        cecho blue "[START] Installing $package"
        sudo nala install -y "$package"
        cecho green "[DONE] Installing $package"
    done <~/cyborg/ubuntu/packages.txt
}
# main entrypoint
launch_setup() {
    installpackages
}
