const fs = require('fs');
const path = require('path');
const os = require('os');
const readline = require('readline');
const { spawnSync } = require('child_process');

// Native fetch is available in Node 18+
const configPath = path.join(os.homedir(), '.ayfetch-config.json');

const rl = readline.createInterface({
  input: process.stdin,
  output: process.stdout
});

const colors = {
  reset: "\x1b[0m",
  cyan: "\x1b[36m",
  green: "\x1b[32m",
  yellow: "\x1b[33m",
  red: "\x1b[31m",
  bold: "\x1b[1m",
  magenta: "\x1b[35m"
};

let apiKey = process.env.GEMINI_API_KEY || null;

function loadConfig() {
  if (fs.existsSync(configPath)) {
    try {
      const data = JSON.parse(fs.readFileSync(configPath, 'utf8'));
      if (data.GEMINI_API_KEY) {
        apiKey = data.GEMINI_API_KEY;
      }
    } catch (e) {}
  }
}

function saveConfig(key) {
  apiKey = key;
  fs.writeFileSync(configPath, JSON.stringify({ GEMINI_API_KEY: key }, null, 2));
}

let history = [];

async function callGemini(text) {
  if (!apiKey) throw new Error("API Key is missing.");
  
  // Format history for Gemini API Structure
  history.push({ role: "user", parts: [{ text }] });

  try {
    const url = `https://generativelanguage.googleapis.com/v1beta/models/gemini-flash-latest:generateContent?key=${apiKey}`;
    const response = await fetch(url, {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ contents: history })
    });

    const data = await response.json();
    if (data.error) {
       console.error(`\n${colors.red}API Error: ${data.error.message}${colors.reset}\n`);
       history.pop(); // remove the failed prompt block
       return;
    }

    const reply = data.candidates?.[0]?.content?.parts?.[0]?.text || "No response generated.";
    history.push({ role: "model", parts: [{ text: reply }] });
    
    console.log(`\n${colors.bold}${colors.cyan}🤖 AY-Bot:${colors.reset}\n${reply}\n`);
  } catch (err) {
    console.error(`\n${colors.red}Error reaching API: ${err.message}${colors.reset}\n`);
    history.pop(); // remove failed context block
  }
}

function promptChat() {
  rl.question(`\n${colors.bold}${colors.green}You:${colors.reset} `, async (input) => {
    const text = input.trim();
    if (!text) return promptChat();

    // Slash Commands Handling
    if (text.startsWith('/')) {
      const cmd = text.toLowerCase();
      if (cmd === '/exit' || cmd === '/quit') {
        console.log(`\n${colors.magenta}Goodbye! ✨${colors.reset}`);
        rl.close();
        return;
      } else if (cmd === '/menu') {
        console.log(`\n${colors.bold}${colors.yellow}🛠️  AY-Bot Command Menu${colors.reset}`);
        console.log(`${colors.cyan}/install${colors.reset} - Install Apps & Components`);
        console.log(`${colors.cyan}/sys${colors.reset}     - Show System Specs`);
        console.log(`${colors.cyan}/clear${colors.reset}   - Clear Chat History`);
        console.log(`${colors.cyan}/exit${colors.reset}    - Quit Chat`);
      } else if (cmd === '/install' || cmd === '/apps') {
        console.log(`\n${colors.yellow}Running System Setup...${colors.reset}\n`);
        const scriptPath = path.join(__dirname, 'ayfetch.sh');
        spawnSync(scriptPath, ['--setup'], { stdio: 'inherit' });
      } else if (cmd === '/sys') {
        console.log(`\n${colors.yellow}Fetching System Specs...${colors.reset}\n`);
        const scriptPath = path.join(__dirname, 'ayfetch.sh');
        spawnSync(scriptPath, [], { stdio: 'inherit' });
      } else if (cmd === '/clear') {
        history = [];
        console.log(`\n${colors.green}🧹 Chat history cleared!${colors.reset}`);
      } else {
        console.log(`\n${colors.red}Unknown command. Type /menu to see options.${colors.reset}`);
      }
      return promptChat();
    }

    await callGemini(text);
    
    promptChat(); // recursive prompt for more context
  });
}

function start() {
  console.log(`${colors.cyan}==============================${colors.reset}`);
  console.log(`${colors.bold}${colors.cyan}       AY DIGITAL CLI CHAT    ${colors.reset}`);
  console.log(`${colors.cyan}==============================${colors.reset}\n`);

  loadConfig();

  if (!apiKey) {
    console.log(`${colors.yellow}Welcome! It looks like this is your first time using the chatbot.${colors.reset}`);
    rl.question(`Please enter your ${colors.bold}Gemini API Key${colors.reset} (from Google AI Studio): `, (input) => {
      const key = input.trim();
      if (!key) {
        console.log(`${colors.red}A valid key is required. Exiting.${colors.reset}`);
        rl.close();
        return;
      }
      saveConfig(key);
      console.log(`\n${colors.green}✅ API Key saved securely to ~/.ayfetch-config.json!${colors.reset}\n`);
      console.log(`Type "exit" to quit.`);
      promptChat();
    });
  } else {
    console.log(`Type "exit" to quit.`);
    promptChat();
  }
}

// Kick it off
start();
