@echo off
chcp 65001 >nul
title MegaGames - Pack de jeux Batch
mode con cols=80 lines=30
setlocal enabledelayedexpansion

:menu
cls
echo ==========================================================
echo                 MEGAGAMES - PACK DE JEUX
echo ==========================================================
echo.
echo  1) Devinette (nombre)
echo  2) Pierre / Feuille / Ciseaux
echo  3) Pendu (mots FR)
echo  4) Snake (simple)
echo  5) Bataille navale (mini)
echo  6) Quitter
echo.
set /p choice=Choisis un jeu (1-6) : 

if "%choice%"=="1" goto guess
if "%choice%"=="2" goto pfc
if "%choice%"=="3" goto hangman
if "%choice%"=="4" goto snake
if "%choice%"=="5" goto battleship
if "%choice%"=="6" exit
goto menu

:: ==========================================================
:: 1) Devinette
:: ==========================================================
:guess
cls
set /a secret=%random% %% 100 + 1
set tries=0
echo ==========================
echo        DEVINETTE
echo ==========================
echo Devine un nombre entre 1 et 100.
echo.

:guess_loop
set /a tries+=1
set /p g=Ton nombre : 
set /a g=g 2>nul
if "%g%"=="" goto guess_loop

if %g% LSS %secret% (
  echo Trop petit !
  goto guess_loop
)
if %g% GTR %secret% (
  echo Trop grand !
  goto guess_loop
)

echo.
echo BRAVO ! C'etait %secret% !
echo Essais : %tries%
pause
goto menu

:: ==========================================================
:: 2) Pierre / Feuille / Ciseaux
:: ==========================================================
:pfc
cls
echo ==========================
echo   PIERRE FEUILLE CISEAUX
echo ==========================
echo.
echo 1 = Pierre
echo 2 = Feuille
echo 3 = Ciseaux
echo.
set /p p=Ton choix (1-3) : 

if not "%p%"=="1" if not "%p%"=="2" if not "%p%"=="3" goto pfc

set /a bot=%random% %% 3 + 1

set pName=
set bName=
if "%p%"=="1" set pName=Pierre
if "%p%"=="2" set pName=Feuille
if "%p%"=="3" set pName=Ciseaux

if "%bot%"=="1" set bName=Pierre
if "%bot%"=="2" set bName=Feuille
if "%bot%"=="3" set bName=Ciseaux

echo.
echo Toi : %pName%
echo Bot : %bName%
echo.

if "%p%"=="%bot%" (
  echo Egalite !
  pause
  goto menu
)

if "%p%"=="1" if "%bot%"=="3" goto win_pfc
if "%p%"=="2" if "%bot%"=="1" goto win_pfc
if "%p%"=="3" if "%bot%"=="2" goto win_pfc

echo Tu as perdu !
pause
goto menu

:win_pfc
echo Tu as gagne !
pause
goto menu

:: ==========================================================
:: 3) Pendu
:: ==========================================================
:hangman
cls
echo ==========================
echo           PENDU
echo ==========================
echo.

set "word="
set /a w=%random% %% 10

if %w%==0 set word=ORDINATEUR
if %w%==1 set word=MEGAMAN
if %w%==2 set word=WINDOWS
if %w%==3 set word=PINGOS
if %w%==4 set word=CONSOLE
if %w%==5 set word=CLAVIER
if %w%==6 set word=PROGRAMME
if %w%==7 set word=NEXOS
if %w%==8 set word=TELEVISION
if %w%==9 set word=RADIO

set "found="
set "used="
set lives=7

for /l %%i in (1,1,50) do set "found=!found!_"

:: ajuster longueur
set "found="
for /l %%i in (0,1,60) do (
  set "c=!word:~%%i,1!"
  if "!c!"=="" goto hang_ready
  set "found=!found!_"
)
:hang_ready

:hang_loop
cls
echo ==========================
echo           PENDU
echo ==========================
echo Mot : 
call :show_word "%word%" "%found%"
echo.
echo Vies : %lives%
echo Lettres utilisees : %used%
echo.

set /p letter=Lettre : 
if "%letter%"=="" goto hang_loop
set letter=%letter:~0,1%
for %%A in (%letter%) do set letter=%%A
set letter=%letter:"=%
set letter=%letter: =%
set letter=%letter:~0,1%

:: majuscules
for %%Z in (A B C D E F G H I J K L M N O P Q R S T U V W X Y Z) do (
  if /i "%letter%"=="%%Z" set letter=%%Z
)

echo %used% | find /i "%letter%" >nul
if not errorlevel 1 goto hang_loop

set used=%used% %letter%

set hit=0
set "newfound=%found%"

for /l %%i in (0,1,60) do (
  set "c=!word:~%%i,1!"
  if "!c!"=="" goto hang_check
  if "!c!"=="%letter%" (
     set hit=1
     call :replace_char newfound %%i %letter%
  )
)

