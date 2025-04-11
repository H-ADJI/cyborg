#!/bin/bash
# -----------------------------------------------------
# -----------------------------------------------------
GREEN='\033[0;32m'
NONE='\033[0m'
# Prompt
echo -e "${GREEN}"
cat <<"EOF"
   ____         __       ____
  /  _/__  ___ / /____ _/ / /__ ____
 _/ // _ \(_-</ __/ _ `/ / / -_) __/
/___/_//_/___/\__/\_,_/_/_/\__/_/
EOF
echo "Cyborg Setup"
echo -e "${NONE}"
echo ""
read -rp "Enter Master Password : " pswd
echo ""

DISTRO=$(awk '/^ID=/' /etc/*-release | awk -F'=' '{ print tolower($2) }')
if [ "$DISTRO" = "arch" ]; then
    source ~/cyborg/lib/arch-setup.sh
else
    source ~/cyborg/lib/ubuntu-setup.sh
fi

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
