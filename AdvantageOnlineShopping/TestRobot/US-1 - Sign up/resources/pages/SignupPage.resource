*** Settings ***
Library     SeleniumLibrary
Resource    ../jdd/signup_data.resource


*** Variables ***

# ══════════════════════════════════════════════
# Localisateurs — Navigation
# ══════════════════════════════════════════════
${LOC_USER_ICON}                  css:.menuUserLink
${LOC_CREATE_ACCOUNT_BTN}         css:.createNewAccountText

# ══════════════════════════════════════════════
# Localisateurs — Formulaire d'inscription
# ══════════════════════════════════════════════
${LOC_USERNAME_FIELD}             id:usernameRegisterPage
${LOC_EMAIL_FIELD}                id:emailRegisterPage
${LOC_PASSWORD_FIELD}             id:passwordRegisterPage
${LOC_CONFIRM_PASSWORD_FIELD}     id:confirm_passwordRegisterPage
${LOC_FIRST_NAME_FIELD}           id:first_nameRegisterPage
${LOC_LAST_NAME_FIELD}            id:last_nameRegisterPage
${LOC_PHONE_FIELD}                id:phone_numberRegisterPage
${LOC_COUNTRY_SELECT}             id:countryListboxRegisterPage
${LOC_CITY_FIELD}                 id:cityRegisterPage
${LOC_ADDRESS_FIELD}              id:addressRegisterPage
${LOC_ZIP_FIELD}                  id:zip_codeRegisterPage
${LOC_AGREE_CHECKBOX}             xpath://input[@ng-model='registrationInfo.i_agree']
${LOC_REGISTER_BUTTON}            xpath://button[normalize-space()='REGISTER']

# ══════════════════════════════════════════════
# Localisateurs — Vérification post-inscription
# ══════════════════════════════════════════════
${LOC_USER_LOGGED_LABEL}          xpath://span[@class='menuUserLink']//label


*** Keywords ***

Cliquer Sur Icone Utilisateur
    [Documentation]    Clique sur l'icône utilisateur dans la barre de navigation.
    ...                Cette action ouvre le panneau de connexion/inscription.
    Wait Until Element Is Visible    ${LOC_USER_ICON}    timeout=10s
    Click Element                    ${LOC_USER_ICON}

Cliquer Sur Créer Un Nouveau Compte
    [Documentation]    Clique sur le bouton "CREATE NEW ACCOUNT" dans le menu utilisateur.
    ...                Redirige vers le formulaire d'inscription.
    Wait Until Element Is Visible    ${LOC_CREATE_ACCOUNT_BTN}    timeout=10s
    Click Element                    ${LOC_CREATE_ACCOUNT_BTN}

Remplir Formulaire Inscription
    [Documentation]    Remplit tous les champs obligatoires du formulaire d'inscription.
    [Arguments]    ${username}    ${email}    ${password}    ${confirm_password}
    ...            ${first_name}    ${last_name}    ${phone}
    ...            ${country}      ${city}       ${address}    ${zip}
    Wait Until Element Is Visible    ${LOC_USERNAME_FIELD}    timeout=10s
    Input Text        ${LOC_USERNAME_FIELD}             ${username}
    Input Text        ${LOC_EMAIL_FIELD}                ${email}
    Input Password    ${LOC_PASSWORD_FIELD}             ${password}
    Input Password    ${LOC_CONFIRM_PASSWORD_FIELD}     ${confirm_password}
    Input Text    ${LOC_FIRST_NAME_FIELD}           ${first_name}
    Input Text    ${LOC_LAST_NAME_FIELD}            ${last_name}
    Input Text    ${LOC_PHONE_FIELD}                ${phone}
    Select From List By Label    ${LOC_COUNTRY_SELECT}    ${country}
    Input Text    ${LOC_CITY_FIELD}                 ${city}
    Input Text    ${LOC_ADDRESS_FIELD}              ${address}
    Input Text    ${LOC_ZIP_FIELD}                  ${zip}

Accepter Conditions Utilisation
    [Documentation]    Coche la case "I agree to the advantageonlineshopping.com conditions".
    Wait Until Element Is Visible    ${LOC_AGREE_CHECKBOX}    timeout=10s
    Select Checkbox                  ${LOC_AGREE_CHECKBOX}

Cliquer Sur Bouton Register
    [Documentation]    Clique sur le bouton REGISTER pour soumettre le formulaire.
    ...                Attend que le bouton soit actif (enabled) avant de cliquer.
    Wait Until Element Is Enabled    ${LOC_REGISTER_BUTTON}    timeout=10s
    Click Button                     ${LOC_REGISTER_BUTTON}

Vérifier Succès Inscription
    [Documentation]    Vérifie que l'inscription est réussie :
    ...                → L'utilisateur est connecté (son nom s'affiche dans le menu).
    ...                → L'utilisateur n'est plus sur la page d'inscription.
    Wait Until Element Is Visible     ${LOC_USER_LOGGED_LABEL}    timeout=15s
    ${nom_affiché}=    Get Text       ${LOC_USER_LOGGED_LABEL}
    Should Be Equal As Strings        ${nom_affiché}    ${REG_USERNAME}
