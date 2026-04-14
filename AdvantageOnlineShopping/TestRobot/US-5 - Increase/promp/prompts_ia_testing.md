# Utilisation de l'IA (GitHub Copilot) — US-5 : Augmentation de la quantité

**Projet** : Advantage Online Shopping — Automatisation des tests  
**User Story** : US-5 — Increase Quantity  
**Outil IA** : GitHub Copilot (Claude)  
**Framework** : Robot Framework + SeleniumLibrary  

---

## Table des matières

1. [Librairie de prompts orientés testing](#1-librairie-de-prompts-orientés-testing)
2. [Génération des jeux de données de test](#2-génération-des-jeux-de-données-de-test)
3. [Amélioration des scripts d'automatisation](#3-amélioration-des-scripts-dautomatisation)
4. [Synthèse de l'apport de l'IA](#4-synthèse-de-lapport-de-lia)

---

## 1. Librairie de prompts orientés testing

### 1.1 Prompt non amélioré (basique)

> **Prompt :**  
> *« Écris-moi un test Robot Framework pour augmenter la quantité d'un produit dans le panier sur le site Advantage Online Shopping. »*

**Résultat obtenu :**  
L'IA a généré un script générique, linéaire et non fonctionnel :

```robot
*** Test Cases ***
Increase Quantity
    Open Browser    https://www.advantageonlineshopping.com    Chrome
    Click Element    xpath=//div[@id='speakersImg']
    Click Element    xpath=//a[@class='productName']
    Click Element    xpath=//button[@name='save_to_cart']
    Click Element    xpath=//a[@id='shoppingCartLink']
    Input Text       xpath=//input[@name='quantity']    5
    Click Button     xpath=//button[@name='save_to_cart']
    Close Browser
```

**Problèmes identifiés :**
- Aucun `Wait Until` → le script échoue sur un site Angular avec rendu asynchrone
- Aucune gestion du popup cart qui bloque la navigation
- Sélecteur `xpath=//a[@class='productName']` en match exact → ne fonctionne pas car la classe est `roboto-regular productName ng-binding`
- Aucune séparation entre données de test, pages et configuration
- Aucun cas invalide ou négatif (quantité 0, -1, décimale)
- Le bouton `+` est supposé sur la page panier alors qu'il n'existe que sur la page produit

---

### 1.2 Prompt amélioré (structuré et contextualisé)

> **Prompt :**  
> *« Je travaille sur le site Advantage Online Shopping (AngularJS, rendu dynamique). J'utilise Robot Framework avec SeleniumLibrary et une architecture POM (Page Object Model). J'ai besoin de tester l'augmentation de la quantité d'un produit dans le panier (US-5). Voici mes cas de test :*  
> - *CT_US5_01 : Modifier la quantité via le champ EDIT avec une valeur positive (ex: 10)*  
> - *CT_US5_02 : Tenter avec une valeur négative (-1) et vérifier que la quantité reste à 1*  
> - *CT_US5_03 : Tenter avec zéro (0) et vérifier le comportement*  
> - *CT_US5_04 : Augmenter la quantité via le bouton "+" sur la fiche produit*   
>  
> *Génère-moi les jeux de données (valides et invalides) dans un fichier .resource séparé, les keywords de la page panier (ShoppingCartPage.resource), et la suite de tests. Le site utilise des classes CSS dynamiques Angular (ng-binding, ng-scope), les éléments EDIT et REMOVE n'apparaissent qu'au survol de la ligne produit, et le bouton "+" n'est pas présent sur la page panier mais uniquement sur la page produit. Utilise des locators robustes avec `contains(@class,...)` et gère les waits Angular. »*

**Résultat obtenu :**  
L'IA a produit une architecture complète et fonctionnelle :

```
ressources/
├── jdd/
│   └── quantity_data.resource    ← Données valides + invalides
├── pages/
│   ├── HomePage.resource         ← Navigation & sélection catégorie
│   └── ShoppingCartPage.resource ← Keywords panier (Edit, Quantity, +)
config/
├── setupTeardown.robot           ← Setup/Teardown centralisés
└── importResources.robot         ← Import unique de toutes les ressources
suites/
└── CT_US5_01_IncreaseQuantity.robot ← Suite de tests
```

**Différences clés par rapport au prompt basique :**

| Aspect | Prompt basique | Prompt amélioré |
|--------|---------------|-----------------|
| Architecture | Script monolithique | POM avec séparation données/pages/config |
| Locators | `@class='exact'` (fragile) | `contains(@class,...)` (robuste) |
| Waits | Aucun | `Wait Until Element Is Visible` avec timeouts |
| Popup cart | Non géré | `Wait Until Cart Popup Is Gone` |
| Bouton EDIT | Non géré | Hover JS + clic JS (contourne CSS `:hover`) |
| Bouton `+` | Supposé sur page panier | Correctement placé sur page produit via EDIT |
| Cas négatifs | Absents | -1, 0, décimal, texte |
| Résultat test | **FAIL** (crash immédiat) | **PASS** (tous les cas) |

---

## 2. Génération des jeux de données de test

### 2.1 Prompt utilisé

> *« Génère-moi un fichier quantity_data.resource pour Robot Framework contenant des jeux de données pour tester l'augmentation de quantité dans un panier e-commerce. Inclus des données valides (quantités positives), invalides (négatif, zéro, trop élevé, texte, décimal), les noms de produits et catégories du site Advantage Online Shopping. »*

### 2.2 Résultat généré et validé

```robot
*** Variables ***
# Quantités valides
${VALID_QTY_1}              2
${VALID_QTY_2}              5
${VALID_QTY_3}              10
${INITIAL_QTY}              1
${valeur_btnplus}           4

# Quantités invalides
${INVALID_QTY_NEGATIVE}     -1
${INVALID_QTY_ZERO}         0
${INVALID_QTY_TOO_HIGH}     999
${INVALID_QTY_TEXT}         abc
${INVALID_QTY_DECIMAL}      2.5

# Produits
${PRODUCT_1_NAME}           HP Roar Mini Wireless Speaker
${PRODUCT_2_NAME}           HP CHROMEBOOK 14 G1(ENERGY STAR)
${PRODUCT_3_NAME}           BEATS STUDIO 2 OVER-EAR MATTE BLACK HEADPHONES

# Catégories
${CATEGORY_SPEAKERS}        SPEAKERS
${CATEGORY_LAPTOPS}         LAPTOPS
${CATEGORY_HEADPHONES}      HEADPHONES
```

### 2.3 Analyse critique et validation

**Ce que l'IA a bien fait :**
- Couverture complète des classes d'équivalence : positif, négatif, zéro, décimal, texte, limite haute
- Nommage explicite des variables (`INVALID_QTY_NEGATIVE` au lieu de `QTY_1`)
- Séparation claire entre données valides et invalides

**Ce que j'ai ajusté manuellement :**
- Ajout de `${INITIAL_QTY}` = 1 pour les assertions des cas invalides (la quantité doit rester à 1)
- Ajout de `${valeur_btnplus}` = 4 pour le test du bouton `+`
- Vérification des noms de produits exacts sur le site (casse et espaces)
- Ajout des XPath produits (`${PRODUCT_1_XPATH}`, etc.) pour navigation directe

---

## 3. Amélioration des scripts d'automatisation

### 3.1 Problème : le bouton `+` introuvable sur la page panier

**Prompt utilisé :**

> *« Mon keyword `Click Increase Button In Shopping Cart` échoue avec l'erreur : `Element with locator 'xpath=//div[@class='plus']' not found`. Le sélecteur ciblait `div.plus` sur la page Shopping Cart. Pourquoi ça ne marche pas ? Aide-moi à déboguer en inspectant le DOM réel de la ligne produit du panier. »*

**Diagnostic de l'IA :**  
L'IA a injecté du JavaScript de diagnostic pour dumper le HTML réel de la ligne produit du panier :

```robot
Execute JavaScript
...    var row = document.querySelector('table.fixedTableEdgeCompatibility tbody tr');
...    throw new Error('Row HTML: ' + row.innerHTML.substring(0,3000));
```

**Résultat du diagnostic** — Le HTML de la ligne panier ne contient aucun `div.plus` :

```html
<td class="smollCell quantityMobile">
    <label>QUANTITY</label>
    <label class="ng-binding">1</label>   <!-- Juste un label, pas de +/- -->
</td>
<td>
    <span class="actions">
        <a class="edit">EDIT</a> | <a class="remove">REMOVE</a>
    </span>
</td>
```

**Conclusion** : Le bouton `+` n'existe que sur la **page produit**, pas sur la page panier. La bonne approche est : cliquer EDIT → naviguer vers la page produit → cliquer `+` → sauvegarder → retourner au panier.

### 3.2 Amélioration proposée par l'IA et validée

**Avant (FAIL) :**
```robot
Set Product Quantity
    [Arguments]    ${times}
    Wait Until Element Is Visible    xpath=//div[@class='plus']    timeout=3s
    FOR    ${i}    IN RANGE    ${times}
        Click Element    xpath=//div[@class='plus']
        Sleep    2s
    END
```

**Après (PASS) :**
```robot
Set Product Quantity
    [Arguments]    ${times}
    Wait Until Element Is Visible    xpath=//table[...]//tbody//tr    timeout=15s
    Mouse Over    xpath=//table[...]//tbody//tr
    Sleep    1s
    Execute JavaScript    var e=document.querySelector('a.edit'); if(e){e.click();}
    Wait Until Element Is Visible    xpath=//div[@class='plus']    timeout=10s
    FOR    ${i}    IN RANGE    ${times}
        Click Element    xpath=//div[@class='plus']
        Sleep    1s
    END
    Click Button    ${LOC_ADD_TO_CART_BTN}
    Go To Shopping Cart Full Page
```

### 3.3 Amélioration : Hover JS pour le lien EDIT

**Problème** : Les liens EDIT et REMOVE ne sont visibles qu'au survol CSS (`:hover`) de la ligne produit. `Mouse Over` de SeleniumLibrary ne déclenche pas toujours le `:hover` CSS sous Chrome headless.

**Prompt utilisé :**

> *« Le lien EDIT du panier n'apparaît qu'au survol de la ligne produit. `Mouse Over` ne suffit pas car le site utilise AngularJS avec `ng-mouseenter`. Comment faire un hover fiable qui déclenche Angular et le CSS :hover ? »*

**Solution de l'IA :**
```robot
Execute JavaScript
...    var rows = document.querySelectorAll('table.fixedTableEdgeCompatibility tbody tr');
...    var row = null;
...    for(var i=0;i<rows.length;i++){
...        if(rows[i].textContent.toLowerCase().indexOf('${PRODUCT_NAME}'.toLowerCase())!==-1){
...            row=rows[i]; break; } }
...    if(row){ row.dispatchEvent(new MouseEvent('mouseover',{bubbles:true})); }
Sleep    1s
Execute JavaScript
...    var editBtn = row.querySelector('a.edit');
...    if(editBtn){ editBtn.click(); }
```

### 3.4 Optimisation : Data-Driven Testing avec boucle FOR

**Prompt utilisé :**

> *« J'ai 3 cas de test séparés (quantité positive, négative, nulle) qui font presque la même chose. Comment les fusionner en un seul test data-driven en Robot Framework ? »*

**Avant** : 3 test cases distincts avec code dupliqué  
**Après** : 1 test case paramétré avec boucle `FOR ... IN`

```robot
Increase Quantity Positive Value 10
    Click Category     ${CATEGORY_SPEAKERS}
    Select Product From Category     ${PRODUCT_1_NAME}
    Add Product To Cart From Product Page     1
    Go To Shopping Cart Full Page
    Click Edit From Shopping Cart     ${PRODUCT_1_NAME}

    FOR    ${QTY}    ${EXPECTED}        IN
    ...    ${VALID_QTY_3}               ${VALID_QTY_3}
    ...    ${INVALID_QTY_NEGATIVE}      ${INITIAL_QTY}
    ...    ${INVALID_QTY_ZERO}          ${INITIAL_QTY}
        Update Quantity In champ    ${QTY}
        Click Add To Cart Button
        Go To Shopping Cart Full Page
        ${q} =   Get Product Quantity
        Should Be Equal As Strings     ${q}    ${EXPECTED}
        Click Edit From Shopping Cart     ${PRODUCT_1_NAME}
    END
```

---

## 4. Synthèse de l'apport de l'IA

### 4.1 Bénéfices observés

| Bénéfice | Détail |
|----------|--------|
| **Accélération** | Génération instantanée de l'architecture POM, des données de test et des keywords de base |
| **Couverture de test** | L'IA a suggéré des cas limites non prévus initialement (quantité décimale, texte, valeur très élevée) |
| **Diagnostic avancé** | Injection de JavaScript de diagnostic pour inspecter le DOM réel — technique que le testeur n'aurait pas utilisée spontanément |
| **Connaissance Angular** | L'IA connaissait les contraintes spécifiques d'AngularJS (`ng-mouseenter`, lazy rendering, classes dynamiques) |
| **Robustesse des locators** | Remplacement systématique de `@class='exact'` par `contains(@class,'...')` pour gérer les classes Angular dynamiques |
| **Refactoring** | Proposition de fusionner les tests redondants en boucle `FOR` data-driven |

### 4.2 Limites constatées

| Limite | Exemple |
|--------|---------|
| **Hallucination DOM** | L'IA a d'abord supposé que `div.plus` existait sur la page panier — **faux**. Il a fallu un diagnostic HTML pour prouver son absence |
| **Prompt basique = résultat faible** | Sans contexte (Angular, POM, hover CSS), l'IA produit du code non fonctionnel qui crash au premier `Click Element` |
| **Itérations nécessaires** | Il a fallu 8+ tentatives pour résoudre le problème du bouton `+` (mouseover JS, Mouse Over Selenium, puis diagnostic DOM, puis changement d'approche via EDIT) |
| **Dépendance au testeur** | L'IA ne peut pas vérifier seule si le DOM contient l'élément — c'est le testeur qui doit lancer le test et fournir les logs d'erreur |
| **Connaissance du site** | L'IA ne connaît pas l'architecture réelle du site — elle travaille sur des hypothèses qu'il faut valider empiriquement |

### 4.3 Bonnes pratiques observées

1. **Fournir le maximum de contexte dans le prompt** : framework utilisé, architecture cible, contraintes techniques du site (Angular, hover CSS, lazy rendering)
2. **Toujours valider le code généré** par exécution réelle — ne jamais faire confiance aveuglément au code de l'IA
3. **Utiliser l'IA pour le diagnostic** : lui fournir les messages d'erreur exacts et lui demander d'injecter du code de diagnostic (dump HTML, console logs)
4. **Itérer avec feedback** : fournir les résultats de chaque exécution à l'IA pour qu'elle affine sa solution
5. **Séparer génération et validation** : utiliser l'IA pour générer, puis le testeur pour valider, corriger et approuver
6. **Documenter les prompts** : conserver les prompts qui ont fonctionné pour les réutiliser sur d'autres User Stories

### 4.4 Conclusion

L'IA (GitHub Copilot) a été un **accélérateur significatif** sur ce projet, réduisant le temps de développement des scripts d'automatisation et améliorant la couverture des tests. Cependant, son apport est directement proportionnel à la **qualité du prompt** fourni : un prompt vague produit du code inutilisable, tandis qu'un prompt structuré et contextualisé produit une base solide exploitable.