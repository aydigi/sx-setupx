#!/usr/bin/env bash

# Colors
RED="\033[1;31m"
GREEN="\033[1;32m"
CYAN="\033[1;36m"
YELLOW="\033[1;33m"
MAGENTA="\033[1;35m"
RESET="\033[0m"

echo -e "${CYAN}🚀 Installing Advanced Dev & Cloud CLI Tools...${RESET}\n"

if [[ "$OS" == *"macOS"* ]]; then
    echo -e "${YELLOW}>> Installing via Homebrew (macOS)...${RESET}"
    brew install awscli azure-cli
    brew install --cask google-cloud-sdk visual-studio-code
elif [[ "$OS" == *"Linux"* ]] || [[ "$OS" == *"WSL"* ]]; then
    echo -e "${YELLOW}>> Installing via APT/Curl (Linux)...${RESET}"
    # Azure CLI
    curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
    # AWS CLI
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
    unzip -q awscliv2.zip && sudo ./aws/install && rm -rf awscliv2.zip aws/
elif [[ "$OS" == *"Windows"* ]]; then
    echo -e "${YELLOW}>> Installing via Choco (Windows)...${RESET}"
    powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "choco install awscli azure-cli gcloudsdk vscode -y"
fi

echo -e "\n${YELLOW}>> Installing NPM based CLI tools...${RESET}"
if command -v npm >/dev/null 2>&1; then
    echo -e "${MAGENTA}Installing: Vercel, Netlify, Firebase, Gemini CLI...${RESET}"
    npm install -g vercel netlify-cli firebase-tools gemini-chat-cli
else
    echo -e "${RED}❌ npm is not installed. Run base setup first!${RESET}"
fi

echo -e "\n${GREEN}✨ Advanced CLI tools installation complete!${RESET}"
