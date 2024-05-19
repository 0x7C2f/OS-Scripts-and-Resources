@echo off
echo This script will completely remove OneDrive from your system.
echo.
echo Press any key to continue...
pause > nul

:: Check for admin rights
openfiles >nul 2>&1
if %errorlevel% NEQ 0 (
    echo Please run this script as an administrator.
    pause
    exit /B
)

:: Uninstall OneDrive
echo Uninstalling OneDrive...
if exist %SystemRoot%\System32\OneDriveSetup.exe (
    %SystemRoot%\System32\OneDriveSetup.exe /uninstall
) else (
    echo %SystemRoot%\System32\OneDriveSetup.exe not found.
)
if exist %SystemRoot%\SysWOW64\OneDriveSetup.exe (
    %SystemRoot%\SysWOW64\OneDriveSetup.exe /uninstall
) else (
    echo %SystemRoot%\SysWOW64\OneDriveSetup.exe not found.
)
echo OneDrive uninstalled (if it was installed).

:: Wait for the uninstallation to complete
timeout /t 5 /nobreak > nul

:: Remove OneDrive directories
echo Removing OneDrive folders...
if exist "%UserProfile%\OneDrive" rd "%UserProfile%\OneDrive" /Q /S
if exist "%LocalAppData%\Microsoft\OneDrive" rd "%LocalAppData%\Microsoft\OneDrive" /Q /S
if exist "%LocalAppData%\Microsoft\OneDriveSetup" rd "%LocalAppData%\Microsoft\OneDriveSetup" /Q /S
if exist "%AppData%\Microsoft\OneDrive" rd "%AppData%\Microsoft\OneDrive" /Q /S

:: Remove OneDrive registry keys
echo Removing OneDrive registry entries...
reg delete "HKEY_CLASSES_ROOT\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}" /f > nul 2>&1
reg delete "HKEY_CLASSES_ROOT\CLSID\{BBACC218-34EA-4666-9D7A-C78F2274A524}" /f > nul 2>&1
reg delete "HKEY_CLASSES_ROOT\Wow6432Node\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}" /f > nul 2>&1
reg delete "HKEY_CLASSES_ROOT\Wow6432Node\CLSID\{BBACC218-34EA-4666-9D7A-C78F2274A524}" /f > nul 2>&1
reg delete "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Run" /v OneDrive /f > nul 2>&1

:: Remove OneDrive Group Policy settings
echo Disabling OneDrive Group Policy settings...
reg add "HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\OneDrive" /v DisableFileSyncNGSC /t REG_DWORD /d 1 /f > nul 2>&1

:: Remove OneDrive context menu handlers
echo Removing OneDrive context menu entries...
reg delete "HKEY_CLASSES_ROOT\*\shellex\ContextMenuHandlers\OneDrive" /f > nul 2>&1
reg delete "HKEY_CLASSES_ROOT\Directory\shellex\ContextMenuHandlers\OneDrive" /f > nul 2>&1

:: Clean up the system
echo Cleaning up...
taskkill /f /im explorer.exe > nul 2>&1
start explorer.exe

echo OneDrive has been completely removed from your system (if it was present).
echo.
echo Press any key to exit...
pause > nul
