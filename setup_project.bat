@echo off
:: Script optimizado para instalar dependencias npm
:: Versión 1.1 - Corregido y mejorado

:: 1. Verificar Node.js instalado
where node >nul 2>&1 || (
    echo [ERROR] Node.js no está instalado o no está en el PATH
    echo Descargue Node.js desde: https://nodejs.org/
    pause
    exit /b 1
)

:: 2. Verificar directorio del proyecto
cd /d "c:\horno\socket-server" 2>nul || (
    echo [ERROR] Directorio no encontrado: c:\horno\socket-server
    echo Cree el directorio primero o verifique la ruta
    pause
    exit /b 1
)

:: 3. Verificar package.json
if not exist "package.json" (
    echo [ERROR] No se encontró package.json en el directorio
    echo Ejecute 'npm init' primero o copie un package.json válido
    pause
    exit /b 1
)

:: 4. Instalar dependencias
echo [INFO] Instalando dependencias con npm...
npm install

if errorlevel 1 (
    echo [ERROR] Fallo en npm install
    echo Posibles soluciones:
    echo 1. Verifique su conexión a internet
    echo 2. Ejecute como Administrador
    echo 3. Elimine node_modules e intente nuevamente
    pause
    exit /b 1
)

echo [ÉXITO] Dependencias instaladas correctamente
echo Directorio: %CD%
echo.
pause