import React, { useState, useRef, useEffect } from 'react';
import { Terminal, Send, TerminalSquare, Lock, Plus, MessageSquare, Trash2, LogOut } from 'lucide-react';
import './App.css';

const SIMULATED_RESPONSES = [
  {
    keywords: ["install", "setup"],
    text: "Here is how you install applications smoothly. Running `sx --setup` automatically detects your package manager (brew, apt) and installs the required SDKs."
  },
  {
    keywords: ["os", "spec", "system", "hardware"],
    text: "Type `sx` in your terminal to see your gorgeous system dashboard with native ASCII art, CPU data, RAM usage, and uptime."
  },
  {
    keywords: ["clear", "cache", "clean"],
    text: "To clear system caches, I can run diagnostic commands like `docker system prune -a` for you automatically."
  },
  {
    keywords: ["hello", "hi", "hey"],
    text: "Hello there! I am sx-bot, your intelligent terminal assistant. Ask me anything about your system infrastructure."
  }
];

function App() {
  // Authentication Memory
  const [isAuthenticated, setIsAuthenticated] = useState(() => {
    return localStorage.getItem('sx_auth') === 'true';
  });
  const [isAuthenticating, setIsAuthenticating] = useState(false);

  // Chat Memory Config
  const [chats, setChats] = useState(() => {
    const saved = localStorage.getItem('sx_chats');
    if (saved) return JSON.parse(saved);
    return [
      { 
        id: Date.now().toString(), 
        title: 'Initial Setup Chat', 
        messages: [{ id: 1, text: "Welcome to sx-bot web! Type a command or ask a question.", sender: 'bot' }] 
      }
    ];
  });
  const [currentChatId, setCurrentChatId] = useState(() => {
    const saved = localStorage.getItem('sx_current_chat');
    if (saved) return saved;
    return chats.length > 0 ? chats[0].id : null;
  });

  const [input, setInput] = useState('');
  const [isTyping, setIsTyping] = useState(false);
  const messagesEndRef = useRef(null);

  // Auto-scroll logic
  const scrollToBottom = () => {
    messagesEndRef.current?.scrollIntoView({ behavior: "smooth" });
  };

  // Sync memory to LocalStorage whenever it changes
  useEffect(() => {
    localStorage.setItem('sx_chats', JSON.stringify(chats));
    localStorage.setItem('sx_current_chat', currentChatId);
    if (!currentChatId && chats.length > 0) {
      setCurrentChatId(chats[0].id);
    }
  }, [chats, currentChatId]);

  useEffect(() => {
    scrollToBottom();
  }, [chats, currentChatId, isTyping]);


  // Auth Handlers
  const handleLogin = (provider) => {
    setIsAuthenticating(true);
    setTimeout(() => {
      setIsAuthenticating(false);
      setIsAuthenticated(true);
      localStorage.setItem('sx_auth', 'true');
    }, 1200);
  };
  const handleLogout = () => {
    setIsAuthenticated(false);
    localStorage.removeItem('sx_auth');
  };


  // Chat Handlers
  const handleNewChat = () => {
    const newId = Date.now().toString();
    const newSession = {
      id: newId,
      title: 'New Chat',
      messages: [{ id: 1, text: "I'm a fresh instance of sx-bot! How can I assist you today?", sender: 'bot' }]
    };
    setChats(prev => [newSession, ...prev]);
    setCurrentChatId(newId);
  };

  const handleDeleteChat = (e, idToDelete) => {
    e.stopPropagation();
    setChats(prev => {
      const filtered = prev.filter(c => c.id !== idToDelete);
      if (filtered.length === 0) {
        // Create an empty chat if we deleted the last one
        const fallback = { id: Date.now().toString(), title: 'New Chat', messages: [{ id: 1, text: "Welcome back!", sender: 'bot' }] };
        setCurrentChatId(fallback.id);
        return [fallback];
      }
      if (currentChatId === idToDelete) {
        setCurrentChatId(filtered[0].id);
      }
      return filtered;
    });
  };

  const activeChat = chats.find(c => c.id === currentChatId) || chats[0];


  // Message Dispatcher
  const handleSend = () => {
    if (!input.trim() || !activeChat) return;
    
    const userMsg = input.trim();
    const newMsgObj = { id: Date.now(), text: userMsg, sender: 'user' };
    
    // Update the title if it's the first user message
    setChats(prevChats => prevChats.map(c => {
      if (c.id === currentChatId) {
        const newTitle = c.messages.length === 1 ? userMsg.slice(0, 20) + (userMsg.length > 20 ? '...' : '') : c.title;
        return { ...c, title: newTitle, messages: [...c.messages, newMsgObj] };
      }
      return c;
    }));

    setInput('');
    setIsTyping(true);

    // AI Simulation
    setTimeout(() => {
      const lowerText = userMsg.toLowerCase();
      let reply = "I am sx-bot. Install my CLI using `npm i -g @aydigi/setupx-cli` to chat with the real frontend directly from your terminal!";
      
      for (let item of SIMULATED_RESPONSES) {
        if (item.keywords.some(kw => lowerText.includes(kw))) {
          reply = item.text;
          break;
        }
      }

      setChats(prevChats => prevChats.map(c => {
        if (c.id === currentChatId) {
          return { ...c, messages: [...c.messages, { id: Date.now(), text: reply, sender: 'bot' }] };
        }
        return c;
      }));
      setIsTyping(false);
    }, 1000 + Math.random() * 800);
  };


  // UN-AUTHENTICATED RENDER
  if (!isAuthenticated) {
    return (
      <>
        <div className="background-elements">
          <div className="glow glow-1"></div>
          <div className="glow glow-2"></div>
        </div>
        
        <div className="login-container">
          <div className="login-card glass-panel fade-in-up">
            <div className="login-header">
              <TerminalSquare className="logo-icon large" />
              <h2>Welcome to sx-bot</h2>
              <p>Sign in to configure your intelligent terminal assistant dashboard.</p>
            </div>
            
            <div className="auth-buttons">
              <button className="auth-btn google" onClick={() => handleLogin('google')} disabled={isAuthenticating}>
                <svg viewBox="0 0 24 24" width="20" height="20" xmlns="http://www.w3.org/2000/svg">
                  <path d="M22.56 12.25c0-.78-.07-1.53-.2-2.25H12v4.26h5.92c-.26 1.37-1.04 2.53-2.21 3.31v2.77h3.57c2.08-1.92 3.28-4.74 3.28-8.09z" fill="#4285F4"/>
                  <path d="M12 23c2.97 0 5.46-.98 7.28-2.66l-3.57-2.77c-.98.66-2.23 1.06-3.71 1.06-2.86 0-5.29-1.93-6.16-4.53H2.18v2.84C3.99 20.53 7.7 23 12 23z" fill="#34A853"/>
                  <path d="M5.84 14.09c-.22-.66-.35-1.36-.35-2.09s.13-1.43.35-2.09V7.07H2.18C1.43 8.55 1 10.22 1 12s.43 3.45 1.18 4.93l2.85-2.22.81-.62z" fill="#FBBC05"/>
                  <path d="M12 5.38c1.62 0 3.06.56 4.21 1.64l3.15-3.15C17.45 2.09 14.97 1 12 1 7.7 1 3.99 3.47 2.18 7.07l3.66 2.84c.87-2.6 3.3-4.53 6.16-4.53z" fill="#EA4335"/>
                </svg>
                {isAuthenticating ? 'Authenticating...' : 'Sign in with Google'}
              </button>
              
              <button className="auth-btn github" onClick={() => handleLogin('github')} disabled={isAuthenticating}>
                <svg viewBox="0 0 24 24" width="20" height="20" fill="currentColor"><path d="M12 2C6.477 2 2 6.477 2 12c0 4.42 2.865 8.166 6.839 9.489.5.092.682-.217.682-.482 0-.237-.008-.866-.013-1.7-2.782.603-3.369-1.34-3.369-1.34-.454-1.156-1.11-1.462-1.11-1.462-.908-.62.069-.608.069-.608 1.003.07 1.531 1.03 1.531 1.03.892 1.529 2.341 1.087 2.91.831.092-.646.35-1.086.636-1.336-2.22-.253-4.555-1.11-4.555-4.943 0-1.091.39-1.984 1.029-2.683-.103-.253-.446-1.27.098-2.647 0 0 .84-.268 2.75 1.022A9.606 9.606 0 0 1 12 6.82c.85.004 1.705.114 2.504.336 1.909-1.29 2.747-1.022 2.747-1.022.546 1.377.203 2.394.1 2.647.64.699 1.028 1.592 1.028 2.683 0 3.842-2.339 4.687-4.566 4.935.359.309.678.919.678 1.852 0 1.336-.012 2.415-.012 2.743 0 .267.18.578.688.48C19.138 20.161 22 16.418 22 12c0-5.523-4.477-10-10-10Z"/></svg>
                {isAuthenticating ? 'Authenticating...' : 'Sign in with GitHub'}
              </button>
            </div>
            
            <div className="auth-footer">
              <Lock size={12} /> SSO Simulation Sandbox
            </div>
          </div>
        </div>
      </>
    );
  }

  // AUTHENTICATED DASHBOARD RENDER
  return (
    <>
      <div className="background-elements">
        <div className="glow glow-1"></div>
        <div className="glow glow-2"></div>
      </div>

      <div className="dashboard-layout fade-in-up">
        
        {/* SIDEBAR */}
        <aside className="sidebar glass-panel">
          <div className="sidebar-header">
            <button className="new-chat-btn" onClick={handleNewChat}>
              <Plus size={18} /> New Chat
            </button>
          </div>
          
          <div className="chat-history-list">
            <span className="history-label">Previous Chats</span>
            {chats.map(chat => (
              <div 
                key={chat.id} 
                className={`history-item ${chat.id === currentChatId ? 'active' : ''}`}
                onClick={() => setCurrentChatId(chat.id)}
              >
                <MessageSquare size={16} className="item-icon" />
                <span className="item-title">{chat.title}</span>
                <button className="item-delete" onClick={(e) => handleDeleteChat(e, chat.id)}>
                  <Trash2 size={14} />
                </button>
              </div>
            ))}
          </div>

          <div className="sidebar-footer">
            <div className="user-profile">
               <div className="avatar user mini">U</div>
               <span>Test User</span>
            </div>
            <button className="logout-btn" onClick={handleLogout} title="Log out">
              <LogOut size={16} />
            </button>
          </div>
        </aside>

        {/* MAIN CHAT AREA */}
        <main className="main-content glass-panel">
          <header className="chat-topbar">
            <h2>{activeChat?.title || "sx-bot"}</h2>
            <div className="model-badge">Gemini AI Model</div>
          </header>

          <div className="chat-messages">
            {activeChat?.messages.map((msg) => (
              <div key={msg.id} className={`message-wrapper ${msg.sender}`}>
                {msg.sender === 'bot' && <div className="avatar bot"><Terminal size={16} /></div>}
                <div className={`message ${msg.sender}-message`}>
                  {msg.text.split('`').map((part, i) => i % 2 === 1 ? <code key={i}>{part}</code> : part)}
                </div>
                {msg.sender === 'user' && <div className="avatar user">U</div>}
              </div>
            ))}
            {isTyping && (
              <div className="message-wrapper bot">
                <div className="avatar bot"><Terminal size={16} /></div>
                <div className="typing-indicator">
                  <span></span><span></span><span></span>
                </div>
              </div>
            )}
            <div ref={messagesEndRef} />
          </div>

          <div className="chat-input-area">
            <input 
              type="text" 
              value={input}
              onChange={(e) => setInput(e.target.value)}
              onKeyDown={(e) => e.key === 'Enter' && handleSend()}
              placeholder="Message sx-bot..."
            />
            <button onClick={handleSend} className="send-btn">
              <Send size={20} />
            </button>
          </div>
        </main>

      </div>
    </>
  );
}

export default App;
