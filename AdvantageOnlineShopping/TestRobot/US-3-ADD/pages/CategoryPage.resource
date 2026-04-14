*** Settings ***
Library    SeleniumLibrary
Resource  ../resources/variables.resource

*** Keywords ***
Select Product
    [Arguments]    ${product_id}
    Wait Until Element Is Visible    xpath=//img[@id="${product_id}"]    10s
    Click Element    xpath=//img[@id="${product_id}"]

Select Product Tablet
    Select Product    ${PRODUCT_01_ID}

Select Product Laptop
    Select Product    ${PRODUCT_06_ID}