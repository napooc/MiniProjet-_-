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

    private final WebDriver        driver;
    private final JavascriptExecutor js;

    // ── Localisateurs ──────────────────────────────────────────
    private final By userMenuIcon    = By.cssSelector("a#menuUserLink[aria-label='UserMenu']");
    private final By signOutLink     = By.xpath("//label[@class='option roboto-medium ng-scope'][text()='Sign out']");
    // Classe exacte identique à Robot : LOC_USER_LOGGED_LABEL
    private final By userLoggedLabel = By.xpath("//span[@class='hi-user containMiniTitle ng-binding']");
    private final By loader          = By.cssSelector("div.loader");

    public HeaderPage(WebDriver driver) {
        this.driver = driver;
        this.js     = (JavascriptExecutor) driver;
    }

    // ── Actions ────────────────────────────────────────────────

    /** Clique sur l'icône utilisateur (ouvre le panneau). */
    public void clickUserMenu() {
        WaitUtils.waitForInvisible(driver, loader, 15);
        WaitUtils.waitForClickable(driver, userMenuIcon, 10);
        driver.findElement(userMenuIcon).click();
    }

    /** Clique sur "Sign Out" – JS click (robuste contre overlay) + attend fermeture menu. */
    public void clickSignOut() {
        WaitUtils.waitForVisible(driver, signOutLink, 10);
        js.executeScript("arguments[0].click();", driver.findElement(signOutLink));
        // Attendre que le menu se ferme (Sign out disparaît) = déconnexion traitée
        WaitUtils.waitForInvisible(driver, signOutLink, 10);
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
            WaitUtils.waitForVisible(driver, userLoggedLabel, 15);
            return true;
        } catch (Exception e) {
            return false;
        }
    }

    /**
     * True si l'utilisateur est déconnecté.
     * Vérifie via JS que le span hi-user a ng-hide (Angular = déconnecté) ou n'existe pas.
     */
    public boolean isUserLoggedOut() {
        try {
            Thread.sleep(1000);
            Boolean hasNgHide = (Boolean) js.executeScript(
                "var span = document.querySelector('span.hi-user.containMiniTitle.ng-binding');" +
                "if (!span) return true;" +
                "return span.classList.contains('ng-hide');"
            );
            return hasNgHide != null && hasNgHide;
        } catch (Exception e) {
            return false;
        }
    }
}
