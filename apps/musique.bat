@echo off
setlocal enabledelayedexpansion
chcp 65001 >nul

cd "%~dp0"

where python >nul 2>nul
if errorlevel 1 (
    echo Installation de Python ...
    powershell -command "Invoke-WebRequest -Uri 'https://www.python.org/ftp/python/3.12.6/python-3.12.6-amd64.exe' -OutFile 'python_installer.exe'" 2>nul
    if errorlevel 1 (
        echo Erreur lors du téléchargement de Python. Vérifiez votre connexion internet.
        pause
        exit /b
    )
    if errorlevel 0 (
        start /wait python_installer.exe /quiet InstallAllUsers=1 PrependPath=1
        del python_installer.exe
        where python >nul 2>nul
        if errorlevel 1 (
            echo Python n'a pas été installé correctement. Veuillez l'installer manuellement.
        )
        if errorlevel 0 (
            echo Python installé avec succès.
        )
    )
)

:MENU
cls
echo  Musique - Lecteur de musique depuis un lien
echo =============================================
echo.
echo 1. Jouer depuis un lien (YouTube, etc.)
echo 2. Quitter
echo.
set /p choice="Choisissez une option: "

if "%choice%"=="1" goto PLAY
if "%choice%"=="2" exit /b
goto MENU

:PLAY
cls
echo Téléchargement des outils si nécessaire...
if not exist yt-dlp.exe (
    echo Téléchargement de yt-dlp...
    curl -L -o yt-dlp.exe https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp.exe 2>nul
    if errorlevel 1 (
        echo Erreur lors du téléchargement de yt-dlp. Vérifiez votre connexion internet.
        pause
        goto MENU
    )
)

if not exist ffmpeg.exe (
    echo Téléchargement de ffmpeg...
    curl -L -o ffmpeg.zip https://github.com/BtbN/FFmpeg-Builds/releases/download/latest/ffmpeg-master-latest-win64-gpl.zip 2>nul
    if errorlevel 1 (
        echo Erreur lors du téléchargement de ffmpeg.
        pause
        goto MENU
    )
    powershell -command "Expand-Archive -Path ffmpeg.zip -DestinationPath . -Force" 2>nul
    if errorlevel 1 (
        echo Erreur lors de l'extraction de ffmpeg.
        del ffmpeg.zip
        pause
        goto MENU
    )
    move "ffmpeg-master-latest-win64-gpl\bin\ffmpeg.exe" . 2>nul
    move "ffmpeg-master-latest-win64-gpl\bin\ffprobe.exe" . 2>nul
    rmdir /s /q "ffmpeg-master-latest-win64-gpl" 2>nul
    del ffmpeg.zip
)

if not exist spotdl_installed.txt (
    echo Vérification de spotdl...
    python -c "import spotdl" 2>nul
    if errorlevel 1 (
        echo Installation de spotdl...
        python -m pip install spotdl --quiet 2>nul
        if errorlevel 1 (
            echo Erreur lors de l'installation de spotdl.
        ) else (
            echo spotdl installé. > spotdl_installed.txt
        )
    ) else (
        echo spotdl déjà installé. > spotdl_installed.txt
    )
)

echo.
echo Entrez le lien de la musique (YouTube, Spotify, etc.):
set /p url=

if "%url%"=="" (
    echo Aucun lien fourni.
    pause
    goto MENU
)

echo.
echo Traitement du lien...
echo "%url%" | findstr /i "youtube.com youtu.be" >nul
if not errorlevel 1 (
    echo Lien YouTube détecté. Téléchargement et lecture...
    yt-dlp -x --audio-format mp3 -o "temp_music.%%(ext)s" "%url%" --quiet --ffmpeg-location ffmpeg.exe --js-runtimes ""
    if errorlevel 1 (
        echo Erreur lors du téléchargement.
        pause
        goto MENU
    )
    for %%f in (temp_music.*) do (
        echo Lecture de %%f
        start "" "%%f"
    )
) else (
    echo "%url%" | findstr /i "spotify.com" >nul
    if not errorlevel 1 (
        echo Lien Spotify détecté. Téléchargement avec spotdl...
        spotdl "%url%" --quiet
        if errorlevel 1 (
            echo Erreur lors du téléchargement.
            pause
            goto MENU
        )
        for %%f in (*.mp3 *.m4a *.flac) do (
            echo Lecture de %%f
            start "" "%%f"
        )
    ) else (
        echo Type de lien non supporté. Tentative de lecture directe...
        start "" "%url%"
    )
)

echo.
echo Appuyez sur une touche pour revenir au menu...
pause >nul
del temp_music.* 2>nul
goto MENU