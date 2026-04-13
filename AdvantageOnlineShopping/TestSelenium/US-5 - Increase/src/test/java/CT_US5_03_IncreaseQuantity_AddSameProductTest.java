import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertTrue;

import java.time.Duration;
import java.util.List;

import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.openqa.selenium.Alert;
import org.openqa.selenium.By;
import org.openqa.selenium.JavascriptExecutor;
import org.openqa.selenium.TimeoutException;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.chrome.ChromeDriver;
import org.openqa.selenium.chrome.ChromeOptions;
import org.openqa.selenium.interactions.Actions;
import org.openqa.selenium.support.ui.ExpectedConditions;
import org.openqa.selenium.support.ui.WebDriverWait;

class CT_US5_03_IncreaseQuantity_AddSameProductTest {

    private static final String BASE_URL = "https://advantageonlineshopping.com/#/";
    private static final int EXTRA_QTY = 3;
    private static final int MAX_QTY = 10;
    private static final int TIMEOUT_SECONDS = 15;

    private WebDriver driver;
    private WebDriverWait wait;

    @BeforeEach
    void setUp() {
        ChromeOptions options = new ChromeOptions();
        driver = new ChromeDriver(options);
        driver.manage().window().maximize();
        driver.manage().deleteAllCookies();
        wait = new WebDriverWait(driver, Duration.ofSeconds(TIMEOUT_SECONDS));
        driver.get(BASE_URL);
        waitVisible(By.id("menuUser"));
    }

    @AfterEach
    void tearDown() {
        if (driver != null) {
            driver.quit();
        }
    }

    private WebElement waitVisible(By locator) {
        return wait.until(ExpectedConditions.visibilityOfElementLocated(locator));
    }

    private void scrollAndClick(WebElement element) {
        JavascriptExecutor js = (JavascriptExecutor) driver;
        js.executeScript("arguments[0].scrollIntoView({block:'center'});", element);
        try {
            element.click();
        } catch (Exception ex) {
            js.executeScript("arguments[0].click();", element);
        }
    }

    private void dismissAlertIfAny() {
        try {
            Alert alert = new WebDriverWait(driver, Duration.ofSeconds(5))
                .until(ExpectedConditions.alertIsPresent());
            alert.accept();
        } catch (TimeoutException ex) {
            // No alert displayed.
        }
    }

    private void goToCartPage() {
        WebElement cartLink = waitVisible(By.id("shoppingCartLink"));
        scrollAndClick(cartLink);
        new WebDriverWait(driver, Duration.ofSeconds(TIMEOUT_SECONDS))
            .until(d -> d.getCurrentUrl().contains("shoppingCart"));
    }

    private int getCartRowQuantity() {
        JavascriptExecutor js = (JavascriptExecutor) driver;
        WebDriverWait qtyWait = new WebDriverWait(driver, Duration.ofSeconds(TIMEOUT_SECONDS));
        Object value = qtyWait.until(d -> {
            Object result = js.executeScript(
                "var cells=document.querySelectorAll('td.quantityMobile:not(.ng-hide)');"
                    + "for(var i=0;i<cells.length;i++){"
                    + "  var nums=(cells[i].textContent||'').match(/[0-9]+/g);"
                    + "  if(nums){"
                    + "    var v=parseInt(nums[nums.length-1]);"
                    + "    if(v>0){return v;}"
                    + "  }"
                    + "}"
                    + "return 0;"
            );
            long qty = ((Number) result).longValue();
            return qty > 0 ? qty : null;
        });
        return ((Number) value).intValue();
    }

    private String getProductName() {
        try {
            return waitVisible(By.xpath("//h1")).getText().trim();
        } catch (Exception ex) {
            JavascriptExecutor js = (JavascriptExecutor) driver;
            Object text = js.executeScript(
                "var h=document.querySelector('h1');"
                    + "return h?(h.textContent||'').trim():'';"
            );
            return String.valueOf(text).trim();
        }
    }

    private void verifyNoDuplicates() {
        JavascriptExecutor js = (JavascriptExecutor) driver;
        Object hasDuplicates = js.executeScript(
            "var cells=document.querySelectorAll('td.name, td.cart-name, [ng-bind*=\"name\"], .product-name');"
                + "var names=[];"
                + "for(var i=0;i<cells.length;i++){"
                + "  names.push((cells[i].textContent||'').trim());"
                + "}"
                + "var seen={};"
                + "for(var j=0;j<names.length;j++){"
                + "  if(names[j]===''){continue;}"
                + "  if(seen[names[j]]){return true;}"
                + "  seen[names[j]]=true;"
                + "}"
                + "return false;"
        );
        assertFalse((Boolean) hasDuplicates, "Duplicate product rows detected in cart.");
    }

