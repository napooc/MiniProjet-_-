*** Settings ***
Documentation    Page Panier
Library   SeleniumLibrary

*** Variables ***

# Locators xpath
${LOC_CART_TITLE}             xpath=//h3[@class="roboto-regular center sticky fixedImportant ng-binding"]
${LOC_SHOPPING_CART_LINK}     xpath=//label[contains(text(),'SHOPPING CART')]
${LOC_QUANTITY_INPUT}         xpath=//input[@name="quantity"]
${LOC_ADD_TO_CART_BTN}        xpath=//button[@name="save_to_cart"]

#locator pour le champ edit 
#${LOC_EDIT_LINK}             xpath=//a[@class="edit ng-scope"]
#${LOC_EDIT_LINK}       xpath=//a[contains(@class, 'edit')]
#${LOC_EDIT_LINK}      //*[@id="shoppingCart"]/table/tbody/tr/td[6]/span/a[1]
${LOC_EDIT_LINK}      //html/body/div[3]/section/article/div[1]/table/tbody/tr/td[6]/span/a[1]
#ancien ${LOC_EDIT_LINK}   css=.edit     error: Element 's' not visible after 10 seconds.


# Locators css
${LOC_PRODUCT_NAME}           css=a.productName
${LOC_champ_EDIT}             css=#productProperties


#xpath que j'ai cherché pour le get product quantity
${locator_cart_icone}      xpath=//a[@id='shoppingCartLink']
${locator_shoppingcart}    xpath=//h3[contains(text(),"SHOPPING CART" )]
${locator_ligneproduct}    xpath=//table[@class="fixedTableEdgeCompatibility"]//tbody//tr
${locator_quantity}        xpath=//label[@class="ng-binding"]


*** Keywords ***
Verify Cart Page Is Displayed
    Wait Until Page Contains Element    ${LOC_CART_TITLE}    timeout=10s

