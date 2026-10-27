@echo off
title Minion CPU Arena - Automated Tests
echo ========================================================
echo    RUNNING ROUND ROBIN SCHEDULER VERIFICATION TESTS
echo ========================================================
echo.

cd /d "%~dp0"
echo [1/3] Running Round Robin Scheduling Engine Tests...
java -cp bin test.RoundRobinSchedulerTest
if %ERRORLEVEL% NEQ 0 (
    pause
    exit /b 1
)

echo.
echo [2/3] Running Modern 3D Button Interaction Tests...
java -cp bin test.ButtonInteractiveTest
if %ERRORLEVEL% NEQ 0 (
    pause
    exit /b 1
)

echo.
echo [3/4] Running Java2D GUI and Rendering Smoke Tests...
java -cp bin test.GuiSmokeTest
if %ERRORLEVEL% NEQ 0 (
    pause
    exit /b 1
)

echo.
echo [4/4] Running Minion Facing and Movement Animation Tests...
java -cp bin test.MinionAnimationFacingTest
if %ERRORLEVEL% NEQ 0 (
    pause
    exit /b 1
)

echo.
echo ========================================================
echo    ALL TESTS COMPLETED SUCCESSFULLY WITH 100%% PASS RATE!
echo ========================================================
pause
