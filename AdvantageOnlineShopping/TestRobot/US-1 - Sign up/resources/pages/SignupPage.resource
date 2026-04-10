*** Settings ***
Library     SeleniumLibrary
Resource    ../jdd/signup_data.resource


*** Variables ***

# ══════════════════════════════════════════════
# Localisateurs — Navigation
# ══════════════════════════════════════════════
${LOC_USER_ICON}                  xpath://a[@id='menuUserLink'][@aria-label='UserMenu']
${LOC_CREATE_ACCOUNT_BTN}         xpath://a[@href='javascript:void(0)'][text()='CREATE NEW ACCOUNT']

# ══════════════════════════════════════════════
# Localisateurs — Formulaire d'inscription
# ══════════════════════════════════════════════
${LOC_USERNAME_FIELD}             xpath://input[@name='usernameRegisterPage']
${LOC_EMAIL_FIELD}                xpath://input[@name='emailRegisterPage']
${LOC_PASSWORD_FIELD}             xpath://input[@name='passwordRegisterPage']
${LOC_CONFIRM_PASSWORD_FIELD}     xpath://input[@name='confirm_passwordRegisterPage']
${LOC_FIRST_NAME_FIELD}           xpath://input[@name='first_nameRegisterPage']
${LOC_LAST_NAME_FIELD}            xpath://input[@name='last_nameRegisterPage']
${LOC_AGREE_CHECKBOX}             xpath://input[@name='i_agree']
${LOC_REGISTER_BUTTON}            xpath://button[@id='register_btn'][text()='REGISTER']

# ══════════════════════════════════════════════
# Localisateurs — Vérification post-inscription
# ══════════════════════════════════════════════
${LOC_USER_LOGGED_LABEL}          xpath://span[@class='hi-user containMiniTitle ng-binding']


*** Keywords ***

Cliquer Sur Icone Utilisateur
    [Documentation]    Clique sur l'icône utilisateur dans la barre de navigation.
    ...                Cette action ouvre le panneau de connexion/inscription.
    Wait Until Element Is Visible    ${LOC_USER_ICON}    timeout=10s
    Click Element                    ${LOC_USER_ICON}

Cliquer Sur Créer Un Nouveau Compte
    [Documentation]    Clique sur le bouton "CREATE NEW ACCOUNT" dans le menu utilisateur.
    ...                Utilise un clic JavaScript pour éviter les interceptions par les éléments SVG overlay.
    Wait Until Element Is Visible    ${LOC_CREATE_ACCOUNT_BTN}    timeout=10s
    Execute Javascript    document.querySelector("a.create-new-account").click()

Remplir Formulaire Inscription
    [Documentation]    Remplit les champs du formulaire. Le Click Element sur chaque champ déclenche
    ...                le blur sur le champ précédent, activant les watchers AngularJS secModel.
    [Arguments]    ${username}    ${email}    ${password}    ${confirm_password}    ${first_name}    ${last_name}
    Wait Until Element Is Visible    ${LOC_USERNAME_FIELD}    timeout=10s
    Execute Javascript    document.querySelector('[name="usernameRegisterPage"]').scrollIntoView({block:"center"})
    Click Element    ${LOC_USERNAME_FIELD}
    Input Text       ${LOC_USERNAME_FIELD}    ${username}
    Execute Javascript    document.querySelector('[name="emailRegisterPage"]').scrollIntoView({block:"center"})
    Click Element    ${LOC_EMAIL_FIELD}
    Input Text       ${LOC_EMAIL_FIELD}    ${email}
    Execute Javascript    document.querySelector('[name="passwordRegisterPage"]').scrollIntoView({block:"center"})
    Click Element    ${LOC_PASSWORD_FIELD}
    Input Password   ${LOC_PASSWORD_FIELD}    ${password}
    Execute Javascript    document.querySelector('[name="confirm_passwordRegisterPage"]').scrollIntoView({block:"center"})
    Click Element    ${LOC_CONFIRM_PASSWORD_FIELD}
    Input Password   ${LOC_CONFIRM_PASSWORD_FIELD}    ${confirm_password}
    Execute Javascript    document.querySelector('[name="first_nameRegisterPage"]').scrollIntoView({block:"center"})
    Click Element    ${LOC_FIRST_NAME_FIELD}
    Input Text       ${LOC_FIRST_NAME_FIELD}    ${first_name}
    Execute Javascript    document.querySelector('[name="last_nameRegisterPage"]').scrollIntoView({block:"center"})
    Click Element    ${LOC_LAST_NAME_FIELD}
    Input Text       ${LOC_LAST_NAME_FIELD}    ${last_name}
    # Clic sur un élément neutre pour déclencher le blur sur last_name et finaliser la validation
    Execute Javascript    document.querySelector('[name="usernameRegisterPage"]').scrollIntoView({block:"center"})
    Click Element    ${LOC_USERNAME_FIELD}
    Sleep    1s

Accepter Conditions Utilisation
    [Documentation]    Vérifie que la case "I agree" est cochée, la coche si nécessaire.
    Scroll Element Into View         ${LOC_AGREE_CHECKBOX}
    Wait Until Element Is Visible    ${LOC_AGREE_CHECKBOX}    timeout=10s
    ${checked}=    Get Element Attribute    ${LOC_AGREE_CHECKBOX}    checked
    Log    Checkbox checked avant clic: '${checked}'    WARN
    Run Keyword If    '${checked}' == 'None'    Click Element    ${LOC_AGREE_CHECKBOX}
    ${checked2}=    Get Element Attribute    ${LOC_AGREE_CHECKBOX}    checked
    Log    Checkbox checked après clic: '${checked2}'    WARN

Cliquer Sur Bouton Register
    [Documentation]    Attend que le bouton Register soit actif (secInput secIsValid) puis clique.
    Wait Until Element Is Enabled    ${LOC_REGISTER_BUTTON}    timeout=10s
    Click Element                    ${LOC_REGISTER_BUTTON}

Vérifier Succès Inscription
    [Documentation]    Vérifie que l'inscription est réussie :
    ...                → L'URL n'est plus sur la page register.
    ...                → L'utilisateur est connecté (son nom s'affiche dans le menu).
    [Arguments]    ${username}
    Sleep                        2s
    ${url}=    Get Location
    Log    URL après Register : ${url}    level=WARN
    Capture Page Screenshot      EMBED
    Should Not Contain           ${url}    register
    Wait Until Element Contains  ${LOC_USER_LOGGED_LABEL}    ${username}    timeout=15s
