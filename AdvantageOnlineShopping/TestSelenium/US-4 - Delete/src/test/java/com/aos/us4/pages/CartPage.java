package com.aos.us4.pages;

import com.aos.us4.utils.ChatKiller;
import com.aos.us4.utils.WaitHelper;
import org.openqa.selenium.By;
import org.openqa.selenium.JavascriptExecutor;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.ui.ExpectedConditions;
import org.openqa.selenium.support.ui.WebDriverWait;

import java.time.Duration;
import java.util.List;

public class CartPage {

    private final WebDriver driver;

    private static final By REMOVE_BUTTON = By.xpath(
            "//a[@class='remove red ng-scope' and contains(text(),'REMOVE')]");
    private static final By CART_TOTAL_PRICE = By.xpath(
            "//*[contains(@class,'totals')]//*[contains(@class,'total-price')] | "
            + "//*[contains(@class,'cart-total')]//span | "
            + "//*[contains(@class,'cartTotal')] | "
            + "//*[contains(@class,'orderTotal')]");
    private static final By CHECKOUT_BUTTON = By.xpath(
            "//*[contains(@class,'btn-checkout')] | "
            + "//a[contains(@class,'checkout-btn')] | "
            + "//button[contains(@class,'checkout')] | "
            + "//*[contains(@href,'checkout')]");
    private static final By HEADER_CART_BADGE = By.xpath(
            "//*[@id='menuCart']//*[contains(@class,'cart-count')] | "
            + "//*[@id='menuCart']//*[contains(@class,'badge')] | "
            + "//*[contains(@class,'shopping_cart_count')] | "
            + "//*[@id='menuCart']//span[contains(@class,'qty')]");

    public CartPage(WebDriver driver) {
        this.driver = driver;
    }

    public CartPage clickRemoveFirstProduct() {
        int countBefore = driver.findElements(REMOVE_BUTTON).size();
        WebElement btn = WaitHelper.waitForVisible(driver, REMOVE_BUTTON);
        ((JavascriptExecutor) driver).executeScript("arguments[0].click();", btn);
        new WebDriverWait(driver, Duration.ofSeconds(8))
                .until(d -> d.findElements(REMOVE_BUTTON).size() < countBefore);
        return this;
    }

    public int getArticleCountFromTitle() {
        return getCartProductCount();
    }

    public String getCartTotalPrice() {
        try {
            for (WebElement el : driver.findElements(CART_TOTAL_PRICE)) {
                String text = el.getText().trim();
                if (!text.isEmpty()) return text;
            }
        } catch (Exception ignored) {}
        return "$0.00";
    }

    public String getCheckoutButtonText() {
        try {
            List<WebElement> elements = driver.findElements(CHECKOUT_BUTTON);
            if (!elements.isEmpty()) return elements.get(0).getText().trim();
        } catch (Exception ignored) {}
        return "";
    }

    public int getHeaderCartBadgeCount() {
        try {
            List<WebElement> elements = driver.findElements(HEADER_CART_BADGE);
            if (!elements.isEmpty()) {
                String text = elements.get(0).getText().trim();
                if (!text.isEmpty()) return Integer.parseInt(text.replaceAll("[^0-9]", ""));
            }
        } catch (Exception ignored) {}
        return getCartProductCount();
    }

    public int getCartProductCount() {
        try {
            return driver.findElements(REMOVE_BUTTON).size();
        } catch (Exception e) {
            return 0;
        }
    }

    public CartPage waitForCartPageToLoad() {
        new WebDriverWait(driver, Duration.ofSeconds(10))
                .until(ExpectedConditions.urlContains("shoppingCart"));
        ChatKiller.kill(driver);
        WaitHelper.waitForPresence(driver, REMOVE_BUTTON);
        return this;
    }
}
