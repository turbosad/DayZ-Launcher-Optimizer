@echo off
:: This batch file launches the PowerShell script with the necessary permissions.
:: It bypasses the default Windows Execution Policy restricted mode.

SET "scriptPath=%~dp0ClearDayZ.ps1"

if exist "%scriptPath%" (
    echo Launching DayZ Cleanup Utility...
    powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%scriptPath%"
) else (
    echo ERROR: ClearDayZ.ps1 not found in this folder!
    echo Please make sure both files are in the same directory.
    pause
)
pause