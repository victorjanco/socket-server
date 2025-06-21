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



echo.
echo SUCCESS! Start server with: npm start
pause