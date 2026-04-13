*** Settings ***
Library    SeleniumLibrary

*** Variables ***
${BASE_URL}    https://advantageonlineshopping.com/#/

*** Keywords ***
Add Products To Cart For US3
    [Documentation]    Ajoute 1 produit depuis la home et retourne son nom.
    Run Keyword And Ignore Error    Wait Until Element Is Not Visible    css=.loader    timeout=15s
    Wait Until Element Is Visible    id=menuUser    timeout=15s
    Wait Until Keyword Succeeds    10x    1s    Wait Until Element Is Visible    xpath=(//a[contains(@href,'#/product/')][contains(.,'View Details')])[2]    timeout=10s

    ${PRODUCT_1}=    Add Home Product To Cart By Index    2

    RETURN    ${PRODUCT_1}

Add Home Product To Cart By Index
    [Arguments]    ${product_index}
    Execute JavaScript    window.scrollTo(0, document.body.scrollHeight * 0.65);
    Wait Until Element Is Visible    xpath=(//a[contains(@href,'#/product/')][contains(.,'View Details')])[${product_index}]    timeout=20s
    Scroll Element Into View    xpath=(//a[contains(@href,'#/product/')][contains(.,'View Details')])[${product_index}]
    ${clicked}=    Run Keyword And Return Status    Click Element    xpath=(//a[contains(@href,'#/product/')][contains(.,'View Details')])[${product_index}]
    IF    not ${clicked}
        Execute JavaScript
        ...    var idx=arguments[0];
        ...    var xp="(//a[contains(@href,'#/product/')][contains(.,'View Details')])["+idx+"]";
        ...    var node=document.evaluate(xp, document, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null).singleNodeValue;
        ...    if(node){ node.click(); }
    END
    Wait Until Keyword Succeeds    10x    1s    Wait Until Element Is Visible    xpath=//button[@name='save_to_cart']    timeout=10s

    ${product_name}=    Get Product Name From Product Page
    Click Button    xpath=//button[@name='save_to_cart']
    Wait And Confirm Alert

    Go To    ${BASE_URL}
    Wait Until Element Is Visible    id=menuUser    timeout=15s
    RETURN    ${product_name}

Get Product Name From Product Page
    ${status}    ${value}=    Run Keyword And Ignore Error    Get Text    xpath=//h1[contains(@class,'roboto') or contains(@class,'ng-binding')]
    IF    '${status}' == 'PASS' and '${value}' != ''
        RETURN    ${value}
    END

    ${fallback_name}=    Execute JavaScript
    ...    var h=document.querySelector('h1');
    ...    return h ? (h.textContent||'').trim() : '';
    IF    '${fallback_name}' == ''
        ${fallback_name}=    Set Variable    UNKNOWN_PRODUCT
    END
    RETURN    ${fallback_name}

Wait And Confirm Alert
    ${alert_present}=    Run Keyword And Return Status    Alert Should Be Present    timeout=5s
    Run Keyword If    ${alert_present}    Handle Alert    action=ACCEPT
