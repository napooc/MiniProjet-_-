*** Settings ***
Library    SeleniumLibrary
Resource  ../resources/variables.resource


*** Keywords ***
Select Color
    [Arguments]    ${color}
    Wait Until Element Is Visible    xpath=//span[@title="${color}"]    10s
    Click Element    xpath=//span[@title="${color}"]

Enter Quantity
    [Arguments]    ${quantity}
    Clear Element Text    name=quantity
    Input Text    name=quantity    ${quantity}

Enter Quantity If Visible
    [Arguments]    ${quantity}
    ${has_quantity}=    Run Keyword And Return Status    Wait Until Element Is Visible    name=quantity    3s
    Run Keyword If    ${has_quantity}    Clear Element Text    name=quantity
    Run Keyword If    ${has_quantity}    Input Text    name=quantity    ${quantity}

Add Product To Cart
    Wait Until Element Is Visible    ${Button_xpath}   10s
    Click Button     ${Button_xpath} 