# US-4 — Delete Product | Selenium / Java — Documentation Complète

> **Public cible :** Débutant voulant comprendre et maîtriser l'automatisation de tests avec Selenium + Java + TestNG + POM.  
> **Niveau visé :** Senior QA Automation Engineer  
> **Application testée :** [Advantage Online Shopping (AOS)](https://www.advantageonlineshopping.com/#/)

---

## Table des matières

1. [C'est quoi Selenium ? Comment ça marche vraiment ?](#1-cest-quoi-selenium--comment-ça-marche-vraiment)
2. [La structure du projet : pourquoi cette organisation ?](#2-la-structure-du-projet--pourquoi-cette-organisation)
3. [Le Pattern Page Object Model (POM) — expliqué à fond](#3-le-pattern-page-object-model-pom--expliqué-à-fond)
4. [Roadmap de compréhension : lire les fichiers dans cet ordre](#4-roadmap-de-compréhension--lire-les-fichiers-dans-cet-ordre)
5. [Comment un test s'exécute ? Étape par étape](#5-comment-un-test-sexécute--étape-par-étape)
6. [La User Story US-4 et ses cas de test](#6-la-user-story-us-4-et-ses-cas-de-test)
7. [Résultats attendus et assertions](#7-résultats-attendus-et-assertions)
8. [Comment lancer les tests](#8-comment-lancer-les-tests)
9. [Arborescence complète des fichiers commentée](#9-arborescence-complète-des-fichiers-commentée)
10. [Glossaire : termes importants à maîtriser](#10-glossaire--termes-importants-à-maîtriser)

---

## 1. C'est quoi Selenium ? Comment ça marche vraiment ?

### Définition simple

Selenium est une bibliothèque open-source qui permet à du code Java (ou Python, C#...) de **contrôler un navigateur web** comme si c'était un humain : cliquer, taper, naviguer, lire des valeurs...

### L'architecture Selenium — vision d'ensemble

```
┌─────────────────────────────────────────────────────────────────────┐
│                     TON CODE JAVA (les tests)                       │
│                                                                     │
│   driver.navigate().to("https://www.advantageonlineshopping.com")   │
│   driver.findElement(By.id("removeBtn")).click()                    │
└───────────────────────────┬─────────────────────────────────────────┘
                            │
                            │  Protocol : W3C WebDriver (HTTP REST)
                            │  POST /session/{id}/url
                            │  POST /session/{id}/element
                            │  POST /session/{id}/element/{id}/click
                            ▼
┌─────────────────────────────────────────────────────────────────────┐
│              CHROMEDRIVER.EXE (fourni par Google)                  │
│      Serveur HTTP local (port 9515)                                │
│      Traduit les commandes WebDriver en actions Chrome             │
└───────────────────────────┬─────────────────────────────────────────┘
                            │
                            │  Chrome DevTools Protocol (CDP)
                            ▼
┌─────────────────────────────────────────────────────────────────────┐
│              GOOGLE CHROME (le vrai navigateur)                    │
│      Exécute les actions : clics, saisie, navigation...            │
└─────────────────────────────────────────────────────────────────────┘
```

### Étapes lorsque ton code dit `driver.findElement(By.id("btn")).click()` :

1. **Java** envoie une requête HTTP à ChromeDriver : `POST /element {using: "id", value: "btn"}`
2. **ChromeDriver** reçoit la requête et la traduit en commande Chrome
3. **Chrome** cherche l'élément `<button id="btn">` dans le DOM de la page
4. **Chrome** retourne l'identifiant interne de l'élément à ChromeDriver
5. **ChromeDriver** envoie une deuxième requête : `POST /element/{elementId}/click`
6. **Chrome** exécute le clic sur l'élément
7. La réponse remonte jusqu'à ton code Java

> **Résumé :** Ton code Java → ChromeDriver (serveur local) → Chrome  
> Tout passe par le protocole HTTP standard défini par le W3C (WebDriver Protocol).

---

## 2. La structure du projet : pourquoi cette organisation ?

### Structure Maven standard

Maven impose une structure de dossiers **conventionnelle**. Si tu respectes cette convention,
Maven sait automatiquement où trouver ton code et tes ressources.

```
US-4 - Delete/
│
├── pom.xml                               ← CONFIGURATION MAVEN (chef de projet)
│   Déclare les dépendances (Selenium, TestNG...) et plugins
│
└── src/
    └── test/                             ← Code de TEST (pas de code de production ici)
        ├── java/                         ← Le code Java
        │   └── com/aos/us4/             ← Notre "namespace" (package racine)
        │       │
        │       ├── base/                ← COUCHE 1 : Infrastructure commune
        │       │   └── BaseTest.java    → Setup/Teardown partagé par tous les tests
        │       │
        │       ├── utils/               ← COUCHE 2 : Outils réutilisables
        │       │   ├── ConfigReader.java  → Lit config.properties
        │       │   ├── DriverFactory.java → Crée/gère le WebDriver Chrome
        │       │   ├── WaitHelper.java    → Attentes explicites Selenium
        │       │   └── ScreenshotHelper.java → Capture d'écran
        │       │
        │       ├── data/               ← COUCHE 3 : Données de test (JDD)
        │       │   └── TestData.java   → Constantes (noms de produits, messages attendus...)
        │       │
        │       ├── pages/              ← COUCHE 4 : PAGE OBJECT MODEL (le cœur du projet)
        │       │   ├── HomePage.java   → Interactions avec la page d'accueil
        │       │   ├── ProductPage.java→ Interactions avec les pages produit
        │       │   └── CartPage.java   → Interactions avec la page panier
        │       │
        │       └── tests/              ← COUCHE 5 : LES VRAIS CAS DE TEST
        │           ├── CT_US4_01_DeleteFromCartPage.java
        │           └── CT_US4_02_DeleteFromHome.java
        │
        └── resources/                  ← Les fichiers ressources (non-Java)
            ├── config.properties       → Configuration (URL, browser, timeouts...)
            └── testng.xml              → Configuration de la suite de tests TestNG
```

### Pourquoi CETTE structure et pas une autre ?

#### ❌ Structure "tout-en-un" (ce qu'il ne faut pas faire)

```java
// MonTest.java — MAUVAISE PRATIQUE
public class MonTest {
    public void test() {
        System.setProperty("webdriver.chrome.driver", "C:/chromedriver.exe"); // hardcodé !
        WebDriver driver = new ChromeDriver();
        driver.navigate().to("https://www.advantageonlineshopping.com");
        
        // Sélecteur copié-collé dans chaque méthode
        driver.findElement(By.cssSelector(".cart-items-container .btn-remove")).click();
        
        // Assertion avec une valeur hardcodée
        assertEquals(driver.findElement(By.id("cartCount")).getText(), "0");
        
        driver.quit();
    }
}
```

**Problèmes** :
- Si le sélecteur `.btn-remove` change → modifier **50 tests** !
- Si l'URL change → modifier **50 fichiers** !
- Un nouveau collègue ne comprend pas quoi faire
- Impossible de tester sur Firefox sans tout réécrire

#### ✅ Structure POM par couche (ce projet)

**Chaque couche a une seule responsabilité** (principe SOLID : Single Responsibility) :

| Couche | Responsabilité | Rôle |
|--------|---------------|------|
| `utils/` | Infrastructure technique | Gérer le driver, les attentes, les screenshots |
| `data/` | Données | Centraliser les valeurs des tests |
| `pages/` | Cartographie de l'application | Savoir OÙ sont les éléments et COMMENT interagir avec eux |
| `tests/` | Logique de test | QUOI tester et QUOI vérifier |
| `base/` | Cycle de vie | Setup/teardown commun |

---

## 3. Le Pattern Page Object Model (POM) — expliqué à fond

### Concept fondamental

> **Une page web = une classe Java**

Chaque page de l'application est représentée par **une classe Java dédiée** qui :
- **Connaît** tous les éléments de sa page (sélecteurs)
- **Sait** comment interagir avec eux (méthodes)
- **Ne vérifie rien** (pas d'assertions — c'est le rôle du test)

### Analogie concrète : une page web comme un tableau de bord de voiture

```
   Page Web (CartPage)                     Tableau de bord
   ─────────────────                       ────────────────
   Les boutons, textes, liens              ≡ Les boutons, jauges, témoins
   Les sélecteurs CSS/XPath                ≡ La position physique des boutons
   Les méthodes clickRemove()              ≡ Les actions (appuyer sur "Start")
   L'objet CartPage                        ≡ Le manuel d'utilisation du tableau de bord
```

### Les 3 composants d'une méthode Page Object

```java
// Dans CartPage.java :

// 1. SÉLECTEUR (privé) : comment trouver le bouton Remove dans le HTML
//    Déclaré UNE SEULE FOIS en haut de la classe
private final By REMOVE_BUTTON = By.cssSelector(".cart-remove-btn");


// 2. MÉTHODE D'ACTION (publique) : ce que peut faire l'utilisateur sur cette page
//    Nommée avec un verbe d'action
public CartPage clickRemoveFirstProduct() {

    // 3. ATTENTE + ACTION : attendre que l'élément soit prêt, puis agir
    WaitHelper.waitForClickable(driver, REMOVE_BUTTON).click();

    // Retourner "this" = l'objet courant → permet le chaînage
    return this;
}
```

### Fluent Interface (chaînage) — pourquoi retourner `this` ?

```java
// Sans chaînage (verbeux)
cartPage.waitForCartPageToLoad();
cartPage.clickRemoveFirstProduct();
String total = cartPage.getCartTotalPrice();

// Avec chaînage (élégant)
String total = cartPage
    .waitForCartPageToLoad()
    .clickRemoveFirstProduct()
    .getCartTotalPrice();
```

---

## 4. Roadmap de compréhension : lire les fichiers dans cet ordre

Pour progresser du débutant au senior, lis les fichiers dans cet ordre précis :

```
ÉTAPE 1 — Infrastructure de base
    ● config.properties       → Les paramètres de configuration
    ● ConfigReader.java       → Comment lire ces paramètres en Java
    ● DriverFactory.java      → Comment créer et gérer le navigateur

ÉTAPE 2 — Outils de stabilité
    ● WaitHelper.java         → Pourquoi et comment attendre (crucial !)
    ● ScreenshotHelper.java   → Capture de preuves en cas d'échec

ÉTAPE 3 — Données
    ● TestData.java           → Les données du jeu de test (JDD)

ÉTAPE 4 — Infrastructure de test
    ● BaseTest.java           → Setup + Teardown + Reporting

ÉTAPE 5 — Page Objects (le cœur du projet)
    ● HomePage.java           → La page d'accueil et le panier flottant
    ● ProductPage.java        → La page produit (pour ajouter au panier)
    ● CartPage.java           → La page Shopping Cart (la plus importante pour US-4)

ÉTAPE 6 — Les tests (l'objectif final)
    ● CT_US4_01_DeleteFromCartPage.java    → Test de suppression depuis la page cart
    ● CT_US4_02_DeleteFromHome.java        → Test de suppression depuis le panier flottant

ÉTAPE 7 — Configuration d'exécution
    ● testng.xml              → Comment maven lance les tests
    ● pom.xml                 → Les dépendances Maven
```

---

## 5. Comment un test s'exécute ? Étape par étape

### Cycle de vie complet de CT_US4_01

```
mvn test
│
├─► Maven lit pom.xml → sait qu'il faut exécuter src/test/resources/testng.xml
│
├─► TestNG lit testng.xml → liste des classes à tester
│
├─► TestNG lance CT_US4_01_DeleteFromCartPage
│
│   [1] BaseTest.setUpSuite() — @BeforeSuite (1 fois pour toute la suite)
│       → Initialise ExtentReports
│       → Crée le dossier target/extent-reports/
│
│   [2] BaseTest.setUp() — @BeforeMethod
│       → DriverFactory.initDriver() → WebDriverManager télécharge chromedriver si besoin
│       → ChromeDriver.exe démarre (serveur HTTP local)
│       → new ChromeDriver() → Chrome s'ouvre avec la fenêtre maximisée
│       → driver.navigate().to("https://www.advantageonlineshopping.com/#/")
│       → La page d'accueil AOS s'affiche dans Chrome
│       → extentTest est créé dans le rapport
│
│   [3] CT_US4_01.setUpPrecondition() — @BeforeMethod (enfant)
│       → homePage.clickOnLaptopsCategory()
│       → [Chrome] : clic sur le lien "Laptops"
│       → productPage.clickProductByName("HP CHROMEBOOK 14 G1")
│       → [Chrome] : chrome cherche le produit et clique dessus
│       → productPage.clickAddToCart()
│       → [Chrome] : clic sur le bouton ADD TO CART
│       → [Chrome] : le badge panier affiche maintenant "1"
│
│   [4] CT_US4_01.CT_US4_01_SuppresionProduitPanier() — @Test
│       → homePage.clickCartIcon()
│       → [Chrome] : navigue vers la page /shopping-cart
│       → cartPage.getArticleCountFromTitle() → lit "Shopping cart (1)" → retourne 1
│       → cartPage.isProductInCart("HP CHROMEBOOK 14 G1") → retourne true
│       → Assert.assertTrue(true) → ✓ PASSE
│       → cartPage.clickRemoveFirstProduct()
│       → [Chrome] : trouve le bouton Remove, attend qu'il soit cliquable, clique
│       → [Angular] : met à jour le DOM de manière asynchrone
│       → WaitHelper attend la disparition du bouton Remove (confirmation de suppression)
│       → Assert.assertFalse(cartPage.isProductInCart("HP CHROMEBOOK 14 G1"))
│       → [Chrome] : cherche le produit → absent → retourne false
│       → Assert.assertFalse(false) → ✓ PASSE
│       → Assert.assertEquals(currentBadgeCount, 0) → ✓ PASSE
│       → Assert.assertEquals(currentCountFromTitle, 0) → ✓ PASSE
│       → Assert.assertEquals(currentTotal, "$0.00") → ✓ PASSE
│
│   [5] BaseTest.tearDown() — @AfterMethod
│       → result.getStatus() == SUCCESS → logPass dans rapport
│       → DriverFactory.quitDriver() → Chrome se ferme, ChromeDriver.exe s'arrête
│
└─► BaseTest.tearDownSuite() — @AfterSuite (1 fois)
    → extentReports.flush() → Le fichier HTML est écrit sur disque
    → target/extent-reports/US4_Delete_Product_Report.html → TON RAPPORT VISUEL
```

---

## 6. La User Story US-4 et ses cas de test

### US-4 — "Delete Product"

> En tant que client, je veux pouvoir supprimer un produit de mon panier  
> afin de le mettre à jour avant le paiement.

### CT_US4_01 — Suppression depuis la page Shopping Cart

| Élément | Détail |
|---------|--------|
| **Fichier de test** | `CT_US4_01_DeleteFromCartPage.java` |
| **Page testée** | `/shopping-cart` (page complète) |
| **Précondition** | Un produit (Laptop) est dans le panier |
| **Action principale** | Clic sur le bouton **Remove** dans la liste des produits |
| **Page Objects utilisés** | `HomePage`, `ProductPage`, `CartPage` |

**Flux visuel :**
```
[Page d'accueil] → [Laptops] → [HP Chromebook] → [ADD TO CART]
→ [Clic icône panier] → [Page Shopping Cart]
→ [Clic "Remove"] → [Vérifications ×5]
```

### CT_US4_02 — Suppression depuis le panier flottant

| Élément | Détail |
|---------|--------|
| **Fichier de test** | `CT_US4_02_DeleteFromHome.java` |
| **Zone testée** | Mini-cart / panier flottant dans le header |
| **Précondition** | Un produit (Laptop) est dans le panier |
| **Action principale** | Clic sur le bouton **X** dans le panier flottant |
| **Page Objects utilisés** | `HomePage`, `ProductPage`, `CartPage` |

**Flux visuel :**
```
[Page d'accueil] → [Laptops] → [HP Chromebook] → [ADD TO CART]
→ [Retour à la home] → [Clic icône panier → panier flottant s'ouvre]
→ [Clic "X" sur le produit] → [Vérifications ×5 + vérification cohérence ×1]
```

---

## 7. Résultats attendus et assertions

### CT_US4_01 — 6 assertions

| N° | Ce qu'on vérifie | Code assertion |
|----|-----------------|---------------|
| 1 | Produit absent du panier après suppression | `assertFalse(cartPage.isProductInCart("HP CHROMEBOOK 14 G1"))` |
| 2 | Badge header décrémenté | `assertEquals(currentBadge, initialBadge - 1)` |
| 3 | Titre "Shopping cart (X)" décrémenté | `assertEquals(currentCount, initialCount - 1)` |
| 4 | Total recalculé | `assertEquals(currentTotal, "$0.00")` si 1 seul produit |
| 5 | Bouton Checkout = total recalculé | `assertTrue(checkoutText.contains(currentTotal))` |
| 6 | Message "panier vide" visible | `assertTrue(cartPage.isEmptyCartMessageDisplayed())` |

### CT_US4_02 — 6 assertions

| N° | Ce qu'on vérifie | Code assertion |
|----|-----------------|---------------|
| 1 | Produit absent du panier flottant | `assertEquals(currentCount, initialCount - 1)` |
| 2 | Badge header décrémenté | `assertEquals(currentBadge, initialBadge - 1)` |
| 3 | Total du panier flottant recalculé | `assertEquals(floatingTotal, "$0.00")` |
| 4 | Bouton Checkout cohérent avec le total | `logPass(checkoutBtnText)` |
| 5 | Cohérence nb produits : flottant = page cart | `assertEquals(cartPageCount, floatingCartCount)` |
| 6 | Cohérence total : flottant = page cart | `assertEquals(cartPageTotal, floatingCartTotal)` |

---

## 8. Comment lancer les tests

### Prérequis

1. **Java 17+** installé → vérifier avec `java -version`
2. **Maven 3.6+** installé → vérifier avec `mvn -version`
3. **Google Chrome** installé (version récente)
4. **Connexion internet** (pour télécharger ChromeDriver via WebDriverManager)

### Commandes Maven

```bash
# Se placer dans le dossier du projet
cd "AdvantageOnlineShopping/TestSelenium/US-4 - Delete"

# ─────────────────────────────────────────────────────────────
# Lancer TOUS les tests
mvn test

# Lancer uniquement CT_US4_01
mvn test -Dtest=CT_US4_01_DeleteFromCartPage

# Lancer uniquement CT_US4_02
mvn test -Dtest=CT_US4_02_DeleteFromHome

# Lancer en mode headless (sans interface graphique)
mvn test -Dheadless=true

# Lancer sur Firefox
mvn test -Dbrowser=firefox
# ─────────────────────────────────────────────────────────────
```

### Où trouver les résultats ?

```
target/
├── surefire-reports/          ← Rapports XML/HTML TestNG (format Maven standard)
├── screenshots/               ← Screenshots des tests échoués
└── extent-reports/
    └── US4_Delete_Product_Report.html   ← RAPPORT VISUEL OUVRIRE DANS UN NAVIGATEUR
```

---

## 9. Arborescence complète des fichiers commentée

```
US-4 - Delete/
│
├── pom.xml                   [MAVEN] Déclaration des dépendances et plugins
│
└── src/test/
    ├── java/com/aos/us4/
    │   │
    │   ├── base/
    │   │   └── BaseTest.java
    │   │       RÔLE : Classe mère de tous les tests.
    │   │       CONTIENT :
    │   │         @BeforeSuite → Initialise ExtentReports
    │   │         @BeforeMethod → Ouvre Chrome, navigue vers AOS
    │   │         @AfterMethod → Screenshot si échec, ferme Chrome
    │   │         @AfterSuite → Génère le rapport HTML final
    │   │         logStep/logPass/logFail → Trace dans rapport et console
    │   │
    │   ├── utils/
    │   │   ├── ConfigReader.java
    │   │   │     RÔLE : Lire config.properties en Java
    │   │   │     USAGE : ConfigReader.get("browser") → "chrome"
    │   │   │
    │   │   ├── DriverFactory.java
    │   │   │     RÔLE : Créer et gérer le WebDriver Chrome/Firefox/Edge
    │   │   │     USAGE : DriverFactory.initDriver() / getDriver() / quitDriver()
    │   │   │     KEY CONCEPT : ThreadLocal (tests parallèles sûrs)
    │   │   │
    │   │   ├── WaitHelper.java
    │   │   │     RÔLE : Centraliser les attentes explicites Selenium
    │   │   │     USAGE : WaitHelper.waitForClickable(driver, By.id("btn"))
    │   │   │     KEY CONCEPT : WebDriverWait + ExpectedConditions
    │   │   │
    │   │   └── ScreenshotHelper.java
    │   │         RÔLE : Capturer l'écran du navigateur
    │   │         USAGE : captureScreenshotAsBase64(driver) → intégré dans rapport
    │   │
    │   ├── data/
    │   │   └── TestData.java
    │   │         RÔLE : Jeu de Données centralisé
    │   │         CONTIENT : Noms de produits, messages attendus, totaux attendus
    │   │
    │   ├── pages/
    │   │   ├── HomePage.java
    │   │   │     RÔLE : Page Object de la page d'accueil AOS
    │   │   │     COUVRE : Icône panier, panier flottant (mini-cart), navigation
    │   │   │     UTILISE : WaitHelper pour toutes les interactions
    │   │   │
    │   │   ├── ProductPage.java
    │   │   │     RÔLE : Page Object pour la page produit (précondition : ajout au panier)
    │   │   │     COUVRE : Liste des produits, page détail, bouton ADD TO CART
    │   │   │
    │   │   └── CartPage.java
    │   │         RÔLE : Page Object de la PAGE SHOPPING CART (/shopping-cart)
    │   │         COUVRE : Title, lignes produit, bouton Remove, total, checkout
    │   │         C'EST LA PAGE LA PLUS IMPORTANTE POUR US-4 !
    │   │
    │   └── tests/
    │       ├── CT_US4_01_DeleteFromCartPage.java
    │       │     RÔLE : Cas de test CT_US4_01 - Suppression depuis la page /shopping-cart
    │       │     HÉRITE : BaseTest
    │       │     PRÉCONDITION (@BeforeMethod) : Ajoute un Laptop au panier
    │       │     TEST (@Test) : Supprime via bouton "Remove" → 6 vérifications
    │       │
    │       └── CT_US4_02_DeleteFromHome.java
    │             RÔLE : Cas de test CT_US4_02 - Suppression depuis le panier flottant
    │             HÉRITE : BaseTest
    │             PRÉCONDITION (@BeforeMethod) : Ajoute un Laptop au panier + revient home
    │             TEST (@Test) : Supprime via bouton "X" dans mini-cart → 6 vérifications
    │
    └── resources/
        ├── config.properties   [CONFIG] Paramètres externalisés (URL, browser, timeouts)
        └── testng.xml          [TESTNG] Suite de tests : quoi exécuter et dans quel ordre
```

---

## 10. Glossaire : termes importants à maîtriser

| Terme | Définition |
|-------|-----------|
| **WebDriver** | Interface Selenium principale qui "pilote" le navigateur |
| **ChromeDriver** | Programme exécutable fourni par Google qui traduit les commandes WebDriver vers Chrome |
| **WebDriverManager** | Bibliothèque qui télécharge automatiquement le bon ChromeDriver |
| **Locator / Selector** | La façon d'identifier un élément HTML (id, css, xpath...) |
| **CSS Selector** | Syntaxe de ciblage d'éléments HTML : `#id`, `.class`, `div > span` |
| **XPath** | Langage de navigation dans le DOM HTML : `//button[@id='x']` |
| **POM** | Page Object Model — pattern : une page web = une classe Java |
| **Assertion** | Vérification dans un test : "cette valeur DOIT être X, sinon le test échoue" |
| **TestNG** | Framework de tests Java : gère @Test, @Before/AfterMethod, assertions |
| **Maven** | Outil de gestion de projet Java : gère les dépendances et le build |
| **Explicit Wait** | Attente d'une condition précise : `waitForClickable(driver, By.id("btn"))` |
| **Implicit Wait** | Attente automatique globale appliquée à tous les findElement() |
| **Thread Safety** | Garantir que des tests en parallèle n'interfèrent pas l'un avec l'autre |
| **ThreadLocal** | Stockage d'une valeur par thread (chaque test a son propre driver) |
| **Fluent Interface** | Style de code où les méthodes retournent `this` pour le chaînage |
| **Screenshot Base64** | Image encodée en texte pour l'intégrer directement dans un rapport HTML |
| **ExtentReports** | Bibliothèque de génération de rapports HTML visuels riches |
| **@BeforeMethod** | Méthode TestNG exécutée AVANT chaque @Test (setup, préconditions) |
| **@AfterMethod** | Méthode TestNG exécutée APRÈS chaque @Test (teardown, cleanup) |
| **Headless** | Mode navigateur sans interface graphique (pour CI/CD) |
| **DOM** | Document Object Model — structure arborescente d'une page HTML |
| **Angular** | Framework JavaScript utilisé par AOS (applications asynchrones) |
| **AJAX** | Technique JS pour communiquer avec le serveur sans recharger la page |
| **DRY** | "Don't Repeat Yourself" — ne jamais dupliquer du code/données |
| **SOLID** | Principes de conception logicielle (Single Responsibility, Open/Closed...) |

---

*Projet créé dans le cadre de la formation QA Automation — Capgemini*  
*Architecture : Page Object Model | Framework : Selenium 4 + TestNG + Maven | Langage : Java 17*
