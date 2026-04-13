*** Settings ***
Library     SeleniumLibrary
Library     OperatingSystem
Resource    ../resources/jdd/signup_data.resource
Resource    ../resources/utils/browser_utils.resource


*** Keywords ***

Suite Setup - Open Browser To AOS
    [Documentation]    Ouvre le navigateur et navigue vers le site AOS.
    ${options}=         Evaluate    selenium.webdriver.ChromeOptions()    modules=selenium.webdriver
    Call Method         ${options}    add_argument    --no-sandbox
    Call Method         ${options}    add_argument    --disable-dev-shm-usage
    Call Method         ${options}    add_argument    --disable-extensions
    Open Browser          ${BASE_URL}    ${BROWSER}    options=${options}
    Maximize Browser Window
    Set Selenium Implicit Wait    ${IMPLICIT_WAIT}
    Wait Until Element Is Visible      xpath://a[@id='menuUserLink'][@aria-label='UserMenu']    timeout=20s
    Wait Until Element Is Not Visible    css:.loader    timeout=15s
    Fermer Le Chat Si Visible

Suite Teardown - Close Browser
    [Documentation]    Ferme le navigateur à la fin de la suite de tests.
    Close Browser

Test Teardown - Capture On Failure
    [Documentation]    Capture automatiquement une screenshot si le test échoue.
    ...                Utile pour le diagnostic en cas d'erreur.
    Run Keyword If Test Failed    Capture Page Screenshot    EMBED
