*** Settings ***
Documentation    CT_US2_01 – Connexion avec identifiants valides
...
...    USER STORY    : US-2 – Sign In
...    CAS DE TEST   : CT_US2_01
...    TYPE          : Test positif
...    OBJECTIF      : Vérifier qu'un utilisateur enregistré peut se connecter avec des identifiants valides.
...    PRÉCONDITIONS : Le site AOS est accessible. L'utilisateur est déconnecté. Un compte valide existe.

Resource    ../config/import_resources.resource

Suite Setup       Suite Setup - Open Browser To AOS
Suite Teardown    Suite Teardown - Close Browser
Test Teardown     Test Teardown - Capture On Failure


*** Test Cases ***

CT_US2_01 - Connexion avec identifiants valides
    [Documentation]    Vérifie qu'un utilisateur enregistré peut se connecter avec des identifiants valides.
    ...                Résultat attendu : Connexion réussie.
    ...                Le nom de l'utilisateur s'affiche dans la barre de navigation.
    [Tags]    US2    CT_US2_01    positif    connexion

    # ─────────────────────────────────────────────────────────
    # Étape 1 : Accéder au site AOS (réalisé par le Suite Setup)
    # ─────────────────────────────────────────────────────────

    # Étape 2 : Cliquer sur l'icône User
    Cliquer Sur Icone Utilisateur

    # Étape 3 : Saisir un username valide
    Saisir Nom Utilisateur    ${LOGIN_USERNAME}

    # Étape 4 : Saisir un mot de passe valide
    Saisir Mot De Passe    ${LOGIN_PASSWORD}

    # Étape 5 : Cliquer sur Sign In
    Cliquer Sur Sign In

    # Résultat attendu : Connexion réussie, nom de l'utilisateur affiché
    Vérifier Succès Connexion    ${LOGIN_USERNAME}
