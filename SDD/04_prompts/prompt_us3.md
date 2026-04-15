═══════════════════════════════════════════════════════════════════
                    🤖 MASTER PROMPT — US-3 ADD TO CART
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
Stack technique : Selenium Java + TestNG + POM

DOSSIER DE TRAVAIL OBLIGATOIRE :
────────────────────────────────
AdvantageOnlineShopping/TestSelenium/US-3 - ADD/

FICHIERS DÉJÀ EXISTANTS — NE PAS RECRÉER :
───────────────────────────────────────────
✅ BaseTest.java / ConfigReader.java / DriverFactory.java / ScreenshotHelper.java

🎯 GUARDRAILS
─────────────
❌ Ne touches PAS : US-1 / US-2 / US-4 / US-5 / TestRobot
❌ Ne génères PAS tout d'un coup
❌ N'inventes PAS de XPath
❌ Attends ma validation après chaque étape

📌 REQUIREMENTS — CAS DE TEST
───────────────────────────────
US CIBLE    : US-3 — Add to Cart
CAS DE TEST : CT_US3_01 — Ajout réussi d'un produit au panier (TEST POSITIF)

PRÉCONDITIONS :
- L'utilisateur est connecté : JohnDoe2026 / Test@1234
- Le produit HP PAVILION 15-P078NR est disponible

ÉTAPES :
1. Accéder au site
2. Se connecter avec JohnDoe2026 / Test@1234
3. Naviguer vers catégorie Laptops
4. Sélectionner HP PAVILION 15-P078NR
5. Cliquer sur Add to Cart
6. Vérifier que le compteur panier est incrémenté

RÉSULTAT ATTENDU :
✅ Produit ajouté au panier
✅ Compteur panier = 1

🔧 TECHNICAL SKILLS — XPATH OBLIGATOIRES
──────────────────────────────────────────
// Connexion
Icône utilisateur     : //a[@id='menuUserLink'][@aria-label='UserMenu']
Champ Username        : //input[@name='username']
Champ Password        : //input[@name='password']
Bouton Sign In        : //button[@id='sign_in_btn']
Nom connecté          : //span[@class='hi-user ng-binding']

// Navigation
Menu Laptops          : //a[contains(@href,'#/category')]
Produit HP PAVILION   : //a[contains(text(),'HP PAVILION')]

// Page produit
Bouton Add to Cart    : //button[contains(@class,'add-to-cart')]

// Vérification
Compteur panier       : //span[@class='cart-item-count ng-binding']

📊 JDD — DONNÉES DE TEST
──────────────────────────
Source : SDD/03_jdd/jdd_us3_addtocart.json — id: US3_V_01

username        : JohnDoe2026
password        : Test@1234
category        : Laptops
product_name    : HP PAVILION 15-P078NR
quantity        : 1
expected_result : Produit ajouté — compteur panier incrémenté à 1

🏗️ PLAN D'EXÉCUTION OBLIGATOIRE
──────────────────────────────────
ÉTAPE 1 → Crée LoginPage.java     — Attends validation
ÉTAPE 2 → Crée ProductPage.java   — Attends validation
ÉTAPE 3 → Crée CartPage.java      — Attends validation
ÉTAPE 4 → Crée CT_US3_01_AddToCartTest.java — Attends validation
ÉTAPE 5 → Montre commande d'exécution finale

🎯 OBJECTIF FINAL
──────────────────
✅ LoginPage.java + ProductPage.java + CartPage.java
✅ CT_US3_01_AddToCartTest.java
✅ mvn test fonctionnel
✅ Rapport HTML dans target/reports/
✅ ZÉRO impact sur les autres membres

═══════════════════════════════════════════════════════════════════
⚡ COMMENCE PAR L'ÉTAPE 1 — Génère LoginPage.java
═══════════════════════════════════════════════════════════════════