Get Product Quantity
    [Arguments]    ${product_index}=1
    ${quantity_locator}=    Set Variable    xpath=(//td[contains(@class,'quantityMobile')]//label[contains(@class,'ng-binding')])[${product_index}]
    Wait Until Element Is Visible    ${quantity_locator}    10s
    ${quantity}=      Get Text    ${quantity_locator}

    RETURN    ${quantity}

Move Mouse Away From Cart Icon
    # Déplace la souris vers le centre de la page pour fermer le popup
    Mouse Down   xpath=//body
    Sleep    0.5s

#Click Edit Button
    #[Arguments]    ${product_index}=1
    #Move Mouse Away From Cart Icon
    # Build dynamic locator for EDIT inside this row
    #${edit_locator}=    Set Variable    xpath=${LOC_EDIT_LINK}[${product_index}]
    #Run Keyword And Ignore Error   Wait Until Element Is Visible    ${edit_locator}    10s 
    #Click Element    ${edit_locator} 
    #locating image and all section of it :  //article[@class="max-width "][1]
    #Wait Until Element Is Visible    ${LOC_champ_EDIT}     timeout=10s
    #Sleep    2s

Wait Until Cart Popup Is Gone
    # popup = div.toolTip (AdvantageDemo mini cart)
    Run Keyword And Ignore Error    Wait Until Element Is Not Visible    xpath=//div[contains(@class,'toolTip')]    10s
    Run Keyword And Ignore Error    Wait Until Page Does Not Contain   xpath=//div[contains(@class,'toolTip')]    5s




Go To Shopping Cart Full Page
    Log    Navigation Shopping Cart - Desktop Mode

    Maximize Browser Window
    Wait Until Element Is Visible    id=shoppingCartLink    10s

    ${clicked}=    Run Keyword And Return Status    Click Element    id=shoppingCartLink
    IF    not ${clicked}
        Execute JavaScript    document.querySelector('#shoppingCartLink').click();
    END

    Wait Until Keyword Succeeds    15x    1s    Location Should Contain    shoppingCart

    # Ferme le popup mobile s'il reste (rare)
    Run Keyword And Ignore Error    Wait Until Page Does Not Contain Element    xpath=//tool-tip-cart    5s
Force Close Mobile Cart Popup
    # Supprimer complètement le popup mobile du DOM
    Execute JavaScript    var el=document.querySelector('tool-tip-cart'); if(el){ el.remove(); }
    Sleep    0.5s
    # Vérifier qu'il n'existe plus
    Run Keyword And Ignore Error    Wait Until Page Does Not Contain Element    xpath=//tool-tip-cart    5s


Clicko Edit From Shopping Cart
    #[Arguments]    ${PRODUCT_NAME}

    Maximize Browser Window
    Click Element    id=shoppingCartLink
    Wait Until Page Contains Element    xpath=//table[@class='fixedTableEdgeCompatibility']    10s

    # Remove popup mobile
    Execute JavaScript    var el=document.querySelector('tool-tip-cart'); if(el){el.remove();}

    # ✅ Find the product row (simple, safe)
    #${product_row}=    Set Variable    xpath=//label[contains(@class,'productName') and normalize-space(.)="${PRODUCT_NAME}"]/ancestor::tr
    ${product_row}=    Set Variable    xpath=//label[contains(@class,'productName') and normalize-space(.)="HP ROAR MINI WIRELESS SPEAKER"]/ancestor::tr    # ✅ Hover the row (CRUCIAL)
    Mouse Over    ${product_row}
    Sleep    0.7s    # gives Angular time to show EDIT

    # ✅ Now get the EDIT locator
    ${edit_btn}=    Set Variable    xpath=${product_row}//a[contains(@class,'edit')]
    Scroll Element Into View    ${edit_btn}
    Wait Until Element Is Visible    ${edit_btn}    10s
    Click Element    ${edit_btn}

    Wait Until Element Is Visible    ${LOC_CHAMP_EDIT}    10s





Clicka Edit From Shopping Cart
    [Arguments]    ${PRODUCT_NAME}

    Maximize Browser Window
    Click Element    id=shoppingCartLink
    Wait Until Keyword Succeeds    10x    1s    Location Should Contain    shoppingCart

    # Remove mobile popup if present
    Execute JavaScript    var el=document.querySelector('tool-tip-cart'); if(el){el.remove();}
    Sleep    0.5s

    # Wait for desktop table
    Wait Until Element Is Visible    xpath=//table[@class='fixedTableEdgeCompatibility']    10s

    # Find row safely (NO translate uppercase issue)
    ${product_row}=    Set Variable    xpath=//label[contains(@class,'productName')][contains(translate(., 'ABCDEFGHIJKLMNOPQRSTUVWXYZ','abcdefghijklmnopqrstuvwxyz'), '${PRODUCT_NAME.lower()}')]/ancestor::tr
    Wait Until Element Is Visible    ${product_row}    10s

    # Find EDIT button
    ${edit_btn}=    Set Variable    xpath=//label[contains(@class,'productName') and normalize-space(.)="${PRODUCT_NAME}"]/../..//a[contains(@class,'edit')]
    Wait Until Element Is Visible    ${edit_btn}
    Scroll Element Into View    ${edit_btn}
    Wait Until Element Is Visible    ${edit_btn}    10s
    Click Element    ${edit_btn}

    Wait Until Element Is Visible    ${LOC_CHAMP_EDIT}    10s

Clicker Edit From Shopping Cart
    [Arguments]    ${PRODUCT_NAME}

    Log    Étape 1: Accéder à la page Shopping Cart en mode desktop
    Go To Shopping Cart Full Page

    Log    Étape 2: Vérifier la présence du tableau produit
    Wait Until Element Is Visible    xpath=//table[@class='fixedTableEdgeCompatibility']    10s

    Log    Étape 3: Debug - Vérifier les noms des produits dans le DOM
    ${all_products}=    Get WebElements    xpath=//label[contains(@class,'productName')]
    FOR    ${p}    IN    @{all_products}
        ${txt}=    Get Text    ${p}
        Log To Console    PRODUIT TROUVÉ DANS DOM: ${txt}
    END

    Log    Étape 4: Localiser la ligne du produit ciblé (match insensible à la casse)
    ${product_row}=    Set Variable    
    ...    xpath=//label[contains(@class,'productName')
    ...    and contains(
    ...        translate(., 'abcdefghijklmnopqrstuvwxyz', 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'),
    ...        "${PRODUCT_NAME.upper()}"
    ...    )
    ...    ]/ancestor::tr

    Wait Until Element Is Visible    ${product_row}    10s

    Log    Étape 5: Localiser le bouton EDIT associé
    ${edit_btn}=    Set Variable    xpath=${product_row}//a[contains(@class,'edit') and normalize-space(.)='EDIT']

    Scroll Element Into View    ${edit_btn}
    Wait Until Element Is Visible    ${edit_btn}    10s

    Log    Étape 6: Cliquer sur EDIT
    Click Element    ${edit_btn}

    Log    Étape 7: Vérifier que la page d’édition s'affiche
    Wait Until Element Is Visible    ${LOC_CHAMP_EDIT}    10s

    Log    Étape 8: Action EDIT réalisée avec succès ✅



Click Edit From Shopping Cart
    [Arguments]    ${PRODUCT_NAME}

    # 1. Fermer popup sinon le tableau est inaccessible
    Wait Until Cart Popup Is Gone
    Wait Until Page Contains Element    xpath=//h3[contains(.,'SHOPPING CART')]    10s
    # 2. Attendre chargement réel du tableau PC
    Wait Until Element Is Visible    xpath=//table[@class='fixedTableEdgeCompatibility']    10s
    Move Mouse Away From Cart Icon
    Mouse over   xpath=//h3[contains(.,'SHOPPING CART')]  
    Page Should Contain Element    xpath=//label[contains(@class,'productName')]
    # 3. Trouver ligne produit
    ${product_row}=    Set Variable    xpath=//label[contains(@class,'productName') and normalize-space(.)="${PRODUCT_NAME}"]/ancestor::tr
    
    Wait Until Element Is Visible    ${product_row}    10s

    # 4. Trouver EDIT
    ${edit_btn}=    Set Variable    xpath=${product_row}//a[contains(@class,'edit') and normalize-space(.)='EDIT']

    Scroll Element Into View    ${edit_btn}
    Sleep    0.2s

    Wait Until Element Is Visible    ${edit_btn}    10s
    Click Element    ${edit_btn}

    Wait Until Element Is Visible    ${LOC_champ_EDIT}    10s

Click Edit From Shopping Cartiiiii
    [Arguments]    ${PRODUCT_NAME}
    Wait Until Cart Popup Is Gone
    #Attendre que la page panier soit complètement chargée
    Wait Until Element Is Visible    xpath=//h3[contains(.,'SHOPPING CART')]    10s
    Wait Until Element Is Visible    xpath=//table[@class='fixedTableEdgeCompatibility']//tr    10s

    #Localiser la ligne du produit contenant le PRODUCT_NAME
    ${product_row}=    Set Variable    xpath=//label[contains(@class,'productName') and normalize-space(.)="${PRODUCT_NAME}"]/ancestor::tr    
    Scroll Element Into View    ${product_row}
    #Attendre que la ligne soit visible
    Wait Until Element Is Visible    ${product_row}    10s
    #Construire le locator pour le bouton EDIT dans cette ligne
    ${edit_btn}=    Set Variable    xpath=${product_row}//a[contains(@class,'edit') and normalize-space(.)='EDIT']
    #Scroll jusqu’au bouton EDIT (important)
    Scroll Element Into View    ${edit_btn}
    Sleep    0.3s
    #Attendre que EDIT soit cliquable
    Wait Until Element Is Visible    ${edit_btn}    10s
    #Cliquer
    Click Element    ${edit_btn}
    #Attendre que la page d'édition soit visible
    Wait Until Element Is Visible    ${LOC_champ_EDIT}    10s

    Sleep    1s







Update Quantity In champ
    [Arguments]    ${new_quantity}
    Wait Until Element Is Visible    ${LOC_QUANTITY_INPUT}    timeout=10s
    Clear Element Text    ${LOC_QUANTITY_INPUT}
    Input Text    ${LOC_QUANTITY_INPUT}    ${new_quantity}
    Sleep    2s

Click Add To Cart Button
    Wait Until Element Is Visible    ${LOC_ADD_TO_CART_BTN}    timeout=10s
    Click Button    ${LOC_ADD_TO_CART_BTN}
    Sleep    10s

