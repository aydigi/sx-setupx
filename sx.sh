#!/usr/bin/env bash

# ==============================
# setupx CLI - SYSTEM INFO
# ==============================

# Colors
RED="\033[1;31m"
GREEN="\033[1;32m"
CYAN="\033[1;36m"
YELLOW="\033[1;33m"
BLUE="\033[1;34m"
MAGENTA="\033[1;35m"
RESET="\033[0m"
BOLD="\033[1m"

# ==============================
# OS DETECTION (Required First)
# ==============================
OS="Unknown"
KERNEL=$(uname -r 2>/dev/null)
ARCH=$(uname -m 2>/dev/null)
OS_ICON="🖥️ "

case "$(uname -s 2>/dev/null)" in
    Linux*) 
        OS="Linux"
        OS_ICON="🐧"
        if [ -f /etc/os-release ]; then
            . /etc/os-release
            OS="${NAME} ${VERSION_ID:-}"
        fi
        ;;
    Darwin*) 
        OS="macOS"
        OS_ICON="🍎"
        ;;
    CYGWIN*|MINGW*|MSYS*) 
        OS="Windows"
        OS_ICON="🪟"
        ;;
    *) 
        OS="Unknown" 
        OS_ICON="🖥️"
        ;;
esac

# Detect WSL
if grep -qi microsoft /proc/version 2>/dev/null; then
    OS="WSL (Windows Subsystem for Linux)"
    OS_ICON="🪟 "
fi

# ==============================
# ==============================
# INSTALL & SETUP MODE
# ==============================
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

if [[ "$1" == "--setup" ]]; then
    source "$DIR/components/install-base.sh"
    exit 0
elif [[ "$1" == "--chat" ]]; then
    if command -v node >/dev/null 2>&1; then
        exec node "$DIR/sx-chat.js"
    else
        echo -e "${RED}Node.js is not installed! Run './sx.sh --setup' to automatically install Node, then try again.${RESET}"
    fi
    exit 0
elif [[ "$1" == "--install-cli" ]]; then
    source "$DIR/components/install-cli.sh"
    exit 0
elif [[ "$1" == "--install-flutter" ]]; then
    source "$DIR/components/install-flutter.sh"
    exit 0
elif [[ "$1" == "--install-react-native" ]]; then
    source "$DIR/components/install-react-native.sh"
    exit 0
fi

# ==============================
# SYSTEM INFO FETCHING
# ==============================

# Detect Shell
SHELL_NAME=$(basename "$SHELL")

# User & Host
USER_NAME=$(whoami 2>/dev/null)
HOST_NAME=$(hostname -s 2>/dev/null || hostname 2>/dev/null)

# Uptime
case "$(uname -s)" in
    Darwin*)
        boot_time=$(sysctl -n kern.boottime | awk '{print $4}' | tr -d ',')
        now=$(date +%s)
        uptime_sec=$((now - boot_time))
        days=$((uptime_sec / 86400))
        hours=$((uptime_sec % 86400 / 3600))
        mins=$((uptime_sec % 3600 / 60))
        if [ $days -gt 0 ]; then
            UPTIME="${days}d ${hours}h ${mins}m"
        else
            UPTIME="${hours}h ${mins}m"
        fi
        ;;
    *)
        UPTIME=$(uptime -p 2>/dev/null | sed 's/up //')
        ;;
esac
[ -z "$UPTIME" ] && UPTIME=$(uptime 2>/dev/null | awk -F'( |,|:)+' '{print $6,$7" "$8}')

# CPU Info
CPU="Unknown CPU"
if [ "$(uname -s)" = "Darwin" ]; then
    CPU=$(sysctl -n machdep.cpu.brand_string)
elif command -v lscpu >/dev/null 2>&1; then
    CPU=$(lscpu | grep "Model name:" | sed -r 's/Model name:\s{1,}//g')
else
    CPU=$(uname -p)
fi

# GPU Info
GPU="Unknown GPU"
if [ "$(uname -s)" = "Darwin" ]; then
    GPU=$(system_profiler SPDisplaysDataType 2>/dev/null | awk -F': ' '/Chipset Model/ {print $2}')
elif command -v lspci >/dev/null 2>&1; then
    GPU=$(lspci | grep -i 'vga\|3d\|2d' | head -n 1 | awk -F': ' '{print $2}')
fi
[ -z "$GPU" ] && GPU="N/A"

# Memory
MEM="N/A"
if command -v free >/dev/null 2>&1; then
    MEM=$(free -h | awk '/Mem:/ {print $3 " / " $2}')
elif [ "$(uname -s)" = "Darwin" ]; then
    total_mem=$(sysctl -n hw.memsize)
    total_mb=$((total_mem / 1024 / 1024))
    used_mem=$(vm_stat | grep "Pages active" | awk '{print $3}' | sed 's/\.//')
    used_mb=$((used_mem * 4096 / 1024 / 1024))
    MEM="${used_mb}MB / ${total_mb}MB"
fi

# Disk Info
DISK=$(df -h / | awk 'NR==2 {print $3 " / " $2 " (" $5 " used)"}')

