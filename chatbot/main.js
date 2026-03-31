import { app, BrowserWindow } from 'electron';
import path from 'path';
import { fileURLToPath } from 'url';

// Handling ES Module file-paths in Node natively.
const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

function createWindow() {
  const win = new BrowserWindow({
    width: 1280,
    height: 800,
    minWidth: 800,
    minHeight: 600,
    titleBarStyle: 'hiddenInset', // Creates a brilliant, native macOS borderless window that matches Apple's styling system
    vibrancy: 'sidebar',          // Requests native macOS blur behind the window rendering layers
    visualEffectState: 'active',
    backgroundColor: '#00000000', // Transport layer so your custom index.css variables show!
    webPreferences: {
      nodeIntegration: true,
      contextIsolation: false
    }
  });

  // Load the cross-compiled minified frontend UI statically without requiring a server!
  win.loadFile(path.join(__dirname, 'dist', 'index.html'));
  
  // Optionally open developer tools for testing layout
  // win.webContents.openDevTools();
}

app.whenReady().then(() => {
  createWindow();

  app.on('activate', () => {
    // macOS characteristic: rebooting window on dock click if running.
    if (BrowserWindow.getAllWindows().length === 0) createWindow();
  });
});

app.on('window-all-closed', () => {
  // macOS characteristic: keeping application core memory hot in the dock.
  if (process.platform !== 'darwin') app.quit();
});
