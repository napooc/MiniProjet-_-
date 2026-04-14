package pages;

import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import utils.WaitUtils;

public class HomePage {

    private final WebDriver driver;

    private final By loader = By.cssSelector(".loader");
    private final By cartIcon = By.id("shoppingCartLink");
    private final By laptopsCategory = By.xpath("//div[@id='laptopsImg']");
    private final By defaultLaptopProduct = By.xpath("//img[@id='1']");

    public HomePage(WebDriver driver) {
        this.driver = driver;
    }

    public void open(String baseUrl) {
        driver.get(baseUrl);
    }

    public void waitForPageLoad() {
        WaitUtils.waitForInvisible(driver, loader);
        WaitUtils.waitForVisible(driver, cartIcon);
    }

    public void goToShoppingCart() {
        WaitUtils.waitForClickable(driver, cartIcon).click();
    }

    public void openLaptopsCategory() {
        WaitUtils.waitForClickable(driver, laptopsCategory).click();
    }

    public void openDefaultLaptopProduct() {
        WaitUtils.waitForClickable(driver, defaultLaptopProduct).click();
    }
}
