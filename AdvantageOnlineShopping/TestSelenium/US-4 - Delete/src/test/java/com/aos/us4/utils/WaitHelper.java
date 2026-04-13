package com.aos.us4.utils;

import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.ui.ExpectedConditions;
import org.openqa.selenium.support.ui.WebDriverWait;

import java.time.Duration;
import java.util.List;

public final class WaitHelper {

    private static final int TIMEOUT = ConfigReader.getInt("explicit.wait");

    private WaitHelper() {}

    public static WebElement waitForVisible(WebDriver driver, By locator) {
        return new WebDriverWait(driver, Duration.ofSeconds(TIMEOUT))
                .until(ExpectedConditions.visibilityOfElementLocated(locator));
    }

    public static WebElement waitForClickable(WebDriver driver, By locator) {
        return new WebDriverWait(driver, Duration.ofSeconds(TIMEOUT))
                .until(ExpectedConditions.elementToBeClickable(locator));
    }

    public static WebElement waitForPresence(WebDriver driver, By locator) {
        return new WebDriverWait(driver, Duration.ofSeconds(TIMEOUT))
                .until(ExpectedConditions.presenceOfElementLocated(locator));
    }

    public static List<WebElement> waitForAllVisible(WebDriver driver, By locator) {
        return new WebDriverWait(driver, Duration.ofSeconds(TIMEOUT))
                .until(ExpectedConditions.visibilityOfAllElementsLocatedBy(locator));
    }
}
