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
    if ! command -v firebase >/dev/null 2>&1 && ! command -v npx >/dev/null 2>&1; then
        echo -e "${RED}❌ Firebase CLI and npx are not installed. Please run './sx.sh --install-cli' or install Node.js first.${RESET}"
        exit 1
    fi
    
    export XDG_CONFIG_HOME="$PWD/.firebase_config"

    # Ensure Firebase project is setup
    if grep -q "YOUR_FIREBASE_PROJECT_ID" .firebaserc 2>/dev/null; then
        echo -e "${YELLOW}⚠️  Firebase Project ID is not yet configured!${RESET}"
        echo -n -e "${CYAN}Enter your Firebase Project ID (or press enter to skip if you want to test): ${RESET}"
        read -r fb_project
        if [[ -n "$fb_project" ]]; then
            # Replace placeholder for Mac (sed -i '') and Linux (sed -i)
            sed -i '' "s/YOUR_FIREBASE_PROJECT_ID/$fb_project/g" .firebaserc 2>/dev/null || sed -i "s/YOUR_FIREBASE_PROJECT_ID/$fb_project/g" .firebaserc 2>/dev/null
            echo -e "${GREEN}✅ Configured .firebaserc with project ID: $fb_project${RESET}"
        fi
    fi

    echo -e "${CYAN}Checking Firebase authentication...${RESET}"
    if ! npx firebase projects:list >/dev/null 2>&1; then
        echo -e "${YELLOW}⚠️  You are not logged in. Initiating Firebase login...${RESET}"
        npx firebase login --no-localhost
        if [ $? -ne 0 ]; then
            echo -e "${RED}❌ Firebase login failed or was aborted!${RESET}"
            exit 1
        fi
    fi

    echo -e "${CYAN}Deploying to Firebase Hosting...${RESET}"
    npx firebase deploy

else
    echo -e "${RED}❌ Unknown deployment target. Use '--deploy-vercel' or '--deploy-firebase'.${RESET}"
    exit 1
fi

echo -e "\n${GREEN}✨ Deployment operation completed on $TARGET!${RESET}"
