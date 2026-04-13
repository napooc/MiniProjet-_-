package com.aos.us4.pages;

import com.aos.us4.utils.ChatKiller;
import com.aos.us4.utils.WaitHelper;
import org.openqa.selenium.By;
import org.openqa.selenium.JavascriptExecutor;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.interactions.Actions;
import org.openqa.selenium.support.ui.ExpectedConditions;
import org.openqa.selenium.support.ui.WebDriverWait;

import java.time.Duration;

public class HomePage {

    private final WebDriver driver;

    private static final By CART_ICON = By.xpath("//*[@id='menuCart']");
    private static final By FLOATING_CART_REMOVE_BTN = By.xpath("//*[@class='removeProduct iconCss iconX']");
    private static final By FLOATING_CART_PRODUCT_ROWS = By.xpath("//*[@class='removeProduct iconCss iconX']");
    private static final By NAV_SPEAKERS = By.xpath("//span[@id='speakersTxt']");

    public HomePage(WebDriver driver) {
        this.driver = driver;
    }

    public HomePage clickCartIcon() {
        ChatKiller.kill(driver);
        WebElement cart = WaitHelper.waitForClickable(driver, CART_ICON);
        try {
            cart.click();
        } catch (Exception e) {
            new Actions(driver).moveToElement(cart).click().perform();
        }
        return this;
    }

    public HomePage hoverCartIcon() {
        ChatKiller.kill(driver);
        WebElement cartIcon = WaitHelper.waitForVisible(driver, CART_ICON);
        ((JavascriptExecutor) driver).executeScript("arguments[0].scrollIntoView({block:'center'});", cartIcon);

        new Actions(driver).moveToElement(cartIcon).perform();
        if (!isFloatingCartOpen(3)) {
            ((JavascriptExecutor) driver).executeScript(
                    "var el=arguments[0];"
                    + "el.dispatchEvent(new MouseEvent('mouseenter',{bubbles:true}));"
                    + "el.dispatchEvent(new MouseEvent('mouseover',{bubbles:true}));",
                    cartIcon);
        }
        if (!isFloatingCartOpen(3)) {
            WebElement body = driver.findElement(By.tagName("body"));
            new Actions(driver)
                    .moveToElement(body, 0, 0).pause(Duration.ofMillis(300))
                    .moveToElement(cartIcon).perform();
            new WebDriverWait(driver, Duration.ofSeconds(5))
                    .until(ExpectedConditions.visibilityOfElementLocated(FLOATING_CART_REMOVE_BTN));
        }
        return this;
    }

    private boolean isFloatingCartOpen(int timeoutSec) {
        try {
            new WebDriverWait(driver, Duration.ofSeconds(timeoutSec))
                    .until(ExpectedConditions.visibilityOfElementLocated(FLOATING_CART_REMOVE_BTN));
            return true;
        } catch (Exception e) {
            return false;
        }
    }

    public HomePage clickRemoveFirstProductFromFloatingCart() {
        int countBefore = driver.findElements(FLOATING_CART_PRODUCT_ROWS).size();
        WebElement btn = WaitHelper.waitForClickable(driver, FLOATING_CART_REMOVE_BTN);
        ((JavascriptExecutor) driver).executeScript("arguments[0].click();", btn);
        new WebDriverWait(driver, Duration.ofSeconds(8))
                .until(d -> d.findElements(FLOATING_CART_PRODUCT_ROWS).size() < countBefore);
        return this;
    }

    public int getFloatingCartProductCount() {
        return driver.findElements(FLOATING_CART_PRODUCT_ROWS).size();
    }

    public HomePage clickOnSpeakersCategory() {
        ChatKiller.kill(driver);
        ((JavascriptExecutor) driver).executeScript("window.scrollTo(0,0);");
        WebElement speakers = WaitHelper.waitForClickable(driver, NAV_SPEAKERS);
        ((JavascriptExecutor) driver).executeScript("arguments[0].click();", speakers);
        try { Thread.sleep(1500); } catch (InterruptedException ignored) {}
        ChatKiller.kill(driver);
        new WebDriverWait(driver, Duration.ofSeconds(12))
                .until(ExpectedConditions.presenceOfElementLocated(
                        By.xpath("//img[@id and string-length(@id) > 0]")));
        return this;
    }
}
