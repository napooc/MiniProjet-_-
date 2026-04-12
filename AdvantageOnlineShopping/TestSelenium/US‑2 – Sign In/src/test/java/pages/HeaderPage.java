package pages;

import org.openqa.selenium.By;
import org.openqa.selenium.JavascriptExecutor;
import org.openqa.selenium.WebDriver;
import utils.WaitUtils;

/**
 * HeaderPage – barre de navigation AOS.
 * Gère l'icône utilisateur, la déconnexion et la vérification
 * de l'état connecté/déconnecté.
 */
public class HeaderPage {

    private final WebDriver driver;

    // ── Localisateurs ──────────────────────────────────────────
    private final By userMenuIcon    = By.cssSelector("a#menuUserLink[aria-label='UserMenu']");
    private final By signOutLink     = By.xpath("//a[normalize-space()='Sign Out']");
    private final By userLoggedLabel = By.cssSelector("span.hi-user.containMiniTitle.ng-binding");
    private final By loader          = By.cssSelector("div.loader");

    public HeaderPage(WebDriver driver) {
        this.driver = driver;
    }

    // ── Actions ────────────────────────────────────────────────

    /** Clique sur l'icône utilisateur (ouvre le panneau). */
    public void clickUserMenu() {
        WaitUtils.waitForInvisible(driver, loader, 15);
        WaitUtils.waitForClickable(driver, userMenuIcon, 10);
        driver.findElement(userMenuIcon).click();
    }

    /** Clique sur "Sign Out" dans le panneau utilisateur. */
    public void clickSignOut() {
        WaitUtils.waitForClickable(driver, signOutLink, 10);
        driver.findElement(signOutLink).click();
        WaitUtils.waitForInvisible(driver, loader, 15);
    }

    /** Séquence complète de déconnexion : ouvre le menu → clique Sign Out. */
    public void logout() {
        clickUserMenu();
        clickSignOut();
    }

    // ── Assertions ─────────────────────────────────────────────

    /** Retourne le texte affiché dans le label utilisateur connecté. */
    public String getLoggedInUsername() {
        WaitUtils.waitForVisible(driver, userLoggedLabel, 15);
        return driver.findElement(userLoggedLabel).getText().trim();
    }

    /** True si le label de l'utilisateur connecté est visible. */
    public boolean isUserLoggedIn() {
        try {
            WaitUtils.waitForVisible(driver, userLoggedLabel, 5);
            return true;
        } catch (Exception e) {
            return false;
        }
    }

    /** True si le panneau de login est accessible (utilisateur déconnecté). */
    public boolean isUserLoggedOut() {
        return !isUserLoggedIn();
    }
}
