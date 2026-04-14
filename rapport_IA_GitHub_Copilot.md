# Utilisation de l'IA (GitHub Copilot) — Activités de Test
## Projet : Advantage Online Shopping — Automatisation Multi-US

**Auteur :** Rim Ouchayan  
**Date :** Avril 2026  
**Outils IA :** GitHub Copilot (Claude Sonnet 4.6)  
**Frameworks :** Robot Framework 7.0 · SeleniumLibrary 6.3.0 · Selenium Java (TestNG)  
**Périmètre couvert :** US-1 (Sign Up) · US-2 (Sign In) · US-3 (Add to Cart) · US-4 (Delete) · US-5 (Increase/Delete)

---

## Sommaire

1. [Génération des Jeux de Données de Test](#1-génération-des-jeux-de-données-de-test)
2. [Améliorations des Tests et Scripts d'Automatisation](#2-améliorations-des-tests-et-scripts-dautomatisation)
3. [Bibliothèque de Prompts Orientés Testing](#3-bibliothèque-de-prompts-orientés-testing)
4. [Synthèse de l'Apport de l'IA](#4-synthèse-de-lapport-de-lia)

---

## 1. Génération des Jeux de Données de Test

L'IA a été sollicitée à chaque User Story pour générer les données de test structurées, séparées du code d'automatisation selon le principe **Data-Driven Testing**.

---

### 1.1 US-1 — Inscription (Selenium Java)

**Fichier concerné :** `TestSelenium/US-1 - Sign up/src/test/java/tests/authentication/SignUpTest.java`

#### Données Valides générées par l'IA

| Champ | Valeur | Justification |
|---|---|---|
| `username` | `qa_auto_user` | Nom unique, format alphanumérique |
| `email` | `qa_auto_user@test.com` | Format e-mail valide, domaine test |
| `password` | `Test@1234` | Respecte les contraintes (majuscule, chiffre, caractère spécial) |
| `confirm_password` | `Test@1234` | Identique au mot de passe |
| `first_name` | `Test` | Prénom simple, sans caractères spéciaux |
| `last_name` | `User` | Nom simple |
| `phone` | `0600000000` | Format téléphone FR valide |

**Prompt utilisé :**
```
"Génère des données de test valides pour un formulaire d'inscription avec :
username, email, password (avec contraintes : majuscule, chiffre, caractère
spécial), confirmation password, prénom, nom, téléphone. Le site cible est
advantageonlineshopping.com."
```

#### Données Invalides proposées par l'IA

| Cas | Données | Résultat attendu |
|---|---|---|
| Username déjà pris | `qa_auto_user` (existant) | Message "username already exist" |
| Email malformé | `qa_auto_user@` | Champ invalidé / formulaire bloqué |
| Passwords différents | `Test@1234` / `Test@5678` | Message d'erreur de confirmation |
| Password trop court | `abc` | Validation front-end bloquante |
| Téléphone non numérique | `abcdefghij` | Champ rejeté |
| Sans cocher "I agree" | Tous champs valides, case décochée | Bouton Register inactif |

**Prompt utilisé :**
```
"Génère des cas de test invalides pour le formulaire d'inscription :
username déjà existant, email malformé, mots de passe non concordants,
mot de passe trop court, téléphone non numérique, case CGU non cochée."
```

---

### 1.2 US-5 Increase — Augmentation quantité panier (Robot Framework)

**Fichier concerné :** `TestRobot/US-5 - Increase/fichiers/jdd_CT_US5.robot`

#### Données Valides générées par l'IA

```robotframework
*** Variables ***
${JDD_CATEGORY}               TABLETS
${JDD_PRODUCT_NAME}           HP ElitePad 1000 G2
${JDD_PRODUCT_NAME_UPPER}     HP ELITEPAD 1000 G2 TABLET
${JDD_CLICS_PREMIER_AJOUT}    ${2}
${JDD_CLICS_DEUXIEME_AJOUT}   ${1}
```

| Variable | Valeur | Description |
|---|---|---|
| `${JDD_CATEGORY}` | `TABLETS` | Catégorie accessible via le menu horizontal |
| `${JDD_PRODUCT_NAME}` | `HP ElitePad 1000 G2` | Nom exact dans la liste produits |
| `${JDD_PRODUCT_NAME_UPPER}` | `HP ELITEPAD 1000 G2 TABLET` | Nom en majuscules affiché dans le panier |
| `${JDD_CLICS_PREMIER_AJOUT}` | `2` | Nombre de clics sur "+" lors du 1er ajout |
| `${JDD_CLICS_DEUXIEME_AJOUT}` | `1` | Nombre de clics sur "+" lors du 2ème ajout |

**Prompt utilisé :**
```
"Crée un fichier de jeux de données Robot Framework pour le test CT_US5_03.
Externalise toutes les variables : catégorie, nom produit (deux variantes :
affichage liste et affichage panier), et quantités d'ajout sous forme d'entiers."
```

#### Données Invalides proposées par l'IA

| Cas | Données | Résultat attendu |
|---|---|---|
| Quantité = 0 | `${JDD_CLICS_PREMIER_AJOUT} = ${0}` | Produit non ajouté ou quantité = 1 par défaut |
| Produit inexistant | `HP ElitePad XXXX` | Aucun élément trouvé → erreur XPath |
| Catégorie vide | `${JDD_CATEGORY} = ${""}` | Aucun produit affiché, navigation impossible |
| Quantité très élevée | `${JDD_CLICS_PREMIER_AJOUT} = ${99}` | Vérifier comportement limite du site |
| Nom panier incorrect | Casse erronée | `Should Not Be Empty` échoue |

---

### 1.3 Génération de Données Multi-formats et à Volume

L'un des apports les plus significatifs de l'IA est sa capacité à générer des jeux de données **réalistes**, **structurés** et **en volume** dans des formats exploitables directement selon le contexte technique.

#### Formats générés

| Format | Exemple généré | Usage |
|---|---|---|
| **Robot Framework** | `${JDD_PRODUCT_NAME}    HP ElitePad 1000 G2` | Variables de test RF |
| **JSON** | `{"username": "qa_auto_user", "phone": "+33600000000"}` | API / mocks |
| **CSV** | `qa_auto_user,Test@1234,test@mail.com,0600000000` | Tests data-driven paramétrés |
| **SQL** | `INSERT INTO users VALUES ('qa_auto_user', 'Test@1234', ...)` | Initialisation base de données |
| **Java constants** | `public static final String TEST_USERNAME = "qa_auto_user";` | Classes de test Selenium |

L'IA génère ces données en respectant les contraintes métier (format téléphone, règles mot de passe, unicité) et peut produire des **jeux de masse** (dizaines de combinaisons) en un seul prompt.

#### Données Invalides à Haute Valeur — Cas que l'on n'anticipe pas toujours

L'un des apports cruciaux de l'IA est la génération de données **invalides non évidentes** que le testeur n'aurait pas forcément pensé à inclure :

| Catégorie | Exemple de données | Objectif |
|---|---|---|
| **Injection SQL** | `' OR '1'='1` dans le champ username | Vérifier la robustesse contre les tentatives d'injection |
| **Injection SQL (mot de passe)** | `'; DROP TABLE users; --` | Tester la sécurité de l'authentification |
| **Chaîne trop longue** | 256 caractères dans le champ prénom | Vérifier les limites des champs en base et en UI |
| **Caractères spéciaux** | `<script>alert('xss')</script>` dans username | Détecter les failles XSS potentielles |
| **Espaces uniquement** | `"   "` dans un champ obligatoire | Tester la validation côté serveur |
| **Caractères Unicode** | `用户名`, `Ñoño`, `émoji🔥` | Tester l'encodage et l'internationalisation |
| **Format e-mail limite** | `a@b.c`, `user+tag@domain.co.uk` | Couvrir les variantes valides non testées |

Ces cas, difficiles à imaginer systématiquement, permettent de couvrir des scénarios de **robustesse et de sécurité** dès la première phase de test, **réduisant les coûts** liés à la détection tardive de ces défauts.

### 1.4 Stratégie Globale de Génération des Données

L'IA a systématiquement proposé la structure suivante pour chaque US :

```
Fichier JDD (données) ─── séparé de ──► Fichier Test (.robot / .java)
       │                                         │
  Variables externes                    Paramètres injectés
  Maintenabilité accrue                 Lisibilité du test
```

**Avantage validé :** La modification d'une donnée (ex: changer de produit) ne nécessite qu'une modification dans le fichier JDD, sans toucher au script de test.

---

## 2. Améliorations des Tests et Scripts d'Automatisation

### 2.1 Améliorations sur CT_US5_03 (Robot Framework)

| # | Amélioration | Avant (version initiale) | Après (version IA validée) | Validée |
|---|---|---|---|---|
| 1 | **Vérification quantité intermédiaire** | Aucune vérification entre les deux ajouts | `Should Be True ${quantite_apres_1er_ajout} > 0` | ✅ |
| 2 | **Captures d'écran aux étapes clés** | Aucune capture | 4 screenshots : avant/après chaque ajout + teardown | ✅ |
| 3 | **Externalisation des données** | Variables inline dans le test | Fichier `jdd_CT_US5.robot` séparé | ✅ |
| 4 | **Attente avant lecture quantité** | `Get Text` direct | `Wait Until Element Is Visible` avant `Get Text` | ✅ |
| 5 | **Vérification relative robuste** | `Should Be Equal As Integers qty 3` (fragile) | `Should Be True ${qty_finale} > ${qty_initiale}` | ✅ |
| 6 | **Teardown enrichi** | `Close Browser` seul | `Run Keywords Capture Page Screenshot AND Close Browser Session` | ✅ |
| 7 | **Extraction regex sécurisée** | `\d+` dans Evaluate (non interprété) | `[0-9]+` avec `re.search(...).group()` | ✅ |
| 8 | **Navigation SPA** | `Go To` direct sur URL produit | Navigation par clics : catégorie → produit | ✅ |

### 2.2 Améliorations sur CT_US1_01 (Selenium Java)

| # | Amélioration | Avant | Après (IA) | Validée |
|---|---|---|---|---|
| 1 | **Attente explicite uniformisée** | Mix `Thread.sleep` / `wait` | `WebDriverWait` + `ExpectedConditions` partout | ✅ |
| 2 | **jsClick pour éléments Angular** | `element.click()` | `jsClick(element)` via `JavascriptExecutor` | ✅ |
| 3 | **Vérification double assertion** | Un seul `assertTrue` | `assertTrue(url)` + `assertFalse(pageSource.contains("already exist"))` | ✅ |
| 4 | **Loader wait réutilisable** | `Thread.sleep(3000)` | `waitForLoaderToDisappear()` dans `AppTest` | ✅ |
| 5 | **Classe de base `AppTest`** | Code dupliqué dans chaque test | `AppTest` avec `@BeforeMethod` / `@AfterMethod` | ✅ |

### 2.3 Qualité des Sélecteurs XPath — Apport de l'IA

GitHub Copilot a joué un rôle déterminant dans la sélection des localisateurs Selenium. Pour chaque élément à cibler, l'IA propose plusieurs alternatives classées par robustesse :

| Niveau | Sélecteur proposé | Robustesse |
|---|---|---|
| ❌ Fragile | `//div[3]/span[2]` (position absolue) | Casse au moindre changement de structure |
| ⚠️ Moyen | `//span[@class='category-name']` (classe seule) | Sensible aux renommages CSS |
| ✅ Robuste | `//span[normalize-space()='TABLETS']` (texte normalisé) | Résistant aux espaces et aux espaces insécables |
| ✅ Robuste | `//h3[normalize-space()='${PRODUCT}']/following-sibling::label[1]` | Relation structurelle, indépendante du positionnement |

L'IA privilégie systématiquement les sélecteurs basés sur le **contenu textuel normalisé** et les **relations DOM** (`following-sibling`, `ancestor`, `contains`) plutôt que sur des positions fragiles.

### 2.4 Analyse Critique par le Testeur

#### Améliorations Acceptées

- **Vérification relative** (`qty_finale > qty_initiale`) est préférée car elle reste valide même si le panier n'est pas vide avant le test
- **`Wait Until Element Is Visible`** avant toute lecture évite les erreurs `NoneType` dues au rendu asynchrone Angular
- **`jsClick`** en Java pour contourner les éléments masqués par des overlays Angular
- **`AppTest` comme classe de base** en Java centralise le setup/teardown, élimination de la duplication

**Point crucial — Validation humaine systématique :** L'IA propose, le testeur valide. Chaque suggestion est examinée avant d'être appliquée pour s'assurer qu'elle ne génère pas de faux positifs et qu'elle respecte les exigences métier. Un test qui passe grâce à une mauvaise assertion est pire qu'un test qui échoue honnêtement.

#### Améliorations Rejetées ou Ajustées

| Proposition IA | Problème | Solution adoptée |
|---|---|---|
| `\d+` dans Evaluate RF | RF n'interprète pas les backslashes dans les chaînes | Remplacé par `[0-9]+` |
| `Sleep 5s` génériques | Trop long, ralentit la suite | Réduit à `Sleep 2s` après observation réelle |
| XPath par `id` ou `class` seul | Sélecteurs fragiles sur SPA Angular | XPath combinés `normalize-space()` / `contains()` |
| URL directe vers page produit | Ne fonctionne pas sur Angular SPA | Navigation par clics obligatoire |
| Fonctions RF inexistantes | L'IA a parfois inventé des keywords qui n'existent pas dans SeleniumLibrary | Vérification dans la documentation officielle avant usage |

### 2.4 Architecture Résultante Validée

```
US-5 - Increase/
├── config/
│   └── config.robot          ← BASE_URL, BROWSER, TIMEOUT
├── resources/
│   ├── common.resource       ← Open Browser, Wait For Loader, JS Click
│   └── cart.resource         ← Go To Category, Add To Cart, Lire Quantite
├── fichiers/
│   └── jdd_CT_US5.robot      ← Données de test externalisées
└── suites/
    └── panier/
        └── CT_US5_03.robot   ← Test case pur, sans logique technique
```

**Principe validé :** Un fichier test ne contient que la logique métier. Toute la technique (XPath, attentes, navigateur) est dans les resources.

---

## 3. Bibliothèque de Prompts Orientés Testing

Cette section documente les prompts utilisés tout au long du projet, classés par domaine.

---

### 3.1 Génération de Jeux de Données

```
"Génère des données de test valides pour [formulaire/scénario] avec les
contraintes suivantes : [liste des contraintes métier]."

"Génère des cas de données invalides pour [scénario] couvrant :
valeurs nulles, formats incorrects, valeurs hors limites, données dupliquées."

"Crée un fichier de jeux de données Robot Framework pour le test [ID].
Externalise toutes les variables : [liste de variables]. Format *** Variables ***."

"Génère un fichier .java contenant les constantes de test pour [classe de test] :
URL de base, credentials, données formulaire."
```

---

### 3.2 Génération de Tests Robot Framework

```
"Crée un test case Robot Framework pour le scénario : [description en langage naturel].
Utilise les keywords : [liste de keywords]. Sans authentification."

"Crée un keyword Robot Framework nommé [Nom] qui [action].
Utilise SeleniumLibrary. Arguments : [liste]."

"Ajoute des vérifications de quantité après chaque ajout au panier
dans ce test Robot Framework : [coller le code]."

"Ajoute 4 captures d'écran aux étapes clés de ce test :
avant ajout 1, après ajout 1, avant ajout 2, résultat final."

"Écris le teardown pour ce test : capturer une screenshot en cas d'échec
et fermer le navigateur."
```

---

### 3.3 Génération de Tests Selenium Java

```
"Crée un test TestNG pour le scénario d'inscription sur [URL].
Utilise WebDriverWait avec ExpectedConditions. Classe de base : AppTest."

"Génère une classe de base AppTest avec @BeforeMethod (ChromeDriver, maximize,
WebDriverWait 15s) et @AfterMethod (driver.quit())."

"Ajoute une méthode jsClick(WebElement) utilisant JavascriptExecutor."

"Génère deux assertions pour vérifier la réussite de l'inscription :
URL de redirection et absence du message 'username already exist'."
```

---

### 3.4 Navigation & Sélecteurs XPath

```
"Donne-moi le XPath pour cliquer sur la catégorie [NOM] dans le menu de navigation
d'une application Angular (les textes peuvent avoir des espaces)."

"Donne-moi le XPath pour sélectionner le produit [NOM] dans une liste de produits."

"Donne-moi le XPath pour lire la quantité d'un produit [NOM] dans un panier,
sachant que le nom est dans un <h3> et la quantité dans un <label> frère suivant."

"Comment naviguer vers une page produit dans une SPA Angular sans utiliser Go To URL ?"

"Le XPath [xpath] ne trouve pas l'élément. Voici le HTML : [coller HTML].
Propose une alternative."
```

---

### 3.5 Débogage et Correction d'Erreurs

```
"Mon test Robot Framework échoue avec l'erreur : [message exact].
Voici le keyword concerné : [coller code]. Comment corriger ?"

"Le regex \d+ dans Evaluate de Robot Framework ne fonctionne pas.
Pourquoi et quelle alternative ?"

"J'ai une erreur NoneType lors du Get Text. L'élément est visible mais le texte
est vide. Comment sécuriser la lecture ?"

"Le click() Selenium échoue avec ElementClickInterceptedException.
L'élément est derrière un overlay Angular. Comment contourner ?"

"Comment attendre la disparition d'un loader CSS avant d'interagir avec la page ?"
```

---

### 3.6 Architecture et Refactoring

```
"Comment organiser les fichiers d'un projet Robot Framework en séparant :
config, données, resources et suites ?"

"Refactorise ce test Robot Framework en extrayant les keywords techniques
dans un fichier resource séparé."

"Comment appliquer le pattern Page Object Model en Robot Framework ?"

"Mon test Robot Framework a du code dupliqué entre [fichier A] et [fichier B].
Comment centraliser dans un resource commun ?"
```

---

### 3.7 Git et Gestion de Version

```
"Initialise un dépôt Git local et pousse vers [URL] sur la branche [nom]."

"Le push échoue avec l'erreur 403 Forbidden. Comment corriger les credentials
Git sous Windows (Credential Manager) ?"

"Comment inclure plusieurs dossiers dans un seul commit Git ?"

"Comment créer et pousser une branche nommée [nom] vers un remote GitHub ?"
```

---

### 3.8 Documentation

```
"Génère un rapport Markdown documentant l'utilisation de GitHub Copilot
dans les activités de test du projet [nom]. Inclure : JDD, améliorations,
prompts utilisés, synthèse bénéfices/limites."

"Ajoute des commentaires [Documentation] à tous les keywords de ce fichier
resource Robot Framework."

"Génère un tableau récapitulatif des XPaths utilisés dans le projet avec
l'élément ciblé et le keyword associé."
```

---

### 3.9 Référentiel XPaths Validés du Projet

| Élément | XPath | Keyword |
|---|---|---|
| Page d'accueil chargée | `//h1[contains(@class,'roboto-bold')]` | `Open Browser And Navigate To Site` |
| Catégorie dans le menu | `//span[text()='TABLETS']` | `Go To Category` |
| Titre page catégorie | `//h3[normalize-space()='TABLETS']` | `Go To Category` |
| Lien produit dans liste | `//a[normalize-space()='HP ElitePad 1000 G2']` | `Select Product From Category` |
| Page produit chargée | `//p[contains(@class,'roboto-light')]` | `Select Product From Category` |
| Bouton + (incrément quantité) | `//div[@class='plus']` | `Set Product Quantity` |
| Bouton Add to Cart | `//button[@name='save_to_cart']` | `Add Product To Cart` |
| Icône panier | `//a[@href='#/shoppingCart']` | `Open Cart` |
| Nom produit dans panier | `//h3[normalize-space()='HP ELITEPAD 1000 G2 TABLET']` | `Lire Quantite Produit Dans Panier` |
| Label quantité panier | `//h3[normalize-space()='HP ELITEPAD 1000 G2 TABLET']/following-sibling::label[1]` | `Lire Quantite Produit Dans Panier` |
| Loader de chargement | `css:div.loader` | `Wait For Loader To Disappear` |
| Menu utilisateur | `By.id("menuUser")` (Java) | `openUserMenu()` |
| Lien création compte | `By.className("create-new-account")` (Java) | `CT_US1_01` |
| Bouton Register | `By.id("register_btn")` (Java) | `CT_US1_01` |

---

## 4. Synthèse de l'Apport de l'IA dans les Activités de Test

### 4.1 Bénéfices Observés

| Domaine | Apport Concret | Gain Estimé |
|---|---|---|
| **Génération de code** | Squelettes de tests, keywords, classes Java générés en quelques secondes | -60% temps de rédaction |
| **Jeux de données** | Données valides ET invalides structurées, cas limites identifiés | -50% temps de conception |
| **Débogage XPath** | Identification et correction des sélecteurs Selenium/RF | -40% temps de debug |
| **Débogage erreurs RF** | Correction regex `\d+` → `[0-9]+`, NoneType, loader timing | Résolution en 1-2 itérations |
| **Architecture** | Séparation systématique config / resources / JDD / suites | Code maintenable dès la 1ère version |
| **Git** | Init repo, gestion credentials Windows, push multi-dossiers | Autonomie immédiate |
| **Documentation** | Génération automatique de tableaux, commentaires, rapports Markdown | -70% temps de documentation |

### 4.2 Limites Observées

| Limite | Description | Contournement |
|---|---|---|
| **DOM non visible** | L'IA ne voit pas le DOM réel — les XPath demandent des ajustements empiriques | Inspecter l'élément manuellement, puis soumettre le HTML à l'IA |
| **Timing dynamique** | Les `Sleep` et `Wait Until` proposés doivent être calibrés sur le site réel | Observer le comportement, réduire les délais après validation |
| **Contexte limité** | L'IA ignore l'état du panier entre les exécutions | Ajouter des preconditions ou un setup d'état |
| **Applications SPA** | Les SPA Angular nécessitent une navigation par clics, non par URL | Spécifier explicitement "ne pas utiliser Go To URL" dans le prompt |
| **Credentials externes** | L'IA ne peut pas gérer les tokens GitHub ni les conflits de droits | Gestion manuelle via Windows Credential Manager |
| **Hallucinations** | L'IA peut proposer des XPath plausibles mais invalides | Toujours valider en exécutant le test |
| **Regex RF** | Comportement des backslashes différent de Python pur | Toujours tester le regex isolément avant intégration |

### 4.3 Bonnes Pratiques Observées

1. **Externaliser les données dans un fichier JDD séparé** — un seul point de modification pour changer les paramètres de test

2. **Un keyword = une seule responsabilité** — `Go To Category`, `Select Product`, `Add Product To Cart`, `Lire Quantite` sont des unités indépendantes et réutilisables

3. **Vérifications relatives plutôt qu'absolues** — `qty_finale > qty_initiale` reste valide quel que soit l'état initial du panier

4. **`Wait Until Element Is Visible` systématique** avant toute action ou lecture — élimine les erreurs d'éléments non chargés

5. **Captures d'écran aux étapes clés + en teardown** — facilite le diagnostic d'échecs en exécution CI/CD

6. **Nommage explicite et lisible** — `${quantite_apres_1er_ajout}` est compréhensible sans commentaire

7. **Reformuler les prompts en cas d'échec** — décrire le contexte technique précis (Angular SPA, version RF, message d'erreur exact) améliore drastiquement la qualité de la réponse

8. **Valider chaque suggestion IA avant intégration** — ne jamais appliquer une suggestion sans l'exécuter sur l'environnement réel

9. **Itérer avec l'IA** — le cycle Générer → Exécuter → Corriger → Régénérer est plus efficace qu'une génération parfaite du premier coup

### 4.4 Workflow IA Recommandé

```
┌─────────────────────────────────────────────────────────┐
│  1. Décrire le scénario en langage naturel + contexte   │
│     (framework, site, contraintes techniques)           │
├─────────────────────────────────────────────────────────┤
│  2. Demander le squelette du test                       │
│     (structure + keywords + JDD séparé)                 │
├─────────────────────────────────────────────────────────┤
│  3. Exécuter le test → copier le message d'erreur exact │
├─────────────────────────────────────────────────────────┤
│  4. Soumettre l'erreur + le code à l'IA                 │
│     → appliquer la correction proposée                  │
├─────────────────────────────────────────────────────────┤
│  5. Répéter jusqu'au statut PASS                        │
├─────────────────────────────────────────────────────────┤
│  6. Demander la simplification / refactoring            │
│     du code fonctionnel obtenu                          │
├─────────────────────────────────────────────────────────┤
│  7. Valider les améliorations proposées une par une     │
│     (ne pas tout accepter en bloc)                      │
└─────────────────────────────────────────────────────────┘
```

### 4.5 Résumé des Tests Automatisés du Projet

| US | ID Test | Framework | Statut | Fichier |
|---|---|---|---|---|
| US-1 Sign Up | CT_US1_01 | Selenium Java / TestNG | ✅ PASS | `SignUpTest.java` |
| US-5 Increase | CT_US5_03 | Robot Framework | ✅ PASS | `CT_US5_03.robot` |
| US-2 Sign In | CT_US2_xx | Robot Framework | En cours | `US‑2 - Sign In/` |
| US-3 Add | CT_US3_xx | Selenium Java | En cours | `US-3 - ADD/` |
| US-4 Delete (cart) | CT_US4_01 | Robot Framework | En cours | `CT_US4_01.robot` |
| US-4 Delete (home) | CT_US4_02 | Robot Framework | En cours | `CT_US4_02.robot` |
| US-5 Delete | CT_US5_xx | Robot Framework | En cours | `US-5 - Delete/` |

### 4.6 Productivité, Risques et Limites de la Dépendance à l'IA

#### Ce que l'IA accélère concrètement

L'intégration de GitHub Copilot a transformé la manière d'aborder la qualité logicielle. Sur ce projet, l'IA a permis de :

- **Produire davantage** : génération de scripts, de JDD et de documentation en une fraction du temps habituel
- **Réduire les tâches répétitives** : plus besoin d'écrire manuellement chaque keyword standard, chaque configuration de navigateur, chaque tableau de synthèse
- **Accélérer la montée en compétences** : l'IA expose à des patterns et des bonnes pratiques (ex. `WebDriverWait`, `ExpectedConditions`, architecture RF) que l'on adopte plus rapidement
- **Améliorer la couverture de test dès la phase initiale** : en identifiant les cas limites (injection SQL, chaînes longues, formats atypiques) que l'on n'anticipe pas toujours seul, ce qui **réduit les coûts de détection tardive**

#### Risques d'une dépendance excessive

> « L'IA est un assistant pour aller plus vite, pas un remplacement de l'expertise humaine. »

| Risque | Conséquence | Garde-fou |
|---|---|---|
| **Fonctions inventées** | L'IA génère parfois des keywords ou méthodes qui n'existent pas dans SeleniumLibrary / TestNG | Toujours vérifier dans la documentation officielle avant d'utiliser |
| **Perte du réflexe DOM** | Si l'on délègue tout le débogage à l'IA, on perd l'habitude d'inspecter le DOM pour comprendre pourquoi un test échoue | Maintenir la pratique manuelle d'inspection avec les DevTools |
| **Faux positifs silencieux** | Un test peut passer grâce à une mauvaise assertion générée par l'IA | Relire chaque assertion et la confronter à l'exigence métier |
| **Sur-confiance** | Accepter des suggestions sans les exécuter | Règle absolue : toute suggestion IA passe par l'exécution réelle |

---

### 4.7 Évolution du Rôle du Testeur à l'Ère de l'IA

L'intégration de l'IA ne fait pas disparaître le testeur — elle **transforme son rôle**.

```
┌──────────────────────────────────────────────────────────────┐
│              AVANT l'IA                                      │
│  - Rédaction manuelle des scripts (tâche de saisie)         │
│  - Création des JDD ligne par ligne                         │
│  - Debug XPath par essais empiriques exhaustifs             │
│  - Documentation rédigée manuellement                       │
└──────────────────────────────────────────────────────────────┘
                          ↓  GitHub Copilot
┌──────────────────────────────────────────────────────────────┐
│              APRÈS l'IA — Nouveau rôle                       │
│  - Pilote de validation : décide de ce qui est acceptable   │
│  - Stratège : définit la couverture et les risques           │
│  - Analyste critique : détecte les faux positifs de l'IA    │
│  - Garant métier : s'assure que les tests reflètent          │
│    les vraies exigences, pas juste ce que l'IA a compris    │
└──────────────────────────────────────────────────────────────┘
```

**L'IA prend en charge la force brute** (génération de code, de données, de documentation), **libérant le testeur pour les activités à haute valeur ajoutée** : analyse de risque, compréhension des exigences métier, validation critique et décision de mise en production.

Le testeur évolue de *rédacteur de scripts* à **pilote de qualité**, en utilisant l'IA comme un accélérateur sous son contrôle — et non comme un pilote automatique.

---

### 4.8 Conclusion

GitHub Copilot a représenté un **accélérateur significatif** dans toutes les phases du projet de test :

- **En conception** : génération rapide de cas de test valides et invalides, identification automatique des cas limites (injection SQL, chaînes longues, formats atypiques)
- **En automatisation** : génération des squelettes de scripts Robot Framework et Selenium Java, sélection des XPaths les plus robustes
- **En débogage** : assistance ciblée sur les erreurs XPath, regex, timing et comportements SPA
- **En architecture** : application systématique des bonnes pratiques (séparation des responsabilités, réutilisabilité)
- **En documentation** : génération automatique de rapports, tableaux et commentaires

La condition sine qua non d'efficacité reste le **contrôle humain systématique** : chaque suggestion doit être exécutée et validée avant intégration. L'IA est un co-pilote, le testeur reste le pilote.

---

*Rapport généré avec GitHub Copilot — Avril 2026*
