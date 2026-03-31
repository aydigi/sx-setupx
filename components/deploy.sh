#!/usr/bin/env bash

# Colors
RED="\033[1;31m"
GREEN="\033[1;32m"
CYAN="\033[1;36m"
YELLOW="\033[1;33m"
MAGENTA="\033[1;35m"
RESET="\033[0m"

TARGET="$1"

if [[ "$TARGET" == "vercel" ]]; then
    echo -e "${CYAN}🚀 Executing Production Deployment to Vercel...${RESET}\n"
    if ! command -v vercel >/dev/null 2>&1; then
        echo -e "${RED}❌ Vercel CLI is not installed. Please run './sx.sh --install-cli' first.${RESET}"
        exit 1
    fi
    npx vercel --prod

elif [[ "$TARGET" == "firebase" ]]; then
    echo -e "${CYAN}🔥 Executing Firebase Application Deployment...${RESET}\n"
    if ! command -v firebase >/dev/null 2>&1; then
        echo -e "${RED}❌ Firebase CLI is not installed. Please run './sx.sh --install-cli' first.${RESET}"
        exit 1
    fi
    npx firebase deploy

else
    echo -e "${RED}❌ Unknown deployment target. Use '--deploy-vercel' or '--deploy-firebase'.${RESET}"
    exit 1
fi

echo -e "\n${GREEN}✨ Deployment operation completed on $TARGET!${RESET}"
