*** Settings ***
Library    SeleniumLibrary


*** Keywords ***

Naviguer Vers Accueil
    [Documentation]    Navigue vers la page d'accueil du site AOS.
    ...                Attend que l'en-tête soit visible avant de continuer.
    [Arguments]    ${url}
    Go To                            ${url}
    Wait Until Element Is Visible    css:header    timeout=10s
