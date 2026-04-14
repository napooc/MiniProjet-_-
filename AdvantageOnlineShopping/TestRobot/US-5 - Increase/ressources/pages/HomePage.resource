*** Settings ***
Documentation    Page d'accueil
Library    SeleniumLibrary

*** Variables ***
# Locators
${LOC_MENU_CART}                    id=menuCart
${LOC_CATEGORY_SPEAKERS}            //div[@id='speakersImg']
${LOC_CATEGORY_LAPTOPS}             //div[@id='laptopsImg']  
${LOC_CATEGORY_HEADPHONES}          //div[@id='headphonesImg'] 
${LOC_ADD}    //button[@name="save_to_cart"]
${LOC_qt}     //input[@name="quantity"]
${LOC_QUANTITY_INPUT}         xpath=//input[@name="quantity"]


*** Keywords ***
Navigate To Cart
    Maximize Browser Window
    Wait Until Element Is Visible    ${LOC_MENU_CART}    timeout=10s
    Click Element    ${LOC_MENU_CART}
    

Click Category
    [Arguments]    ${category_name}
    ${category_locator}=    Set Variable If
    ...    '${category_name}' == 'SPEAKERS'    ${LOC_CATEGORY_SPEAKERS}
    ...    '${category_name}' == 'LAPTOPS'     ${LOC_CATEGORY_LAPTOPS}
    ...    '${category_name}' == 'HEADPHONES'  ${LOC_CATEGORY_HEADPHONES}
    ...    ${LOC_CATEGORY_SPEAKERS}
    Wait Until Element Is Visible    ${category_locator}    timeout=10s
    Click Element    ${category_locator}
    Sleep    10s

Select Product From Category
    [Arguments]    ${product_name}
    # Build dynamic locator by product text
    ${locator}=    Set Variable    xpath=//a[contains(.,'${product_name}')]
    Wait Until Element Is Visible    ${locator}    15s
    Click Element    ${locator}

Add Product To Cart From Product Page
    [Arguments]    ${quantity}=1  
    Wait Until Element Is Visible    name=quantity    timeout=10s
    Press Keys    ${LOC_QUANTITY_INPUT}    CTRL+a
    Press Keys    ${LOC_QUANTITY_INPUT}    DELETE
    Input Text    ${LOC_qt}    ${quantity}
    Click Button    ${LOC_ADD}
    Sleep    2s
