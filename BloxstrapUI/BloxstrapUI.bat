:: BloxstrapUI.bat

:: I'm not very experienced with making .bat files, so if you encounter any errors, please create an issue on: https://github.com/fr0st-iwnl/kiyokomacro/issues
:: If you want to help and know how to work with .bat files, you can create a pull request at https://github.com/fr0st-iwnl/kiyokomacro/pulls

@echo off

for /F %%A in ('echo prompt $E ^| cmd') do set "ESC=%%A"

:: color codes
set "COLOR_RESET=%ESC%[0m"
set "COLOR_GREEN=%ESC%[32m"
set "COLOR_YELLOW=%ESC%[33m"
set "COLOR_RED=%ESC%[31m"
set "COLOR_BLUE=%ESC%[34m"
set "COLOR_CYAN=%ESC%[36m"

:: main menu
:menu
cls
echo %COLOR_CYAN%[MAIN MENU]%COLOR_RESET%
echo.
echo %COLOR_YELLOW%1. [Bloxstrap] Install/Modify/Uninstall%COLOR_RESET%
echo %COLOR_YELLOW%2. Exit%COLOR_RESET%
set /p choice="Select an option (1-2): "

if "%choice%"=="" (
    echo %COLOR_RED%You must select an option.%COLOR_RESET%
    pause
    goto menu
)

if "%choice%"=="1" (
    call :bloxstrap_options
    goto menu
) else if "%choice%"=="2" (
    echo %COLOR_GREEN%Exiting...%COLOR_RESET%
    exit
) else (
    echo %COLOR_RED%Invalid choice. Please enter 1 or 2.%COLOR_RESET%
    pause
    goto menu
)

:bloxstrap_options
cls
echo %COLOR_CYAN%[Bloxstrap Options]%COLOR_RESET%
echo.
echo %COLOR_YELLOW%1. Install Bloxstrap%COLOR_RESET%
echo %COLOR_YELLOW%2. Modify ClientAppSettings.json [REVERT TO OLD UI]%COLOR_RESET%
echo %COLOR_YELLOW%3. Modify ClientAppSettings.json [REVERT TO NEW UI]%COLOR_RESET%
echo %COLOR_YELLOW%4. Uninstall Bloxstrap%COLOR_RESET%
echo %COLOR_YELLOW%5. Back to Main Menu%COLOR_RESET%
set /p bloxstrap_choice="Select an option (1-5): "

if "%bloxstrap_choice%"=="" (
    echo %COLOR_RED%You must select an option.%COLOR_RESET%
    pause
    goto bloxstrap_options
)

if "%bloxstrap_choice%"=="1" (
    call :install_bloxstrap
) else if "%bloxstrap_choice%"=="2" (
    call :modify_bloxstrap_settings_old_ui
) else if "%bloxstrap_choice%"=="3" (
    call :modify_bloxstrap_settings_new_ui
) else if "%bloxstrap_choice%"=="4" (
    call :uninstall_bloxstrap
) else if "%bloxstrap_choice%"=="5" (
    goto menu
) else (
    echo %COLOR_RED%Invalid choice. Please enter 1, 2, 3, 4, or 5.%COLOR_RESET%
    pause
    goto bloxstrap_options
)

goto bloxstrap_options

:: install bloxstrap
:install_bloxstrap
set "bloxstrapPath=C:\Users\%USERNAME%\AppData\Local\Bloxstrap"

if exist "%bloxstrapPath%" (
    echo %COLOR_BLUE%Bloxstrap is already installed.%COLOR_RESET%
) else (
    if not exist "%TEMP%\BloxstrapInstaller.exe" (
    echo %COLOR_CYAN%Downloading the latest version of Bloxstrap...%COLOR_RESET%
    powershell -Command ^
        "$release = Invoke-RestMethod -Uri 'https://api.github.com/repos/bloxstraplabs/bloxstrap/releases/latest';" ^
        "$downloadUrl = $release.assets | Where-Object { $_.name -match '.*.exe$' } | Select-Object -First 1 -ExpandProperty browser_download_url;" ^
        "Invoke-WebRequest -Uri $downloadUrl -OutFile '%TEMP%\\BloxstrapInstaller.exe';"
    )

    if exist "%TEMP%\BloxstrapInstaller.exe" (
    echo %COLOR_GREEN%Installing Bloxstrap...%COLOR_RESET%
    powershell -Command "Start-Process -FilePath '%TEMP%\\BloxstrapInstaller.exe' -ArgumentList '/S' -Wait"
    echo %COLOR_GREEN%Installation of Bloxstrap completed.%COLOR_RESET%
    del "%TEMP%\BloxstrapInstaller.exe" /Q
    ) else (
    echo %COLOR_RED%Failed to download Bloxstrap installer.%COLOR_RESET%
    )

)
pause
goto bloxstrap_options

:modify_bloxstrap_settings_old_ui
set "settingsPath=C:\Users\%USERNAME%\AppData\Local\Bloxstrap\Modifications\ClientSettings\ClientAppSettings.json"
call :modify_json_setting "False"
goto bloxstrap_options

