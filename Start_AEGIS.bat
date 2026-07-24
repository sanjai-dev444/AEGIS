@echo off
title Aegis Project Launcher
color 0A

echo ==========================================
echo        AEGIS PROJECT LAUNCHER
echo ==========================================
echo.

:: Check Python
python --version >nul 2>&1
if errorlevel 1 (
    echo [ERROR] Python is not installed or not in PATH.
    pause
    exit /b
)

:: Check Node.js
node --version >nul 2>&1
if errorlevel 1 (
    echo [ERROR] Node.js is not installed.
    pause
    exit /b
)

echo [OK] Python Found
echo [OK] Node.js Found
echo.

:: ----------------------------
:: Backend
:: ----------------------------
echo Preparing Backend...

cd backend

if not exist venv (
    echo Creating virtual environment...
    python -m venv venv
)

call venv\Scripts\activate

if not exist .deps_installed (
    echo Installing backend packages...
    pip install -r requirements.txt
    type nul > .deps_installed
)

echo Starting Backend...
start "Backend" cmd /k "call venv\Scripts\activate && python -m uvicorn app.main:app --reload"

timeout /t 8 >nul

echo Running Demo Seed...
python demo_seed.py

cd ..

:: ----------------------------
:: Dashboard
:: ----------------------------
echo Preparing Dashboard...

cd dashboard

if not exist node_modules (
    echo Installing Dashboard packages...
    npm install
)

echo Starting Dashboard...
start "Dashboard" cmd /k "npm run dev"

timeout /t 8 >nul

start http://localhost:5173

cd ..

:: ----------------------------
:: Client
:: ----------------------------
echo Preparing Client...

cd client

if not exist .deps_installed (
    echo Installing Client packages...
    pip install -r requirements.txt
    type nul > .deps_installed
)

echo Starting Client...
start "Client" cmd /k "python main.py"

cd ..

echo.
echo ==========================================
echo        PROJECT STARTED SUCCESSFULLY
echo ==========================================
echo.
echo Backend  : http://127.0.0.1:8000/docs
echo Dashboard: http://localhost:5173
echo.
pause