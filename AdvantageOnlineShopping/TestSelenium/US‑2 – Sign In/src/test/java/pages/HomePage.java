package pages;

import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import utils.WaitUtils;

/**
 * HomePage – page d'accueil AOS (/#/).
 * Fournit les méthodes de vérification de chargement de la page.
 */
public class HomePage {

    private final WebDriver driver;

    // ── Localisateurs ──────────────────────────────────────────
    private final By loader      = By.cssSelector("div.loader");
    private final By userMenu    = By.cssSelector("a#menuUserLink[aria-label='UserMenu']");

    public HomePage(WebDriver driver) {
        this.driver = driver;
    }

    // ── Actions ────────────────────────────────────────────────

    /**
     * Attend que la page d'accueil soit complètement chargée :
     * loader invisible + icône UserMenu visible.
     */
    public void waitForPageLoad() {
        WaitUtils.waitForInvisible(driver, loader, 15);
        WaitUtils.waitForVisible(driver, userMenu, 20);
    }

    /** Retourne l'URL courante du navigateur. */
    public String getCurrentUrl() {
        return driver.getCurrentUrl();
    }
}
