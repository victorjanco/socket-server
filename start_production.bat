@echo off
set NODE_ENV=production
c:\laragon\www\socket-server\start_server.bat || (
    echo Error occurred while starting the server.
    pause
    exit /b 1
)
pause