<div align="center">
  <h1>AY Digital CLI 🚀</h1>
  <p><strong>A Next-Generation System Fetch & Command Hub for macOS, Linux, and Windows.</strong></p>
</div>

<br>

AY Digital CLI (`ayfetch.sh`) is an all-in-one terminal Swiss-army knife. It goes far beyond a standard `neofetch` script by unifying system diagnostics, OS-specific package management, and a robust Gemini AI Chatbot directly into one unified command-line tool.

---

## 🔥 Features
* **🎨 Stunning System Info (`ayfetch`)**: Dynamically fetch your real-time CPU, GPU, Disk Usage, Uptime, Memory, Network IPs, and precise City locations. Renders with beautiful ASCII logos custom-built for Windows, Linux, and macOS.
* **📦 Native OS Installers (`--setup`)**: Instantly install dependencies no matter what OS you run! Automatically downloads required package managers (`homebrew`, `apt`, `chocolatey`, `scoop`) and installs standard components natively (`node`, `python`, `git`, `gh`).
* **🧠 Gemini AI Chatbot (`--chat`)**: Native, real-time Node.js chat client directly built into the CLI that seamlessly talks to Google's Gemini models.
* **⚡ Slash Commands Hub**: Run `/install` or `/sys` natively from inside the Chat prompt without ever quitting your session!

---

## 🛠️ Installation

Because the core execution relies on pure bash, you can run this script instantly!

**1. Clone the repository:**
```bash
git clone https://github.com/aydigi/sx-setupx.git
cd sx-setupx
```

**2. Make Executable:**
```bash
chmod +x ayfetch.sh
```

**3. Run:**
```bash
./ayfetch.sh
```

---

## 💻 Commands Summary

| Command | Action |
| --- | --- |
| `./ayfetch.sh` | Fetches your system hardware specs and internet information alongside an OS-specific Logo. |
| `./ayfetch.sh --setup` | Analyzes your OS and seamlessly runs native installers (Brew/Apt/Choco) to setup Node, Yarn, Git, Python, etc. |
| `./ayfetch.sh --chat` | Drops you into an interactive AI terminal session driven by Google Gemini. |
| `npx @aydigi/ayfetch` | Runs the script if you have published it to the npm repository! |

---

## 🤖 Chatbot Slash Commands
When in `--chat` mode, you don't even have to exit to manage your system! Just use these built-in slash commands:
- `/menu` — Prints out all commands.
- `/install` (or `/apps`) — Instantly kicks off the `ayfetch.sh --setup` installer script!
- `/sys` — Prints your hardware system information instantly.
- `/clear` — Clears conversation context memory.
- `/exit` — Closes the chat gracefully.

---
*⚡ Powered by AY Digital*
