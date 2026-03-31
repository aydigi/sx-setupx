const terminalOutput = document.getElementById("term-view");
const lines = [
    "<span class='cyan'>$</span> ./sx.sh",
    " ",
    "                    <span class='green'>'c.</span>        <span class='cyan bold'>aydigi@macbook</span>",
    "                 <span class='green'>,xNMM.</span>        -----------------------------",
    "               <span class='green'>.OMMMMo</span>         <span class='magenta bold'>OS:</span>          🍎 macOS",
    "               <span class='green'>OMMM0,</span>          <span class='magenta bold'>Arch:</span>        arm64",
    "     <span class='green'>.;loddo:' loolloddol;.</span>    <span class='magenta bold'>Shell:</span>       zsh",
    "   <span class='green'>cKMMMMMMMMMMNWMMMMMMMMMM0:</span>  -----------------------------",
    " <span class='green'>.KMMMMMMMMMMMMMMMMMMMMMMMWd.</span>  <span class='yellow bold'>CPU:</span>         Apple M1",
    " <span class='green'>XMMMMMMMMMMMMMMMMMMMMMMMX.</span>    <span class='yellow bold'>GPU:</span>         Apple M1",
    " <span class='cyan'>;MMMMMMMMMMMMMMMMMMMMMMMM:</span>    <span class='yellow bold'>Memory:</span>      528MB / 8192MB",
    "  <span class='cyan'>:MMMMMMMMMMMMMMMMMMMMMMMM:</span>   -----------------------------",
    "  <span class='cyan'>.KMMMMMMMMMMMMMMMMMMMMMMM.</span>   <span class='green bold'>Pkg Mgrs:</span>    📦 brew, npm, choco",
    "   <span class='cyan'>.xMMMMMMMMMMMMMMMMMMMMMM.</span>   <span class='green bold'>Public IP:</span>   🌐 192.168.0.1",
    "     <span class='cyan'>.xMMMMMMMMMMMMMMMMMMMO.</span>   <span class='green bold'>Location:</span>    📍 Earth",
    "        <span class='cyan'>.:dOKKKKKKKOKKd:.</span>      -----------------------------",
    "                               <span class='cyan bold'>⚡ Powered by setupx</span>"
];

let i = 0;
function renderTerminal() {
    if (!terminalOutput) return;
    if (i < lines.length) {
        let div = document.createElement('div');
        div.innerHTML = lines[i];
        terminalOutput.appendChild(div);
        i++;
        setTimeout(renderTerminal, 150 + Math.random() * 50);
    }
}

// Start animation slightly after load
setTimeout(renderTerminal, 500);

// ============================================
// Chatbot Logic (Simulated Demo)
// ============================================

const chatWidget = document.getElementById("chatWidget");
const chatInput = document.getElementById("chatInput");
const chatMessages = document.getElementById("chatMessages");

function toggleChat() {
    chatWidget.classList.toggle("active");
    if (chatWidget.classList.contains("active")) {
        chatInput.focus();
    }
}

const simulatedResponses = [
    { keywords: ["install", "download", "get"], response: "To install packages, you can use the command: <pre>sx --setup</pre> This will natively detect your OS and install everything securely using Brew, APT, or Choco." },
    { keywords: ["os", "system", "hardware", "spec"], response: "To pull up your colorized system dashboard, simply type: <pre>sx</pre> It gives you an ASCII logo along with CPU, RAM, OS, and Kernel information!" },
    { keywords: ["clear", "cache", "clean"], response: "To automatically clear system cache, you can ask me inside the CLI! For Docker, you could run:<pre>docker system prune -a</pre>" },
    { keywords: ["hello", "hi", "hey"], response: "Hello there! I'm the simulated web preview of the sx-bot. If you install my CLI tool, you can chat with the real me anytime using: <pre>sx --chat</pre>" },
    { keywords: ["who", "what", "setupx"], response: "I am setupx! A next-generation system utility that helps you manage your PC natively through the terminal effortlessly." }
];

function handleChatSend() {
    const text = chatInput.value.trim();
    if (!text) return;

    // 1. Add User Message
    addMessage(text, "user-message");
    chatInput.value = "";

    // 2. Add Typing Indicator
    const typingId = "typing-" + Date.now();
    const typingHTML = `<div class="typing-indicator" id="${typingId}"><span></span><span></span><span></span></div>`;
    addMessageHTML(typingHTML, "bot-message");

    // 3. Simulate Network Delay & AI Processing
    setTimeout(() => {
        document.getElementById(typingId).parentNode.remove();
        
        // Find best response match
        const lowerText = text.toLowerCase();
        let reply = "I'm just a simulated demo right now! Run <strong>sx --chat</strong> in your terminal to talk to the real Gemini AI behind me.";
        
        for (let item of simulatedResponses) {
            if (item.keywords.some(kw => lowerText.includes(kw))) {
                reply = item.response;
                break;
            }
        }
        
        addMessageHTML(reply, "bot-message");
    }, 1000 + Math.random() * 800);
}

function addMessage(text, className) {
    const div = document.createElement("div");
    div.className = `message ${className}`;
    div.textContent = text;
    chatMessages.appendChild(div);
    chatMessages.scrollTop = chatMessages.scrollHeight;
}

function addMessageHTML(html, className) {
    const div = document.createElement("div");
    div.className = `message ${className}`;
    div.innerHTML = html;
    chatMessages.appendChild(div);
    chatMessages.scrollTop = chatMessages.scrollHeight;
}
