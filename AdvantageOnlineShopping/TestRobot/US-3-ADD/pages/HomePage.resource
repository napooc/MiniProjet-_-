*** Settings ***
Library    SeleniumLibrary
Resource  ../resources/variables.resource

*** Keywords ***
Open Category
    [Arguments]    ${category_xpath}
    Wait Until Element Is Visible    ${category_xpath}    10s
    Click Element    ${category_xpath}

Open Category Tablets
    Open Category    ${CATEGORY_01_XPATH}

Open Category Laptops
    Open Category    ${CATEGORY_06_XPATH}