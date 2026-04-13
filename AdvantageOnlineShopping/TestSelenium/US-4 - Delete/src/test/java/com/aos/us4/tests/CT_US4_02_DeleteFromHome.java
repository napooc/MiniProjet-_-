package com.aos.us4.tests;

import com.aos.us4.base.BaseTest;
import com.aos.us4.pages.HomePage;
import com.aos.us4.pages.ProductPage;
import org.testng.Assert;
import org.testng.annotations.BeforeMethod;
import org.testng.annotations.Test;

public class CT_US4_02_DeleteFromHome extends BaseTest {

    private HomePage homePage;
    private ProductPage productPage;

    @BeforeMethod(alwaysRun = true)
    public void setUpPrecondition() {
        homePage    = new HomePage(driver);
        productPage = new ProductPage(driver);

        logStep("Setup: adding product to cart");
        homePage.clickOnSpeakersCategory();
        productPage.clickFirstProduct();
        productPage.clickAddToCart();
        logStep("Setup complete");
    }

    @Test(
        description = "CT_US4_02 - Delete product from floating mini-cart and verify cart is updated",
        groups = { "US4", "CT_US4_02", "regression", "cart", "home" },
        timeOut = 120000,
        priority = 2
    )
    public void CT_US4_02_SuppresionProduitPanierHome() {
        logStep("Step 1: Hover cart icon to open mini-cart");
        homePage.hoverCartIcon();

        int initialProductCount = homePage.getFloatingCartProductCount();
        logStep("Initial product count in mini-cart: " + initialProductCount);

        Assert.assertTrue(initialProductCount > 0,
                "Precondition failed: mini-cart should contain at least 1 product");
        logPass("Mini-cart opened with " + initialProductCount + " product(s)");

        logStep("Step 2: Click X button to remove product");
        homePage.clickRemoveFirstProductFromFloatingCart();

        int currentProductCount = homePage.getFloatingCartProductCount();

        Assert.assertEquals(currentProductCount, initialProductCount - 1,
                "Product count should decrease by 1. Expected: "
                + (initialProductCount - 1) + ", Actual: " + currentProductCount);
        logPass("Product count: " + initialProductCount + " -> " + currentProductCount);

        logStep("CT_US4_02 complete - all verifications passed");
    }
}
