@echo off
cd /d "c:\laragon\www\socket-server"
echo Starting server in "%NODE_ENV%" mode...
:: Check environment
if "%NODE_ENV%"=="production" (
    echo Starting server in PRODUCTION mode...
) else if "%NODE_ENV%"=="development" (
    echo Starting server in DEVELOPMENT mode...
) else (
    echo NODE_ENV is not set. Defaulting to DEVELOPMENT mode...
    set NODE_ENV=development
)

:: Start the server with the correct environment
set NODE_ENV=%NODE_ENV%&& npm start
pause