*** Settings ***
Documentation    Keywords utilitaires navigateur
Library   SeleniumLibrary

*** Variables ***
${BROWSER}        Chrome
${URL}            https://www.advantageonlineshopping.com

*** Keywords ***

Open Browser To Homepage
    Open Browser    ${URL}    ${BROWSER}
    Wait Until Element Is Visible    id=menuCart    timeout=15s
