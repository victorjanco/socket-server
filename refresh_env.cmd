@echo off
:: This script refreshes environment variables from the registry
for /f "tokens=1,2,*" %%a in ('reg query "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment"') do (
    if /i "%%a"=="PATH" (
        set "PATH=%%c"
    )
)
for /f "tokens=1,2,*" %%a in ('reg query "HKCU\Environment"') do (
    if /i "%%a"=="PATH" (
        set "PATH=%%c;%PATH%"
    )
)