# Internet & IP (Timeout 2s)
PUBLIC_IP=$(curl -s --max-time 2 ifconfig.me || echo "Offline")
LOCATION="Unknown Location"
if [ "$PUBLIC_IP" != "Offline" ]; then
    # try ipinfo.io
    LOCATION=$(curl -s --max-time 2 "ipinfo.io/$PUBLIC_IP/city" || echo "Unknown")
    COUNTRY=$(curl -s --max-time 2 "ipinfo.io/$PUBLIC_IP/country" || echo "")
    [ -n "$COUNTRY" ] && LOCATION="$LOCATION, $COUNTRY"
fi

# Detect Package Managers
PKG_MGRS=""
command -v brew >/dev/null 2>&1 && PKG_MGRS="$PKG_MGRS brew,"
command -v apt >/dev/null 2>&1 && PKG_MGRS="$PKG_MGRS apt,"
command -v choco >/dev/null 2>&1 && PKG_MGRS="$PKG_MGRS choco,"
command -v scoop >/dev/null 2>&1 && PKG_MGRS="$PKG_MGRS scoop,"
command -v npm >/dev/null 2>&1 && PKG_MGRS="$PKG_MGRS npm,"
command -v yarn >/dev/null 2>&1 && PKG_MGRS="$PKG_MGRS yarn,"

PKG_MGRS=$(echo "$PKG_MGRS" | sed 's/,$//')
[ -z "$PKG_MGRS" ] && PKG_MGRS="None"

# Detect CLI Tools
TOOLS=""
command -v node >/dev/null 2>&1 && TOOLS+="node✅ " || TOOLS+="node❌ "
command -v git >/dev/null 2>&1 && TOOLS+="git✅ " || TOOLS+="git❌ "
command -v gh >/dev/null 2>&1 && TOOLS+="gh✅ " || TOOLS+="gh❌ "
command -v python3 >/dev/null 2>&1 && TOOLS+="python✅" || TOOLS+="python❌"

# ==============================
# LOGOS & PRINTING
# ==============================

declare -a LOGO
if [[ "$OS" == *"macOS"* ]]; then
    c1=$GREEN; c2=$CYAN
    LOGO=(
        "${c1}                    'c.        "
        "${c1}                 ,xNMM.        "
        "${c1}               .OMMMMo         "
        "${c1}               OMMM0,          "
        "${c1}     .;loddo:' loolloddol;.    "
        "${c1}   cKMMMMMMMMMMNWMMMMMMMMMM0:  "
        "${c1} .KMMMMMMMMMMMMMMMMMMMMMMMWd.  "
        "${c1} XMMMMMMMMMMMMMMMMMMMMMMMX.    "
        "${c2} ;MMMMMMMMMMMMMMMMMMMMMMMM:    "
        "${c2}  :MMMMMMMMMMMMMMMMMMMMMMMM:   "
        "${c2}  .KMMMMMMMMMMMMMMMMMMMMMMM.   "
        "${c2}   .xMMMMMMMMMMMMMMMMMMMMMM.   "
        "${c2}     .xMMMMMMMMMMMMMMMMMMMO.   "
        "${c2}        .:dOKKKKKKKOKKd:.      "
    )
    pad="             " 
elif [[ "$OS" == *"Linux"* ]]; then
    c1=$YELLOW; c2=$RED
    LOGO=(
        "${c1}         _nnnn_         "
        "${c1}        dGGGGMMb        "
        "${c1}       @p~qp~~qMb       "
        "${c1}       M|@||@) M|       "
        "${c1}       @,----.JM|       "
        "${c1}      JS^\\__/  qKL     "
        "${c1}     dZP        qKRb    "
        "${c1}    dZP          qKKb   "
        "${c2}   fZP            SMMb  "
        "${c2}   HZM            MMMM  "
        "${c2}   FqM            MMMM  "
        "${c2} __| \".        |\\dS\"qML "
        "${c2} |    \`.       | \`' \\Zq "
        "${c2}_)      \\.___.,|     .' "
        "${c2}\\____   )MMMMMP|   .'   "
        "${c2}     \`-'       \`--'     "
    )
    pad="         " 
elif [[ "$OS" == *"Windows"* || "$OS" == *"WSL"* ]]; then
    c1=$CYAN; c2=$CYAN
    LOGO=(
        "${c1}        ,.=:!!t3Z3z.,              "
        "${c1}       :tt:::tt333EE3              "
        "${c1}       Et:::ztt33EEEL @Ee.,      .., "
        "${c1}      ;tt:::tt333EE7 ;EEEEEEttttt33# "
        "${c1}     :Et:::zt333EEQ. $EEEEEttttt33QL "
        "${c1}     it::::tt333EEF @EEEEEEttttt33F  "
        "${c1}    ;3=*\`\`\`\"*4EEV :EEEEEEttttt33@.  "
        "${c1}    ,.=::::!t=., \` @EEEEEEtttz33QF   "
        "${c1}   ;::::::::zt33)   \"4EEEtttji3P*    "
        "${c2}  :t::::::::tt33.::.  \"4EEEt33!      "
        "${c2}  i::::::::zt33F AEEEf .,\`/            "
        "${c2} ;:::::::::t33V ;EEEttttt33#        "
        "${c2} E::::::::zt33L @EEEtttttt33L       "
        "${c2}{3=*\`\`\`\"*4E3) ;EEtttttttt33V      "
        "${c2}               \"4EEttttt33*         "
    )
    pad=""
