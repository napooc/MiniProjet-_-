*** Settings ***
Documentation    CT_US4_02 - Suppression d'un produit depuis le panier flottant (hover + X)
Resource    ../config/import_resources.resource

Suite Setup     Setup CT02
Suite Teardown  Teardown CT02

*** Test Cases ***
CT_US4_02 - DeleteProduct From Floating Cart
    [Documentation]    Vérifier que la suppression d'un produit depuis le panier flottant (hover + bouton X) fonctionne correctement
    
    # Étape 1: Accéder à la page d'accueil
    Log    Étape 1: Accéder à la page d'accueil
    Wait Until Element Is Visible    id=shoppingCartLink    timeout=10s
    
    # Étape 2: Ajouter 1 produit au panier via US-3 script
    Log    Étape 2: Ajouter 1 produit au panier via US-3 Add Products Script
    ${product_1}=    Add Products To Cart For US3
    Wait Until Element Is Visible    id=shoppingCartLink    timeout=10s
    
    # Étape 3: Survoler l'icône panier pour ouvrir le floating cart
    Log    Étape 3: Survoler l'icône panier pour ouvrir le floating cart
    Mouse Over    id=shoppingCartLink
    Wait Until Element Is Visible    xpath=((//div[contains(@class,'removeProduct')]) | (//a[contains(@class,'remove') and contains(.,'REMOVE')]))[1]    timeout=10s

    # Étape 4: Vérifier la présence du bouton X dans le floating cart
    Log    Étape 4: Vérifier la présence du bouton X/Remove dans le floating cart
    Wait Until Element Is Visible    xpath=((//div[contains(@class,'removeProduct')]) | (//a[contains(@class,'remove') and contains(.,'REMOVE')]))[1]    timeout=15s

    # Étape 5: Capturer le nombre de lignes produit dans le floating cart
    Log    Étape 5: Capturer le nombre de lignes produit dans le floating cart
    ${initial_items}=    Get Removable Items Count
    Should Be True    ${initial_items} >= 1

    # Étape 6: Supprimer le produit avec le bouton X du floating cart
    Log    Étape 6: Supprimer le produit avec le bouton X du floating cart
    Remove Product From Floating Cart    ${product_1}

    # Attendre un instant pour que la suppression soit traitée
    Sleep    2s

    # Étape 7: Vérifier que l'on reste sur la home (pas de navigation vers la page panier)
    Log    Étape 7: Vérifier que l'on reste hors de la page panier
    ${current_url}=    Get Location
    Should Not Contain    ${current_url}    shoppingCart

    # Étape 8: Vérifier que le panier est vide
    Log    Étape 8: Vérifier que le nombre de produits est 0
    ${final_items}=    Get Removable Items Count
    Should Be Equal As Integers    ${final_items}    0
    Log    Nombre de lignes avant/après suppression: ${initial_items} -> ${final_items}

    # Étape 9: Vérifier que le badge panier est à 0
    Log    Étape 9: Vérifier que le badge panier est mis à jour
    ${cart_count}=    Get Current Product Count
    Should Be Equal As Strings    ${cart_count}    0

    # Étape 10: Vérifier que le panier est vide après suppression
    Log    Étape 10: Vérifier que le panier est vide
    ${remaining_items}=    Get Removable Items Count
    Should Be Equal As Integers    ${remaining_items}    0

    # Étape 11: Vérifier l'état final (toujours hors page panier)
    Log    Étape 11: Vérifier l'état final (toujours hors page panier)
    ${final_url}=    Get Location
    Should Not Contain    ${final_url}    shoppingCart

    Log    Test CT_US4_02 complété avec succès
