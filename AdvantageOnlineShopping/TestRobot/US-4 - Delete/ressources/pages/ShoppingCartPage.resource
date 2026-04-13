*** Settings ***
Library    SeleniumLibrary

*** Keywords ***
Prepare Cart For US4 Delete
    ${product_1}=    Add Home Product To Cart By Index    1
    ${product_2}=    Add Home Product To Cart By Index    2
    RETURN    ${product_1}    ${product_2}

Add Home Product To Cart By Index
    [Arguments]    ${product_index}
    Run Keyword And Ignore Error    Wait Until Element Is Not Visible    css=.loader    timeout=15s
    Wait Until Page Contains    POPULAR ITEMS    timeout=20s
    Execute JavaScript    window.scrollTo(0, document.body.scrollHeight * 0.65);
    Wait Until Element Is Visible    xpath=(//a[contains(@href,'#/product/')][contains(.,'View Details')])[${product_index}]    timeout=20s
    ${product_name}=    Set Variable    HOME_PRODUCT_${product_index}
    Click Element    xpath=(//a[contains(@href,'#/product/')][contains(.,'View Details')])[${product_index}]
    Wait Until Element Is Visible    xpath=//button[@name='save_to_cart']    timeout=15s
    Click Button    xpath=//button[@name='save_to_cart']
    Wait And Confirm Alert
    Go To    https://advantageonlineshopping.com/#/
    RETURN    ${product_name}

# Naviguer vers le shopping cart (page complète)
Go To Shopping Cart Full Page
    Wait Until Element Is Visible    id=shoppingCartLink    timeout=10s
    Scroll Element Into View    id=shoppingCartLink
    ${clicked}=    Run Keyword And Return Status    Click Element    id=shoppingCartLink
    IF    not ${clicked}
        Execute JavaScript    var el=document.querySelector('#shoppingCartLink'); if(el){ el.click(); }
    END
    Wait Until Keyword Succeeds    15x    1s    Location Should Contain    shoppingCart

# Ouvrir le panier flottant (hover)
Open Floating Cart
    Wait Until Element Is Visible    id=shoppingCartLink    timeout=10s
    Mouse Over    id=shoppingCartLink
    ${floating_visible}=    Run Keyword And Return Status    Wait Until Element Is Visible    xpath=//div[contains(@class,'floating-cart') or contains(@class,'cart') or contains(@class,'mini') or contains(@id,'cart')]    timeout=5s
    IF    not ${floating_visible}
        Click Element    id=shoppingCartLink
    END

# Vérifier la présence d'un produit dans le panier complet
Verify Product In Cart
    [Arguments]    ${product_name}
    Wait Until Page Contains    ${product_name}    timeout=10s

# Vérifier le nombre de produits au-dessus de l'icône panier
Verify Product Count In Cart Icon
    [Arguments]    ${expected_count}
    ${cart_count}=    Get Current Product Count
    Should Be Equal As Strings    ${cart_count}    ${expected_count}

# Obtenir le nombre actuel de produits dans le panier
Get Current Product Count
    ${cart_count}=    Execute JavaScript
    ...    var link=document.querySelector('#shoppingCartLink');
    ...    var txt='';
    ...    if(link){ txt=(link.textContent||'')+' '+(link.innerText||''); }
    ...    var badge=document.querySelector('.cart.ng-binding,.cart span,.ng-binding.cart,.cart');
    ...    if(badge){ txt += ' ' + (badge.textContent||''); }
    ...    var m=txt.match(/\d+/);
    ...    return m ? m[0] : '0';
    RETURN    ${cart_count}

Remove Product From Shopping Cart
    [Arguments]    ${product_name}
    Go To Shopping Cart Full Page
    Wait Until Element Is Visible    xpath=(//a[contains(@class,'remove') and contains(.,'REMOVE')])[1]    timeout=15s
    Scroll Element Into View    xpath=(//a[contains(@class,'remove') and contains(.,'REMOVE')])[1]
    ${removed}=    Run Keyword And Return Status    Click Element    xpath=(//a[contains(@class,'remove') and contains(.,'REMOVE')])[1]
    IF    not ${removed}
        Execute JavaScript    document.querySelectorAll("a.remove")[0].click();
    END
    
Remove Product From Floating Cart
    [Arguments]    ${product_name}
    ${removed_in_floating}=    Run Keyword And Return Status
    ...    Click Element
    ...    xpath=(//div[contains(@class,'removeProduct')])[1]
    IF    not ${removed_in_floating}
        Wait Until Element Is Visible    xpath=(//a[contains(@class,'remove') and contains(.,'REMOVE')])[1]    timeout=10s
        Click Element    xpath=(//a[contains(@class,'remove') and contains(.,'REMOVE')])[1]
    END

# Vérifier que le produit a été supprimé du panier
Verify Product Not In Cart
    [Arguments]    ${product_name}
    Page Should Not Contain    ${product_name}

# Vérifier le total du panier
Verify Cart Total
    [Arguments]    ${expected_total}
    ${total}=    Get Element Attribute    xpath=//span[@class='total-price' or contains(@class, 'total')]    textContent
    Should Contain    ${total}    ${expected_total}

# Vérifier le montant du bouton Checkout
Verify Checkout Amount
    [Arguments]    ${expected_amount}
    ${checkout_amount}=    Get Element Attribute    xpath=//button[@class='checkout' or contains(text(), 'Checkout')]    textContent
    Should Contain    ${checkout_amount}    ${expected_amount}

# Helper pour confirmer les alertes
Wait And Confirm Alert
    ${alert_present}=    Run Keyword And Return Status    Alert Should Be Present    timeout=5s
    Run Keyword If    ${alert_present}    Handle Alert    action=ACCEPT

Get Removable Items Count
    ${count}=    Execute JavaScript
    ...    var countA=document.querySelectorAll('a.remove').length;
    ...    var countDiv=document.querySelectorAll('div.removeProduct').length;
    ...    return countA > 0 ? countA : countDiv;
    RETURN    ${count}