    private ProductContext addOneProductFromHome() {
        JavascriptExecutor js = (JavascriptExecutor) driver;
        js.executeScript("window.scrollTo(0, document.body.scrollHeight*0.65);");

        WebElement viewDetails = waitVisible(By.xpath(
            "(//a[contains(@href,'#/product/')][contains(.,'View Details')])[2]"
        ));
        scrollAndClick(viewDetails);

        waitVisible(By.xpath("//button[@name='save_to_cart']"));
        String productName = getProductName();
        String productUrl = driver.getCurrentUrl();

        WebElement addBtn = driver.findElement(By.xpath("//button[@name='save_to_cart']"));
        scrollAndClick(addBtn);
        dismissAlertIfAny();

        driver.get(BASE_URL);
        waitVisible(By.id("menuUser"));

        return new ProductContext(productName, productUrl);
    }

    private int getCartBadgeQty() {
        JavascriptExecutor js = (JavascriptExecutor) driver;
        Object qty = js.executeScript(
            "var badge=document.querySelector('.cart.ng-binding,.cart span,.ng-binding.cart');"
                + "if(badge){"
                + "  var m=(badge.textContent||'').match(/[0-9]+/);"
                + "  if(m){return parseInt(m[0]);}"
                + "}"
                + "var link=document.querySelector('#shoppingCartLink');"
                + "if(link){"
                + "  var m2=(link.textContent||'').match(/[0-9]+/);"
                + "  if(m2){return parseInt(m2[0]);}"
                + "}"
                + "return 0;"
        );
        return ((Number) qty).intValue();
    }

    @Test
    void test_CT_US5_03_increase_quantity_add_same_product() {
        waitVisible(By.id("shoppingCartLink"));
        waitVisible(By.xpath("(//a[contains(@href,'#/product/')][contains(.,'View Details')])[1]"));

        ProductContext context = addOneProductFromHome();

        goToCartPage();
        waitVisible(By.xpath("(//a[contains(@class,'remove') and contains(.,'REMOVE')])[1]"));
        int initialQty = getCartRowQuantity();
        verifyNoDuplicates();

        driver.get(context.productUrl());
        waitVisible(By.xpath("//button[@name='save_to_cart']"));
        String pageName = getProductName();
        assertEquals(context.productName().trim(), pageName.trim(), "Product name mismatch.");

        WebElement qtyInput = waitVisible(By.xpath(
            "//input[@name='quantity' or @id='quantity' or contains(@ng-model,'quantity')]"
        ));
        JavascriptExecutor js = (JavascriptExecutor) driver;
        js.executeScript(
            "var el=arguments[0];"
                + "var setter=Object.getOwnPropertyDescriptor(window.HTMLInputElement.prototype,'value').set;"
                + "setter.call(el, arguments[1]);"
                + "el.dispatchEvent(new Event('input',{bubbles:true}));"
                + "el.dispatchEvent(new Event('change',{bubbles:true}));",
            qtyInput,
            String.valueOf(EXTRA_QTY)
        );

        int displayed = Integer.parseInt(qtyInput.getAttribute("value"));
        assertEquals(EXTRA_QTY, displayed, "Quantity input value was not applied.");

        WebElement addBtn = driver.findElement(By.xpath("//button[@name='save_to_cart']"));
        scrollAndClick(addBtn);
        dismissAlertIfAny();
        waitVisible(By.id("shoppingCartLink"));

        int badgeQty = getCartBadgeQty();
        assertTrue(badgeQty >= 1, "Cart badge did not update after Add to Cart.");

        WebElement cartIcon = driver.findElement(By.id("shoppingCartLink"));
        new Actions(driver).moveToElement(cartIcon).perform();
        try {
            new WebDriverWait(driver, Duration.ofSeconds(8)).until(
                ExpectedConditions.visibilityOfElementLocated(By.xpath(
                    "((//div[contains(@class,'removeProduct')]) | "
                        + "(//a[contains(@class,'remove') and contains(.,'REMOVE')]))[1]"
                ))
            );
            verifyNoDuplicates();
        } catch (TimeoutException ignored) {
            // Floating cart is not always displayed on every run.
        }

        goToCartPage();
        waitVisible(By.xpath("(//a[contains(@class,'remove') and contains(.,'REMOVE')])[1]"));

        int expectedQty = Math.min(initialQty + EXTRA_QTY, MAX_QTY);
        int actualQty = getCartRowQuantity();
        assertEquals(expectedQty, actualQty, "Final cart quantity is incorrect.");

        List<WebElement> priceCells = driver.findElements(By.xpath("//table//td"));
        assertTrue(!priceCells.isEmpty(), "Cart price cells not found.");

        verifyNoDuplicates();

        Object emptyRows = js.executeScript(
            "var rows=document.querySelectorAll('tr');"
                + "var e=0;"
                + "for(var i=0;i<rows.length;i++){"
                + "  if((rows[i].textContent||'').trim()===''){e++;}"
                + "}"
                + "return e;"
        );
        assertEquals(0, ((Number) emptyRows).intValue(), "Empty rows detected in cart.");
    }

    private record ProductContext(String productName, String productUrl) {
    }
}
