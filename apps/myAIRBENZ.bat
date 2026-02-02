@echo off
setlocal enabledelayedexpansion
chcp 65001 >nul

:menu
cls
echo.
echo ====================================================
echo Bienvenue sur myAIRBENZ!
echo L'appli de la communaute retro
echo ====================================================
echo.
echo ====================================================
echo Actualites:
echo.
powershell -command "Invoke-WebRequest -Uri 'https://devffin.github.io/dl/ma-actus.txt' -OutFile '%temp%\actus.txt'" 2>nul
type "%temp%\actus.txt" 2>nul || echo Aucune actualité disponible.
del "%temp%\actus.txt" 2>nul
echo.
echo ====================================================
echo.
echo Appuyez sur une touche pour revenir au menu...
pause >nul
exit /b 0