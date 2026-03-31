#!/usr/bin/env bash

# Colors
RED="\033[1;31m"
GREEN="\033[1;32m"
CYAN="\033[1;36m"
YELLOW="\033[1;33m"
MAGENTA="\033[1;35m"
RESET="\033[0m"

echo -e "${CYAN}🚀 Starting Base setupx CLI Setup...${RESET}\n"

if [[ "$OS" == *"macOS"* ]]; then
    echo -e "${YELLOW}>> Installing Homebrew (macOS)...${RESET}"
    if ! command -v brew >/dev/null 2>&1; then
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        if [ -x "/opt/homebrew/bin/brew" ]; then
            eval "$(/opt/homebrew/bin/brew shellenv)"
        elif [ -x "/usr/local/bin/brew" ]; then
            eval "$(/usr/local/bin/brew shellenv)"
        fi
    else
        echo -e "${GREEN}✓ Homebrew is already installed.${RESET}"
    fi
    echo -e "${YELLOW}>> Installing Node, Python, Git, and GitHub CLI...${RESET}"
    brew install node yarn python git gh
    
elif [[ "$OS" == *"Linux"* ]] || [[ "$OS" == *"WSL"* ]]; then
    echo -e "${YELLOW}>> Installing APT Packages (Linux/WSL)...${RESET}"
    sudo apt update
    sudo apt install -y curl wget software-properties-common git python3 python3-pip
    sudo apt install -y gh || echo "Note: 'gh' might require adding the GitHub repo on older Debian/Ubuntu."
    
    echo -e "${YELLOW}>> Installing Node.js & Yarn...${RESET}"
    curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
    sudo apt install -y nodejs
    sudo npm install -g yarn

elif [[ "$OS" == *"Windows"* ]]; then
    echo -e "${YELLOW}>> Installing Package Managers (Windows)...${RESET}"
    echo -e "${MAGENTA}* This requires Admin privileges. A PowerShell window may pop up.*${RESET}"
    
    # Install Scoop & Choco
    powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "Invoke-RestMethod -Uri https://get.scoop.sh | Invoke-Expression"
    powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))"
    
    echo -e "${YELLOW}>> Installing Packages via Choco...${RESET}"
    powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "choco install nodejs yarn python git gh -y"
fi

echo -e "\n${GREEN}✨ Base Setup Complete!${RESET}"
