package example.us3add.pages;

import java.time.Duration;
import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.support.ui.ExpectedConditions;
import org.openqa.selenium.support.ui.WebDriverWait;

/**
 * Robot equivalents:
 * - pages/HomePage.resource   : Open Category Tablets / Open Category Laptops
 * - pages/CategoryPage.resource : Select Product Tablet / Select Product Laptop
 *
 * Variables (from resources/variables.resource):
 *   ${CATEGORY_01_XPATH} = //div[@id="tabletsImg"]
 *   ${CATEGORY_06_XPATH} = //div[@id="laptopsImg"]
 *   ${PRODUCT_01_ID}     = 18
 *   ${PRODUCT_06_ID}     = 1
 */
public class HomePage {

    private final WebDriver driver;
    private final WebDriverWait wait;

    // Robot: ${CATEGORY_01_XPATH}
    private final By tabletsCategory = By.xpath("//div[@id='tabletsImg']");

    // Robot: ${CATEGORY_06_XPATH}
    private final By laptopsCategory = By.xpath("//div[@id='laptopsImg']");

    public HomePage(WebDriver driver) {
        this.driver = driver;
        this.wait = new WebDriverWait(driver, Duration.ofSeconds(10));
    }

    // Robot: Open Category Tablets
    public void openCategoryTablets() {
        wait.until(ExpectedConditions.elementToBeClickable(tabletsCategory)).click();
    }

    // Robot: Open Category Laptops
    public void openCategoryLaptops() {
        wait.until(ExpectedConditions.elementToBeClickable(laptopsCategory)).click();
    }

    // Robot: Select Product (CategoryPage.resource)
    // Uses xpath: //img[@id="${product_id}"]
    public void selectProductById(String productId) {
        By product = By.xpath("//img[@id='" + productId + "']");
        wait.until(ExpectedConditions.elementToBeClickable(product)).click();
    }

    // Robot: Select Product Tablet  → ${PRODUCT_01_ID} = 18
    public void selectProductTablet() {
        selectProductById("18");
    }

    // Robot: Select Product Laptop  → ${PRODUCT_06_ID} = 1
    public void selectProductLaptop() {
        selectProductById("1");
    }
}
