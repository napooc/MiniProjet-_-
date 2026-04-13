*** Settings ***
Library    SeleniumLibrary

*** Keywords ***
Open Browser To Application
    Open Browser    https://advantageonlineshopping.com/#/    chrome
    Maximize Browser Window
    Delete All Cookies
    Execute JavaScript    window.localStorage.clear(); window.sessionStorage.clear();
    Go To    https://advantageonlineshopping.com/#/
    Wait Until Element Is Visible    id=menuUser    timeout=10 s

Login User
    Click Element    id=menuUser
    Wait Until Element Is Visible    name=username    timeout=10 s
    Input Text    name=username    testuser
    Input Password    name=password    password
    Click Button    id=sign_in_btn
    Wait Until Element Is Visible    id=shoppingCartLink    timeout=10 s

Close Browser
    Close All Browsers

Take Screenshot With Name
    [Arguments]    ${screenshot_name}
    Capture Page Screenshot    ${screenshot_name}