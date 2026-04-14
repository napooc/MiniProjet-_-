*** Settings ***
# Automation ID = CT_US5_03
Documentation    CT_US5_03 – Augmenter le nombre d'items en ré-ajoutant le même produit avec une nouvelle quantité
Resource        ../../resources/common.resource
Resource        ../../resources/cart.resource
Resource        ../../fichiers/jdd_CT_US5.robot

Test Setup      Open Browser And Navigate To Site
Test Teardown   Run Keywords    Capture Page Screenshot    AND    Close Browser Session


*** Variables ***
${CATEGORY}               ${JDD_CATEGORY}
${PRODUCT_NAME}           ${JDD_PRODUCT_NAME}
${PRODUCT_NAME_UPPER}     ${JDD_PRODUCT_NAME_UPPER}
${CLICS_PREMIER_AJOUT}    ${JDD_CLICS_PREMIER_AJOUT}
${CLICS_DEUXIEME_AJOUT}   ${JDD_CLICS_DEUXIEME_AJOUT}


*** Test Cases ***
CT_US5_03_Augmenter_Quantite_En_Reajoutant_Produit
    [Documentation]    Vérifier que la quantité s'additionne correctement quand on ajoute
    ...                deux fois le même produit au panier.
    [Tags]    panier    quantite    CT_US5_03    valid

    # --- PREMIER AJOUT ---
    # Aller sur la catégorie Tablets et choisir le produit
    Go To Category              ${CATEGORY}
    Select Product From Category    ${PRODUCT_NAME}

    # Cliquer 2 fois sur le bouton + puis ajouter au panier
    Set Product Quantity        ${CLICS_PREMIER_AJOUT}
    Capture Page Screenshot    filename=screenshots/01_produit_avant_1er_ajout.png
    Add Product To Cart
    Sleep    2s

    # Ouvrir le panier et vérifier que le produit est présent avec sa quantité
    Open Cart
    Capture Page Screenshot    filename=screenshots/02_panier_apres_1er_ajout.png
    ${quantite_apres_1er_ajout}=    Lire Quantite Produit Dans Panier    ${PRODUCT_NAME_UPPER}
    Log    Quantité après le 1er ajout : ${quantite_apres_1er_ajout}
    Should Be True    ${quantite_apres_1er_ajout} > 0
    ...    msg=Le produit ${PRODUCT_NAME_UPPER} n'est pas présent dans le panier après le 1er ajout

    # --- DEUXIEME AJOUT ---
    # Cliquer sur le nom du produit dans le panier pour retourner à sa fiche
    Click Element    xpath=//h3[normalize-space()='${PRODUCT_NAME_UPPER}']
    Wait Until Element Is Visible    xpath=//p[contains(@class,'roboto-light')]    ${TIMEOUT}

    # Cliquer 1 fois sur le bouton + puis ajouter au panier
    Set Product Quantity        ${CLICS_DEUXIEME_AJOUT}
    Capture Page Screenshot    filename=screenshots/03_produit_avant_2eme_ajout.png
    Add Product To Cart
    Sleep    2s

    # --- VERIFICATION FINALE ---
    # Retourner au panier et vérifier que la quantité a bien augmenté
    Open Cart
    Capture Page Screenshot    filename=screenshots/04_panier_final.png
    ${quantite_finale}=    Lire Quantite Produit Dans Panier    ${PRODUCT_NAME_UPPER}
    Log    Quantité finale : ${quantite_finale}

    # La quantité finale doit être supérieure à la quantité après le 1er ajout
    Should Be True    ${quantite_finale} > ${quantite_apres_1er_ajout}
    ...    msg=La quantité n'a pas augmenté : avant=${quantite_apres_1er_ajout} après=${quantite_finale}

    # La quantité finale doit être exactement : quantité 1er ajout + clics du 2ème ajout
    ${quantite_attendue}=    Evaluate    ${quantite_apres_1er_ajout} + ${CLICS_DEUXIEME_AJOUT}
    Should Be Equal As Integers    ${quantite_finale}    ${quantite_attendue}
    ...    msg=La quantité attendue est ${quantite_attendue} mais le panier affiche ${quantite_finale}
