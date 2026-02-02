@echo off
setlocal enabledelayedexpansion
chcp 65001 >nul

REM Configuration
set "API_KEY=e0b7a0b97ab5b2c36b1f2e3d4c5a6b7f"
set "CONFIG_FILE=%~dp0meteo_config.txt"

REM Charger la ville mémorisée
set "CITY=Paris"
if exist "%CONFIG_FILE%" (
    for /f "delims=" %%a in ('type "%CONFIG_FILE%"') do (
        set "CITY=%%a"
    )
)

:MENU
cls
echo.
echo =============================================
echo           SYSTEME DE METEO EN LIGNE
echo =============================================
echo.
echo Ville actuelle: %CITY%
echo.
echo 1. Voir la meteo pour %CITY%
echo 2. Changer de ville
echo 3. Quitter
echo.
set /p "CHOICE=Choisissez une option (1-3): "

if "%CHOICE%"=="1" goto METEO
if "%CHOICE%"=="2" goto CHANGECITY
if "%CHOICE%"=="3" goto END
echo.
echo Option invalide!
timeout /t 2 >nul
goto MENU

:CHANGECITY
cls
echo.
echo ====================================
echo           CHANGER DE VILLE
echo ====================================
echo.
echo Villes populaires: Paris, Lyon, Marseille, Toulouse, Nice, Bordeaux
echo.
set /p "NEWCITY=Entrez le nom de la ville: "

if "%NEWCITY%"=="" (
    echo Nom vide, retour au menu...
    timeout /t 2 >nul
    goto MENU
)

REM Vérifier que la ville existe
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0meteo_check.ps1" "%NEWCITY%" "%API_KEY%"

if !errorlevel! equ 0 (
    echo %NEWCITY%> "%CONFIG_FILE%"
    set "CITY=%NEWCITY%"
    echo.
    echo Ville sauvegardee!
    timeout /t 2 >nul
    goto MENU
) else (
    echo.
    echo Appuyez sur une touche...
    pause >nul
    goto CHANGECITY
)

:METEO
cls
echo.
echo =============================================
echo           SYSTEME DE METEO EN LIGNE
echo =============================================
echo.
echo Recuperation des donnees meteo pour: %CITY%
echo.

REM Appel API via PowerShell
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0meteo_get.ps1" "%CITY%" "%API_KEY%"

echo.
echo ===============================================
echo Appuyez sur une touche pour revenir au menu...
pause >nul
goto MENU

:END
echo.
echo Au revoir!
echo.