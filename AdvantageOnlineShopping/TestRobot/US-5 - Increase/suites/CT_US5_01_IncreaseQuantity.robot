*** Settings ***
Documentation    Tests d'augmentation de quantité dans le panier
Library   SeleniumLibrary
Resource    ../config/setupTeardown.robot
Resource    ../ressources/jdd/quantity_data.resource
Suite Setup      Suite Setup
Test Setup       Test Setup
Test Teardown    Test Teardown

*** Test Cases ***

Increase Quantity Positive Value 2
    Click Category     ${CATEGORY_SPEAKERS}
    Select Product From Category     ${PRODUCT_1_NAME}

    Add Product To Cart From Product Page     1

    Go To Shopping Cart Full Page
    Click Edit From Shopping Cart     ${PRODUCT_1_NAME}

    Update Quantity In champ    ${VALID_QTY_1}
    Click Add To Cart Button

    Go To Shopping Cart Full Page
    ${q} =   Get Product Quantity
    Should Be Equal As Strings     ${q}    ${VALID_QTY_1} 


Increase Quantity Positive Value 10
    Click Category     ${CATEGORY_SPEAKERS}
    Select Product From Category     ${PRODUCT_1_NAME}

    Add Product To Cart From Product Page     1

    Go To Shopping Cart Full Page
    Click Edit From Shopping Cart     ${PRODUCT_1_NAME}

    Update Quantity In champ    ${VALID_QTY_2}
    Click Add To Cart Button

    Go To Shopping Cart Full Page
    ${q} =   Get Product Quantity
    Should Be Equal As Strings     ${q}    ${VALID_QTY_2} 

Increase Quantity With Negative Value
    Click Category     ${CATEGORY_SPEAKERS}
    Select Product From Category     ${PRODUCT_1_NAME}
    Add Product To Cart From Product Page     1
    Go To Shopping Cart Full Page
    Click Edit From Shopping Cart     ${PRODUCT_1_NAME}
    Update Quantity In champ    ${INVALID_QTY_NEGATIVE}
    Click Add To Cart Button
    Go To Shopping Cart Full Page
    ${q} =    Get Product Quantity
    Should Be Equal As Strings    ${q}    1

Increase Quantity With Null Value
    Click Category     ${CATEGORY_SPEAKERS}
    Select Product From Category     ${PRODUCT_1_NAME}
    Add Product To Cart From Product Page     1
    Go To Shopping Cart Full Page
    Click Edit From Shopping Cart     ${PRODUCT_1_NAME}
    Update Quantity In champ    ${INVALID_QTY_ZERO}
    Click Add To Cart Button
    Go To Shopping Cart Full Page
    ${q} =    Get Product Quantity
    Should Be Equal As Strings    ${q}    1

























*** Comments ***
Increase Quantity With Decimal Value
    Click Category     ${CATEGORY_SPEAKERS}
    Select Product From Category     ${PRODUCT_1_NAME}
    Add Product To Cart From Product Page     1
    Go To Shopping Cart Full Page
    Click Edit From Shopping Cart     ${PRODUCT_1_NAME}
    Update Quantity In champ    ${INVALID_QTY_DECIMAL}
    Click Add To Cart Button
    Go To Shopping Cart Full Page
    ${q} =    Get Product Quantity
    ${expected_qty}=    Evaluate    '${INVALID_QTY_DECIMAL}'.replace('.', '')
    Should Be Equal As Strings    ${q}    ${expected_qty}