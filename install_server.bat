@echo off
echo Installing Node.js and setting up Socket Server...
echo.

:: Check if Node.js is already installed
node -v >nul 2>&1
if %errorlevel% equ 0 (
    echo Node.js is already installed.
) else (
    echo Installing Node.js...
    :: Download and install Node.js
    curl -o node-installer.msi https://nodejs.org/dist/v18.16.1/node-v18.16.1-x64.msi
    start /wait msiexec /i node-installer.msi /quiet /norestart
    del node-installer.msi
    echo Node.js installation complete.
    
    :: Refresh environment variables
    call refresh_env.cmd
)

:: Check if npm is available
npm -v >nul 2>&1
if %errorlevel% neq 0 (
    echo npm is not available in PATH. Trying to fix...
    :: Add Node.js to PATH
    setx PATH "%PATH%;%ProgramFiles%\nodejs\"
    echo Please restart this script in a new command prompt.
    pause
    exit /b
)

:: Navigate to project directory
cd /d "c:\horno\socket-server" 2>nul || (
    echo Directory c:\horno\socket-server does not exist. Creating...
    mkdir "c:\horno\socket-server"
    cd /d "c:\horno\socket-server"
)

:: Install npm packages
echo Installing npm packages...
npm install
if %errorlevel% equ 0 (
    echo npm packages installed successfully.
) else (
    echo npm install failed. Please check:
    echo 1. Your internet connection
    echo 2. That package.json exists in the directory
)

echo.
echo Setup complete! You can now start the server with: npm start
pause