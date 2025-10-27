#!/bin/bash
# -----------------------------------------------------
# -----------------------------------------------------
GREEN='\033[0;32m'
NONE='\033[0m'

# Prompt
echo -e "${GREEN}"
DISTRO=$(awk '/^ID=/' /etc/*-release | awk -F'=' '{ print tolower($2) }')
cat <<"EOF"
   ____         __       ____
  /  _/__  ___ / /____ _/ / /__ ____
 _/ // _ \(_-</ __/ _ `/ / / -_) __/
/___/_//_/___/\__/\_,_/_/_/\__/_/
EOF
gum log -l info "Cyborg Setup For : $DISTRO"
if [ "$DISTRO" = "arch" ]; then
    dir="arch"
else
    dir="ubuntu"
fi
bash "$HOME/cyborg/$dir/setup.sh"

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
