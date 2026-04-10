*** Settings ***
Library     SeleniumLibrary
Resource    ../jdd/signin_data.resource


*** Variables ***

# ══════════════════════════════════════════════
# Localisateurs — Navigation
# ══════════════════════════════════════════════
${LOC_USER_ICON}           xpath://a[@id='menuUserLink'][@aria-label='UserMenu']

# ══════════════════════════════════════════════
# Localisateurs — Formulaire de connexion
# ══════════════════════════════════════════════
${LOC_USERNAME_INPUT}      xpath://input[@name='username']
${LOC_PASSWORD_INPUT}      xpath://input[@name='password']
${LOC_SIGN_IN_BUTTON}      xpath://button[@id='sign_in_btn']

# ══════════════════════════════════════════════
# Localisateurs — Vérification post-connexion
# ══════════════════════════════════════════════
${LOC_USER_LOGGED_LABEL}   xpath://span[@class='hi-user containMiniTitle ng-binding']


*** Keywords ***

Cliquer Sur Icone Utilisateur
    [Documentation]    Clique sur l'icône utilisateur dans la barre de navigation.
    ...                Cette action affiche le formulaire de connexion.
    Wait Until Element Is Visible    ${LOC_USER_ICON}    timeout=10s
    Click Element                    ${LOC_USER_ICON}

Saisir Nom Utilisateur
    [Documentation]    Saisit le nom d'utilisateur (scrollIntoView + click pour déclencher secModel).
    [Arguments]    ${username}
    Wait Until Element Is Visible      ${LOC_USERNAME_INPUT}    timeout=10s
    Wait Until Element Is Not Visible  css:.loader              timeout=15s
    Execute Javascript    document.querySelector('[name="username"]').scrollIntoView({block:"center"})
    Click Element    ${LOC_USERNAME_INPUT}
    Input Text       ${LOC_USERNAME_INPUT}    ${username}

Saisir Mot De Passe
    [Documentation]    Saisit le mot de passe via JS click (SVG overlay intercepte le clic natif).
    [Arguments]    ${password}
    Wait Until Element Is Visible    ${LOC_PASSWORD_INPUT}    timeout=10s
    Execute Javascript    document.querySelector('[name="password"]').scrollIntoView({block:"center"})
    Execute Javascript    document.querySelector('[name="password"]').click()
    Input Password   ${LOC_PASSWORD_INPUT}    ${password}
    # Clic sur username pour déclencher blur sur password et activer secModel
    Execute Javascript    document.querySelector('[name="username"]').click()

Cliquer Sur Sign In
    [Documentation]    Clique sur le bouton Sign In pour soumettre le formulaire de connexion.
    Wait Until Element Is Visible    ${LOC_SIGN_IN_BUTTON}    timeout=10s
    Click Element                    ${LOC_SIGN_IN_BUTTON}

Vérifier Succès Connexion
    [Documentation]    Vérifie que la connexion est réussie :
    ...                → Le nom de l'utilisateur connecté s'affiche dans la barre de navigation.
    [Arguments]    ${expected_username}
    Wait Until Element Is Visible    ${LOC_USER_LOGGED_LABEL}    timeout=15s
    ${nom_affiché}=    Get Text       ${LOC_USER_LOGGED_LABEL}
    Should Be Equal As Strings       ${nom_affiché}    ${expected_username}
