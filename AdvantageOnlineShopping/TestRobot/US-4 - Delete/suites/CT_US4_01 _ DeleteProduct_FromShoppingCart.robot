*** Settings ***
Documentation    CT_US4_01 - Suppression d'un produit depuis la page Shopping Cart (clic sur l'icône panier)
Library    SeleniumLibrary
Library    OperatingSystem
Resource    ../config/import_resources.resource

Suite Setup     Setup CT01
Suite Teardown  Teardown CT01

*** Test Cases ***
CT_US4_01 - DeleteProduct From Shopping Cart Page
    [Documentation]    Vérifier que la suppression d'un produit depuis la page Shopping Cart fonctionne correctement

    Log    Étape 1: Accéder à la page d'accueil
    Wait Until Element Is Visible    id=shoppingCartLink    timeout=10s

    # Étape 2: Ajouter 1 produit au panier via US-3 script
    Log    Étape 2: Ajouter 1 produit au panier via US-3 Add Products Script
    ${product_1}=    Add Products To Cart For US3
    Wait Until Element Is Visible    id=shoppingCartLink    timeout=10s

    # Étape 3: Cliquer sur l'icône panier pour naviguer vers la page Shopping Cart
    Log    Étape 3: Cliquer sur l'icône panier pour accéder à la page Shopping Cart
    Go To Shopping Cart Full Page
    ${current_url}=    Get Location
    Should Contain    ${current_url}    shoppingCart

    # Étape 4: Capturer le nombre de lignes produit dans le panier
    Log    Étape 4: Capturer le nombre de lignes produit dans le panier
    ${initial_items}=    Get Removable Items Count
    Should Be True    ${initial_items} >= 1

    # Étape 5: Supprimer le produit via le keyword Remove Product From Shopping Cart
    Log    Étape 5: Supprimer le produit via le bouton REMOVE de la page panier
    Remove Product From Shopping Cart    ${product_1}

    Sleep    2s

    # Étape 6: Vérifier que le nombre de lignes produit a diminué
    Log    Étape 6: Vérifier que le nombre de lignes produit a diminué de 1
    ${final_items}=    Get Removable Items Count
    Should Be Equal As Integers    ${final_items}    0
    Log    Nombre de lignes avant/après suppression: ${initial_items} -> ${final_items}

    # Étape 7: Vérifier que le badge panier est mis à jour à 0
    Log    Étape 7: Vérifier que le badge panier est mis à jour
    ${cart_count}=    Get Current Product Count
    Should Be Equal As Strings    ${cart_count}    0

    Log    Test CT_US4_01 complété avec succès
