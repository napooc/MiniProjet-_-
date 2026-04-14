# Utilisation de l'IA (GitHub Copilot) – Activités de Test
## Projet : Advantage Online Shopping – US2 & US5
**Auteur :** Rim Ouchayan  
**Date :** Avril 2026  
**Outils :** GitHub Copilot · Robot Framework 7.0 · SeleniumLibrary 6.3.0 · Selenium (Java)

---

## Sommaire

1. [Génération des Jeux de Données de Test](#1-génération-des-jeux-de-données-de-test)
2. [Améliorations des Tests et Scripts d'Automatisation](#2-améliorations-des-tests-et-scripts-dautomatisation)
3. [Bibliothèque de Prompts Orientés Testing](#3-bibliothèque-de-prompts-orientés-testing)
4. [Synthèse de l'Apport de l'IA](#4-synthèse-de-lapport-de-lia)

---

## 1. Génération des Jeux de Données de Test

### 1.1 Données Valides générées par l'IA

L'IA a été utilisée pour générer le fichier `fichiers/jdd_CT_US5.robot` contenant les données de test pour le scénario CT_US5_03.

| Variable | Valeur | Description |
|---|---|---|
| `${JDD_CATEGORY}` | `TABLETS` | Catégorie de navigation |
| `${JDD_PRODUCT_NAME}` | `HP ElitePad 1000 G2` | Nom du produit à ajouter |
| `${JDD_PRODUCT_NAME_UPPER}` | `HP ELITEPAD 1000 G2 TABLET` | Nom affiché dans le panier |
| `${JDD_CLICS_PREMIER_AJOUT}` | `2` | Quantité lors du 1er ajout |
| `${JDD_CLICS_DEUXIEME_AJOUT}` | `1` | Quantité lors du 2ème ajout |

**Prompt utilisé :**
```
"Crée un fichier de jeux de données Robot Framework pour le test CT_US5_03.
Externalise toutes les variables : catégorie, nom produit, quantités d'ajout."
```

### 1.2 Données Invalides (à tester)

L'IA propose les cas invalides suivants pour renforcer la couverture de test :

| Cas | Données | Résultat attendu |
|---|---|---|
| Quantité = 0 | `${CLICS} = 0` | Produit non ajouté ou quantité inchangée |
| Produit inexistant | `HP ElitePad XXXX` | Aucun résultat dans la liste |
| Catégorie vide | `${CATEGORY} = ""` | Aucun produit affiché |
| Quantité très grande | `${CLICS} = 99` | Vérifier limite max du site |

**Prompt utilisé :**
```
"Génère des jeux de données invalides pour tester les cas limites
du scénario d'ajout au panier : quantité nulle, produit inexistant,
catégorie invalide."
```

---

## 2. Améliorations des Tests et Scripts d'Automatisation

### 2.1 Améliorations Proposées par l'IA

| Amélioration | Avant | Après (IA) | Validée |
|---|---|---|---|
| **Vérification quantité** | Pas de vérification intermédiaire | `Should Be True ${qty} > 0` après chaque ajout | ✅ Oui |
| **Captures d'écran** | Aucune capture | 4 screenshots aux étapes clés + teardown | ✅ Oui |
| **Externalisation données** | Variables dans le test | Fichier JDD séparé | ✅ Oui |
| **Robustesse lecture qty** | `Get Text` sans attente | `Wait Until Element Is Visible` sur le label avant lecture | ✅ Oui |
| **Vérification relative** | `Should Be Equal As Integers qty 3` (fragile) | `Should Be True qty_finale > qty_initiale` (robuste) | ✅ Oui |
| **Teardown automatique** | `Close Browser` seulement | `Capture Page Screenshot AND Close Browser` | ✅ Oui |

### 2.2 Analyse Critique par le Testeur

**Améliorations acceptées :**
- La vérification relative (`qty_finale > qty_initiale`) est plus robuste car elle ne dépend pas de l'état initial du panier
- Les captures d'écran facilitent le diagnostic en cas d'échec
- L'externalisation dans un fichier JDD améliore la maintenabilité

**Améliorations rejetées / ajustées :**
- L'IA avait proposé `\d+` dans le pattern regex → remplacé par `[0-9]+` car Robot Framework n'interprète pas les backslashes de la même façon
- L'IA avait proposé des `Sleep 5s` → réduits à `Sleep 2s` après validation que le site chargeait plus vite

**Prompt utilisé :**
```
"Analyse ce test Robot Framework et propose des améliorations :
vérifications manquantes, robustesse des sélecteurs, captures d'écran,
gestion des données de test."
```

---

## 3. Bibliothèque de Prompts Orientés Testing

### 3.1 Navigation & Sélection Produit

```
"Donne-moi le XPath pour cliquer sur la catégorie [NOM] dans le menu de navigation"
"Donne-moi le XPath pour sélectionner le produit [NOM] dans la liste"
"Comment naviguer vers une catégorie sans utiliser l'URL directement (Angular SPA) ?"
"Donne-moi le XPath pour revenir à la fiche produit depuis le panier"
```

### 3.2 Gestion du Panier

```
"Donne-moi le XPath du bouton + pour augmenter la quantité"
"Donne-moi le XPath du bouton Add to Cart"
"Donne-moi le XPath pour ouvrir le panier"
"Donne-moi le XPath pour lire la quantité d'un produit dans le panier"
"Comment lire un nombre dans un texte de type QTY: 3 avec Robot Framework ?"
```

### 3.3 Automatisation Robot Framework

```
"Crée un keyword Robot Framework qui [action] en utilisant SeleniumLibrary"
"Crée un test case Robot Framework pour [scénario], sans authentification"
"Ajoute des vérifications de quantité après chaque ajout au panier"
"Ajoute des captures d'écran aux étapes clés du test"
"Crée un fichier de jeux de données (JDD) pour externaliser les variables du test"
"Corrige l'erreur [message d'erreur] dans ce keyword Robot Framework"
"Comment attendre qu'un élément soit visible avant de lire son texte ?"
"Comment vérifier qu'une valeur a augmenté entre deux étapes du test ?"
```

### 3.4 Débogage

```
"Mon test échoue avec l'erreur [message], comment corriger ?"
"Le XPath [xpath] ne trouve pas l'élément, propose une alternative"
"Le regex \d+ ne fonctionne pas dans Robot Framework Evaluate, pourquoi ?"
"Comment gérer un element non visible au moment du clic ?"
```

### 3.5 Git & Push

```
"Initialise un dépôt Git et pousse vers [URL] sur une branche [nom]"
"Le push échoue avec erreur 403, comment corriger ?"
"Comment supprimer les credentials Git en cache sous Windows ?"
"Comment inclure deux dossiers dans un seul commit Git ?"
```

---

## 3.6 Référentiel XPaths du Projet (CT_US5_03)

Tous les XPaths validés et utilisés dans les scripts Robot Framework :

| Élément | XPath | Keyword associé |
|---|---|---|
| **Page d'accueil chargée** | `//h1[contains(@class,'roboto-bold')]` | `Go To Category` |
| **Catégorie dans le menu** | `//span[text()='TABLETS']` | `Go To Category` |
| **Titre de page catégorie** | `//h3[normalize-space()='TABLETS']` | `Go To Category` |
| **Lien produit dans la liste** | `//a[contains(text(),'HP ElitePad 1000 G2')]` | `Select Product From Category` |
| **Page produit chargée** | `//p[contains(@class,'roboto-light')]` | `Select Product From Category` |
| **Bouton + (augmenter quantité)** | `//div[@class='plus']` | `Set Product Quantity` |
| **Bouton Add to Cart** | `//button[@name='save_to_cart']` | `Add Product To Cart` |
| **Icône panier** | `//a[@href='#/shoppingCart']` | `Open Cart` |
| **Nom produit dans le panier** | `//h3[normalize-space()='HP ELITEPAD 1000 G2 TABLET']` | `Lire Quantite Produit Dans Panier` |
| **Label quantité dans le panier** | `//h3[normalize-space()='HP ELITEPAD 1000 G2 TABLET']/following-sibling::label[1]` | `Lire Quantite Produit Dans Panier` |
| **Loader de chargement** | `css:div.loader` | `Wait For Loader To Disappear` |

---

## 4. Synthèse de l'Apport de l'IA dans les Activités de Test

### 4.1 Bénéfices Observés

| Domaine | Apport |
|---|---|
| **Génération de code** | Création rapide des keywords, test cases, resources Robot Framework |
| **Débogage XPath** | Identification et correction des sélecteurs Selenium |
| **Débogage erreurs** | Correction regex (`\d+` → `[0-9]+`), gestion NoneType, labels vides |
| **Architecture** | Séparation des responsabilités : `common.resource` / `cart.resource` / `jdd_CT_US5.robot` |
| **Git** | Init repo, gestion credentials Windows, création branche, push |
| **Documentation** | Génération de commentaires et de fichiers de synthèse |

### 4.2 Limites Observées

| Limite | Description |
|---|---|
| **DOM non visible** | L'IA ne voit pas le DOM réel du navigateur — les XPath nécessitent des essais empiriques |
| **Timing dynamique** | Les `Sleep` et `Wait Until` doivent être ajustés selon la vitesse réelle du site |
| **Credentials externes** | L'IA ne peut pas gérer les tokens GitHub ni les invitations collaborateur |
| **État du navigateur** | L'IA ne connaît pas le contenu réel du panier entre les exécutions |
| **Applications SPA** | Les applications Angular nécessitent une navigation par clics, pas par URL directe |

### 2.3 Bonnes Pratiques Observées

1. **Externaliser les données** dans un fichier JDD séparé — facilite la maintenance et la lisibilité
2. **Un keyword = une responsabilité** — `Go To Category`, `Select Product`, `Add Product To Cart` séparés
3. **Vérifications relatives** — Comparer `qty_finale > qty_initiale` plutôt qu'une valeur absolue (robuste si le panier n'est pas vide)
4. **Captures d'écran systématiques** — Aux étapes clés + en teardown en cas d'échec
5. **`Wait Until Element Is Visible` avant toute lecture** — Évite les erreurs `NoneType` sur éléments non chargés
6. **Nommage explicite en français** — Variables comme `${quantite_apres_1er_ajout}` lisibles par toute l'équipe
7. **Reformuler les prompts** — Si l'IA propose une solution qui ne fonctionne pas, décrire le contexte plus précisément

### 2.4 Workflow IA Recommandé

```
1. Décrire le scénario de test en langage naturel
2. Demander la génération du squelette du test
3. Exécuter le test → identifier l'erreur
4. Copier le message d'erreur exact dans le prompt
5. Appliquer la correction proposée
6. Répéter jusqu'à PASS
7. Demander la simplification / refactoring du code obtenu
```

---

## 3. Résumé du Projet

| Élément | Valeur |
|---|---|
| **Test automatisé** | CT_US5_03 – Augmenter la quantité en ré-ajoutant le même produit |
| **Statut** | ✅ PASS |
| **Branche GitHub** | `ouchayan-rim__US2_US5` |
| **Repo** | https://github.com/napooc/MiniProjet-_- |
| **Fichiers créés** | `suites/panier/CT_US5_03.robot`, `resources/cart.resource`, `resources/common.resource`, `fichiers/jdd_CT_US5.robot` |
| **Captures d'écran** | 4 screenshots générés dans `results/` |
