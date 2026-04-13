@echo off
REM ==================================================
REM Script d'exécution des tests US-5 - Increase Quantity
REM ==================================================

echo ========================================
echo     Tests US-5 - Increase Quantity
echo ========================================
echo.

REM Vérifier que Robot Framework est installé
python -c "import robot" 2>nul
if errorlevel 1 (
    echo [ERREUR] Robot Framework n'est pas installé.
    echo Installez-le avec : pip install robotframework robotframework-seleniumlibrary
    pause
    exit /b 1
)

echo [INFO] Robot Framework est installé.
echo.

REM Menu de choix
echo Choisissez une option :
echo 1. Exécuter tous les tests
echo 2. Exécuter uniquement les tests valides
echo 3. Exécuter uniquement les tests invalides
echo 4. Exécuter un test spécifique
echo 5. Quitter
echo.

set /p choice="Votre choix (1-5) : "

if "%choice%"=="1" goto all_tests
if "%choice%"=="2" goto valid_tests
if "%choice%"=="3" goto invalid_tests
if "%choice%"=="4" goto specific_test
if "%choice%"=="5" goto end

:all_tests
echo.
echo [INFO] Exécution de tous les tests...
robot --outputdir "fichiers" --name "US-5 All Tests" suites/CT_US5_01_IncreaseQuantity.robot
goto show_results

:valid_tests
echo.
echo [INFO] Exécution des tests valides uniquement...
robot --outputdir "fichiers" --include valid --name "US-5 Valid Tests" suites/CT_US5_01_IncreaseQuantity.robot
goto show_results

:invalid_tests
echo.
echo [INFO] Exécution des tests invalides uniquement...
robot --outputdir "fichiers" --include negative-test --name "US-5 Invalid Tests" suites/CT_US5_01_IncreaseQuantity.robot
goto show_results

:specific_test
echo.
echo Exemple : CT_US5_01
set /p test_name="Entrez le nom du test (sans le préfixe 'CT_') : "
echo.
echo [INFO] Exécution du test CT_%test_name%...
robot --outputdir "fichiers" --test "CT_%test_name%*" suites/CT_US5_01_IncreaseQuantity.robot
goto show_results

:show_results
echo.
echo ========================================
echo [SUCCESS] Exécution terminée !
echo ========================================
echo.
echo Les résultats sont disponibles dans le dossier "fichiers" :
echo - Rapport HTML : fichiers\report.html
echo - Log HTML    : fichiers\log.html
echo - Output XML  : fichiers\output.xml
echo.
echo Voulez-vous ouvrir le rapport HTML ? (O/N)
set /p open_report=""

if /i "%open_report%"=="O" (
    start fichiers\report.html
)

pause
goto end

:end
echo.
echo Au revoir !
