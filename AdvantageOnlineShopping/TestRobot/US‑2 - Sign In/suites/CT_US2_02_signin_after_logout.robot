# ════════════════════════════════════════════════════════════════════════════════
# FILE: CT_US2_02_signin_after_logout.robot
# ════════════════════════════════════════════════════════════════════════════════
#
# WHY A SEPARATE .robot FILE (not added inside CT_US2_01)?
#   Each .robot file = one "suite" of tests.
#   CT_US2_01 and CT_US2_02 have DIFFERENT PRECONDITIONS:
#     CT_US2_01: user must be LOGGED OUT at the start.
#     CT_US2_02: user must be LOGGED IN  at the start.
#   Because the Suite Setup is different, they MUST be in separate files.
#   One Suite Setup = one .robot file. That is the Robot Framework rule.
#
# WHERE THIS FILE LIVES: suites/ (same folder as CT_US2_01)
#   WHY: Both are test cases for the same User Story (US-2 Sign In).
#   We don't create a new folder — we extend the existing suite folder.
# ════════════════════════════════════════════════════════════════════════════════

*** Settings ***
# ────────────────────────────────────────────────────────────────────────────────
# SECTION: *** Settings ***
# WHY: This section is ALWAYS the first section in a .robot file.
#      It declares meta-information and imports for the entire suite.
# ────────────────────────────────────────────────────────────────────────────────

Documentation
...    ════════════════════════════════════════════════════════════
...    FILE DOCUMENTATION (displayed in log.html / report.html)
...    ════════════════════════════════════════════════════════════
...    USER STORY    : US-2 – Sign In
...    CAS DE TEST   : CT_US2_02
...    TYPE          : Test positif
...    OBJECTIF      : Vérifier qu'un utilisateur peut se reconnecter
...                    après s'être déconnecté.
...    PRÉCONDITIONS : L'utilisateur est DÉJÀ CONNECTÉ au démarrage du test.
...                    (Pris en charge par le Suite Setup ci-dessous.)
...    ════════════════════════════════════════════════════════════

# ── Resource Import ──────────────────────────────────────────────────────────
# WHY ONE SINGLE Resource import?
#   import_resources.resource is the "hub" file that already imports:
#     - SeleniumLibrary         (browser control)
#     - setup_teardown.resource (Setup/Teardown keywords)
#     - signin_data.resource    (test data: URL, username, password)
#     - SigninPage.resource     (page locators + keywords: click, type, verify, logout)
#     - browser_utils.resource  (navigation helpers)
#   Importing it here gives us access to EVERYTHING with a single line.
#   We never import SigninPage or data files directly from .robot files.
#   WHY? Because the hub file is the single source of truth for dependencies.
#        If you add a new resource tomorrow, you update only the hub — not 10 .robot files.
Resource    ../config/import_resources.resource

# ── Suite Setup ───────────────────────────────────────────────────────────────
# WHY Suite Setup (not Test Setup)?
#   "Suite Setup" runs ONCE before ALL tests in this file.
#   "Test Setup" would run before EACH test.
#   Here we have 1 test, but using Suite Setup is the correct pattern because:
#   - Opening a browser is expensive (slow).
#   - The precondition (already logged in) belongs to the entire suite context.
#
# WHY this specific keyword (Suite Setup - Open Browser To AOS And Login)?
#   The precondition for CT_US2_02 states: "L'utilisateur est déjà connecté".
#   So we need to:
#     1. Open the browser.
#     2. Navigate to AOS.
#     3. Actually LOG IN so the user is already connected when the test starts.
#   This keyword (defined in setup_teardown.resource) does exactly that.
Suite Setup       Suite Setup - Open Browser To AOS And Login

# ── Suite Teardown ────────────────────────────────────────────────────────────
# WHY Suite Teardown?
#   Runs ONCE after ALL tests finish (pass or fail).
#   We always close the browser here to free system resources.
#   If we forget this and a test fails, the browser stays open forever.
Suite Teardown    Suite Teardown - Close Browser

