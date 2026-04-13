*** Settings ***
Documentation    Tests d'augmentation de quantité dans le panier
Library   SeleniumLibrary
Resource    ../config/setupTeardown.robot
Resource    ../ressources/jdd/quantity_data.resource
Suite Setup      Suite Setup
Test Setup       Test Setup
Test Teardown    Test Teardown

***** Test Cases *****    

Increase Quantity To 2
    Click Category     ${CATEGORY_SPEAKERS}
    Select Product From Category     ${PRODUCT_1_NAME}
    Add Product To Cart From Product Page     1

    Go To Cart
    Click Edit From Shopping Cart     ${PRODUCT_1_NAME}

    Update Quantity     2
    Click Add To Cart

    ${q} =   Get Product Quantity
    Should Be Equal As Strings     ${q}     2

*** Comments ***
CT_US5_01 - Augmenter la quantité à 2
    [Documentation]    
    ...    Augmenter la quantité d'un produit à 2
    [Tags]    valid    
    
    Click Category    ${CATEGORY_SPEAKERS}
    Select Product From Category    ${PRODUCT_1_NAME}
    Add Product To Cart From Product Page    ${INITIAL_QTY}
    Navigate To Cart
    #Clicko Edit From Shopping Cart    ${PRODUCT_1_NAME}
    Clicko Edit From Shopping Cart    
    Update Quantity In champ    ${VALID_QTY_1}
    Click Add To Cart Button
    Sleep    5s
    ${quantite}=    Get Product Quantity
    Should Be Equal As Strings    ${quantite}    ${VALID_QTY_1}

CT_US5_02 - Augmenter la quantité à 5
    [Documentation]    
    ...    Augmenter la quantité d'un produit à 5
    [Tags]    valid
    
    Click Category    ${CATEGORY_LAPTOPS}
    Select Product From Category    ${PRODUCT_2_NAME}
    Add Product To Cart From Product Page    ${INITIAL_QTY}
    Navigate To Cart
    Click Edit From Shopping Cart    ${PRODUCT_2_NAME}
    Update Quantity In champ    ${VALID_QTY_2}
    Click Add To Cart Button
    Sleep    2s
    ${quantite}=   Get Product Quantity
    Should Be Equal As Strings    ${quantite}    ${VALID_QTY_2}

CT_US5_03 - Augmenter la quantité à 10
    [Documentation]    Augmenter la quantité d'un produit à 10
    [Tags]    valid
    
    Click Category    ${CATEGORY_HEADPHONES}
    Select Product From Category    ${PRODUCT_3_NAME}
    Add Product To Cart From Product Page    ${INITIAL_QTY}
    Navigate To Cart
    Click Edit From Shopping Cart       ${PRODUCT_3_NAME}
    Update Quantity In champ    ${VALID_QTY_3}
    Click Add To Cart Button
    Sleep    2s
    ${quantite}=    Get Product Quantity
    Should Be Equal As Strings    ${quantite}    ${VALID_QTY_3}

CT_US5_04 - Augmenter la quantité avec valeur négative
    [Documentation]    Test avec quantité négative (invalide)
    [Tags]    invalid
    
    Click Category    ${CATEGORY_SPEAKERS}
    Select Product From Category    ${PRODUCT_1_NAME}
    Add Product To Cart From Product Page    ${INITIAL_QTY}
    Navigate To Cart
    Click Edit From Shopping Cart    ${PRODUCT_1_NAME}
    Update Quantity In champ    ${INVALID_QTY_NEGATIVE}
    Click Add To Cart Button
    Sleep    2s
    ${quantite}=    Get Product Quantity
    Should Be Equal As Strings    ${quantite}    ${INITIAL_QTY}

CT_US5_05 - Augmenter la quantité avec zéro
    [Documentation]    Test avec quantité zéro (invalide)
    [Tags]    invalid
    
    Click Category    ${CATEGORY_SPEAKERS}
    Select Product From Category    ${PRODUCT_1_NAME}
    Add Product To Cart From Product Page    ${INITIAL_QTY}
    Navigate To Cart
    Click Edit From Shopping Cart    ${PRODUCT_1_NAME}
    Update Quantity In champ    ${INVALID_QTY_ZERO}
    Click Add To Cart Button
    Sleep    2s
    ${quantite}=    Get Product Quantity
    Should Be Equal As Strings    ${quantite}    ${INITIAL_QTY}

CT_US5_06 - Augmenter la quantité avec valeur trop élevée
    [Documentation]    Test avec quantité trop élevée (invalide)
    [Tags]    invalid
    
    Click Category    ${CATEGORY_SPEAKERS}
    Select Product From Category    ${PRODUCT_1_NAME}
    Add Product To Cart From Product Page    ${INITIAL_QTY}
    Navigate To Cart
    Click Edit From Shopping Cart    ${PRODUCT_1_NAME}
    Update Quantity In champ    ${INVALID_QTY_TOO_HIGH}
    Click Add To Cart Button
    Sleep    2s
    ${quantite}=    Get Product Quantity
    Should Be Equal As Strings    ${quantite}    ${INITIAL_QTY}

CT_US5_07 - Augmenter la quantité avec caractères texte
    [Documentation]    Test avec caractères non numériques (invalide)
    [Tags]    invalid
    
    Click Category    ${CATEGORY_SPEAKERS}
    Select Product From Category    ${PRODUCT_1_NAME}
    Add Product To Cart From Product Page    ${INITIAL_QTY}
    Navigate To Cart
    Click Edit From Shopping Cart    ${PRODUCT_1_NAME}
    Update Quantity In champ    ${INVALID_QTY_TEXT}
    Click Add To Cart Button
    Sleep    2s
    ${quantite}=    Get Product Quantity
    Should Be Equal As Strings    ${quantite}    ${INITIAL_QTY}

CT_US5_08 - Augmenter la quantité avec valeur décimale
    [Documentation]    Test avec valeur décimale (invalide)
    [Tags]    invalid
    
    Click Category    ${CATEGORY_SPEAKERS}
    Select Product From Category    ${PRODUCT_1_NAME}
    Add Product To Cart From Product Page    ${INITIAL_QTY}
    Navigate To Cart
    Click Edit From Shopping Cart    ${PRODUCT_1_NAME}
    Update Quantity In champ    ${INVALID_QTY_DECIMAL}
    Click Add To Cart Button
    Sleep    2s
    ${quantite}=    Get Product Quantity
    Should Be Equal As Strings    ${quantite}    ${INITIAL_QTY}
