*** Settings ***
Resource    common.resource


*** Keywords ***
Open Cart
    [Documentation]    Clique sur l'icône panier pour ouvrir le panier
    Wait Until Element Is Visible    xpath=//a[@href='#/shoppingCart']    ${TIMEOUT}
    Click Element                    xpath=//a[@href='#/shoppingCart']
    Wait For Loader To Disappear

Go To Category
    [Arguments]    ${category_text}
    [Documentation]    Va à la page d'accueil et clique sur la catégorie souhaitée
    Go To    ${BASE_URL}
    Wait Until Element Is Visible    xpath=//h1[contains(@class,'roboto-bold')]    ${TIMEOUT}
    Wait Until Element Is Visible    xpath=//span[text()='${category_text}']    ${TIMEOUT}
    Click Element                    xpath=//span[text()='${category_text}']
    Wait Until Element Is Visible    xpath=//h3[normalize-space()='${category_text}']    ${TIMEOUT}

Select Product From Category
    [Arguments]    ${product_name}
    [Documentation]    Trouve le produit dans la liste et clique dessus
    Scroll Element Into View         xpath=//a[contains(text(),'${product_name}')]
    Wait Until Element Is Visible    xpath=//a[contains(text(),'${product_name}')]    ${TIMEOUT}
    Click Element                    xpath=//a[contains(text(),'${product_name}')]
    Wait Until Element Is Visible    xpath=//p[contains(@class,'roboto-light')]    ${TIMEOUT}

Set Product Quantity
    [Arguments]    ${times}
    [Documentation]    Clique ${times} fois sur le bouton + pour augmenter la quantité
    Wait Until Element Is Visible    xpath=//div[@class='plus']    ${TIMEOUT}
    Scroll Element Into View         xpath=//div[@class='plus']
    FOR    ${i}    IN RANGE    ${times}
        Click Element    xpath=//div[@class='plus']
    END

Add Product To Cart
    [Documentation]    Fait défiler jusqu'au bouton Add to Cart et clique dessus
    Wait Until Element Is Visible    xpath=//button[@name='save_to_cart']    ${TIMEOUT}
    Scroll Element Into View         xpath=//button[@name='save_to_cart']
    Wait For Loader To Disappear
    Click Element                    xpath=//button[@name='save_to_cart']
    Wait For Loader To Disappear

Lire Quantite Produit Dans Panier
    [Arguments]    ${product_name_upper}
    [Documentation]    Retourne la quantité (nombre entier) d'un produit dans le panier
    Wait Until Element Is Visible    xpath=//h3[normalize-space()='${product_name_upper}']    ${TIMEOUT}
    Wait Until Element Is Visible    xpath=//h3[normalize-space()='${product_name_upper}']/following-sibling::label[1]    ${TIMEOUT}
    ${qty_texte}=    Get Text    xpath=//h3[normalize-space()='${product_name_upper}']/following-sibling::label[1]
    Should Not Be Empty    ${qty_texte}    msg=Le label de quantité est vide pour ${product_name_upper}
    ${qty_nombre}=    Evaluate    int(re.search(r'[0-9]+', '${qty_texte}').group())    modules=re
    RETURN    ${qty_nombre}
