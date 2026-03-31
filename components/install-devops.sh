#!/usr/bin/env bash

# Colors
RED="\033[1;31m"
GREEN="\033[1;32m"
CYAN="\033[1;36m"
YELLOW="\033[1;33m"
MAGENTA="\033[1;35m"
RESET="\033[0m"

echo -e "${CYAN}🐳 Installing DevOps & Container Architecture...${RESET}\n"

if [[ "$OS" == *"macOS"* ]]; then
    echo -e "${YELLOW}>> Installing Docker Desktop and Kubernetes via Homebrew...${RESET}"
    brew install --cask docker
    brew install kubectl minikube helm

elif [[ "$OS" == *"Linux"* ]] || [[ "$OS" == *"WSL"* ]]; then
    echo -e "${YELLOW}>> Installing Headless Docker Engine & K8s (Linux)...${RESET}"
    
    # 1. Headless Docker Engine
    if ! command -v docker >/dev/null 2>&1; then
        echo -e "${MAGENTA}Fetching official Docker install script...${RESET}"
        curl -fsSL https://get.docker.com -o get-docker.sh
        sudo sh get-docker.sh
        rm get-docker.sh
        sudo usermod -aG docker $USER
        echo -e "${GREEN}✓ Docker Engine installed. Please restart your shell!${RESET}"
    else
        echo -e "${GREEN}✓ Docker is already installed.${RESET}"
    fi
    
    # 2. Kubectl
    if ! command -v kubectl >/dev/null 2>&1; then
        echo -e "${MAGENTA}Fetching kubectl binary...${RESET}"
        curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
        sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
        rm kubectl
    fi
    
    # 3. Minikube
    if ! command -v minikube >/dev/null 2>&1; then
        echo -e "${MAGENTA}Fetching minikube...${RESET}"
        curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
        sudo install minikube-linux-amd64 /usr/local/bin/minikube
        rm minikube-linux-amd64
    fi

elif [[ "$OS" == *"Windows"* ]]; then
    echo -e "${YELLOW}>> Installing Docker Desktop & K8s via Choco (Windows)...${RESET}"
    powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "choco install docker-desktop kubernetes-cli minikube kubernetes-helm -y"
fi

echo -e "\n${GREEN}✨ DevOps & Container Environment Setup Complete!${RESET}"
if [[ "$OS" == *"macOS"* || "$OS" == *"Windows"* ]]; then
    echo -e "${CYAN}Note: Please launch 'Docker Desktop' manually from your applications menu to start the daemon for the first time.${RESET}"
fi
