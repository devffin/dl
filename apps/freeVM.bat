@echo off
chcp 65001 >nul

:menu
cls
echo ============================================
echo                 LSE FreeVM
echo     Location de VMs légales et gratuites
echo ============================================
echo.
echo 1. Voir les VMs disponibles
echo 2. Louer une VM
echo 3. Mes locations actives
echo 0. Quitter
echo.
set /p choice="Choisissez une option: "

if "%choice%"=="1" goto list_vms
if "%choice%"=="2" goto rent_vm
if "%choice%"=="3" goto my_rentals
if "%choice%"=="0" goto end
echo Option invalide.
pause
goto menu

:list_vms
cls
echo VMs disponibles:
echo.
echo 1. Ubuntu 20.04 - Pour développement web
echo 2. Windows 10 - Pour applications Windows
echo 3. Zorin OS - Pour utilisateurs Linux débutants
echo 4. Fedora 35 - Pour développeurs et testeurs
echo.
echo Toutes les VMs sont gratuites et légales.
pause
goto menu

:rent_vm
cls
echo Ouverture du formulaire de location...
start https://forms.gle/7kd8NjzYbafvQRyM9
pause
goto menu

:my_rentals
cls
echo Vos locations actives:
echo.
set /p username="Entrez votre nom d'utilisateur: "
echo Récupération des locations pour %username%...
echo.
powershell -command "Invoke-WebRequest -Uri 'https://devffin.github.io/dl/locs/%username%.txt' -OutFile '%temp%\%username%_locs.txt'" 2>nul
type "%temp%\%username%_locs.txt" 2>nul || echo Aucune location trouvée pour %username%.
del "%temp%\%username%_locs.txt" 2>nul
echo.
pause
goto menu

:end
echo Merci d'avoir utilisé LSE FreeVM.
timeout /t 2 >nul