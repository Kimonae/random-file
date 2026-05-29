@echo off
title Random file
set "SRC_DIR=C:\Users\USER\Videos\"
set "EXT_LIST=mp4"
:MENU
cls
echo        Fichier surprise
echo.
echo 1. Changer le dossier source
echo 2. Gérer les extensions
echo 3. Lancer un tirage aléatoire
echo 4. Exporter un script avec mes paramètres
echo 5. Quitter
echo.
set /p CHX=Votre choix : 
if "%CHX%"=="1" goto CHG_DIR
if "%CHX%"=="2" goto EXT_MENU
if "%CHX%"=="3" goto RANDOM
if "%CHX%"=="4" goto EXPORT
if "%CHX%"=="5" exit
goto MENU
:CHG_DIR
cls
echo === Changer le dossier source ===
echo Dossier actuel : %SRC_DIR%
echo.
set /p NEWDIR=Entrez le nouveau chemin : 
if not exist "%NEWDIR%" (
    echo Chemin invalide.
    pause
    goto CHG_DIR
)
set "SRC_DIR=%NEWDIR%"
call :SAVE_CONFIG
goto MENU
:EXT_MENU
cls
echo === Gestion des extensions ===
echo Extensions actuelles : %EXT_LIST%
echo.
echo 1. Ajouter une extension
echo 2. Supprimer une extension
echo 3. Scanner automatiquement les extensions du dossier
echo 4. Retour
echo.
set /p EXTCHX=Votre choix : 
if "%EXTCHX%"=="1" goto ADD_EXT
if "%EXTCHX%"=="2" goto DEL_EXT
if "%EXTCHX%"=="3" goto SCAN_EXT
goto MENU
:ADD_EXT
set /p NEWEXT=Nouvelle extension (sans le .) : 
set "EXT_LIST=%EXT_LIST%;%NEWEXT%"
call :SAVE_CONFIG
goto EXT_MENU
:DEL_EXT
set /p REMEXT=Extension à retirer : 
set "EXT_LIST=%EXT_LIST:;%REMEXT%=%"
call :SAVE_CONFIG
goto EXT_MENU
:SCAN_EXT
set "EXT_LIST="
for %%A in ("%SRC_DIR%\*.*") do (
    set "ext=%%~xA"
    set "ext=!ext:~1!"
    if "!EXT_LIST!" not=="" (
        echo !EXT_LIST! | findstr /i "\<!ext!\>" >nul || set "EXT_LIST=!EXT_LIST!;!ext!"
    ) else (
        set "EXT_LIST=!ext!"
    )
)
call :SAVE_CONFIG
goto EXT_MENU
:RANDOM
cls
echo Tirage en cours...
setlocal enabledelayedexpansion
set i=0
for %%E in (%EXT_LIST%) do (
    for /r "%SRC_DIR%" %%F in (*.%%E) do (
        rem --------------
rem RÈGLES DE SÉCURITÉ
rem Le moteur de tirage intègre des règles de sécurité pour empêcher l’exécution de fichiers système, cachés ou dangereux.
rem -- 1) Ignorer fichiers cachés (H)
attrib "%%F" | find " H " >nul && (
    echo [SECURITE] Fichier cache ignore : %%F
    continue
)

rem -- 2) Ignorer fichiers système (S)
attrib "%%F" | find " S " >nul && (
    echo [SECURITE] Fichier systeme ignore : %%F
    continue
)

rem -- 3) Ignorer fichiers sans extension
if "%%~xF"=="" (
    echo [SECURITE] Fichier sans extension ignore : %%F
    continue
)

rem -- 4) Ignorer extensions dangereuses
echo %%~xF | findstr /i "\.exe \.bat \.cmd \.vbs \.ps1 \.msi \.scr" >nul && (
    echo [SECURITE] Extension dangereuse ignoree : %%F
    continue
)

rem -- 5) Ignorer dossiers sensibles Windows
echo "%%F" | findstr /i "Windows\\ Program\ Files\\ Program\ Files\ (x86)\\ AppData\\ System32\\ System\ Volume\ Information\\ $Recycle.Bin\\" >nul && (
    echo [SECURITE] Dossier systeme ignore : %%F
    continue
)

rem  FIN DES RÈGLES DE SÉCURITÉ 


        set /a i+=1
        set "FILE[!i!]=%%F"
    )
)
if %i%==0 (
    echo Aucun fichier trouvé.
    pause
    goto MENU
)
set /a pick=(%random% %% i) + 1
start "" "!FILE[%pick%]!"
endlocal
goto MENU
:EXPORT
cls
echo Export du script...
copy "%~f0" "Scrp03_Export.bat" >nul
echo Export termine.
pause
goto MENU
:SAVE_CONFIG
(
    echo %%L
)
echo set "SRC_DIR=%SRC_DIR%"
echo set "EXT_LIST=%EXT_LIST%"
 > "%~f0.tmp"
move /y "%~f0.tmp" "%~f0" >nul
exit /b


