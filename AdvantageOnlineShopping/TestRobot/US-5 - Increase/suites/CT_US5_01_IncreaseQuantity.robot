*** Settings ***
Documentation    Tests d'augmentation de quantité dans le panier
Library   SeleniumLibrary
Resource    ../config/setupTeardown.robot
Resource    ../ressources/jdd/quantity_data.resource
Suite Setup      Suite Setup
Test Setup       Test Setup
Test Teardown    Test Teardown

*** Test Cases ***

Increase Quantity Positive Value 10
    Click Category     ${CATEGORY_SPEAKERS}
    Select Product From Category     ${PRODUCT_1_NAME}

    Add Product To Cart From Product Page     1

    Go To Shopping Cart Full Page
    Click Edit From Shopping Cart     ${PRODUCT_1_NAME}
    
    FOR    ${QTY}    ${EXPECTED}        IN 
    ...    ${VALID_QTY_3}               ${VALID_QTY_3}
    ...    ${INVALID_QTY_NEGATIVE}      ${INITIAL_QTY}
    ...    ${INVALID_QTY_ZERO}          ${INITIAL_QTY}

        Update Quantity In champ    ${QTY}
        Click Add To Cart Button

        Go To Shopping Cart Full Page
        ${q} =   Get Product Quantity
        Should Be Equal As Strings     ${q}    ${EXPECTED}
        Click Edit From Shopping Cart     ${PRODUCT_1_NAME}
    END


Increase Quantity Via Button Plus
    Click Category     ${CATEGORY_SPEAKERS}
    Select Product From Category     ${PRODUCT_1_NAME}
    Add Product To Cart From Product Page     1
    Go To Shopping Cart Full Page
    Set Product Quantity    2
    ${q} =    Get Product Quantity
    Should Be Equal As Strings    ${q}    3


*** Comments ***
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