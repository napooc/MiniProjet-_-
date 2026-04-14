package pages;

import java.util.List;
import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import utils.WaitUtils;

public class ProductPage {

    private final WebDriver driver;

    private final By quantityInput = By.name("quantity");
    private final By addToCartButton = By.name("save_to_cart");

    public ProductPage(WebDriver driver) {
        this.driver = driver;
    }

    public void setQuantity(int quantity) {
        WebElement input = WaitUtils.waitForVisible(driver, quantityInput);
        input.clear();
        input.sendKeys(String.valueOf(quantity));
    }

    public void setQuantityIfVisible(int quantity) {
        List<WebElement> inputs = driver.findElements(quantityInput);
        if (!inputs.isEmpty() && inputs.get(0).isDisplayed()) {
            WebElement input = inputs.get(0);
            input.clear();
            input.sendKeys(String.valueOf(quantity));
        }
    }

    public void addToCart() {
        WaitUtils.waitForClickable(driver, addToCartButton).click();
    }
}
