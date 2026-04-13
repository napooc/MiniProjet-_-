*** Settings ***
Library    SeleniumLibrary

*** Variables ***
${BASE_URL}    https://advantageonlineshopping.com/#/

*** Keywords ***
# Vérifier que la page d'accueil est chargée
Verify Home Page Loaded
    Wait Until Element Is Visible    id=menuUser    timeout=15s
    Wait Until Element Is Visible    id=shoppingCartLink    timeout=10s

# Naviguer vers la page d'accueil
Go To Home Page
    Go To    ${BASE_URL}
    Verify Home Page Loaded

# Attendre que les produits populaires soient visibles
Wait For Popular Items
    Run Keyword And Ignore Error    Wait Until Element Is Not Visible    css=.loader    timeout=15s
    Wait Until Page Contains    POPULAR ITEMS    timeout=20s
    Wait Until Element Is Visible    xpath=(//a[contains(@href,'#/product/')][contains(.,'View Details')])[1]    timeout=20s

# Obtenir le nombre de produits dans le badge panier depuis la home
Get Cart Badge Count
    ${count}=    Execute JavaScript
    ...    var badge=document.querySelector('.cart.ng-binding, .cart span, .ng-binding.cart');
    ...    if(badge){ var m=(badge.textContent||'').match(/\d+/); return m ? parseInt(m[0]) : 0; }
    ...    return 0;
    RETURN    ${count}

# Survoler l'icône panier pour ouvrir le panier flottant
Hover Over Cart Icon
    Wait Until Element Is Visible    id=shoppingCartLink    timeout=10s
    Mouse Over    id=shoppingCartLink
    Wait Until Element Is Visible    xpath=((//div[contains(@class,'removeProduct')]) | (//a[contains(@class,'remove') and contains(.,'REMOVE')]))[1]    timeout=10s

# Vérifier que le panier flottant est visible
Verify Floating Cart Is Visible
    Wait Until Element Is Visible    xpath=((//div[contains(@class,'removeProduct')]) | (//a[contains(@class,'remove') and contains(.,'REMOVE')]))[1]    timeout=15s
