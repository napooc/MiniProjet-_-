*** Settings ***
Library    SeleniumLibrary
Resource  ../resources/variables.resource

*** Keywords ***

Verify Product Added To Cart
    [Arguments]    ${product_name_token}=${EMPTY}
    Wait Until Element Is Visible    ${CartLink_xpath}    10s
    ${cart_badge}=    Get Text    ${CartLink_xpath}
    Should Not Be Equal    ${cart_badge}    0
    Click Element    ${CartLink_xpath}
    Run Keyword If    '${product_name_token}' != ''    Wait Until Page Contains    ${product_name_token}    20s

Verify Cart Quantity
    [Arguments]    ${quantity}
    Page Should Contain    ${quantity}