#!/bin/bash
# -----------------------------------------------------
# -----------------------------------------------------
GREEN='\033[0;32m'
NONE='\033[0m'
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
# Prompt
echo -e "${GREEN}"
DISTRO=$(awk '/^ID=/' /etc/*-release | awk -F'=' '{ print tolower($2) }')
cat <<"EOF"
   ____         __       ____
  /  _/__  ___ / /____ _/ / /__ ____
 _/ // _ \(_-</ __/ _ `/ / / -_) __/
/___/_//_/___/\__/\_,_/_/_/\__/_/
EOF
cecho blue "Cyborg Setup For : $DISTRO"
echo -e "${NONE}"
echo ""
export pswd
read -rp "Enter Master Password : " pswd
echo ""
if [ "$DISTRO" = "arch" ]; then
    dir="arch"
else
    dir="ubuntu"
fi
source "$HOME/cyborg/$dir/setup.sh"

launch_setup

# -----------------------------------------------------
# -----------------------------------------------------
GREEN='\033[0;32m'
NONE='\033[0m'
# Prompt
echo -e "${GREEN}"
cat <<"EOF"
    ____
   / __ \____  ____  ___
  / / / / __ \/ __ \/ _ \
 / /_/ / /_/ / / / /  __/
/_____/\____/_/ /_/\___/

Reboot Your system to apply all changes
EOF
echo -e "${NONE}"
