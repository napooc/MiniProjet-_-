package utils;

import java.time.Duration;
import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.ui.ExpectedConditions;
import org.openqa.selenium.support.ui.WebDriverWait;

public final class WaitUtils {

    private static final int DEFAULT_TIMEOUT_SECONDS = 20;

    private WaitUtils() {
    }

    public static WebElement waitForVisible(WebDriver driver, By locator) {
        return new WebDriverWait(driver, Duration.ofSeconds(DEFAULT_TIMEOUT_SECONDS))
                .until(ExpectedConditions.visibilityOfElementLocated(locator));
    }

    public static boolean waitForInvisible(WebDriver driver, By locator) {
        return new WebDriverWait(driver, Duration.ofSeconds(DEFAULT_TIMEOUT_SECONDS))
                .until(ExpectedConditions.invisibilityOfElementLocated(locator));
    }

    public static WebElement waitForClickable(WebDriver driver, By locator) {
        return new WebDriverWait(driver, Duration.ofSeconds(DEFAULT_TIMEOUT_SECONDS))
                .until(ExpectedConditions.elementToBeClickable(locator));
    }

    public static boolean waitForText(WebDriver driver, By locator, String expectedText) {
        return new WebDriverWait(driver, Duration.ofSeconds(DEFAULT_TIMEOUT_SECONDS))
                .until(ExpectedConditions.textToBe(locator, expectedText));
    }
}
