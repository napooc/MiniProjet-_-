package example.us3add.pages;

import java.time.Duration;
import org.junit.jupiter.api.Assertions;
import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.support.ui.WebDriverWait;

/**
 * Robot equivalent: pages/CartPage.resource
 *
 * Keywords:
 *   Verify Product Added To Cart → verifyProductAddedToCart(String productNameToken)
 *   Verify Cart Quantity         → verifyCartQuantity(int quantity)
 *
 * Variables:
 *   ${CartLink_xpath} = //a[@id="shoppingCartLink"]
 */
public class CartPage {

    private final WebDriver driver;
    private final WebDriverWait wait;

    // Robot: ${CartLink_xpath}
    private final By cartLink = By.xpath("//a[@id='shoppingCartLink']");

    public CartPage(WebDriver driver) {
        this.driver = driver;
        this.wait = new WebDriverWait(driver, Duration.ofSeconds(20));
    }

    /**
     * Robot:
     *   Wait Until Element Is Visible  ${CartLink_xpath}  10s
     *   ${cart_badge}= Get Text        ${CartLink_xpath}
     *   Should Not Be Equal            ${cart_badge}  0
     *   Click Element                  ${CartLink_xpath}
     *   Wait Until Page Contains       ${product_name_token}  20s  (if token given)
     */
    public void verifyProductAddedToCart(String productNameToken) {
        // Wait for badge to be non-empty and non-zero
        wait.until(d -> {
            String text = d.findElement(cartLink).getText().trim();
            return !text.isEmpty() && !text.equals("0");
        });

        // Click cart link (opens panel or navigates to cart)
        driver.findElement(cartLink).click();

        // Robot: Wait Until Page Contains ${product_name_token}
        // Equivalent: wait until page source contains the token
        if (productNameToken != null && !productNameToken.isBlank()) {
            wait.until(d -> d.getPageSource().contains(productNameToken));
        }
    }

    /**
     * Robot:
     *   Page Should Contain  ${quantity}
     */
    public void verifyCartQuantity(int quantity) {
        Assertions.assertTrue(
            driver.getPageSource().contains(String.valueOf(quantity)),
            "Expected quantity " + quantity + " not found on cart page"
        );
    }
}
