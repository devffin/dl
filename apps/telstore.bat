@echo off
setlocal enabledelayedexpansion
chcp 65001 >nul

:MENU
cls
echo.
echo ===============================================
echo              TelService STORE
echo ===============================================
echo.
if exist freeVM.bat (echo 1. [INSTALLE] LSE FreeVM) else (echo 1. [NON INSTALLE] LSE FreeVM)
if exist myAIRBENZ.bat (echo 2. [INSTALLE] myAIRBENZ) else (echo 2. [NON INSTALLE] myAIRBENZ)
if exist meteo.bat (echo 3. [INSTALLE] Meteorologie) else (echo 3. [NON INSTALLE] Meteorologie)
if exist musique.bat (echo 4. [INSTALLE] Musique) else (echo 4. [NON INSTALLE] Musique)
echo.
echo 5. Retour au menu principal TelService
echo.
set /p choice="Veuillez entrer le numero de l'application a installer/desinstaller ou 5 pour revenir: "
if "%choice%"=="1" goto TOGGLE_FREEVM
if "%choice%"=="2" goto TOGGLE_MYAIRBENZ
if "%choice%"=="3" goto TOGGLE_METEO
if "%choice%"=="4" goto TOGGLE_MUSIQUE
if "%choice%"=="5" exit /b
echo Choix invalide. Veuillez reessayer.
pause
goto MENU

:TOGGLE_FREEVM
if exist "apps\freeVM.bat" (
    powershell -command "Invoke-WebRequest -Uri 'https://devffin.github.io/dl/apps/freeVM.version.txt' -OutFile 'temp_version.txt'" 2>nul
    if exist "temp_version.txt" (
        set /p remote_ver=<temp_version.txt
        if exist "apps\freeVM.version.txt" (
            set /p local_ver=<apps\freeVM.version.txt
            if "!local_ver!" neq "!remote_ver!" (
                echo Mise a jour de LSE FreeVM...
                powershell -command "Invoke-WebRequest -Uri 'https://devffin.github.io/dl/apps/freeVM.bat' -OutFile 'apps\freeVM.bat'"
                copy temp_version.txt "apps\freeVM.version.txt" >nul
            )
        ) else (
            echo Telechargement de la version de LSE FreeVM...
            powershell -command "Invoke-WebRequest -Uri 'https://devffin.github.io/dl/apps/freeVM.bat' -OutFile 'apps\freeVM.bat'"
            copy temp_version.txt "apps\freeVM.version.txt" >nul
        )
         del temp_version.txt
    )
    call "apps\freeVM.bat"
    goto menu
) else (
    echo Telechargement de LSE FreeVM...
    powershell -command "Invoke-WebRequest -Uri 'https://devffin.github.io/dl/apps/freeVM.bat' -OutFile 'apps\freeVM.bat'" 2>nul
    powershell -command "Invoke-WebRequest -Uri 'https://devffin.github.io/dl/apps/freeVM.version.txt' -OutFile 'apps\freeVM.version.txt'" 2>nul
    if exist "apps\freeVM.bat" (
        call "apps\freeVM.bat"
    ) else (
         echo Erreur de telechargement!
         pause
    )
     goto menu
)

:TOGGLE_MYAIRBENZ
if exist "apps\myAIRBENZ.bat" (
    powershell -command "Invoke-WebRequest -Uri 'https://devffin.github.io/dl/apps/myAIRBENZ.version.txt' -OutFile 'temp_version.txt'" 2>nul
    if exist "temp_version.txt" (
        set /p remote_ver=<temp_version.txt
        if exist "apps\myAIRBENZ.version.txt" (
            set /p local_ver=<apps\myAIRBENZ.version.txt
            if "!local_ver!" neq "!remote_ver!" (
                echo Mise a jour de myAIRBENZ...
                powershell -command "Invoke-WebRequest -Uri 'https://devffin.github.io/dl/apps/myAIRBENZ.bat' -OutFile 'apps\myAIRBENZ.bat'"
                copy temp_version.txt "apps\myAIRBENZ.version.txt" >nul
            )
        ) else (
            echo Telechargement de la version de myAIRBENZ...
            powershell -command "Invoke-WebRequest -Uri 'https://devffin.github.io/dl/apps/myAIRBENZ.bat' -OutFile 'apps\myAIRBENZ.bat'"
            copy temp_version.txt "apps\myAIRBENZ.version.txt" >nul
        )
        del temp_version.txt
    )
    call "apps\myAIRBENZ.bat"
    goto menu
) else (
    echo Telechargement de myAIRBENZ...
    powershell -command "Invoke-WebRequest -Uri 'https://devffin.github.io/dl/apps/myAIRBENZ.bat' -OutFile 'apps\myAIRBENZ.bat'" 2>nul
    powershell -command "Invoke-WebRequest -Uri 'https://devffin.github.io/dl/apps/myAIRBENZ.version.txt' -OutFile 'apps\myAIRBENZ.version.txt'" 2>nul
    if exist "apps\myAIRBENZ.bat" (
        call "apps\myAIRBENZ.bat"
    ) else (
        echo Erreur de telechargement!
        pause
    )
    goto menu
)