:modify_bloxstrap_settings_new_ui
set "settingsPath=C:\Users\%USERNAME%\AppData\Local\Bloxstrap\Modifications\ClientSettings\ClientAppSettings.json"
call :modify_json_setting "True"
goto bloxstrap_options

:modify_json_setting
set "setting_value=%~1"
set waitTime=0
echo %COLOR_YELLOW%Waiting for ClientAppSettings.json to be created...%COLOR_RESET%

:waitloop
if exist "%settingsPath%" (
    echo %COLOR_GREEN%ClientAppSettings.json found. Proceeding with modification...%COLOR_RESET%
    goto modifyJson
)

timeout /t 5 >nul
set /a waitTime+=5
if %waitTime% GEQ 30 (
    echo %COLOR_RED%ClientAppSettings.json was not found after 30 seconds.%COLOR_RESET%
    pause
    goto bloxstrap_options
)
goto waitloop

:modifyJson
powershell -Command ^
    "$settingsPath = '%settingsPath%'; " ^
    "$jsonContent = Get-Content -Path $settingsPath -Raw -ErrorAction SilentlyContinue; " ^
    "if ($jsonContent -eq $null -or $jsonContent.Trim() -eq '') { " ^
    "    Write-Output '%COLOR_YELLOW%ClientAppSettings.json is empty or missing. Creating new JSON structure...%COLOR_RESET%'; " ^
    "    $newJson = @{ 'FFlagEnableInGameMenuChromeABTest4' = '%setting_value%' }; " ^
    "    $newJson | ConvertTo-Json -Depth 10 | Set-Content -Path $settingsPath -Force; " ^
    "    Write-Output '%COLOR_GREEN%ClientAppSettings.json has been created with the new setting.%COLOR_RESET%' " ^
    "} else { " ^
    "    try { " ^
    "        $json = $jsonContent | ConvertFrom-Json; " ^
    "        if (-not $json.PSObject.Properties.Match('FFlagEnableInGameMenuChromeABTest4')) { " ^
    "            $json | Add-Member -MemberType NoteProperty -Name 'FFlagEnableInGameMenuChromeABTest4' -Value '%setting_value%'; " ^
    "        } else { " ^
    "            $json.FFlagEnableInGameMenuChromeABTest4 = '%setting_value%'; " ^
    "        } " ^
    "        $json | ConvertTo-Json -Depth 10 | Set-Content -Path $settingsPath -Force; " ^
    "        Write-Output '%COLOR_YELLOW%ClientAppSettings.json has been updated with the new setting.%COLOR_RESET%' " ^
    "    } catch { " ^
    "        Write-Output '%COLOR_RED%The JSON file is malformed. Reinitializing the file with correct structure.%COLOR_RESET%'; " ^
    "        $newJson = @{ 'FFlagEnableInGameMenuChromeABTest4' = '%setting_value%' }; " ^
    "        $newJson | ConvertTo-Json -Depth 10 | Set-Content -Path $settingsPath -Force; " ^
    "        Write-Output '%COLOR_GREEN%ClientAppSettings.json has been reinitialized with the new setting.%COLOR_RESET%' " ^
    "    } " ^
    "}"

echo %COLOR_GREEN%Modification of ClientAppSettings.json complete.%COLOR_RESET%
pause
goto bloxstrap_options

:uninstall_bloxstrap
set "bloxstrapPath=C:\Users\%USERNAME%\AppData\Local\Bloxstrap"
set "desktopShortcut=%USERPROFILE%\Desktop\Bloxstrap.lnk"
set "startMenuShortcut=%APPDATA%\Microsoft\Windows\Start Menu\Programs\Bloxstrap.lnk"

:: Check if Bloxstrap is running
tasklist /FI "IMAGENAME eq Bloxstrap.exe" | find /I "Bloxstrap.exe" >nul
if %errorlevel%==0 (
    echo %COLOR_RED%Bloxstrap is currently running. Please close it and try again.%COLOR_RESET%
    pause
    goto bloxstrap_options
)

if exist "%bloxstrapPath%" (
    echo %COLOR_RED%Uninstalling Bloxstrap...%COLOR_RESET%
    rmdir /S /Q "%bloxstrapPath%"
    echo %COLOR_RED%Bloxstrap has been uninstalled.%COLOR_RESET%
    
    if exist "%desktopShortcut%" (
        del "%desktopShortcut%"
        echo %COLOR_RED%Shortcut has been removed.%COLOR_RESET%
    ) else (
        echo %COLOR_BLUE%No Bloxstrap shortcut found on Desktop.%COLOR_RESET%
    )

    if exist "%startMenuShortcut%" (
    del "%startMenuShortcut%"
    echo %COLOR_RED%Shortcut has been removed from Start Menu.%COLOR_RESET%
) else (
    echo %COLOR_BLUE%No Bloxstrap shortcut found in Start Menu.%COLOR_RESET%
)

    
    reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Uninstall\Bloxstrap" /f >nul 2>&1
    reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Bloxstrap" /f >nul 2>&1
    echo %COLOR_RED%Registry entries removed.%COLOR_RESET%
    
) else (
    echo %COLOR_BLUE%Bloxstrap is not installed.%COLOR_RESET%
)

pause
goto bloxstrap_options
