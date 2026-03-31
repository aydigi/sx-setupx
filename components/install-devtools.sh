#!/usr/bin/env bash

# Colors
RED="\033[1;31m"
GREEN="\033[1;32m"
CYAN="\033[1;36m"
YELLOW="\033[1;33m"
MAGENTA="\033[1;35m"
RESET="\033[0m"

echo -e "${CYAN}🚀 Installing Mega Developer SDK & Heavy Apps...${RESET}\n"

# 1. Essential Core CLI Checks (GH, Git)
echo -e "${YELLOW}>> Checking core CLIs (Git, GH)...${RESET}"
for tool in git gh; do
    if ! command -v $tool >/dev/null 2>&1; then
        echo -e "${RED}❌ $tool is missing. Please run the base setup first (chat: 'install apps').${RESET}"
    else
        echo -e "${GREEN}✓ $tool is already installed.${RESET}"
    fi
done

# 2. OS Specific Heavy UI Installations
if [[ "$OS" == *"macOS"* ]]; then
    echo -e "${YELLOW}>> Checking Xcode Command Line Tools...${RESET}"
    if ! xcode-select -p >/dev/null 2>&1; then
        echo -e "${MAGENTA}>> Installing Xcode Command Line Tools...${RESET}"
        xcode-select --install
    else
        echo -e "${GREEN}✓ Xcode Tools are installed.${RESET}"
    fi

    echo -e "${YELLOW}>> Installing Heavy Editor SDKs via Homebrew...${RESET}"
    echo -e "${MAGENTA}Installing: Android Studio, VS Code, Google Chrome, ChatGPT Desktop${RESET}"
    brew install --cask android-studio
    brew install --cask visual-studio-code
    brew install --cask google-chrome
    brew install --cask chatgpt

elif [[ "$OS" == *"Linux"* ]] || [[ "$OS" == *"WSL"* ]]; then
    echo -e "${YELLOW}>> Installing via Snap (Linux/WSL)...${RESET}"
    if command -v snap >/dev/null 2>&1; then
        sudo snap install android-studio --classic
        sudo snap install code --classic
    else
        echo -e "${RED}>> Snap is missing. Falling back to APT...${RESET}"
        sudo apt update
        sudo apt install -y android-studio code || echo "Warning: Standard apt repos might not contain android-studio."
    fi

elif [[ "$OS" == *"Windows"* ]]; then
    echo -e "${YELLOW}>> Installing Heavy Editor SDKs via Choco...${RESET}"
    powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "choco install androidstudio vscode googlechrome -y"
fi

echo -e "\n${GREEN}✨ Full DevTools Suite Setup Complete!${RESET}"
echo -e "${CYAN}Note: Depending on your system, you might need to launch Android Studio once to download the Android SDK properly.${RESET}"
