*** Settings ***
Library    SeleniumLibrary
Resource  ../resources/variables.resource

*** Keywords ***
Open Application
    Open Browser    ${URL}    ${BROWSER}
    Maximize Browser Window

Close Application
    Close Browser