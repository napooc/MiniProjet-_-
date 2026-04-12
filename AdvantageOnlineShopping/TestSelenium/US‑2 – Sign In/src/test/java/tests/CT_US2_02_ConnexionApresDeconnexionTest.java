package tests;

import io.github.bonigarcia.wdm.WebDriverManager;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.chrome.ChromeDriver;
import org.openqa.selenium.chrome.ChromeOptions;
import org.testng.Assert;
import org.testng.annotations.AfterClass;
import org.testng.annotations.BeforeClass;
import org.testng.annotations.Test;
import pages.HeaderPage;
import pages.HomePage;
import pages.LoginPage;

import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;

/**
 * CT_US2_02 – Connexion après déconnexion
 *
 * USER STORY    : US-2 – Sign In
 * CAS DE TEST   : CT_US2_02
 * TYPE          : Test positif
 * OBJECTIF      : Vérifier qu'un utilisateur connecté peut se déconnecter
 *                 puis se reconnecter avec des identifiants valides.
 *
 * PRÉCONDITIONS : Le site AOS est accessible.
 *                 Le compte username/password défini dans config.properties existe.
 *
 * ÉTAPES MANUELLES (qTest) :
 *   1. [Setup]   L'utilisateur est connecté (connexion initiale via @BeforeClass)
 *   2. Logout    → clic UserMenu → clic Sign Out
 *   3. Vérifier  → l'utilisateur est bien déconnecté (panneau login visible)
 *   4. Saisir    → username
 *   5. Saisir    → password
 *   6. Sign In   → clic bouton Sign In
 *   7. Résultat  → le nom d'utilisateur s'affiche dans la barre de navigation
 */
public class CT_US2_02_ConnexionApresDeconnexionTest {

    private WebDriver  driver;
    private Properties config;

    private LoginPage  loginPage;
    private HomePage   homePage;
    private HeaderPage headerPage;

    // ── Setup ──────────────────────────────────────────────────────────────────

    @BeforeClass
    public void setUp() throws IOException {
        // Chargement de la configuration
        config = new Properties();
        try (InputStream is = getClass().getClassLoader()
                .getResourceAsStream("config.properties")) {
            if (is == null) {
                throw new IOException("config.properties introuvable dans le classpath");
            }
            config.load(is);
        }

        // ChromeDriver géré automatiquement par WebDriverManager
        WebDriverManager.chromedriver().setup();

        ChromeOptions options = new ChromeOptions();
        options.addArguments("--no-sandbox");
        options.addArguments("--disable-dev-shm-usage");
        driver = new ChromeDriver(options);
        driver.manage().window().maximize();

        // Initialisation des Page Objects
        loginPage  = new LoginPage(driver);
        homePage   = new HomePage(driver);
        headerPage = new HeaderPage(driver);

        // PRÉCONDITION : naviguer vers AOS et se connecter
        driver.get(config.getProperty("base.url"));
        homePage.waitForPageLoad();
        loginPage.login(
                config.getProperty("username"),
                config.getProperty("password")
        );
        // Vérifier que la connexion initiale est réussie
        Assert.assertTrue(
                headerPage.isUserLoggedIn(),
                "[Setup] La connexion initiale a échoué – le compte existe-t-il ?"
        );
    }

    // ── Test ───────────────────────────────────────────────────────────────────

    @Test(description = "CT_US2_02 – Connexion après déconnexion")
    public void testConnexionApresDeconnexion() {

        // ── Étape 2 : Déconnexion ─────────────────────────────────────────────
        headerPage.logout();

        // ── Étape 3 : Vérifier l'état déconnecté ─────────────────────────────
        homePage.waitForPageLoad();
        Assert.assertFalse(
                headerPage.isUserLoggedIn(),
                "L'utilisateur est encore connecté après Sign Out"
        );

        // ── Étapes 4 & 5 : Saisie des identifiants ───────────────────────────
        // ── Étape 6 : Clic Sign In ────────────────────────────────────────────
        loginPage.login(
                config.getProperty("username"),
                config.getProperty("password")
        );

        // ── Étape 7 : Vérifier la reconnexion ────────────────────────────────
        String expectedUsername = config.getProperty("username");
        String displayedUsername = headerPage.getLoggedInUsername();

        Assert.assertEquals(
                displayedUsername,
                expectedUsername,
                "CT_US2_02 FAIL – Le nom affiché après reconnexion ne correspond pas"
        );
    }

    // ── Teardown ───────────────────────────────────────────────────────────────

    @AfterClass(alwaysRun = true)
    public void tearDown() {
        if (driver != null) {
            driver.quit();
        }
    }
}
