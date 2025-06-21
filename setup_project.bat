@echo off
:: npm_verification_and_setup.bat
:: Standalone script for npm verification and project initialization

echo Verifying npm and setting up project...
echo.

:: ==============================================
:: NPM VERIFICATION SECTION
:: ==============================================

:: First try with default PATH
npm -v >nul 2>&1
if %errorlevel% equ 0 (
    echo npm is available in PATH.
    goto PROJECT_SETUP
)

:: Try with explicit Program Files path
"%ProgramFiles%\nodejs\npm" -v >nul 2>&1
if %errorlevel% equ 0 (
    echo Found npm in Program Files.
    set "PATH=%PATH%;%ProgramFiles%\nodejs"
    goto PROJECT_SETUP
)

:: Check alternative install location
if exist "%LocalAppData%\Programs\nodejs\npm.cmd" (
    echo Found npm in Local AppData.
    set "PATH=%PATH%;%LocalAppData%\Programs\nodejs"
    goto PROJECT_SETUP
)

:: Final error if all checks fail
echo [ERROR] npm could not be found. Solutions:
echo 1. RESTART YOUR COMPUTER (required after Node.js installation)
echo 2. Manually verify Node.js installation:
echo    - Check if this folder exists: "C:\Program Files\nodejs"
echo    - If missing, reinstall Node.js
echo 3. Add to PATH manually:
echo    - Win+R → sysdm.cpl → Advanced → Environment Variables
echo    - Edit Path → Add: "C:\Program Files\nodejs"
pause
exit /b

:: ==============================================
:: PROJECT SETUP SECTION
:: ==============================================
:PROJECT_SETUP

:: Create project directory if missing
if not exist "c:\horno\socket-server\" (
    echo Creating project directory...
    mkdir "c:\horno\socket-server"
)

:: Navigate to project
cd /d "c:\horno\socket-server" || (
    echo [ERROR] Failed to access project directory
    pause
    exit /b
)

:: Install packages
echo Installing npm packages...
call npm install
if %errorlevel% neq 0 (
    echo [ERROR] npm install failed. Possible causes:
    echo - Missing package.json in "c:\horno\socket-server"
    echo - No internet connection
    echo - Permission issues (try running as Admin)
    pause
    exit /b
)

echo.
echo Project setup complete! Start with: npm start
pause