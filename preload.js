// preload.js
const { contextBridge, ipcRenderer } = require('electron');
let isScriptRunning = false;

contextBridge.exposeInMainWorld(
  'myApi', {
    getScripts: async () => {
      return ipcRenderer.invoke('get-scripts');
    },
    runScript: async (scriptName) => {
      isScriptRunning = true;
      const result = await ipcRenderer.invoke('run-script', scriptName);
      isScriptRunning = false;
      return result;
    },
    onConsoleLog: (callback) => {
      ipcRenderer.on('console-log', (event, data) => {
        data.output = data.output || '';
        if (data.isWaitingForInput && isScriptRunning) {
          data.showCursor = true;
        } else {
          data.showCursor = false;
        }
        callback(data);
      });
    },
    onScriptOutput: (callback) => {
        ipcRenderer.on('script-output', (event, data) => callback(data));
      },
    quit: () => {
      ipcRenderer.send('quit');
    },
    deleteFile: (filePath) => {
      return ipcRenderer.invoke('delete-file', filePath);
    },
    checkFileExists: (filePath) => {
      return ipcRenderer.invoke('check-file-exists', filePath);
    },
    executeCommand: (command) => {
      return ipcRenderer.invoke('execute-command', command);
    },
    runInteractiveScript: (scriptPath, args) => {
      // Ensure that args is an array
      
      args = Array.isArray(args) ? args : [args];
      isScriptRunning = true;
      // Map each argument to ensure that paths with spaces are enclosed in quotes
      const formattedArgs = args.map(arg => `"${arg}"`);

      ipcRenderer.send('run-interactive-script', scriptPath, formattedArgs);
    },
    onScriptComplete: (callback) => {
      ipcRenderer.on('script-complete', (event, result) => {
        isScriptRunning = false;
        callback(result);
      });
      },
    writeToPythonStdin: (input) => {
      return ipcRenderer.invoke('write-to-python-stdin', input);
    },
    getUserDataPath: () => {
      return ipcRenderer.invoke('get-user-data-path');
    },
    safeIpc: {
      send: (channel, data) => ipcRenderer.send(channel, data),
      on: (channel, func) => {
        ipcRenderer.on(channel, (event, ...args) => func(...args));
      }
    },
    joinPath: async (path1, path2) => {
        const result = await ipcRenderer.invoke('join-path', path1, path2);
        return result;
    }
  }
);