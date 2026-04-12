package pages;

import org.openqa.selenium.By;
import org.openqa.selenium.ElementClickInterceptedException;
import org.openqa.selenium.JavascriptExecutor;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.support.ui.FluentWait;
import utils.WaitUtils;

import java.time.Duration;

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
    private final By usernameInput = By.xpath("//input[@name='username']");
    private final By passwordInput = By.xpath("//input[@name='password']");
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
        WaitUtils.waitForVisible(driver, usernameInput, 10);
        WaitUtils.waitForInvisible(driver, loader, 15);
    }

    /** Saisit le nom d'utilisateur avec un vrai clic WebDriver (déclenche blur AngularJS).
     *  Retry si le loader intercept le clic (race condition AOS). */
    public void enterUsername(String username) {
        WaitUtils.waitForInvisible(driver, loader, 20);
        WaitUtils.waitForClickable(driver, usernameInput, 10);
        js.executeScript("document.querySelector('[name=\"username\"]').scrollIntoView({block:'center'})");
        // FluentWait : retry sur ElementClickInterceptedException si loader réapparaît
        new FluentWait<>(driver)
            .withTimeout(Duration.ofSeconds(15))
            .pollingEvery(Duration.ofMillis(500))
            .ignoring(ElementClickInterceptedException.class)
            .until(d -> { d.findElement(usernameInput).click(); return true; });
        driver.findElement(usernameInput).sendKeys(username);
    }

    /**
     * Saisit le mot de passe (JS click car SVG overlay intercepte le clic natif),
     * puis vrai clic sur username pour déclencher blur → secModel sur password.
     *
     * Attendre loader invisible, JS click sur password (SVG overlay),
     * puis clic WebDriver réel sur username pour déclencher blur/secModel.
     */
    public void enterPassword(String password) {
        WaitUtils.waitForVisible(driver, passwordInput, 10);
        js.executeScript("document.querySelector('[name=\"password\"]').scrollIntoView({block:'center'})");
        js.executeScript("document.querySelector('[name=\"password\"]').click()");
        driver.findElement(passwordInput).sendKeys(password);
        // JS click sur username → blur sur password → secModel valide (identique Robot)
        js.executeScript("document.querySelector('[name=\"username\"]').click()");
    }

    /** Clique sur Sign In – clic natif WebDriver (identique Robot Click Element) pour déclencher ng-click Angular. */
    public void clickSignIn() {
        WaitUtils.waitForVisible(driver, signInButton, 15);
        driver.findElement(signInButton).click();
        WaitUtils.waitForInvisible(driver, loader, 20);
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
