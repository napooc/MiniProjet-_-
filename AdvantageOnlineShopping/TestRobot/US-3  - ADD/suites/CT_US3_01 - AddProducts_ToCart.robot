*** Settings ***
Documentation    CT_US3_01 - Add one product to cart from home page
Library    SeleniumLibrary
Resource    ../config/import_resources.resource

Suite Setup     Open AOS Home Page
Suite Teardown  Close All Browsers

*** Variables ***
${BASE_URL}    https://advantageonlineshopping.com/#/

*** Test Cases ***
CT_US3_01 - Add Products To Cart
    [Documentation]    Verify that adding products populates Shopping Cart.

    ${product_1}=    Add Products To Cart For US3
    Should Not Be Empty    ${product_1}

    Click Element    id=shoppingCartLink
    Wait Until Keyword Succeeds    10x    1s    Location Should Contain    shoppingCart
    Wait Until Element Is Visible    xpath=(//a[contains(@class,'remove') and contains(.,'REMOVE')] | //div[contains(@class,'removeProduct')])[1]    timeout=15s
    ${line_count}=    Execute JavaScript    return document.querySelectorAll("a.remove, .removeProduct").length;
    Should Be True    ${line_count} >= 1

    Log    Added product: ${product_1}
    Log    Shopping cart now contains at least one line item.

*** Keywords ***
Open AOS Home Page
    Open Browser    ${BASE_URL}    chrome
    Maximize Browser Window
    Wait Until Element Is Visible    id=menuUser    timeout=15s
