*** Settings ***
Library     SeleniumLibrary    implicit_wait=0s
Resource    ../config/config.robot


*** Keywords ***
Open Browser And Navigate To Site
    [Documentation]    Ouvre le navigateur, maximise et navigue vers BASE_URL
    Open Browser    ${BASE_URL}    ${BROWSER}
    Maximize Browser Window
    Set Selenium Timeout    ${TIMEOUT}

Close Browser Session
    [Documentation]    Ferme le navigateur
    Close Browser

Wait For Loader To Disappear
    [Documentation]    Attend la disparition du loader
    Wait Until Element Is Not Visible    css:div.loader    ${TIMEOUT}

JS Click
    [Arguments]    ${locator}
    [Documentation]    Clique via JavaScript sur un élément
    ${element}=    Get WebElement    ${locator}
    Execute JavaScript    arguments[0].click();    ARGUMENTS    ${element}
