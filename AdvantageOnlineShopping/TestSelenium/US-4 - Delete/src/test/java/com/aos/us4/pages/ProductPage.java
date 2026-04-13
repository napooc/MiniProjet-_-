package com.aos.us4.pages;

import com.aos.us4.utils.ChatKiller;
import org.openqa.selenium.By;
import org.openqa.selenium.JavascriptExecutor;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.interactions.Actions;
import org.openqa.selenium.support.ui.ExpectedConditions;
import org.openqa.selenium.support.ui.WebDriverWait;

import java.time.Duration;
import java.util.List;

public class ProductPage {

    private final WebDriver driver;

    private static final By FIRST_PRODUCT_IMAGE = By.xpath("//img[@id='20']");
    private static final By ADD_TO_CART_BUTTON = By.xpath(
            "//button[@class='roboto-medium ng-scope' and contains(text(),'ADD TO CART')]");
    private static final By CART_BADGE = By.xpath(
            "//*[@id='menuCart']//span[contains(@class,'cart-size')]");

    public ProductPage(WebDriver driver) {
        this.driver = driver;
    }

    public void clickFirstProduct() {
        ChatKiller.kill(driver);

        List<WebElement> found = driver.findElements(FIRST_PRODUCT_IMAGE);
        WebElement img = found.isEmpty()
                ? driver.findElement(By.xpath("(//img[@id and string-length(@id) > 0])[1]"))
                : found.get(0);

        ((JavascriptExecutor) driver).executeScript(
                "arguments[0].scrollIntoView({block:'center'});", img);
        try { Thread.sleep(500); } catch (InterruptedException ignored) {}

        try {
            WebElement anchor = (WebElement) ((JavascriptExecutor) driver).executeScript(
                    "return arguments[0].closest('a');", img);
            if (anchor != null) {
                ((JavascriptExecutor) driver).executeScript("arguments[0].click();", anchor);
            } else {
                ((JavascriptExecutor) driver).executeScript("arguments[0].click();", img);
            }
        } catch (Exception e) {
            ((JavascriptExecutor) driver).executeScript("arguments[0].click();", img);
        }

        try { Thread.sleep(3000); } catch (InterruptedException ignored) {}
        ChatKiller.kill(driver);

        String url = driver.getCurrentUrl();
        if (url != null && url.contains("chat.html")) {
            driver.navigate().back();
            try { Thread.sleep(2000); } catch (InterruptedException ignored) {}
            ChatKiller.kill(driver);
            found = driver.findElements(FIRST_PRODUCT_IMAGE);
            img = found.isEmpty()
                    ? driver.findElement(By.xpath("(//img[@id and string-length(@id) > 0])[1]"))
                    : found.get(0);
            ((JavascriptExecutor) driver).executeScript("arguments[0].click();", img);
            try { Thread.sleep(3000); } catch (InterruptedException ignored) {}
            ChatKiller.kill(driver);
        }

        new WebDriverWait(driver, Duration.ofSeconds(15))
                .until(ExpectedConditions.presenceOfElementLocated(ADD_TO_CART_BUTTON));
    }

    public ProductPage clickAddToCart() {
        ChatKiller.kill(driver);

        try {
            List<WebElement> colorOptions = driver.findElements(By.xpath(
                    "//li[contains(@class,'color') and not(contains(@class,'selected'))] | "
                    + "//label[contains(@class,'color')]"));
            if (!colorOptions.isEmpty()) {
                ((JavascriptExecutor) driver).executeScript(
                        "arguments[0].click();", colorOptions.get(0));
                try { Thread.sleep(500); } catch (InterruptedException ignored) {}
            }
        } catch (Exception ignored) {}

        WebElement btn = new WebDriverWait(driver, Duration.ofSeconds(10))
                .until(ExpectedConditions.elementToBeClickable(ADD_TO_CART_BUTTON));
        new Actions(driver).moveToElement(btn).click().perform();

        try { Thread.sleep(3000); } catch (InterruptedException ignored) {}
        try {
            new WebDriverWait(driver, Duration.ofSeconds(10))
                    .until(d -> {
                        try {
                            String text = (String) ((JavascriptExecutor) d).executeScript(
                                    "return document.getElementById('menuCart').innerText.trim();");
                            return text != null && text.matches(".*[1-9].*");
                        } catch (Exception ex) {
                            return false;
                        }
                    });
        } catch (Exception ignored) {}

        return this;
    }
}
