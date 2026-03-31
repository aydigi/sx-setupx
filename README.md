<div align="center">
  <h1>setupx CLI 🚀</h1>
  <p><strong>A Next-Generation System Provisioner, Cloud Deployer, and Gemini AI Chatbot.</strong></p>
</div>

---

## 📖 About

**setupx** (built by AY Digital) is the ultimate Swiss-army knife for modern developers. It unifies high-performance OS-specific package management, graphical heavy-app installations, Cloud Native deployments, and an intelligent **Google Gemini-powered** terminal chatbot into a single script. 

Whether you are spinning up a fresh MacBook, a Windows desktop, or a Linux headless server, `setupx` abstracts all package managers (`brew`, `choco`, `apt`, `snap`) and environment variables so you can get to work instantly.

---

## 🔥 Features & Architecture

`setupx` operates on a highly modular components system:

1. **System Diagnostics**: Native `sx` script fetches real-time CPU, GPU, RAM, Uptime, and Geolocation overlaid with OS-specific ASCII art.
2. **Base Installation**: Installs core tools like `git`, `python`, `node`, `yarn`.
3. **Mobile SDKs**: Seamlessly provisions **Flutter** and **React Native** (including Watchman, Xcode Command Line tools, and Azul Zulu Java).
4. **DevOps Engine**: Deploys **Docker**, **Kubernetes (kubectl)**, and **Minikube** clusters natively.
5. **Data Science**: Bypasses heavy GUIs to strictly install **Miniconda3** for pure CLI AI & Data workflows.
6. **Mega DevTools**: Installs heavy UI applications including VS Code, Android Studio, Google Chrome, and ChatGPT Desktop.
7. **Cloud Delivery**: Ships your local applications instantly to **Vercel** or **Firebase**.
8. **AI Chatbot (`sx-chat`)**: Native Node.js interceptor powered by Google Gemini. It can answer coding questions, or execute any of the above installations via Natural Language!

---

## 🛠️ Installation & Setup

You can run this script instantly out of the box because it relies on pure bash!

```bash
# 1. Clone the repository
git clone https://github.com/aydigi/sx-setupx.git
cd sx-setupx

# 2. Make it Executable
chmod +x sx.sh

# 3. Fire it up!
./sx.sh
```

*(Note: On your first run, enter the AI Chat prompt mode to securely cache your Google Gemini API Key into `~/.setupx-config.json`)*

---

## 💻 CLI Usage

The core engine is driven by straightforward arguments. 

| Command | Action |
| --- | --- |
| `./sx.sh` | Fetches hardware specs, network IPs, prints OS Logo, and runs a Component Status Check. |
| `./sx.sh --install-all` | The "God Command". Installs the Base, DevOps, Conda, Mobile SDKs, and DevTools all sequentially. |
| `./sx.sh --status` | Verifies your `$PATH` for over 25+ toolchains (Docker, Flutter, Conda, Brew, Node, etc.). | 
| `./sx.sh --setup` | Installs pure foundational tools (Node, Git, Python). |
| `./sx.sh --install-devops` | Pulls down Docker and Kubernetes natively for your OS. |
| `./sx.sh --chat` | Drops you into the interactive Gemini AI terminal. |

---

## ☁️ Cloud Deployments

You can now use `setupx` as your CI/CD delivery mechanism natively! 

- **To Vercel:** Run `./sx.sh --deploy-vercel` 
- **To Firebase:** Run `./sx.sh --deploy-firebase`

*Or inside the Chatbot, simply command:* `"Deploy this project to Vercel."*

---

## 🤖 The AI Chatbot
The Node.js integrated chatbot isn't just an LLM wrapper. It natively parses your natural language and executes local terminal installations to guard API limits! 

**Natural Language Examples:**
- *"Install DevTools"* -> Triggers the heavy Android Studio & VS Code installer.
- *"Show system status"* -> Triggers `--status`.
- *"Install Anaconda"* -> Triggers Miniconda provisioner.
- *"Deploy Firebase"* -> Ships your code!

**Built-in Slash Commands:**
- `/menu` — Prints out all commands.
- `/status` — Scans the health of your system toolchains.
- `/install all` — Master provisioner.
- `/sys` — Prints your hardware system information.
- `/exit` — Closes the chat gracefully.

---

## 🔗 Resources

Explore deeper into the technologies powering this environment:

* [**AY Digital**](https://github.com/aydigi) - The studio behind `setupx`.
* [**Google Gemini AI Platform**](https://aistudio.google.com/) - Get your free API key here to power the `sx-chat` engine.
* [**Vercel Documentation**](https://vercel.com/docs) - Learn how Vercel deployments are handled.
* [**Firebase Hosting**](https://firebase.google.com/docs/hosting) - Learn more about the Firebase CLI wrapper.

<br>
<div align="center">
  <i>Engineered for the modern developer.</i>
</div>
