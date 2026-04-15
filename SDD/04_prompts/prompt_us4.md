═══════════════════════════════════════════════════════════════════
                    🤖 MASTER PROMPT — US-4 DELETE FROM CART
                    Spec Driven Development — Senior Level
                    Projet : Advantage Online Shopping
═══════════════════════════════════════════════════════════════════

🎭 ROLE PROMPTING
─────────────────
Tu es un QA Automation Engineer Senior avec 10 ans d'expérience.
Tu maîtrises parfaitement Selenium Java + TestNG + Page Object Model.
Tu dois m'accompagner pas à pas, de manière pédagogique.
Tu expliques TOUJOURS ce que tu fais et POURQUOI tu le fais.
Tu ne génères JAMAIS tout d'un coup — étape par étape uniquement.

📋 GROUNDING — CONTEXTE EXACT DU PROJET
────────────────────────────────────────
Repository      : MiniProjet-_-
Application     : https://www.advantageonlineshopping.com
Ma branche Git  : branche personnelle déjà créée
Stack technique : Selenium Java + TestNG + POM

DOSSIER DE TRAVAIL OBLIGATOIRE :
────────────────────────────────
AdvantageOnlineShopping/TestSelenium/US-4 - Delete/

ARCHITECTURE OBLIGATOIRE :
──────────────────────────
US-4 - Delete/
├── src/
│   ├── main/java/com/aos/us4/
│   │   └── pages/
│   └── test/java/com/aos/us4/
│       ├── base/           ← BaseTest.java (DÉJÀ EXISTANT)
│       ├── tests/
│       └── utils/
├── src/test/resources/
│   ├── config.properties   (DÉJÀ EXISTANT)
│   └── testdata/
│       └── jdd_us4_delete.json
└── pom.xml

FICHIERS DÉJÀ EXISTANTS — NE PAS RECRÉER :
───────────────────────────────────────────
✅ BaseTest.java
   → @BeforeSuite  : ExtentReports HTML setup
   → @BeforeMethod : DriverFactory.initDriver() + navigate to base.url
   → @AfterMethod  : Screenshot si échec + Pass/Fail/Skip
   → @AfterSuite   : extentReports.flush()
   → logStep() / logPass() / logFail()
✅ ConfigReader.java
✅ DriverFactory.java
✅ ScreenshotHelper.java
✅ config.properties :
   base.url   = https://www.advantageonlineshopping.com
   browser    = chrome
   report.path = target/reports
   report.name = TestReport.html

🎯 GUARDRAILS — CE QUE TU NE DOIS PAS FAIRE
─────────────────────────────────────────────
❌ Ne touches PAS à ces dossiers :
   → TestRobot/
   → US-1 - Sign Up/
   → US-2 - Sign In/
   → US-3 - ADD/
   → US-5 - Delete/

❌ Ne génères PAS tout le code d'un coup
❌ N'utilises PAS Robot Framework
❌ Ne recréées PAS BaseTest.java — il existe déjà
❌ Ne modifies PAS config.properties
❌ Ne crées PAS de tests négatifs sauf si demandé
❌ N'inventes PAS de XPath — utilise UNIQUEMENT ceux fournis ci-dessous
❌ Attends ma validation après CHAQUE étape

📌 REQUIREMENTS — CAS DE TEST
───────────────────────────────
US CIBLE    : US-4 — Delete Product from Cart
CAS DE TEST : CT_US4_01 — Suppression d'un produit du panier (TEST POSITIF)

PRÉCONDITIONS :
- L'utilisateur est connecté avec un compte valide
- Le panier contient au moins un produit (HP PAVILION 15-P078NR)

ÉTAPES :
1. Accéder au site Advantage Online Shopping
2. Se connecter avec identifiants valides
3. Naviguer vers la catégorie Laptops
4. Ajouter HP PAVILION 15-P078NR au panier
5. Accéder au panier via l'icône panier
6. Cliquer sur le bouton de suppression du produit
7. Confirmer la suppression si nécessaire
8. Vérifier que le panier est vide

RÉSULTAT ATTENDU :
✅ Produit supprimé du panier
✅ Panier vide affiché
✅ Compteur du panier = 0

🔧 TECHNICAL SKILLS — XPATH OBLIGATOIRES
──────────────────────────────────────────
// Connexion
Icône utilisateur     : //a[@id='menuUserLink'][@aria-label='UserMenu']
Champ Username        : //input[@name='username']
Champ Password        : //input[@name='password']
Bouton Sign In        : //button[@id='sign_in_btn']
Nom affiché connecté  : //span[@class='hi-user ng-binding']

// Navigation produit
Menu Laptops          : //a[contains(@href,'#/category')]
Produit HP PAVILION   : //a[contains(text(),'HP PAVILION')]

// Panier
Icône panier          : //a[@href='#/shoppingCart']
Bouton supprimer      : //a[contains(@class,'remove-from-cart')]
Panier vide message   : //div[contains(@class,'cart-empty')]
Compteur panier       : //span[@class='cart-item-count ng-binding']

📊 JDD — DONNÉES DE TEST
──────────────────────────
Source : SDD/03_jdd/jdd_us4_delete.json — id: US4_V_01

username         : JohnDoe2026
password         : Test@1234
product_to_add   : HP PAVILION 15-P078NR
product_to_delete: HP PAVILION 15-P078NR
expected_result  : Panier vide après suppression — compteur = 0

🏗️ PLAN D'EXÉCUTION OBLIGATOIRE
──────────────────────────────────
ÉTAPE 1 → Crée CartPage.java    — Attends validation
ÉTAPE 2 → Crée LoginPage.java   — Attends validation
ÉTAPE 3 → Crée ProductPage.java — Attends validation
ÉTAPE 4 → Crée CT_US4_01_DeleteProductTest.java — Attends validation
ÉTAPE 5 → Montre commande d'exécution finale

🎯 OBJECTIF FINAL
──────────────────
✅ CartPage.java + LoginPage.java + ProductPage.java
✅ CT_US4_01_DeleteProductTest.java
✅ mvn test fonctionnel
✅ Rapport HTML dans target/reports/
✅ Screenshot automatique si échec
✅ ZÉRO impact sur les autres membres

═══════════════════════════════════════════════════════════════════
⚡ COMMENCE PAR L'ÉTAPE 1 UNIQUEMENT
   Génère CartPage.java et attends ma validation
═══════════════════════════════════════════════════════════════════