:TOGGLE_METEO
if exist "apps\meteo.bat" (
    powershell -command "Invoke-WebRequest -Uri 'https://devffin.github.io/dl/apps/meteo.version.txt' -OutFile 'temp_version.txt'" 2>nul
    if exist "temp_version.txt" (
        set /p remote_ver=<temp_version.txt
        if exist "apps\meteo.version.txt" (
            set /p local_ver=<apps\meteo.version.txt
            if "!local_ver!" neq "!remote_ver!" (
                echo Mise a jour de Meteorologie...
                powershell -command "Invoke-WebRequest -Uri 'https://devffin.github.io/dl/apps/meteo.bat' -OutFile 'apps\meteo.bat'"
                copy temp_version.txt "apps\meteo.version.txt" >nul
            )
        ) else (
            echo Telechargement de la version de Meteorologie...
            powershell -command "Invoke-WebRequest -Uri 'https://devffin.github.io/dl/apps/meteo.bat' -OutFile 'apps\meteo.bat'"
            copy temp_version.txt "apps\meteo.version.txt" >nul
        )
        del temp_version.txt
    )
    call "apps\meteo.bat"
    goto menu
) else (
    echo Telechargement de Meteorologie...
    powershell -command "Invoke-WebRequest -Uri 'https://devffin.github.io/dl/apps/meteo.bat' -OutFile 'apps\meteo.bat'" 2>nul
    powershell -command "Invoke-WebRequest -Uri 'https://devffin.github.io/dl/apps/meteo.version.txt' -OutFile 'apps\meteo.version.txt'" 2>nul
    if exist "apps\meteo.bat" (
        call "apps\meteo.bat"
    ) else (
        echo Erreur de telechargement!
        pause
    )
    goto menu
)

:TOGGLE_MUSIQUE
if exist "apps\musique.bat" (
    powershell -command "Invoke-WebRequest -Uri 'https://devffin.github.io/dl/apps/musique.version.txt' -OutFile 'temp_version.txt'" 2>nul
    if exist "temp_version.txt" (
        set /p remote_ver=<temp_version.txt
        if exist "apps\musique.version.txt" (
            set /p local_ver=<apps\musique.version.txt
            if "!local_ver!" neq "!remote_ver!" (
                echo Mise a jour de Musique...
                powershell -command "Invoke-WebRequest -Uri 'https://devffin.github.io/dl/apps/musique.bat' -OutFile 'apps\musique.bat'"
                copy temp_version.txt "apps\musique.version.txt" >nul
            )
        ) else (
            echo Telechargement de la version de Musique...
            powershell -command "Invoke-WebRequest -Uri 'https://devffin.github.io/dl/apps/musique.bat' -OutFile 'apps\musique.bat'"
            copy temp_version.txt "apps\musique.version.txt" >nul
        )
        del temp_version.txt
    )
    call "apps\musique.bat"
    goto menu
) else (
    echo Telechargement de Musique...
    powershell -command "Invoke-WebRequest -Uri 'https://devffin.github.io/dl/apps/musique.bat' -OutFile 'apps\musique.bat'" 2>nul
    powershell -command "Invoke-WebRequest -Uri 'https://devffin.github.io/dl/apps/musique.version.txt' -OutFile 'apps\musique.version.txt'" 2>nul
    if exist "apps\musique.bat" (
        call "apps\musique.bat"
    ) else (
        echo Erreur de telechargement!
        pause
    )
    goto menu
)

