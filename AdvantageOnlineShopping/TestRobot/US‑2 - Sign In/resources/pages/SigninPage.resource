*** Settings ***
Library     SeleniumLibrary
Resource    ../jdd/signin_data.resource


*** Variables ***

${LOC_USER_ICON}           xpath://a[@id='menuUserLink'][@aria-label='UserMenu']
${LOC_USERNAME_INPUT}      xpath://input[@name='username']
${LOC_PASSWORD_INPUT}      xpath://input[@name='password']
${LOC_SIGN_IN_BUTTON}      xpath://button[@id='sign_in_btn']
${LOC_USER_LOGGED_LABEL}   xpath://span[@class='hi-user containMiniTitle ng-binding']
${LOC_LOGOUT_LINK}         xpath://*[@class='option roboto-medium ng-scope' and contains(text(),'Sign out')]


*** Keywords ***

Cliquer Sur Icone Utilisateur
    [Documentation]    Clique sur l'icône utilisateur dans la barre de navigation.
    ...                Cette action affiche le formulaire de connexion.
    ...                WHY Selenium Click Element (not JS click):
    ...                AOS uses AngularJS data-ng-click on the user icon.
    ...                A bare JS element.click() does NOT reliably trigger AngularJS
    ...                directives — the ng-click handler may not fire, so the login
    ...                panel never opens. Selenium dispatches real browser mouse events
    ...                that AngularJS listens to via its event system.
    ...                WHY loader wait before: the loader overlays the page and would
    ...                cause ElementClickInterceptedException on a Selenium click.
    Wait Until Element Is Not Visible    css:.loader         timeout=20s
    Wait Until Element Is Visible        ${LOC_USER_ICON}    timeout=10s
    Click Element                        ${LOC_USER_ICON}

Saisir Nom Utilisateur
    [Documentation]    Saisit le nom d'utilisateur via JS click (le loader AOS intercepte le clic Selenium natif).
    ...                WHY JS click instead of Click Element:
    ...                Even after Wait Until Element Is Not Visible, the loader can briefly
    ...                reappear between the wait check and the actual Click Element call.
    ...                document.querySelector().click() bypasses the overlay interception.
    [Arguments]    ${username}
    Wait Until Element Is Not Visible  css:.loader              timeout=15s
    Wait Until Element Is Visible      ${LOC_USERNAME_INPUT}    timeout=15s
    Execute Javascript    document.querySelector('[name="username"]').scrollIntoView({block:"center"})
    Execute Javascript    document.querySelector('[name="username"]').click()
    Input Text       ${LOC_USERNAME_INPUT}    ${username}

Saisir Mot De Passe
    [Documentation]    Saisit le mot de passe via JS click (SVG overlay intercepte le clic natif).
    [Arguments]    ${password}
    Wait Until Element Is Visible    ${LOC_PASSWORD_INPUT}    timeout=10s
    Execute Javascript    document.querySelector('[name="password"]').scrollIntoView({block:"center"})
    Execute Javascript    document.querySelector('[name="password"]').click()
    Input Password   ${LOC_PASSWORD_INPUT}    ${password}
    Execute Javascript    document.querySelector('[name="username"]').click()

Cliquer Sur Sign In
    [Documentation]    Clique sur le bouton Sign In pour soumettre le formulaire de connexion.
    ...                WHY JS click instead of Click Element:
    ...                AOS shows a full-page spinner (div.loader) that intercepts all clicks.
    ...                Even after Wait Until Element Is Not Visible, the loader can reappear
    ...                in the milliseconds between the wait check and the Selenium click.
    ...                document.querySelector('#sign_in_btn').click() fires directly on the
    ...                DOM node, bypassing any visual overlay — guaranteed no interception.
    Wait Until Element Is Not Visible    css:.loader              timeout=15s
    Wait Until Element Is Visible        ${LOC_SIGN_IN_BUTTON}    timeout=10s
    Wait Until Element Is Enabled        ${LOC_SIGN_IN_BUTTON}    timeout=10s
    Execute Javascript    document.querySelector('#sign_in_btn').click()

Vérifier Succès Connexion
    [Documentation]    Vérifie que la connexion est réussie :
    ...                → Le nom de l'utilisateur connecté s'affiche dans la barre de navigation.
    [Arguments]    ${expected_username}
    Wait Until Element Is Visible    ${LOC_USER_LOGGED_LABEL}    timeout=15s
    ${nom_affiché}=    Get Text       ${LOC_USER_LOGGED_LABEL}
    Should Be Equal As Strings       ${nom_affiché}    ${expected_username}


Se Déconnecter
    [Documentation]    Déconnecte l'utilisateur actuellement connecté.
    ...
    ...    COMMENT LIGNE PAR LIGNE :
    ...    1. On clique d'abord sur l'icône utilisateur (même chose qu'à la connexion).
    ...       WHY: Sur AOS, quand on est connecté, cliquer sur l'icône user ouvre
    ...       un menu déroulant qui contient les options : Account, My Orders,
    ...       Change Password, et LOGOUT. Sans ce clic, le lien Logout n'est pas visible.
    ...    2. Wait Until Element Is Visible → on attend que le lien "Logout" apparaisse.
    ...       WHY: Le menu déroulant s'anime (animation AngularJS). Si on clique trop vite
    ...       avant que l'animation soit finie, Robot Framework ne trouve pas l'élément.
    ...    3. Click Element ${LOC_LOGOUT_LINK} → clique sur le lien Logout.
    ...       WHY: Lance la déconnexion côté AngularJS (vide la session).
    ...    4. Wait Until Element Is Visible ${LOC_USER_ICON} → attend que l'icône
    ...       "non connecté" réapparaisse.
    ...       WHY: C'est notre ASSERTION implicite que la déconnexion a bien eu lieu.
    ...       Si l'icône user standard est de nouveau visible, on est déconnecté.

   
    Wait Until Element Is Not Visible    css:.loader         timeout=20s
    Wait Until Element Is Visible        ${LOC_USER_ICON}    timeout=10s
    Execute Javascript    document.querySelector('#menuUserLink').click()

    
    Wait Until Element Is Visible    ${LOC_LOGOUT_LINK}   timeout=10s

    
    Click Element    ${LOC_LOGOUT_LINK}
    Wait Until Element Is Not Visible    css:.loader    timeout=20s

    
    Go To    ${BASE_URL}
    Sleep    2s
    Wait Until Element Is Not Visible    css:.loader         timeout=15s
    Wait Until Element Is Visible        ${LOC_USER_ICON}    timeout=20s
