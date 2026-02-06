@echo off

:Menu
cls
echo.
echo ASCIImation 1.0 - (c) devffin 2026
echo ======================================
echo.
echo 1. Bombe
echo 2. Piece
echo 3. Donut
echo 4. DVD
echo 5. Terre
echo 6. Inde
echo 7. Maxwell
echo 8. Nyan Cat
echo 9. Perroquet
echo.
echo Page 1/2 (N) Suivant
echo ======================================
echo.
set /p choice=Choisissez une animation (1-9) ou 0 pour quitter:
if "%choice%"=="1" (
    echo Lancement de l'animation Bombe...
    echo Faites CTRL+C pour arreter l'animation.
    timeout /t 2 >nul
    echo curl ascii.live/bomb > tempanimation.bat
    call tempanimation.bat
    del tempanimation.bat
    goto Menu
)
if "%choice%"=="2" (
    echo Lancement de l'animation Piece...
    echo Faites CTRL+C pour arreter l'animation.
    timeout /t 2 >nul
    echo curl ascii.live/coin > tempanimation.bat
    call tempanimation.bat
    del tempanimation.bat
    goto Menu
)
if "%choice%"=="3" (
    echo Lancement de l'animation Donut...
    echo Faites CTRL+C pour arreter l'animation.
    timeout /t 2 >nul
    echo curl ascii.live/donut > tempanimation.bat
    call tempanimation.bat
    del tempanimation.bat
    goto Menu
)
if "%choice%"=="4" (
    echo Lancement de l'animation DVD...
    echo Faites CTRL+C pour arreter l'animation.
    timeout /t 2 >nul
    echo curl ascii.live/dvd > tempanimation.bat
    call tempanimation.bat
    del tempanimation.bat
    goto Menu
)
if "%choice%"=="5" (
    echo Lancement de l'animation Terre...
    echo Faites CTRL+C pour arreter l'animation.
    timeout /t 2 >nul
    echo curl ascii.live/earth > tempanimation.bat
    call tempanimation.bat
    del tempanimation.bat
    goto Menu
)
if "%choice%"=="6" (
    echo Lancement de l'animation Inde...
    echo Faites CTRL+C pour arreter l'animation.
    timeout /t 2 >nul
    echo curl ascii.live/india > tempanimation.bat
    call tempanimation.bat
    del tempanimation.bat
    goto Menu
)
if "%choice%"=="7" (
    echo Lancement de l'animation Maxwell...
    echo Faites CTRL+C pour arreter l'animation.
    timeout /t 2 >nul
    echo curl ascii.live/maxwell > tempanimation.bat
    call tempanimation.bat
    del tempanimation.bat
    goto Menu
)
if "%choice%"=="8" (
    echo Lancement de l'animation Nyan Cat...
    echo Faites CTRL+C pour arreter l'animation.
    timeout /t 2 >nul
    echo curl ascii.live/nyan > tempanimation.bat
    call tempanimation.bat
    del tempanimation.bat
    goto Menu
)
if "%choice%"=="9" (
    echo Lancement de l'animation Perroquet...
    echo Faites CTRL+C pour arreter l'animation.
    timeout /t 2 >nul
    echo curl ascii.live/parrot > tempanimation.bat
    call tempanimation.bat
    del tempanimation.bat
    goto Menu
)
if "%choice%"=="0" (
    echo Merci d'avoir utilise ASCIImation. Au revoir!
    timeout /t 2 >nul
    exit /b
)
if /i "%choice%"=="N" goto Menu2
goto Menu

:Menu2
cls
echo.
echo ASCIImation 1.0 - (c) devffin 2026
echo ======================================
echo.
echo 10. Rickroll
echo.
echo Animations : ascii.live
echo Page 2/2 (P) Précédent
echo ======================================
echo.
set /p choice=Choisissez une animation (10) ou 0 pour quitter:
if "%choice%"=="10" (
    echo Lancement de l'animation Rickroll...
    echo Faites CTRL+C pour arreter l'animation.
    timeout /t 2 >nul
    echo curl ascii.live/rick > tempanimation.bat
    call tempanimation.bat
    del tempanimation.bat
    goto Menu2
)
if "%choice%"=="0" (
    echo Merci d'avoir utilise ASCIImation. Au revoir!
    timeout /t 2 >nul
    exit /b
)
if /i "%choice%"=="P" goto Menu
goto Menu2