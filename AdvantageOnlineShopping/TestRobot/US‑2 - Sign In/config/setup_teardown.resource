*** Settings ***
Library     SeleniumLibrary
Resource    ../resources/jdd/signin_data.resource


*** Keywords ***

Suite Setup - Open Browser To AOS
    [Documentation]    Ouvre le navigateur et navigue vers le site AOS.
    ...                Le navigateur est maximisé et un délai implicite est appliqué.
    Open Browser          ${BASE_URL}    ${BROWSER}
    Maximize Browser Window
    Set Selenium Implicit Wait    ${IMPLICIT_WAIT}

Suite Teardown - Close Browser
    [Documentation]    Ferme le navigateur à la fin de la suite de tests.
    Close Browser

Test Teardown - Capture On Failure
    [Documentation]    Capture automatiquement une screenshot si le test échoue.
    ...                Utile pour le diagnostic en cas d'erreur.
    Run Keyword If Test Failed    Capture Page Screenshot    EMBED
