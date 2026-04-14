package example.us3add;

import example.us3add.pages.CartPage;
import example.us3add.pages.HomePage;
import example.us3add.pages.ProductPage;
import org.junit.jupiter.api.Test;

/**
 * Robot equivalent: suites/test_us3_add_to_cart.robot
 *
 * Variables (from resources/variables.resource):
 *   ${COLOR_BLACK}        = BLACK
 *   ${PRODUCT_01_ASSERT}  = HP Pro Tablet
 *   ${PRODUCT_06_ASSERT}  = HP Pavilion
 *   ${QTE_MAX}            = 10
 */
public class US3AddToCartTest extends BaseTest {

    private static final String COLOR_BLACK      = "BLACK";
    private static final String PRODUCT_01_ASSERT = "HP Pro Tablet";
    private static final String PRODUCT_06_ASSERT = "HP Pavilion";

    /**
     * Robot: CT_US3_01_Add_Product_With_Quantity_Max_Allowed
     *   Open Category Tablets
     *   Select Product Tablet
     *   Select Color         ${COLOR_BLACK}
     *   Enter Quantity       ${QTE_MAX}
     *   Add Product To Cart
     *   Verify Product Added To Cart
     *   Verify Cart Quantity ${QTE_MAX}
     */
    @Test
    void ct_us3_01_add_product_with_quantity_max_allowed() {
        HomePage homePage       = new HomePage(driver);
        ProductPage productPage = new ProductPage(driver);
        CartPage cartPage       = new CartPage(driver);

        homePage.openCategoryTablets();
        homePage.selectProductTablet();
        productPage.selectColor(COLOR_BLACK);
        productPage.enterQuantity(QTE_MAX);
        productPage.addProductToCart();
        cartPage.verifyProductAddedToCart(null); // Robot: Verify Product Added To Cart (no token)
        cartPage.verifyCartQuantity(QTE_MAX);
    }

    /**
     * Robot: CT_US3_06_Add_Product_To_Cart_Without_Login
     *   Open Category Laptops
     *   Select Product Laptop
     *   Enter Quantity If Visible  ${QTE_MAX}
     *   Add Product To Cart
     *   Verify Product Added To Cart
     */
    @Test
    void ct_us3_06_add_product_to_cart_without_login() {
        HomePage homePage       = new HomePage(driver);
        ProductPage productPage = new ProductPage(driver);
        CartPage cartPage       = new CartPage(driver);

        homePage.openCategoryLaptops();
        homePage.selectProductLaptop();
        productPage.enterQuantityIfVisible(QTE_MAX);
        productPage.addProductToCart();
        cartPage.verifyProductAddedToCart(PRODUCT_06_ASSERT);
    }
}
