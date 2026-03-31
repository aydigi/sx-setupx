#!/usr/bin/env bash

# ==============================
# setupx CLI - INSTALLER
# ==============================

echo "🚀 Installing setupx CLI (sx)..."

# If the user curls from github:
# sudo curl -sL https://raw.githubusercontent.com/aydigi/sx-setupx/main/sx.sh -o /usr/local/bin/sx
# sudo chmod +x /usr/local/bin/sx

# Local install if run from repo
if [ -f "./sx.sh" ]; then
    chmod +x ./sx.sh
    echo "✅ Executable permissions given to sx.sh."
    echo "To install globally, run:"
    echo "  sudo cp sx.sh /usr/local/bin/sx"
else
    echo "❌ Could not find sx.sh in the current directory."
    echo "Please download the script manually or clone the repo."
fi

echo "✨ All set! Once installed, run 'sx' to see your system info."
