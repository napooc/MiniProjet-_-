package pages;

import org.openqa.selenium.By;
import org.openqa.selenium.JavascriptExecutor;
import org.openqa.selenium.WebDriver;
import utils.WaitUtils;

/**
 * LoginPage – formulaire de connexion AOS.
 * Le formulaire apparaît dans le panneau latéral après clic sur UserMenu.
 *
 * NOTE AOS : le site utilise une directive AngularJS personnalisée (secInput /
 * secModel). Pour que ng-model soit déclenché correctement, on utilise des clics
 * JavaScript au lieu de clics WebDriver natifs qui sont interceptés par les
 * éléments SVG superposés.
 */
public class LoginPage {

    private final WebDriver driver;
    private final JavascriptExecutor js;

    // ── Localisateurs ──────────────────────────────────────────
    private final By userMenuIcon  = By.cssSelector("a#menuUserLink[aria-label='UserMenu']");
    private final By usernameInput = By.cssSelector("input[name='username']");
    private final By passwordInput = By.cssSelector("input[name='password']");
    private final By signInButton  = By.id("sign_in_btn");
    private final By loader        = By.cssSelector("div.loader");

    public LoginPage(WebDriver driver) {
        this.driver = driver;
        this.js     = (JavascriptExecutor) driver;
    }

    // ── Actions ────────────────────────────────────────────────

    /** Clique sur l'icône utilisateur pour ouvrir le panneau de connexion. */
    public void openLoginPanel() {
        WaitUtils.waitForInvisible(driver, loader, 15);
        WaitUtils.waitForClickable(driver, userMenuIcon, 10);
        driver.findElement(userMenuIcon).click();
    }

    /** Saisit le nom d'utilisateur (scrollIntoView + click réel → déclenche secModel). */
    public void enterUsername(String username) {
        WaitUtils.waitForInvisible(driver, loader, 15);
        WaitUtils.waitForVisible(driver, usernameInput, 10);
        js.executeScript("document.querySelector('[name=\"username\"]').scrollIntoView({block:'center'})");
        driver.findElement(usernameInput).click();
        driver.findElement(usernameInput).sendKeys(username);
    }

    /**
     * Saisit le mot de passe.
     * Le clic JS est nécessaire : un SVG overlay intercepte le clic WebDriver natif.
     * Après saisie, on clique sur username pour déclencher le blur sur password
     * et activer la validation secModel.
     */
    public void enterPassword(String password) {
        WaitUtils.waitForVisible(driver, passwordInput, 10);
        js.executeScript("document.querySelector('[name=\"password\"]').scrollIntoView({block:'center'})");
        js.executeScript("document.querySelector('[name=\"password\"]').click()");
        driver.findElement(passwordInput).sendKeys(password);
        js.executeScript("document.querySelector('[name=\"username\"]').click()");
    }

    /** Clique sur le bouton Sign In. */
    public void clickSignIn() {
        WaitUtils.waitForClickable(driver, signInButton, 10);
        driver.findElement(signInButton).click();
    }

    /**
     * Séquence complète de connexion :
     * ouvre le panneau → username → password → Sign In.
     */
    public void login(String username, String password) {
        openLoginPanel();
        enterUsername(username);
        enterPassword(password);
        clickSignIn();
    }
}
