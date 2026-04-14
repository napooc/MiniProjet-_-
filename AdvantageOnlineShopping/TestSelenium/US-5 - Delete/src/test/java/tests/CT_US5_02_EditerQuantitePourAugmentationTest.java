package tests;

import io.github.bonigarcia.wdm.WebDriverManager;
import java.io.IOException;
import java.io.InputStream;
import java.math.BigDecimal;
import java.util.Properties;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.chrome.ChromeDriver;
import org.openqa.selenium.chrome.ChromeOptions;
import org.testng.Assert;
import org.testng.annotations.AfterMethod;
import org.testng.annotations.BeforeMethod;
import org.testng.annotations.Test;
import pages.HomePage;
import pages.ProductPage;
import pages.ShoppingCartPage;

public class CT_US5_02_EditerQuantitePourAugmentationTest {

    private WebDriver driver;
    private Properties config;

    @BeforeMethod
    public void setUp() throws IOException {
        config = loadConfig();

        WebDriverManager.chromedriver().setup();
        ChromeOptions options = new ChromeOptions();
        options.addArguments("--remote-allow-origins=*");
        options.addArguments("--disable-dev-shm-usage");
        options.addArguments("--no-sandbox");
        options.addArguments("--disable-gpu");
        options.addArguments("--start-maximized");

        String browser = config.getProperty("browser", "chrome").trim().toLowerCase();
        if ("headless-chrome".equals(browser) || "chrome-headless".equals(browser) || "headless".equals(browser)) {
            options.addArguments("--headless=new");
            options.addArguments("--window-size=1920,1080");
        }

        driver = new ChromeDriver(options);
    }

    @AfterMethod(alwaysRun = true)
    public void tearDown() {
        if (driver != null) {
            driver.quit();
        }
    }

    @Test(description = "CT_US5_02 - Augmenter le nombre d'items via edition manuelle de la quantite")
    public void shouldIncreaseQuantityAndRecalculateTotalsFromManualEdit() {
        String baseUrl = config.getProperty("base.url");
        String configuredProductName = config.getProperty("product.name", "").trim();
        int increment = Integer.parseInt(config.getProperty("quantity.increment", "1"));

        HomePage homePage = new HomePage(driver);
        ProductPage productPage = new ProductPage(driver);
        ShoppingCartPage shoppingCartPage = new ShoppingCartPage(driver);

        homePage.open(baseUrl);
        homePage.waitForPageLoad();
        homePage.goToShoppingCart();

        if (shoppingCartPage.isCartEmpty()) {
            homePage.open(baseUrl);
            homePage.waitForPageLoad();
            homePage.openLaptopsCategory();
            homePage.openDefaultLaptopProduct();
            productPage.setQuantityIfVisible(1);
            productPage.addToCart();
            homePage.goToShoppingCart();
        }

        Assert.assertFalse(shoppingCartPage.isCartEmpty(),
                "Precondition non respectee: le panier doit contenir au moins un produit.");

        String targetProductName = configuredProductName;
        if (targetProductName.isEmpty() || !shoppingCartPage.hasProduct(targetProductName)) {
            targetProductName = shoppingCartPage.getFirstProductName();
        }

        int currentQuantity = shoppingCartPage.getDisplayedQuantity(targetProductName);
        int newQuantity = currentQuantity + increment;

        BigDecimal unitPrice = shoppingCartPage.getUnitPrice(targetProductName);
        BigDecimal cartTotalBefore = shoppingCartPage.getCartTotal();

        shoppingCartPage.editProductQuantity(targetProductName, newQuantity);
        homePage.goToShoppingCart();

        int updatedQuantity = shoppingCartPage.getDisplayedQuantity(targetProductName);
        BigDecimal expectedLineTotal = unitPrice.multiply(BigDecimal.valueOf(newQuantity));
        BigDecimal actualLineTotal = shoppingCartPage.getLineTotal(targetProductName);
        BigDecimal cartTotalAfter = shoppingCartPage.getCartTotal();

        Assert.assertEquals(updatedQuantity, newQuantity,
                "La quantite doit etre mise a jour avec la nouvelle valeur saisie.");
        Assert.assertEquals(actualLineTotal.stripTrailingZeros(), expectedLineTotal.stripTrailingZeros(),
                "Le total du produit doit etre recalcule selon la quantite mise a jour.");
        Assert.assertTrue(cartTotalAfter.compareTo(cartTotalBefore) > 0,
                "Le total general du panier doit augmenter apres augmentation de quantite.");
    }

    private Properties loadConfig() throws IOException {
        Properties properties = new Properties();
        try (InputStream input = getClass().getClassLoader().getResourceAsStream("config.properties")) {
            if (input == null) {
                throw new IllegalStateException("config.properties est introuvable dans src/test/resources");
            }
            properties.load(input);
        }
        return properties;
    }
}
