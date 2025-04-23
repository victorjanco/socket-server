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
)

:: Navigate to project directory
cd /d "c:\laragon\www\socket-server-main"

:: Install npm packages
echo Installing npm packages...
npm install
if %errorlevel% equ 0 (
    echo npm packages installed successfully.
) else (
    echo npm install failed. Please check your internet connection.
)

echo.
echo Setup complete! You can now start the server with: npm start
pause