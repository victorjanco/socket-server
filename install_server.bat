@echo off
echo Installing Node.js and setting up Socket Server...
echo.

:: Check if Node.js is already installed
where node >nul 2>&1
if %errorlevel% equ 0 (
    echo Node.js is already installed.
) else (
    echo Installing Node.js...
    
    :: Download Node.js
    bitsadmin /transfer "NodeDownload" /download /priority high ^
    https://nodejs.org/dist/v18.16.1/node-v18.16.1-x64.msi ^
    "%TEMP%\node-installer.msi"
    
    :: Install silently
    start /wait msiexec /i "%TEMP%\node-installer.msi" /quiet /norestart
    del "%TEMP%\node-installer.msi"
    
    :: Force-update PATH for current session
    for %%i in ("%ProgramFiles%\nodejs") do set "NODE_PATH=%%~fi"
    set "PATH=%PATH%;%NODE_PATH%"
    echo Node.js installation complete.
)

:: Verify npm (now using full path to avoid PATH issues)
"%ProgramFiles%\nodejs\npm" -v >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] npm still not available. Trying last-resort fixes...
    
    :: Check alternative install paths
    if exist "%LocalAppData%\Programs\nodejs\npm.cmd" (
        set "NODE_PATH=%LocalAppData%\Programs\nodejs"
        set "PATH=%PATH%;%NODE_PATH%"
    )
    
    :: Final verification
    "%ProgramFiles%\nodejs\npm" -v >nul 2>&1
    if %errorlevel% neq 0 (
        echo [FINAL ERROR] npm could not be found. Solutions:
        echo 1. RESTART YOUR COMPUTER (required to update PATH)
        echo 2. Manually add Node.js to PATH:
        echo    - Press Win+R → type `sysdm.cpl` → Advanced → Environment Variables
        echo    - Edit "Path" → Add: "C:\Program Files\nodejs"
        pause
        exit /b
    )
)

:: Project setup
if not exist "c:\horno\socket-server\" mkdir "c:\horno\socket-server"
cd /d "c:\horno\socket-server" || exit /b

:: Install packages (using full npm path)
echo Installing npm packages...
"%ProgramFiles%\nodejs\npm" install
if %errorlevel% neq 0 (
    echo [ERROR] npm install failed. Check:
    echo - Is there a package.json in "c:\horno\socket-server"?
    echo - Is your internet connection working?
    pause
    exit /b
)

echo.
echo SUCCESS! Start server with: npm start
pause