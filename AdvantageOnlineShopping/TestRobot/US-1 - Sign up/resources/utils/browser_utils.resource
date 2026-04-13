*** Settings ***
Library    SeleniumLibrary


*** Keywords ***

Naviguer Vers Accueil
    [Documentation]    Navigue vers la page d'accueil du site AOS.
    ...                Attend que l'en-tête soit visible avant de continuer.
    [Arguments]    ${url}
    Go To                            ${url}
    Wait Until Element Is Visible    css:header    timeout=10s

Fermer Le Chat Si Visible
    [Documentation]    Masque le widget de chat flottant du site AOS via JavaScript.
    ...                Ce chat pop-up (chat.html) apparaît aléatoirement et peut bloquer
    ...                les clics sur d'autres éléments de la page pendant les tests.
    ...                On utilise JavaScript car le bouton n'a pas besoin d'être visible
    ...                pour être masqué — et Run Keyword And Ignore Error le rend sûr
    ...                même si le chat n'est pas présent sur la page.
    Run Keyword And Ignore Error
    ...    Execute Javascript
    ...    (function() {
    ...        var selectors = [
    ...            '.chat-btn-icn', '.chat-btn', '#chat-btn',
    ...            'a[href*="chat"]', '[class*="chatBtn"]',
    ...            '[id*="chat"]', '[class*="chat-"]',
    ...            'iframe[src*="chat"]', 'iframe[title*="chat"]'
    ...        ];
    ...        selectors.forEach(function(sel) {
    ...            document.querySelectorAll(sel).forEach(function(el) {
    ...                el.style.display = 'none';
    ...            });
    ...        });
    ...    })();
