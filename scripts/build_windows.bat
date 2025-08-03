@echo off
setlocal enabledelayedexpansion
title Stockify Build & Package Script 🚀

echo.
echo ╔══════════════════════════════════════════════════════════════╗
echo ║                    🏭 Stockify Builder 🏭                    ║
echo ║              Building your awesome app! 🎯                   ║
echo ╚══════════════════════════════════════════════════════════════╝
echo.   

:: Get current directory and show it
set "SCRIPT_DIR=%~dp0"
echo 📍 Script starting from: %SCRIPT_DIR%
cd /d "%SCRIPT_DIR%"

echo 📋 Starting build process...
echo ⏰ %date% %time%
echo.

:: Step 1: Build Flutter App
echo ═══════════════════════════════════════════════════════════════
echo 🦋 STEP 1: Building Flutter Windows App (Release)
echo ═══════════════════════════════════════════════════════════════
echo.

if not exist "..\stockify_app_flutter" (
    echo ❌ Error: Flutter app directory not found!
    echo    Expected: ..\stockify_app_flutter
    pause
    exit /b 1
)

cd ..\stockify_app_flutter
echo 📍 Current directory: %CD%

echo 📦 Running flutter build windows --release...
echo 🔄 This may take a while, please wait...

:: Use cmd /c to ensure proper command execution
cmd /c "flutter build windows --release"
set "FLUTTER_EXIT_CODE=%ERRORLEVEL%"

echo.
echo 🔍 Flutter command completed with exit code: %FLUTTER_EXIT_CODE%

if %FLUTTER_EXIT_CODE% neq 0 (
    echo ❌ Flutter build failed with exit code: %FLUTTER_EXIT_CODE%
    echo 💡 Make sure Flutter is installed and in your PATH
    pause
    exit /b 1
)

echo ✅ Flutter build completed successfully! 🎉
echo 🔍 Checking if Stockify.exe was created...
if exist "build\windows\x64\runner\Release\Stockify.exe" (
    echo ✅ Found Stockify.exe - Flutter build successful!
) else (
    echo ❌ Stockify.exe not found - something went wrong
    dir "build\windows\x64\runner\Release\" 2>nul
    pause
    exit /b 1
)

echo 📍 Flutter build step completed!
echo 🔄 Continuing to next step in 2 seconds...
timeout /t 2 /nobreak >nul

echo 📍 Returning to script directory: %SCRIPT_DIR%

:: Step 2: Build Go Backend
echo ═══════════════════════════════════════════════════════════════
echo 🐹 STEP 2: Building Go Backend DLL
echo ═══════════════════════════════════════════════════════════════
echo.

echo 🔄 Changing to script directory: %SCRIPT_DIR%
cd /d "%SCRIPT_DIR%"
echo 📍 Current directory: %CD%
if not exist "..\stockify_backend_golang" (
    echo ❌ Error: Go backend directory not found!
    echo    Expected: ..\stockify_backend_golang
    pause
    exit /b 1
)

cd ..\stockify_backend_golang
echo 📍 Current directory: %CD%

echo 🔧 Setting Go environment variables...
set GOOS=windows
set GOARCH=amd64
set CGO_ENABLED=1

echo 📦 Building Go shared library...
echo 🔍 Looking for ./src directory...
if not exist "src" (
    echo ❌ Error: src directory not found in Go backend!
    echo 📍 Current location: %CD%
    echo 📂 Available directories:
    dir /ad
    pause
    exit /b 1
)

echo ✅ Found src directory, building DLL...
cmd /c "go build -buildmode=c-shared -o libinventory.dll ./src"
set "GO_EXIT_CODE=%ERRORLEVEL%"

echo.
echo 🔍 Go build completed with exit code: %GO_EXIT_CODE%

if %GO_EXIT_CODE% neq 0 (
    echo ❌ Go build failed with exit code: %GO_EXIT_CODE%
    echo 💡 Make sure Go is installed and CGO is properly configured
    pause
    exit /b 1
)

echo ✅ Go DLL build completed successfully! 🎉
echo 🔍 Checking if DLL files were created...
if exist "libinventory.dll" (echo ✅ Found libinventory.dll) else (echo ❌ Missing libinventory.dll)
if exist "libinventory.h" (echo ✅ Found libinventory.h) else (echo ❌ Missing libinventory.h)
echo.

:: Step 3: Move DLL files
echo ═══════════════════════════════════════════════════════════════
echo 📂 STEP 3: Moving DLL files to Flutter release folder
echo ═══════════════════════════════════════════════════════════════
echo.

set "FLUTTER_RELEASE_DIR=..\stockify_app_flutter\build\windows\x64\runner\Release"

if not exist "%FLUTTER_RELEASE_DIR%" (
    echo ❌ Error: Flutter release directory not found!
    echo    Expected: %FLUTTER_RELEASE_DIR%
    pause
    exit /b 1
)

echo 🚚 Moving libinventory.dll...
if exist "libinventory.dll" (
    copy /Y "libinventory.dll" "%FLUTTER_RELEASE_DIR%\"
    echo ✅ libinventory.dll moved successfully!
) else (
    echo ❌ libinventory.dll not found!
    pause
    exit /b 1
)

echo 🚚 Moving libinventory.h...
if exist "libinventory.h" (
    copy /Y "libinventory.h" "%FLUTTER_RELEASE_DIR%\"
    echo ✅ libinventory.h moved successfully!
) else (
    echo ❌ libinventory.h not found!
    pause
    exit /b 1
)

echo.

:: Step 4: Read version from pubspec.yaml
echo ═══════════════════════════════════════════════════════════════
echo 📖 STEP 4: Reading version from pubspec.yaml
echo ═══════════════════════════════════════════════════════════════
echo.

