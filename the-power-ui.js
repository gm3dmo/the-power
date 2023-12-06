// Electron.js
const { app, BrowserWindow, ipcMain, session } = require('electron');
const path = require('path');
const url = require('url');
const fs = require('fs');
const os = require('os');
const { exec } = require('child_process');
const { Console } = require('console');
const userDataPath = app.getPath('userData');
const confFilePath = path.join(app.getPath('userData'), '.gh-api-examples.conf');
const { spawn } = require('child_process');


let mainWindow;

function createWindow () {
  mainWindow = new BrowserWindow({
    width: 1200,
    height: 900,
    webPreferences: {
      nodeIntegration: false,
      contextIsolation: true, 
      preload: path.join(__dirname, 'preload.js')
    }
  });

  
  // Store the original console.log function
  const originalConsoleLog = console.log;

  // Create a new console that writes to both the original console and the IPC channel
  const newConsole = new Console({
    stdout: process.stdout,
    stderr: process.stderr,
    inspectOptions: { colors: true },
  });

  console.log = function(...data) {
    // Send log message to renderer process
    if(mainWindow && !mainWindow.isDestroyed()) {
      mainWindow.webContents.send('console-log', data.join(' '));
    }
  
    // Call the original console.log function
    originalConsoleLog.apply(newConsole, data);
  };

  mainWindow.loadURL(url.format({
    pathname: path.join(__dirname, 'welcome.html'),
    protocol: 'file:',
    slashes: true
  }));


  mainWindow.on('closed', function () {
    app.quit();
  });
}

app.on('ready', () => {
  session.defaultSession.clearCache().then(() => {
    createWindow();
  }).catch((error) => {
    console.error(error);
  });
});

ipcMain.handle('join-path', (event, path1, path2) => {
  const result = path.join(path1, path2);
  return result;
});

// Handle 'get-scripts' IPC event
ipcMain.handle('get-scripts', async (event) => {
  return new Promise((resolve, reject) => {
    fs.readdir(path.join(__dirname, './'), (err, files) => { // Use __dirname
      if (err) {
        reject(err);
      } else {
        let scripts = files.filter(file => file.endsWith('.sh'));
        resolve(scripts);
      }
    });
  });
});


// Handle 'check-file-exists' IPC event
ipcMain.handle('check-file-exists', async (event, pathToFile) => {
  try {
    await fs.promises.access(pathToFile);
    return true;
  } catch {
    return false;
  }
});

// Handle 'delete-file' IPC event
ipcMain.handle('delete-file', async (event, pathToFile) => {
  try {
    await fs.promises.unlink(pathToFile);
  } catch (error) {
    console.error('Failed to delete file:', error);
    throw error; // re-throw the error to the renderer process
  }
});

let python; // Global variable to store the Python process
//const pythonInterpreterPath = '/usr/local/bin/python3';
const pythonInterpreterPath = 'python3';
// Handle 'run-interactive-script' IPC event
ipcMain.on('run-interactive-script', (event, scriptPath, args) => {
  // Ensure that args is an array
  args = Array.isArray(args) ? args : [args];
  // Join the args array into a string, with each argument enclosed in quotes
  const formattedArgs = args.join(' ');
  process.env.PATH = '/usr/local/bin:' + '/usr/bin/:' + process.env.PATH;
  
  let command;
  if (scriptPath) {
    scriptPath = path.join(__dirname, scriptPath);
    command = `"${pythonInterpreterPath}" "${scriptPath}" ${formattedArgs}`;
  } else {
    command = `${pythonInterpreterPath} ${formattedArgs}`;
  }

  python = exec(command);
  python.stdout.on('data', (data) => {
    const output = data.toString();
    if (output.endsWith('\n')) {
      // The script is not waiting for input, remove the blinking cursor
      mainWindow.webContents.send('console-log', { output, isWaitingForInput: false });
    } else {
      // The script is waiting for input, add the blinking cursor
      mainWindow.webContents.send('console-log', { output, isWaitingForInput: true });
    }
  });

python.stderr.on('data', (data) => {
  mainWindow.webContents.send('console-log', { output: `stderr: ${data}` });
});

python.on('close', (code) => {
  mainWindow.webContents.send('console-log', { output: `child process exited with code ${code}` });
  mainWindow.webContents.send('script-complete');
});

});



// Handle 'write-to-python-stdin' IPC event
ipcMain.handle('write-to-python-stdin', (event, input) => {
  if (python) {
    python.stdin.write(input + '\n');
  }
});

// Handle 'execute-command' IPC event
ipcMain.handle('execute-command', async (event, command) => {
  return new Promise((resolve, reject) => {
    exec(command, (error, stdout, stderr) => {
      if (error) {
        console.error('Failed to execute command:', error);
        reject(error);
      } else {
        resolve({ stdout, stderr });
      }
    });
  });
});

ipcMain.handle('get-user-data-path', () => {
  return userDataPath;
});

// Handle 'run-script' IPC event
ipcMain.handle('run-script', async (event, scriptName) => {
  return new Promise(async (resolve, reject) => {
    try {
      const appPath = app.getAppPath();
      const scriptPath = path.join(appPath, scriptName);
      const scriptDir = path.dirname(scriptPath);
      const scriptContent = await fs.promises.readFile(scriptPath, 'utf-8');
      const scriptLines = scriptContent.split('\n');
      const newScriptLines = scriptLines.map(line => {
        if (line.startsWith('./')) {
          // Replace the relative path to the script with an absolute path
          const scriptName = line.split(' ')[0].slice(2);
          const absoluteScriptPath = path.join(__dirname, scriptName);
          return line.replace(`./${scriptName}`, absoluteScriptPath);
        } else if (line.trim() === '.  ./.gh-api-examples.conf') {
          // Replace the line
          return `. "${confFilePath}"`;
        } else {
          return line;
        }
      });
      const newScriptContent = newScriptLines.join('\n');
      

      // Add the path to jq to the system's PATH environment variable
      const jqPath = '/usr/local/bin:/opt/homebrew/bin/jq';
      process.env.PATH = `${jqPath}:${process.env.PATH}`;

      // Write the new script content to a temporary file
      const tempScriptPath = path.join(os.tmpdir(), scriptName);
      await fs.promises.writeFile(tempScriptPath, newScriptContent);
      const child = spawn('/bin/bash', ['-c', `bash "${tempScriptPath}"`], { cwd: scriptDir });

      child.stdout.on('data', (data) => {
        event.sender.send('script-output', { scriptName, output: data.toString() });
      });

      child.stderr.on('data', (data) => {
        console.error(`stderr: ${data}`);
      });

      child.on('error', (error) => {
        console.error('Failed to start subprocess.', error);
        reject(error);
      });

      child.on('close', (code) => {
        if (code !== 0) {
          console.error(`child process exited with code ${code}`);
          reject(new Error(`child process exited with code ${code}`));
        } else {
          resolve({ output: 'Script executed successfully' });
        }
      });
    } catch (error) {
      console.error('An error occurred:', error);
      reject(error);
    }
  });
});

app.on('window-all-closed', function () {
  if (process.platform !== 'darwin') app.quit();
});

app.on('activate', function () {
  if (mainWindow === null) createWindow();
});

ipcMain.on('quit', () => {
    app.quit();
  });