else
    # Default Text Logo
    c1=$CYAN
    LOGO=(
        "${c1}                              "
        "${c1}      ___   __   __           "
        "${c1}     /   | / /  / /           "
        "${c1}    / /| |/ /  / /            "
        "${c1}   / ___ / /__/ /___          "
        "${c1}  /_/  |_/_____/____/         "
        "                              "
    )
    pad=" "
fi

# Setup stats array
STATS=(
    "${BOLD}${CYAN}${USER_NAME}${RESET}@${BOLD}${CYAN}${HOST_NAME}${RESET}"
    "-----------------------------"
    "${BOLD}${MAGENTA}OS:${RESET}          ${OS_ICON} ${OS}"
    "${BOLD}${MAGENTA}Kernel:${RESET}      ${KERNEL}"
    "${BOLD}${MAGENTA}Arch:${RESET}        ${ARCH}"
    "${BOLD}${MAGENTA}Shell:${RESET}       ${SHELL_NAME}"
    "${BOLD}${MAGENTA}Uptime:${RESET}      ⏱️  ${UPTIME}"
    "-----------------------------"
    "${BOLD}${YELLOW}CPU:${RESET}         ${CPU}"
    "${BOLD}${YELLOW}GPU:${RESET}         ${GPU}"
    "${BOLD}${YELLOW}Memory:${RESET}      ${MEM}"
    "${BOLD}${YELLOW}Disk:${RESET}         ${DISK}"
    "-----------------------------"
    "${BOLD}${GREEN}Pkg Mgrs:${RESET}    📦 ${PKG_MGRS}"
    "${BOLD}${GREEN}Tools:${RESET}       🛠️  ${TOOLS}"
    "${BOLD}${GREEN}Public IP:${RESET}   🌐 ${PUBLIC_IP}"
    "${BOLD}${GREEN}Location:${RESET}    📍 ${LOCATION}"
    "-----------------------------"
    "${BOLD}${CYAN}⚡ Powered by setupx${RESET}"
)

# Render Side-by-Side
MAX_LINES=${#LOGO[@]}
if [ ${#STATS[@]} -gt $MAX_LINES ]; then
    MAX_LINES=${#STATS[@]}
fi

if [[ "$OS" == *"macOS"* ]]; then
    empty_logo="                               " # 31 spaces
elif [[ "$OS" == *"Linux"* ]]; then
    empty_logo="                        " # 24 spaces
elif [[ "$OS" == *"Windows"* || "$OS" == *"WSL"* ]]; then
    empty_logo="                                   " # 35 spaces
else
    empty_logo="                              " # 30 spaces
fi

echo ""
for (( i=0; i<$MAX_LINES; i++ )); do
    # Format logo line to constant width
    LOGO_LINE="${LOGO[$i]}"
    if [ -z "$LOGO_LINE" ]; then
        LOGO_LINE="${empty_logo}"
    fi
    STAT_LINE="${STATS[$i]}"
    
    echo -e "${LOGO_LINE}${RESET}${pad}  ${STAT_LINE}"
done
echo ""

# ==============================
# QUICK STATUS CHECK
# ==============================
echo -e "${YELLOW}>> Automatic System Status Check...${RESET}"

# Package Managers
printf "${MAGENTA}📦 Package Managers:${RESET}"
for pkg in brew apt scoop choco npm yarn; do
    if command -v $pkg >/dev/null 2>&1; then
        version=$($pkg --version 2>/dev/null | head -n 1 | grep -oE 'v?[0-9]+\.[0-9]+(\.[0-9]+)?' | head -n 1)
        [ -z "$version" ] && version="Installed"
        printf " ${GREEN}✅ %s${RESET} (%s)" "$pkg" "$version"
    fi
done
echo ""

# CLI Tools
printf "${MAGENTA}🛠️  CLI Tools:       ${RESET}"
for tool in node git gh python3; do
    if command -v $tool >/dev/null 2>&1; then
        version=$($tool --version 2>/dev/null | head -n 1 | grep -oE 'v?[0-9]+\.[0-9]+(\.[0-9]+)?' | head -n 1)
        [ -z "$version" ] && version="Installed"
        printf " ${GREEN}✅ %s${RESET} (%s)" "$tool" "$version"
    fi
done
echo -e "\n"

# ==============================
# INTERACTIVE PROMPT
# ==============================
echo -ne "${CYAN}Press [Enter] to exit, or type 'c' to start the AI Chatbox: ${RESET}"
read -r choice
echo ""

if [[ "$choice" == "c" || "$choice" == "C" || "$choice" == "chat" ]]; then
    DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
    if command -v node >/dev/null 2>&1; then
        exec node "$DIR/sx-chat.js"
    else
        echo -e "${RED}Node.js is not installed! Run './sx.sh --setup' to automatically install Node, then try again.${RESET}"
    fi
fi
