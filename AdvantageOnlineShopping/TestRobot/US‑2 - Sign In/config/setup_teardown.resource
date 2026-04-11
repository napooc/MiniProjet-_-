*** Settings ***
Library     SeleniumLibrary
Library     OperatingSystem
Resource    ../resources/jdd/signin_data.resource


*** Keywords ***

Suite Setup - Open Browser To AOS
    [Documentation]    Ouvre le navigateur et navigue vers le site AOS.
    ${options}=         Evaluate    selenium.webdriver.ChromeOptions()    modules=selenium.webdriver
    Call Method         ${options}    add_argument    --no-sandbox
    Call Method         ${options}    add_argument    --disable-dev-shm-usage
    Call Method         ${options}    add_argument    --disable-extensions
    Open Browser          ${BASE_URL}    ${BROWSER}    options=${options}
    Maximize Browser Window
    Set Selenium Implicit Wait    ${IMPLICIT_WAIT}
    Wait Until Element Is Visible      xpath://a[@id='menuUserLink'][@aria-label='UserMenu']    timeout=20s
    Wait Until Element Is Not Visible    css:.loader    timeout=15s

Suite Teardown - Close Browser
    [Documentation]    Ferme le navigateur à la fin de la suite de tests.
    Close Browser

Test Teardown - Capture On Failure
    [Documentation]    Capture automatiquement une screenshot si le test échoue.
    ...                Utile pour le diagnostic en cas d'erreur.
    Run Keyword If Test Failed    Capture Page Screenshot    EMBED

# ════════════════════════════════════════════════════════════════════
# SUITE SETUP AJOUTÉ POUR CT_US2_02
# ════════════════════════════════════════════════════════════════════
#
# WHY A SEPARATE SETUP KEYWORD?
#   CT_US2_01 : Précondition = utilisateur DÉCONNECTÉ → on ouvre juste le navigateur.
#   CT_US2_02 : Précondition = utilisateur DÉJÀ CONNECTÉ → on doit se connecter
#               AVANT que le test commence.
#
#   C'est le principe du "GIVEN" en BDD (Behavior Driven Development) :
#   le Setup met le système dans l'état de départ requis pour le test.
#   Ici l'état de départ requis est : "être connecté".
#
# WHY RE-USE EXISTING KEYWORDS?
#   Les keywords Cliquer Sur Icone Utilisateur, Saisir Nom Utilisateur, etc.
#   sont déjà définis et testés dans SigninPage.resource.
#   Les ré-utiliser ici = zéro duplication = si l'AOS change son interface,
#   on corrige UNE SEULE FOIS dans SigninPage.resource et tout fonctionne.
#
# IMPORTANT — ORDER OF IMPORTS:
#   Ce fichier (setup_teardown.resource) est importé PAR import_resources.resource.
#   import_resources.resource importe aussi SigninPage.resource.
#   Donc les keywords de SigninPage (Cliquer Sur Icone Utilisateur, etc.)
#   sont disponibles ici sans avoir besoin de les ré-importer.
# ════════════════════════════════════════════════════════════════════

Suite Setup - Open Browser To AOS And Login
    [Documentation]    PRÉCONDITION pour CT_US2_02 :
    ...                1. Ouvre le navigateur et navigue vers AOS.
    ...                2. Effectue la connexion complète pour que le test
    ...                   commence avec un utilisateur DÉJÀ CONNECTÉ.
    ...                WHY: Le test CT_US2_02 vérifie la reconnexion APRÈS déconnexion.
    ...                     Il faut donc être connecté AU DÉBUT du test.

    # ── Phase 1 : Ouvrir le navigateur (identique à CT_US2_01 Setup) ─
    # WHY: On réutilise la même logique que Suite Setup - Open Browser To AOS.
    #      Les options Chrome (no-sandbox, disable-dev-shm) sont nécessaires
    #      pour éviter des crashes sur certains environnements Windows/CI.
    ${options}=         Evaluate    selenium.webdriver.ChromeOptions()    modules=selenium.webdriver
    Call Method         ${options}    add_argument    --no-sandbox
    Call Method         ${options}    add_argument    --disable-dev-shm-usage
    Call Method         ${options}    add_argument    --disable-extensions
    Open Browser          ${BASE_URL}    ${BROWSER}    options=${options}
    Maximize Browser Window
    Set Selenium Implicit Wait    ${IMPLICIT_WAIT}

    # Attendre que la page soit prête avant de continuer
    # WHY: AOS utilise AngularJS. La page montre un spinner au chargement.
    #      Si on clique avant que le spinner parte, l'action est ignorée.
    Wait Until Element Is Visible      xpath://a[@id='menuUserLink'][@aria-label='UserMenu']    timeout=20s
    Wait Until Element Is Not Visible    css:.loader    timeout=15s

    # ── Phase 2 : Se connecter (pour satisfaire la précondition) ─────
    # WHY: On appelle exactement les mêmes keywords que le test CT_US2_01 utilise.
    #      C'est la démonstration parfaite de la réutilisabilité POM :
    #      les keywords sont indépendants du contexte qui les appelle.
    Cliquer Sur Icone Utilisateur
    Saisir Nom Utilisateur    ${LOGIN_USERNAME}
    Saisir Mot De Passe       ${LOGIN_PASSWORD}
    Cliquer Sur Sign In

    # ── Phase 3 : Vérifier que la connexion du Setup a réussi ────────
    # WHY: Si la connexion du Setup échoue, le test CT_US2_02 n'a aucun sens.
    #      Robot Framework marquera le TEST comme ERREUR (pas FAIL) si le Setup plante.
    #      C'est volontaire : si on ne peut pas préparer l'état initial, le test est invalide.
    Vérifier Succès Connexion    ${LOGIN_USERNAME}
