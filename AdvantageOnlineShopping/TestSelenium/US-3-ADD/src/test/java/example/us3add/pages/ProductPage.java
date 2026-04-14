package example.us3add.pages;

import java.time.Duration;
import java.util.List;
import org.openqa.selenium.By;
import org.openqa.selenium.Keys;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.ui.ExpectedConditions;
import org.openqa.selenium.support.ui.WebDriverWait;

/**
 * Robot equivalent: pages/ProductPage.resource
 *
 * Keywords:
 *   Select Color              → selectColor(String color)
 *   Enter Quantity            → enterQuantity(int quantity)
 *   Enter Quantity If Visible → enterQuantityIfVisible(int quantity)
 *   Add Product To Cart       → addProductToCart()
 *
 * Variables:
 *   ${Button_xpath} = //button[@name="save_to_cart"]
 */
public class ProductPage {

    private final WebDriver driver;
    private final WebDriverWait wait;

    // Robot: name=quantity
    private final By quantityInput = By.name("quantity");

    // Robot: ${Button_xpath}
    private final By addToCartButton = By.xpath("//button[@name='save_to_cart']");

    public ProductPage(WebDriver driver) {
        this.driver = driver;
        this.wait = new WebDriverWait(driver, Duration.ofSeconds(10));
    }

    // Robot: Select Color ${color}
    // Wait Until Element Is Visible xpath=//span[@title="${color}"]
    // Click Element xpath=//span[@title="${color}"]
    public void selectColor(String color) {
        By colorSwatch = By.xpath("//span[@title='" + color + "']");
        wait.until(ExpectedConditions.elementToBeClickable(colorSwatch)).click();
    }

    // Robot: Enter Quantity ${quantity}
    // Clear Element Text  name=quantity
    // Input Text          name=quantity  ${quantity}
    public void enterQuantity(int quantity) {
        WebElement input = wait.until(ExpectedConditions.visibilityOfElementLocated(quantityInput));
        input.click();
        input.sendKeys(Keys.chord(Keys.CONTROL, "a"));
        input.sendKeys(String.valueOf(quantity));
    }

    // Robot: Enter Quantity If Visible ${quantity}
    // Wait Until Element Is Visible  name=quantity  3s  (with status check)
    public void enterQuantityIfVisible(int quantity) {
        List<WebElement> inputs = driver.findElements(quantityInput);
        if (!inputs.isEmpty() && inputs.get(0).isDisplayed()) {
            WebElement input = inputs.get(0);
            input.click();
            input.sendKeys(Keys.chord(Keys.CONTROL, "a"));
            input.sendKeys(String.valueOf(quantity));
        }
    }

    // Robot: Add Product To Cart
    // Wait Until Element Is Visible ${Button_xpath}
    // Click Button ${Button_xpath}
    public void addProductToCart() {
        wait.until(ExpectedConditions.elementToBeClickable(addToCartButton)).click();
    }
}
