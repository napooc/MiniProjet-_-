package utils;

import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.support.ui.ExpectedConditions;
import org.openqa.selenium.support.ui.WebDriverWait;

import java.time.Duration;

/**
 * WaitUtils – utilitaires d'attente explicite pour SeleniumLibrary 4.x / WebDriver 4.x.
 */
public class WaitUtils {

    /**
     * Attend que l'élément soit visible dans le DOM.
     */
    public static void waitForVisible(WebDriver driver, By locator, int seconds) {
        new WebDriverWait(driver, Duration.ofSeconds(seconds))
                .until(ExpectedConditions.visibilityOfElementLocated(locator));
    }

    /**
     * Attend que l'élément soit cliquable.
     */
    public static void waitForClickable(WebDriver driver, By locator, int seconds) {
        new WebDriverWait(driver, Duration.ofSeconds(seconds))
                .until(ExpectedConditions.elementToBeClickable(locator));
    }

    /**
     * Attend que l'élément ne soit plus visible (ex : overlay loader).
     */
    public static void waitForInvisible(WebDriver driver, By locator, int seconds) {
        new WebDriverWait(driver, Duration.ofSeconds(seconds))
                .until(ExpectedConditions.invisibilityOfElementLocated(locator));
    }

    /**
     * Attend que le texte d'un élément contienne la valeur attendue.
     */
    public static void waitForTextPresent(WebDriver driver, By locator, String text, int seconds) {
        new WebDriverWait(driver, Duration.ofSeconds(seconds))
                .until(ExpectedConditions.textToBePresentInElementLocated(locator, text));
    }
}
