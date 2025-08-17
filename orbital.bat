@echo off
setlocal EnableDelayedExpansion

REM MongoDB environment variables configuration
set MONGODB_URI=mongodb://localhost:27017/orbital-market
set NODE_ENV=development

REM Parameter verification
if "%1"=="/setup" goto setup
if "%1"=="/start" goto start
if "%1"=="/s" goto start
if "%1"=="/update_db" goto update_db
if "%1"=="/u" goto update_db
if "%1"=="/end" goto end
if "%1"=="/e" goto end
if "%1"=="/help" goto help
if "%1"=="/h" goto help
if "%1"=="" goto help

echo Invalid parameter: %1
goto help

:setup
echo Installing Playwright and Chromium...
pnpm --filter=@orbital-market/backend exec playwright install chromium
echo Installation completed.
goto end_script

:start
echo Starting OrbitalMarket...
echo Checking and freeing ports...
netstat -ano | findstr :3000 > nul
if !errorlevel! == 0 (
    echo Port 3000 in use, freeing...
    for /f "tokens=5" %%a in ('netstat -ano ^| findstr :3000') do taskkill /f /pid %%a 2>nul
)
netstat -ano | findstr :8080 > nul
if !errorlevel! == 0 (
    echo Port 8080 in use, freeing...
    for /f "tokens=5" %%a in ('netstat -ano ^| findstr :8080') do taskkill /f /pid %%a 2>nul
)
timeout /t 2 >nul
start "Backend" cmd /k "set MONGODB_URI=%MONGODB_URI% && set NODE_ENV=%NODE_ENV% && pnpm --filter=@orbital-market/backend dev"
timeout /t 3 >nul
start "Frontend" cmd /k "pnpm --filter=@orbital-market/frontend dev"
echo Application started - Frontend: http://localhost:8080
echo To stop servers, use Ctrl+C in each window
goto end_script

:update_db
echo Updating database from FAB...
set MONGODB_URI=%MONGODB_URI%
set NODE_ENV=%NODE_ENV%
pnpm --filter=@orbital-market/backend run api:fab-update
echo Database update completed.
goto end_script

:end
echo Stopping servers...
taskkill /f /im node.exe 2>nul
taskkill /f /im cmd.exe /fi "WINDOWTITLE eq Backend*" 2>nul
taskkill /f /im cmd.exe /fi "WINDOWTITLE eq Frontend*" 2>nul
echo Servers stopped.
goto end_script

:help
echo.
echo ===============================================
echo           OrbitalMarket - Management Script
echo ===============================================
echo.
echo Usage: orbital.bat [option]
echo.
echo Available options:
echo   /setup          Install Playwright and Chromium
echo   /start, /s      Start backend and frontend servers
echo   /update_db, /u  Update database from FAB
echo   /end, /e        Stop backend and frontend servers
echo   /help, /h       Show this help
echo.
echo Examples:
echo   orbital.bat /setup
echo   orbital.bat /start
echo   orbital.bat -u
echo   orbital.bat /end
echo.
goto end_script

:end_script
pause