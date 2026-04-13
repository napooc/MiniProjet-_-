package com.aos.us4.tests;

import com.aos.us4.base.BaseTest;
import com.aos.us4.data.TestData;
import com.aos.us4.pages.CartPage;
import com.aos.us4.pages.HomePage;
import com.aos.us4.pages.ProductPage;
import org.testng.Assert;
import org.testng.annotations.BeforeMethod;
import org.testng.annotations.Test;

public class CT_US4_01_DeleteFromCartPage extends BaseTest {

    private HomePage homePage;
    private ProductPage productPage;
    private CartPage cartPage;

    @BeforeMethod(alwaysRun = true)
    public void setUpPrecondition() {
        homePage    = new HomePage(driver);
        productPage = new ProductPage(driver);
        cartPage    = new CartPage(driver);

        logStep("Setup: adding product to cart");
        homePage.clickOnSpeakersCategory();
        productPage.clickFirstProduct();
        productPage.clickAddToCart();
        logStep("Setup complete");
    }

    @Test(
        description = "CT_US4_01 - Delete product from Shopping Cart page and verify cart is updated",
        groups = { "US4", "CT_US4_01", "regression", "cart" },
        timeOut = 120000,
        priority = 1
    )
    public void CT_US4_01_SuppresionProduitPanier() {
        logStep("Step 1: Navigate to Shopping Cart");
        homePage.clickCartIcon();
        cartPage.waitForCartPageToLoad();

        int initialProductCount   = cartPage.getCartProductCount();
        int initialBadgeCount     = cartPage.getHeaderCartBadgeCount();
        int initialCountFromTitle = cartPage.getArticleCountFromTitle();
        String initialTotal       = cartPage.getCartTotalPrice();

        logStep("Initial state - products: " + initialProductCount
                + ", badge: " + initialBadgeCount + ", total: " + initialTotal);

        Assert.assertTrue(initialProductCount > 0,
                "Precondition failed: cart should contain at least 1 product");

        logStep("Step 2: Click Remove button");
        cartPage.clickRemoveFirstProduct();

        int currentProductCount   = cartPage.getCartProductCount();
        int currentBadgeCount     = cartPage.getHeaderCartBadgeCount();
        int currentCountFromTitle = cartPage.getArticleCountFromTitle();
        String currentTotal       = cartPage.getCartTotalPrice();

        Assert.assertEquals(currentProductCount, initialProductCount - 1,
                "Product count should decrease by 1. Expected: "
                + (initialProductCount - 1) + ", Actual: " + currentProductCount);
        logPass("Product count: " + initialProductCount + " -> " + currentProductCount);

        Assert.assertEquals(currentBadgeCount, initialBadgeCount - 1,
                "Badge count should decrease by 1. Expected: "
                + (initialBadgeCount - 1) + ", Actual: " + currentBadgeCount);
        logPass("Badge count: " + initialBadgeCount + " -> " + currentBadgeCount);

        Assert.assertEquals(currentCountFromTitle, initialCountFromTitle - 1,
                "Title count should decrease by 1. Expected: "
                + (initialCountFromTitle - 1) + ", Actual: " + currentCountFromTitle);
        logPass("Count from title: " + initialCountFromTitle + " -> " + currentCountFromTitle);

        if (initialProductCount == 1) {
            Assert.assertEquals(currentTotal, TestData.EXPECTED_TOTAL_AFTER_DELETE,
                    "Total should be $0.00 after removing last product");
            Assert.assertEquals(currentProductCount, 0, "Cart should be empty");
        } else {
            Assert.assertNotEquals(currentTotal, initialTotal,
                    "Total should change after removal");
        }
        logPass("Total: " + initialTotal + " -> " + currentTotal);

        String checkoutText = cartPage.getCheckoutButtonText();
        Assert.assertTrue(
                checkoutText.contains(currentTotal)
                || currentTotal.equals(TestData.EXPECTED_TOTAL_AFTER_DELETE),
                "Checkout button total mismatch. Button: '"
                + checkoutText + "', Total: '" + currentTotal + "'");
        logPass("Checkout button: " + checkoutText);

        logStep("CT_US4_01 complete - all verifications passed");
    }
}
