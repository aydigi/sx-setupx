#!/usr/bin/env bash

# ==============================
# AY DIGITAL CLI - INSTALLER
# ==============================

echo "🚀 Installing AY Digital CLI (ayfetch)..."

# If the user curls from github:
# sudo curl -sL https://raw.githubusercontent.com/anshulyadav/ayfetch/main/ayfetch.sh -o /usr/local/bin/ayfetch
# sudo chmod +x /usr/local/bin/ayfetch

# Local install if run from repo
if [ -f "./ayfetch.sh" ]; then
    chmod +x ./ayfetch.sh
    echo "✅ Executable permissions given to ayfetch.sh."
    echo "To install globally, run:"
    echo "  sudo cp ayfetch.sh /usr/local/bin/ayfetch"
else
    echo "❌ Could not find ayfetch.sh in the current directory."
    echo "Please download the script manually or clone the repo."
fi

echo "✨ All set! Once installed, run 'ayfetch' to see your system info."
