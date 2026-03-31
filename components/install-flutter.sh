#!/usr/bin/env bash

# Colors
RED="\033[1;31m"
GREEN="\033[1;32m"
CYAN="\033[1;36m"
YELLOW="\033[1;33m"
MAGENTA="\033[1;35m"
RESET="\033[0m"

echo -e "${CYAN}🚀 Installing Flutter SDK...${RESET}\n"

INSTALL_DIR="$HOME/flutter"

if [ -d "$INSTALL_DIR" ]; then
    echo -e "${YELLOW}>> Flutter is already installed at $INSTALL_DIR${RESET}"
    echo -e "${YELLOW}>> Updating Flutter...${RESET}"
    cd "$INSTALL_DIR" || exit 1
    git stash
    git checkout stable
    git pull origin stable
else
    echo -e "${YELLOW}>> Cloning Flutter stable channel to $INSTALL_DIR...${RESET}"
    git clone https://github.com/flutter/flutter.git -b stable "$INSTALL_DIR"
fi

# Determine shell config file
SHELL_CONFIG="$HOME/.zshrc"
if [[ "$SHELL" == *"bash"* ]]; then
    SHELL_CONFIG="$HOME/.bashrc"
fi

# Add to PATH if not already present
if ! grep -q "$INSTALL_DIR/bin" "$SHELL_CONFIG" 2>/dev/null; then
    echo -e "${MAGENTA}>> Adding Flutter to PATH in $SHELL_CONFIG...${RESET}"
    echo -e "\n# Flutter SDK\nexport PATH=\"\$PATH:$INSTALL_DIR/bin\"" >> "$SHELL_CONFIG"
    export PATH="$PATH:$INSTALL_DIR/bin"
else
    echo -e "${GREEN}✓ Flutter is already in PATH.${RESET}"
    export PATH="$PATH:$INSTALL_DIR/bin"
fi

echo -e "${YELLOW}>> Pre-caching Flutter & Running Doctor...${RESET}"
echo -e "${MAGENTA}* This may take a few minutes to download SDK files *${RESET}"
flutter precache
flutter doctor

echo -e "\n${GREEN}✨ Flutter Setup Complete!${RESET}"
echo -e "${CYAN}Please run: ${BOLD}source $SHELL_CONFIG${RESET}${CYAN} or restart your terminal to activate.${RESET}"