cd /d "%SCRIPT_DIR%"
cd ..\stockify_app_flutter

set "APP_VERSION="
for /f "tokens=2 delims=: +" %%a in ('findstr "version:" pubspec.yaml') do (
    set "APP_VERSION=%%a"
    goto :version_found
)

:version_found
if "%APP_VERSION%"=="" (
    echo ❌ Could not read version from pubspec.yaml
    set "APP_VERSION=1.0.0"
    echo 💡 Using default version: %APP_VERSION%
) else (
    echo ✅ Found version: %APP_VERSION%
)
echo.

:: Step 5: Create/Update Inno Setup Script
echo ═══════════════════════════════════════════════════════════════
echo 📝 STEP 5: Creating Inno Setup Script
echo ═══════════════════════════════════════════════════════════════
echo.

cd /d "%SCRIPT_DIR%"

:: Create dist directory if it doesn't exist
if not exist "..\dist" mkdir "..\dist"

:: Create Inno Setup script
echo 🎨 Generating Inno Setup script...

(
echo #define MyAppName "Stockify"
echo #define MyAppVersion "%APP_VERSION%"
echo #define MyAppPublisher "defUserName-404"
echo #define MyAppExeName "Stockify.exe"
echo.
echo [Setup]
echo AppName={#MyAppName}
echo AppVersion={#MyAppVersion}
echo AppPublisher={#MyAppPublisher}
echo DefaultDirName={autopf}\{#MyAppName}
echo DefaultGroupName={#MyAppName}
echo AllowNoIcons=yes
echo LicenseFile=
echo OutputDir=..\dist
echo OutputBaseFilename=Stockify-Setup-{#MyAppVersion}
echo SetupIconFile=
echo Compression=lzma
echo SolidCompression=yes
echo WizardStyle=modern
echo.
echo [Languages]
echo Name: "english"; MessagesFile: "compiler:Default.isl"
echo.
echo [Tasks]
echo Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked
echo.
echo [Files]
echo Source: "..\stockify_app_flutter\build\windows\x64\runner\Release\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs
echo Source: "..\stockify_app_flutter\build\windows\x64\runner\Release\libinventory.dll"; DestDir: "{app}"; Flags: ignoreversion
echo Source: "..\stockify_app_flutter\build\windows\x64\runner\Release\libinventory.h"; DestDir: "{app}"; Flags: ignoreversion
echo.
echo [Icons]
echo Name: "{group}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"
echo Name: "{group}\{cm:UninstallProgram,{#MyAppName}}"; Filename: "{uninstallexe}"
echo Name: "{autodesktop}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; Tasks: desktopicon
echo.
echo [Run]
echo Filename: "{app}\{#MyAppExeName}"; Description: "{cm:LaunchProgram,{#MyAppName}}"; Flags: nowait postinstall skipifsilent
echo.
echo [UninstallDelete]
echo Type: filesandordirs; Name: "{userappdata}\Stockify"
echo.
echo [Code]
echo var
echo   DataDirPage: TInputOptionWizardPage;
echo.
echo procedure InitializeUninstallProgressForm^(^);
echo begin
echo   if MsgBox^('Do you want to delete all user data? This will remove all your Stockify settings and data.', mbConfirmation, MB_YESNO^) = IDYES then
echo   begin
echo     DelTree^(ExpandConstant^('{userappdata}\Stockify'^), True, True, True^);
echo   end;
echo end;
) > stockify_installer.iss

echo ✅ Inno Setup script created successfully!
echo.

:: Step 6: Run Inno Setup
echo ═══════════════════════════════════════════════════════════════
echo 🎁 STEP 6: Building Installer with Inno Setup
echo ═══════════════════════════════════════════════════════════════
echo.

echo 🔨 Compiling installer...
echo 💡 Looking for Inno Setup Compiler...

:: Try to find Inno Setup compiler
set "INNO_COMPILER="
if exist "C:\Program Files (x86)\Inno Setup 6\ISCC.exe" (
    set "INNO_COMPILER=C:\Program Files (x86)\Inno Setup 6\ISCC.exe"
) else if exist "C:\Program Files\Inno Setup 6\ISCC.exe" (
    set "INNO_COMPILER=C:\Program Files\Inno Setup 6\ISCC.exe"
) else if exist "D:\Inno Setup 6\ISCC.exe" (
    set "INNO_COMPILER=D:\Inno Setup 6\ISCC.exe"
) else (
    echo ❌ Inno Setup compiler not found!
    echo 💡 Please install Inno Setup 6 from https://jrsoftware.org/isinfo.php
    echo 📂 Script created at: stockify_installer.iss
    echo 🎯 You can compile it manually when Inno Setup is installed
    pause
    exit /b 1
)

echo ✅ Found Inno Setup at: %INNO_COMPILER%
echo 🚀 Compiling installer...

"%INNO_COMPILER%" stockify_installer.iss
if errorlevel 1 (
    echo ❌ Installer compilation failed!
    pause
    exit /b 1
) else (
    del stockify_installer.iss
)

echo.
echo ╔══════════════════════════════════════════════════════════════╗
echo ║                    🎉 BUILD COMPLETE! 🎉                    ║
echo ╚══════════════════════════════════════════════════════════════╝
echo.
echo ✅ Flutter app built successfully
echo ✅ Go DLL compiled and moved
echo ✅ Installer created with version %APP_VERSION%
echo 📦 Installer location: ..\dist\Stockify-Setup-%APP_VERSION%.exe
echo.
echo 🚀 Your Stockify installer is ready to deploy!
echo 💾 The installer includes automatic user data cleanup on uninstall
echo.
echo ⏰ Build completed at: %date% %time%
echo.