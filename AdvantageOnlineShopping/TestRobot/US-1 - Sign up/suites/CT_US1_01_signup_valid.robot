*** Settings ***
Documentation    CT_US1_01 – Inscription avec données valides
...
...    USER STORY    : US-1 – Sign Up
...    CAS DE TEST   : CT_US1_01
...    TYPE          : Test positif
...    OBJECTIF      : Vérifier qu'un utilisateur peut créer un compte avec des informations valides.
...    PRÉCONDITIONS : Le site AOS est accessible. L'utilisateur n'a pas de compte existant avec ce username.

Resource    ../config/import_resources.resource

Suite Setup       Suite Setup - Open Browser To AOS
Suite Teardown    Suite Teardown - Close Browser
Test Teardown     Test Teardown - Capture On Failure


*** Test Cases ***

CT_US1_01 - Inscription avec données valides
    [Documentation]    Vérifie qu'un utilisateur peut créer un compte avec des informations valides.
    ...                Résultat attendu : Le compte est créé avec succès.
    ...                L'utilisateur est redirigé vers la page d'accueil et son nom s'affiche.
    [Tags]    US1    CT_US1_01    positif    inscription

    # ─────────────────────────────────────────────────────────
    # Étape 1 : Accéder au site AOS (réalisé par le Suite Setup)
    # ─────────────────────────────────────────────────────────

    # Étape 2 : Cliquer sur l'icône User
    Cliquer Sur Icone Utilisateur

    # Étape 3 : Cliquer sur Create New Account
    Cliquer Sur Créer Un Nouveau Compte

    # Étape 4 : Renseigner les champs obligatoires avec des données valides
    ${epoch}=              Get Time    epoch
    ${unique_username}=    Set Variable    rimk${epoch}
    ${unique_email}=       Set Variable    rimk${epoch}@testmail.com
    Remplir Formulaire Inscription
    ...    username=${unique_username}
    ...    email=${unique_email}
    ...    password=${REG_PASSWORD}
    ...    confirm_password=${REG_CONFIRM_PASSWORD}
    ...    first_name=${REG_FIRST_NAME}
    ...    last_name=${REG_LAST_NAME}

    # Étape 5 : Cocher la case "I agree to the advantageonlineshopping.com conditions"
    Accepter Conditions Utilisation

    # Étape 6 : Cliquer sur le bouton Register
    Cliquer Sur Bouton Register

    # Résultat attendu : Le compte est créé, l'utilisateur est sur la page d'accueil
    Vérifier Succès Inscription    ${unique_username}
