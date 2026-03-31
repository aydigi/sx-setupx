#!/usr/bin/env bash

# Colors
RED="\033[1;31m"
GREEN="\033[1;32m"
CYAN="\033[1;36m"
YELLOW="\033[1;33m"
MAGENTA="\033[1;35m"
RESET="\033[0m"

echo -e "${CYAN}🐍 Deploying Python Data Science Environment (Miniconda)...${RESET}\n"

if [[ "$OS" == *"macOS"* ]]; then
    echo -e "${YELLOW}>> Installing Miniconda via Homebrew...${RESET}"
    brew install --cask miniconda
    
    # Init conda in standard shells
    INSTALL_DIR="/opt/homebrew/Caskroom/miniconda/base"
    if [ ! -d "$INSTALL_DIR" ]; then 
        INSTALL_DIR="/usr/local/Caskroom/miniconda/base" # Intel mac
    fi
    
    echo -e "${MAGENTA}Initializing conda paths...${RESET}"
    "$INSTALL_DIR/bin/conda" init zsh bash 2>/dev/null

elif [[ "$OS" == *"Linux"* ]] || [[ "$OS" == *"WSL"* ]]; then
    if ! command -v conda >/dev/null 2>&1; then
        echo -e "${YELLOW}>> Fetching official Miniconda3 installer (Linux)...${RESET}"
        curl -repo https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -o miniconda.sh
        bash miniconda.sh -b -p "$HOME/miniconda3"
        rm miniconda.sh
        
        echo -e "${MAGENTA}Initializing conda for bash & zsh...${RESET}"
        "$HOME/miniconda3/bin/conda" init bash zsh 2>/dev/null
    else
        echo -e "${GREEN}✓ Conda is already installed.${RESET}"
    fi

elif [[ "$OS" == *"Windows"* ]]; then
    echo -e "${YELLOW}>> Installing Miniconda3 via Choco (Windows)...${RESET}"
    powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "choco install miniconda3 -y"
fi

echo -e "\n${GREEN}✨ Python Data Science toolchain is fully configured!${RESET}"
echo -e "${CYAN}Note: Please restart your terminal for 'conda' commands to become fully active.${RESET}"
