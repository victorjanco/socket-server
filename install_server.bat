@echo off
echo Installing Node.js and setting up Socket Server...
echo.

:: Check if Node.js is already installed
where node >nul 2>&1
if %errorlevel% equ 0 (
    echo Node.js is already installed.
) else (
    echo Installing Node.js...
    
    :: Download Node.js (using bitsadmin if curl isn't available)
    bitsadmin /transfer "NodeDownload" /download /priority high ^
    https://nodejs.org/dist/v18.16.1/node-v18.16.1-x64.msi ^
    "%TEMP%\node-installer.msi"
    
    :: Install silently
    start /wait msiexec /i "%TEMP%\node-installer.msi" /quiet /norestart
    del "%TEMP%\node-installer.msi"
    
    :: Manually add to PATH (temporary for this session)
    set "PATH=%PATH%;%ProgramFiles%\nodejs"
    echo Node.js installation complete.
)

:: Verify npm
where npm >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] npm still not available. Possible solutions:
    echo 1. Restart your computer to update system PATH
    echo 2. Run this script as Administrator
    echo 3. Manually add "%ProgramFiles%\nodejs" to your PATH
    pause
    exit /b
)

:: Project directory setup
if not exist "c:\horno\socket-server\" (
    mkdir "c:\horno\socket-server"
)
cd /d "c:\horno\socket-server"

:: Install packages
echo Installing npm packages...
npm install
if %errorlevel% neq 0 (
    echo [ERROR] npm install failed. Check:
    echo - package.json exists in this directory
    echo - Internet connection is available
    echo - Run as Administrator if needed
    pause
    exit /b
)

echo.
echo SUCCESS! Start server with: npm start
pause