@echo off
title Minion CPU Arena - Round Robin Simulator
echo ========================================================
echo    MINION CPU ARENA - ROUND ROBIN SCHEDULING SIMULATOR
echo ========================================================
echo.

cd /d "%~dp0"

REM Check if bin directory exists, if not compile
if not exist "bin\Main.class" (
    echo [INFO] Compiling Java source files...
    if not exist "bin" mkdir "bin"
    javac --release 17 -d bin src\model\*.java src\engine\*.java src\ui\*.java src\controller\*.java src\test\*.java src\Main.java 2>nul
    if %ERRORLEVEL% NEQ 0 (
        javac -d bin src\model\*.java src\engine\*.java src\ui\*.java src\controller\*.java src\test\*.java src\Main.java
    )
    if %ERRORLEVEL% NEQ 0 (
        echo [ERROR] Compilation failed!
        pause
        exit /b 1
    )
    echo [INFO] Compilation successful!
)

echo [INFO] Launching Minion CPU Arena GUI...
start javaw -cp bin Main
exit /b 0
