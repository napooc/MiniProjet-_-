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
    Wait Until Element Is Visible    id=shoppingCartLink    10s

    ${clicked}=    Run Keyword And Return Status    Click Element    id=shoppingCartLink
    IF    not ${clicked}
        Execute JavaScript    document.querySelector('#shoppingCartLink').click();
    END

    Wait Until Keyword Succeeds    15x    1s    Location Should Contain    shoppingCart

    # Ferme le popup mobile s'il reste (rare)
    #Run Keyword And Ignore Error    Wait Until Page Does Not Contain Element    xpath=//tool-tip-cart    5s
Force Close Mobile Cart Popup
    # Supprimer complètement le popup mobile du DOM
    Execute JavaScript    var el=document.querySelector('tool-tip-cart'); if(el){ el.remove(); }
    Sleep    0.5s
    # Vérifier qu'il n'existe plus
    Run Keyword And Ignore Error    Wait Until Page Does Not Contain Element    xpath=//tool-tip-cart    5s


Click Edit From Shopping Cart
    [Arguments]    ${PRODUCT_NAME}

    # 1. S'assurer que le panier est visible
    Wait Until Cart Popup Is Gone
    Wait Until Page Contains Element    xpath=//h3[contains(.,'SHOPPING CART')]    15s

    # 2. Attendre le tableau des produits ET les lignes produit (Angular lazy render)
    Wait Until Element Is Visible
    ...    xpath=//table[contains(@class,'fixedTableEdgeCompatibility')]    15s
    Wait Until Element Is Visible     xpath=//th//label[@translate="PRODUCT_NAME"]     15s

    # 3. Attendre qu'au moins une ligne produit soit présente dans le tbody
    Wait Until Element Is Visible
    ...    xpath=//table[contains(@class,'fixedTableEdgeCompatibility')]//tbody//tr    15s

    # 4. Hover via JS + clic sur Edit via JS (contourne les contraintes CSS :hover)
    Execute JavaScript
    ...    var rows = document.querySelectorAll('table.fixedTableEdgeCompatibility tbody tr');
    ...    var row = null;
    ...    for(var i=0;i<rows.length;i++){ if(rows[i].textContent.trim().toLowerCase().indexOf('${PRODUCT_NAME}'.toLowerCase())!==-1){ row=rows[i]; break; } }
    ...    if(!row && rows.length>0){ row=rows[0]; }
    ...    if(row){
    ...      row.dispatchEvent(new MouseEvent('mouseover',{bubbles:true,cancelable:true}));
    ...      var editBtn = row.querySelector('a.edit');
    ...      if(editBtn){ editBtn.click(); }
    ...    }

    Wait Until Element Is Visible    ${LOC_champ_EDIT}    12s



Update Quantity In champ
    [Arguments]    ${new_quantity}
    Wait Until Element Is Visible    ${LOC_QUANTITY_INPUT}    timeout=10s
    Press Keys    ${LOC_QUANTITY_INPUT}    CTRL+a
    Press Keys    ${LOC_QUANTITY_INPUT}    BACKSPACE
    Input Text    ${LOC_QUANTITY_INPUT}    ${new_quantity}
    Sleep    2s

Click Add To Cart Button
    Wait Until Element Is Visible    ${LOC_ADD_TO_CART_BTN}    timeout=10s
    Click Button    ${LOC_ADD_TO_CART_BTN}

Click Increase Button In Shopping Cart
    Wait Until Element Is Visible    xpath=//table[@class='fixedTableEdgeCompatibility']    timeout=10s
    Execute JavaScript
    ...    var row = document.querySelector('table.fixedTableEdgeCompatibility tbody tr');
    ...    if (row) { row.dispatchEvent(new MouseEvent('mouseover', {bubbles: true, cancelable: true})); }
    Sleep    1s
    ${visible}=    Run Keyword And Return Status    Wait Until Element Is Visible    xpath=//div[@class='plus']    timeout=5s
    IF    not ${visible}
        Execute JavaScript    document.querySelector('.plus').click()
    ELSE
        Click Element    xpath=//div[@class='plus']
    END
    Sleep    2s