:hang_check
if "%hit%"=="0" set /a lives-=1

:: gagné ?
call :is_win "%word%" "%newfound%"
if "!errorlevel!"=="0" (
  cls
  echo Mot : %word%
  echo.
  echo GG ! Tu as gagne !
  pause
  goto menu
)

set found=%newfound%

if %lives% LEQ 0 (
  cls
  echo PERDU !
  echo Le mot etait : %word%
  pause
  goto menu
)

goto hang_loop

:: ==========================================================
:: 4) Snake (simple)
:: ==========================================================
:snake
cls
echo ==========================
echo           SNAKE
echo ==========================
echo.
echo Controls :
echo  W = haut
echo  S = bas
echo  A = gauche
echo  D = droite
echo.
echo (Snake batch = version simple, pas ultra fluide)
pause

set /a x=10, y=7
set /a fx=%random% %% 20 + 2
set /a fy=%random% %% 10 + 2
set score=0
set dir=D

:snake_loop
cls
echo Score : %score%
echo.

for /l %%Y in (1,1,15) do (
  set "line="
  for /l %%X in (1,1,30) do (
    set "ch=."
    if %%X==%x% if %%Y==%y% set "ch=O"
    if %%X==%fx% if %%Y==%fy% set "ch=*"
    set "line=!line!!ch!"
  )
  echo !line!
)

echo.
set /p key=Direction (WASD) + ENTER : 
if /i "%key%"=="W" set dir=W
if /i "%key%"=="A" set dir=A
if /i "%key%"=="S" set dir=S
if /i "%key%"=="D" set dir=D

if "%dir%"=="W" set /a y-=1
if "%dir%"=="S" set /a y+=1
if "%dir%"=="A" set /a x-=1
if "%dir%"=="D" set /a x+=1

if %x% LEQ 1 goto snake_dead
if %x% GEQ 30 goto snake_dead
if %y% LEQ 1 goto snake_dead
if %y% GEQ 15 goto snake_dead

if %x%==%fx% if %y%==%fy% (
  set /a score+=1
  set /a fx=%random% %% 28 + 2
  set /a fy=%random% %% 13 + 2
)

goto snake_loop

:snake_dead
cls
echo ==========================
echo          GAME OVER
echo ==========================
echo Score : %score%
pause
goto menu

:: ==========================================================
:: 5) Bataille navale mini (1 bateau)
:: ==========================================================
:battleship
cls
echo ==========================
echo      BATAILLE NAVALE
echo ==========================
echo.
echo Grille 5x5
echo Un seul bateau (1 case)
echo Tu as 7 tirs.
echo.

set /a bx=%random% %% 5 + 1
set /a by=%random% %% 5 + 1
set shots=7

:bs_loop
echo.
echo Tirs restants : %shots%
set /p tx=X (1-5) : 
set /p ty=Y (1-5) : 

set /a tx=tx 2>nul
set /a ty=ty 2>nul

if %tx% LSS 1 goto bs_loop
if %tx% GTR 5 goto bs_loop
if %ty% LSS 1 goto bs_loop
if %ty% GTR 5 goto bs_loop

set /a shots-=1

if %tx%==%bx% if %ty%==%by% (
  echo.
  echo TOUCHE ! Tu as coule le bateau !
  pause
  goto menu
)

echo.
echo Plouf...
if %shots% LEQ 0 (
  echo.
  echo PERDU !
  echo Le bateau etait en : %bx% %by%
  pause
  goto menu
)
goto bs_loop

:: ==========================================================
:: OUTILS
:: ==========================================================
:show_word
setlocal enabledelayedexpansion
set "w=%~1"
set "f=%~2"
set "out="

for /l %%i in (0,1,60) do (
  set "c=!w:~%%i,1!"
  if "!c!"=="" goto done_sw
  set "m=!f:~%%i,1!"
  if "!m!"=="_" (
    set "out=!out! _"
  ) else (
    set "out=!out! !m!"
  )
)
:done_sw
echo !out!
endlocal
exit /b

:replace_char
setlocal enabledelayedexpansion
set "var=%~1"
set /a idx=%~2
set "char=%~3"

set "s=!%var%!"
set "left=!s:~0,%idx%!"
set "right=!s:~%idx%+1!"
set "s=!left!!char!!right!"
endlocal & set "%~1=%s%"
exit /b

:is_win
setlocal enabledelayedexpansion
set "w=%~1"
set "f=%~2"
for /l %%i in (0,1,60) do (
  set "c=!w:~%%i,1!"
  if "!c!"=="" goto win_yes
  set "m=!f:~%%i,1!"
  if "!m!"=="_" (
    endlocal & exit /b 1
  )
)
:win_yes
endlocal & exit /b 0