# ── Test Teardown ─────────────────────────────────────────────────────────────
# WHY Test Teardown?
#   Runs after EACH individual test case.
#   Our keyword "Test Teardown - Capture On Failure" checks if the test failed.
#   If yes → it takes a screenshot and embeds it in the HTML report.
#   WHY embed instead of saving to a file?
#     EMBED means the screenshot is stored DIRECTLY inside log.html.
#     You don't need to manage separate image files. Open log.html and see everything.
Test Teardown     Test Teardown - Capture On Failure


*** Test Cases ***
# ────────────────────────────────────────────────────────────────────────────────
# SECTION: *** Test Cases ***
# WHY: This section contains the actual test scenarios.
#      Each "test case" is a named block of steps.
#      Robot Framework executes each test case independently.
#      A test PASSES if no keyword raises an error.
#      A test FAILS if ANY keyword raises an error.
# ────────────────────────────────────────────────────────────────────────────────

CT_US2_02 - Connexion après déconnexion
    # ── Test Documentation ────────────────────────────────────────────
    # WHY [Documentation]?
    #   Text that appears in the HTML report next to this test case.
    #   Helps anyone reading the report understand what this test verifies.
    [Documentation]    Vérifie qu'un utilisateur peut se reconnecter après s'être déconnecté.
    ...                PRÉCONDITION : L'utilisateur est déjà connecté (géré par Suite Setup).
    ...                RÉSULTAT ATTENDU : Connexion réussie + nom de l'utilisateur affiché.

    # ── Test Tags ─────────────────────────────────────────────────────
    # WHY [Tags]?
    #   Tags let you FILTER which tests to run from the command line.
    #   Example: robot --include CT_US2_02 suites/   → runs only this test.
    #   Example: robot --include positif suites/      → runs all positive tests.
    #   Example: robot --include US2 .               → runs all US-2 tests.
    #   Good tags = US story code + test case code + type (positif/negatif).
    [Tags]    US2    CT_US2_02    positif    connexion    déconnexion

    # ════════════════════════════════════════════════════════════════
    # COMMENT: At this point the Suite Setup has already:
    #   ✔ Opened the Chrome browser
    #   ✔ Navigated to https://www.advantageonlineshopping.com/#/
    #   ✔ Logged in with ${LOGIN_USERNAME} / ${LOGIN_PASSWORD}
    #   ✔ Verified the username label is visible (we are logged in)
    # So the test starts with the user ALREADY CONNECTED.
    # ════════════════════════════════════════════════════════════════

    # ─────────────────────────────────────────────────────────────────
    # ÉTAPE 1 : Cliquer sur Logout
    # ─────────────────────────────────────────────────────────────────
    # WHAT: Calls the keyword "Se Déconnecter" from SigninPage.resource.
    # WHY HERE: This is the FIRST step of the test scenario.
    #           The test verifies that after a logout, a RE-login is possible.
    #           Without a logout first, there is nothing to test.
    # WHAT HAPPENS INSIDE the keyword (see SigninPage.resource for details):
    #   1. Clicks user icon to open the dropdown menu.
    #   2. Waits for the Logout link to appear.
    #   3. Clicks the Logout link.
    #   4. Waits for the user icon (non-logged-in version) to reappear.
    #      → This last wait is the IMPLICIT ASSERTION that logout worked.
    # ─────────────────────────────────────────────────────────────────
    Se Déconnecter

    # ─────────────────────────────────────────────────────────────────
    # ÉTAPE 2 : Cliquer sur l'icône User (re-open the login form)
    # ─────────────────────────────────────────────────────────────────
    # WHAT: Calls "Cliquer Sur Icone Utilisateur" from SigninPage.resource.
    # WHY SAME KEYWORD AS CT_US2_01?
    #   Because it is the SAME action. POM means one keyword per action.
    #   Whether it's the first login or a re-login, clicking the user icon
    #   always opens the login form. Same keyword, same locator, same effect.
    # WHAT HAPPENS INSIDE the keyword:
    #   1. Waits for ${LOC_USER_ICON} to be visible.
    #   2. Clicks it → the login form animates into view.
    # ─────────────────────────────────────────────────────────────────
    Cliquer Sur Icone Utilisateur

    # ─────────────────────────────────────────────────────────────────
    # ÉTAPE 3 : Saisir un username valide
    # ─────────────────────────────────────────────────────────────────
    # WHAT: Calls "Saisir Nom Utilisateur" from SigninPage.resource.
    # WHY ${LOGIN_USERNAME}?
    #   ${LOGIN_USERNAME} is defined in signin_data.resource (JDD file).
    #   Value: "rimkQA2026x" — a registered account.
    #   We pass it as an ARGUMENT so the keyword is reusable with any username.
    # WHAT HAPPENS INSIDE the keyword:
    #   1. Waits for the username input field to be visible.
    #   2. Waits for any loading spinner to disappear (AOS quirk).
    #   3. scrollIntoView (JS) to ensure the field is on screen.
    #   4. Clicks the field.
    #   5. Types the username with Input Text.
    # ─────────────────────────────────────────────────────────────────
    Saisir Nom Utilisateur    ${LOGIN_USERNAME}

    # ─────────────────────────────────────────────────────────────────
    # ÉTAPE 4 : Saisir un mot de passe valide
    # ─────────────────────────────────────────────────────────────────
    # WHAT: Calls "Saisir Mot De Passe" from SigninPage.resource.
    # WHY ${LOGIN_PASSWORD}?
    #   ${LOGIN_PASSWORD} = "SecPass123" — defined in signin_data.resource.
    #   We use Input Password (not Input Text) → the password is MASKED
    #   in all logs and screenshots for security. Never hardcode passwords here.
    # WHAT HAPPENS INSIDE the keyword:
    #   1. Waits for the password field.
    #   2. JS scrollIntoView.
    #   3. JS click on the field (SVG overlay blocks native Selenium click on AOS).
    #   4. Input Password → types and masks the password.
    #   5. JS click on username field → triggers "blur" event on password field
    #      so AngularJS validates the ngModel binding.
    # ─────────────────────────────────────────────────────────────────
    Saisir Mot De Passe    ${LOGIN_PASSWORD}

    # ─────────────────────────────────────────────────────────────────
    # ÉTAPE 5 : Cliquer sur Sign In
    # ─────────────────────────────────────────────────────────────────
    # WHAT: Calls "Cliquer Sur Sign In" from SigninPage.resource.
    # WHY: Submits the login form.
    # WHAT HAPPENS INSIDE: Waits for the Sign In button, then clicks it.
    # AFTER THIS: AOS sends the credentials to the server.
    #             If valid → redirects to home page + shows username in nav bar.
    #             If invalid → shows error message (but won't happen here, test data is valid).
    # ─────────────────────────────────────────────────────────────────
    Cliquer Sur Sign In

    # ─────────────────────────────────────────────────────────────────
    # RÉSULTAT ATTENDU — Connexion réussie (ASSERTION)
    # ─────────────────────────────────────────────────────────────────
    # WHAT: Calls "Vérifier Succès Connexion" from SigninPage.resource.
    # WHY THIS IS CRITICAL:
    #   Without this assertion, the test would PASS even if the login failed.
    #   Robot Framework only fails if an error is raised.
    #   "Cliquer Sur Sign In" succeeds whether or not the login worked.
    #   The ASSERTION is what actually validates the expected result.
    # WHAT HAPPENS INSIDE the keyword:
    #   1. Waits for the username label (${LOC_USER_LOGGED_LABEL}) to appear.
    #      WHY: This label "<span class='hi-user...'>rimkQA2026x</span>" is ONLY
    #           visible when a user is logged in. Its appearance = login success.
    #   2. Gets the text of the label.
    #   3. Compares it to ${LOGIN_USERNAME} using Should Be Equal As Strings.
    #      WHY: Not only must we be logged in, we must be logged in as THE CORRECT user.
    #           This catches bugs where you're redirected to another account.
    # ─────────────────────────────────────────────────────────────────
    Vérifier Succès Connexion    ${LOGIN_USERNAME}
