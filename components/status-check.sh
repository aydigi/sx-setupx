#!/usr/bin/env bash

# Colors
GREEN="\033[1;32m"
YELLOW="\033[1;33m"
MAGENTA="\033[1;35m"
RESET="\033[0m"

echo -e "${YELLOW}>> Automated Component Status Check...${RESET}"

# Group 1: Package Managers
printf "${MAGENTA}📦 Package Managers: ${RESET}"
for pkg in brew apt scoop choco npm yarn; do
    if command -v $pkg >/dev/null 2>&1; then
        version=$($pkg --version 2>/dev/null | head -n 1 | grep -oE 'v?[0-9]+\.[0-9]+(\.[0-9]+)?' | head -n 1)
        [ -z "$version" ] && version="Installed"
        printf " ${GREEN}✅ %s${RESET}(%s)" "$pkg" "$version"
    fi
done
echo ""

# Group 2: CLI Tools
printf "${MAGENTA}🛠️  CLI Tools:        ${RESET}"
for tool in node git gh python3; do
    if command -v $tool >/dev/null 2>&1; then
        version=$($tool --version 2>/dev/null | head -n 1 | grep -oE 'v?[0-9]+\.[0-9]+(\.[0-9]+)?' | head -n 1)
        [ -z "$version" ] && version="Installed"
        printf " ${GREEN}✅ %s${RESET}(%s)" "$tool" "$version"
    fi
done
echo ""

# Group 3: Cloud & AI SDKs
printf "${MAGENTA}☁️  Cloud & AI Tools: ${RESET}"
for tool in aws az gcloud vercel netlify firebase gemini-chat-cli; do
    if command -v $tool >/dev/null 2>&1; then
        # Just print installed without version extraction to keep it fast
        printf " ${GREEN}✅ %s${RESET}" "$tool"
    fi
done
echo ""

# Group 4: Mobile & DevTools
printf "${MAGENTA}📱 Mobile & DevTools:${RESET}"
for tool in flutter react-native watchman code studio google-chrome chatgpt; do
    # Heavy Mac OS applications might not be immediately in PATH under these names
    tool_check="$tool"
    if [[ "$tool" == "studio" ]] && [ -d "/Applications/Android Studio.app" ]; then
        printf " ${GREEN}✅ Android Studio${RESET}"
        continue
    elif [[ "$tool" == "google-chrome" ]] && [ -d "/Applications/Google Chrome.app" ]; then
        printf " ${GREEN}✅ Chrome${RESET}"
        continue
    elif [[ "$tool" == "chatgpt" ]] && [ -d "/Applications/ChatGPT.app" ]; then
        printf " ${GREEN}✅ ChatGPT${RESET}"
        continue
    fi
    
    if command -v $tool_check >/dev/null 2>&1; then
        printf " ${GREEN}✅ %s${RESET}" "$tool"
    fi
done
echo -e "\n"
