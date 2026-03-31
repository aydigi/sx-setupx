#!/usr/bin/env bash

# Colors
GREEN="\033[1;32m"
CYAN="\033[1;36m"
YELLOW="\033[1;33m"
RESET="\033[0m"

echo -e "${CYAN}🚀 Executing Global Mega-Installation (All Components)...${RESET}\n"

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

echo -e "${YELLOW}Stage 1: Base Platform Tools${RESET}"
source "$DIR/install-base.sh"

echo -e "${YELLOW}Stage 2: Cloud CLIs & NPM Packages${RESET}"
source "$DIR/install-cli.sh"

echo -e "${YELLOW}Stage 3: Flutter Environment${RESET}"
source "$DIR/install-flutter.sh"

echo -e "${YELLOW}Stage 4: React Native SDK${RESET}"
source "$DIR/install-react-native.sh"

echo -e "${YELLOW}Stage 5: Heavy DevTools (Chrome, VSCode, Studio)${RESET}"
source "$DIR/install-devtools.sh"

echo -e "${YELLOW}Stage 6: DevOps Infrastructure (Docker, K8s)${RESET}"
source "$DIR/install-devops.sh"

echo -e "${YELLOW}Stage 7: Data Science Ecosystem (Miniconda)${RESET}"
source "$DIR/install-conda.sh"

echo -e "\n${GREEN}✨ ALL Components Installed and Configured Successfully!${RESET}"
