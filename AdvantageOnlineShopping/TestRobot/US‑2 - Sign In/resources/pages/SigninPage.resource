*** Settings ***
Library     SeleniumLibrary
Resource    ../jdd/signin_data.resource


*** Variables ***

# ══════════════════════════════════════════════
# Localisateurs — Navigation
# ══════════════════════════════════════════════
${LOC_USER_ICON}           css:.menuUserLink

# ══════════════════════════════════════════════
# Localisateurs — Formulaire de connexion
# ══════════════════════════════════════════════
${LOC_USERNAME_INPUT}      id:userNameInput
${LOC_PASSWORD_INPUT}      id:passwordInput
${LOC_SIGN_IN_BUTTON}      id:sign_in_btn

# ══════════════════════════════════════════════
# Localisateurs — Vérification post-connexion
# ══════════════════════════════════════════════
${LOC_USER_LOGGED_LABEL}   xpath://span[@class='menuUserLink']//label


*** Keywords ***

Cliquer Sur Icone Utilisateur
    [Documentation]    Clique sur l'icône utilisateur dans la barre de navigation.
    ...                Cette action affiche le formulaire de connexion.
    Wait Until Element Is Visible    ${LOC_USER_ICON}    timeout=10s
    Click Element                    ${LOC_USER_ICON}

Saisir Nom Utilisateur
    [Documentation]    Saisit le nom d'utilisateur dans le champ Username du formulaire.
    [Arguments]    ${username}
    Wait Until Element Is Visible    ${LOC_USERNAME_INPUT}    timeout=10s
    Input Text                       ${LOC_USERNAME_INPUT}    ${username}

Saisir Mot De Passe
    [Documentation]    Saisit le mot de passe dans le champ Password du formulaire.
    ...                Utilise Input Password (le texte ne s'affiche pas en clair dans les logs).
    [Arguments]    ${password}
    Wait Until Element Is Visible    ${LOC_PASSWORD_INPUT}    timeout=10s
    Input Password                   ${LOC_PASSWORD_INPUT}    ${password}

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
