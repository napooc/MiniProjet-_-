*** Settings ***
Documentation    Configuration Setup et Teardown
Library          OperatingSystem
Resource         importResources.robot

*** Variables ***
${BROWSER}              Chrome
${URL}                  https://www.advantageonlineshopping.com
${IMPLICIT_WAIT}        10s
${RESULTS_DIR}          ${EXECDIR}/results

*** Keywords ***
Clean Results Directory
    [Documentation]    Supprime tous les fichiers du dossier results avant l'exécution (ignore les erreurs si fichiers verrouillés)
    ${results_exists}=    Run Keyword And Return Status    Directory Should Exist    ${RESULTS_DIR}
    Run Keyword And Ignore Error    Run Keyword If    ${results_exists}    Remove Files    ${RESULTS_DIR}${/}*

Suite Setup
    [Documentation]    Exécuté une fois avant tous les tests de la suite
    Clean Results Directory

Test Setup
    Open Browser To Homepage
    Maximize Browser Window
    Set Selenium Implicit Wait    ${IMPLICIT_WAIT}

Test Teardown
    Capture Page Screenshot
    Close All Browsers
