#!/usr/bin/env bash

# Colors
RED="\033[1;31m"
GREEN="\033[1;32m"
CYAN="\033[1;36m"
YELLOW="\033[1;33m"
MAGENTA="\033[1;35m"
RESET="\033[0m"

echo -e "${CYAN}🚀 Installing React Native Development Environment...${RESET}\n"

# Check Node
if ! command -v node >/dev/null 2>&1; then
    echo -e "${RED}>> Node.js is required but not found. Please run the base setup first!${RESET}"
    exit 1
fi

if [[ "$OS" == *"macOS"* ]]; then
    echo -e "${YELLOW}>> Installing macOS dependencies via Homebrew...${RESET}"
    
    # Install Watchman
    echo -e "${MAGENTA}>> Installing Watchman (Require for RN hot reload)...${RESET}"
    brew install watchman
    
    # Install Cocoapods
    echo -e "${MAGENTA}>> Installing Cocoapods (Required for iOS)...${RESET}"
    brew install cocoapods
    
    # Install Zulu JDK for Android Emulator support
    echo -e "${MAGENTA}>> Installing Azul Zulu JDK 17 (Required for Android)...${RESET}"
    brew tap homebrew/cask-versions 2>/dev/null
    brew install --cask zulu17
    
elif [[ "$OS" == *"Linux"* ]] || [[ "$OS" == *"WSL"* ]]; then
    echo -e "${YELLOW}>> Installing Linux dependencies...${RESET}"
    sudo apt update
    sudo apt install -y openjdk-17-jdk watchman
elif [[ "$OS" == *"Windows"* ]]; then
    echo -e "${YELLOW}>> Installing Windows dependencies via Choco...${RESET}"
    powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "choco install openjdk17 zulu17"
fi

echo -e "${YELLOW}>> Installing React Native / Expo CLI...${RESET}"
# Recommend using `npx react-native` but we can install the raw cli and expo
npm install -g react-native-cli expo-cli

echo -e "\n${GREEN}✨ React Native Environment Setup Complete!${RESET}"
echo -e "${CYAN}Note: For Android support, please install Android Studio manually and configure the Android SDK.${RESET}"
if [[ "$OS" == *"macOS"* ]]; then
    echo -e "${CYAN}Note: For iOS support, ensure Xcode is installed from the Mac App Store.${RESET}"
fi
