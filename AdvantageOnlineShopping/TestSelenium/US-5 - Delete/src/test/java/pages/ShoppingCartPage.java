package pages;

import java.math.BigDecimal;
import java.text.NumberFormat;
import java.text.ParseException;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;
import java.util.Locale;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import org.openqa.selenium.JavascriptExecutor;
import org.openqa.selenium.By;
import org.openqa.selenium.Keys;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import utils.WaitUtils;

public class ShoppingCartPage {

    private final WebDriver driver;

    private final By productRows = By.xpath("//tr[@id='product']");
    private final By cartLink = By.id("shoppingCartLink");
    private final By productLinks = By.xpath("//a[contains(@class,'productName') or contains(@href,'product')] | //td//a");
    private final By quantityInput = By.cssSelector("input[name='quantity']");
    private final By editButton = By.xpath(".//a[contains(@href,'#/product/') and contains(@href,'pageState=edit')]");
    private final By addToCartButton = By.xpath("//button[@name='save_to_cart']");
    private final By moneyInRow = By.xpath(".//p[contains(@class,'price') and contains(normalize-space(),'$')]");
    private final By quantityLabelInRow = By.xpath(".//label[contains(translate(normalize-space(), 'abcdefghijklmnopqrstuvwxyz', 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'),'QTY') or contains(translate(normalize-space(), 'abcdefghijklmnopqrstuvwxyz', 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'),'QUANTITY')]");
    private final By cartTotalAmount = By.cssSelector("span.cart-total.ng-binding");
    private final By totalByLabel = By.xpath("//*[contains(translate(normalize-space(), 'abcdefghijklmnopqrstuvwxyz', 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'),'TOTAL')]/following::*[contains(normalize-space(),'$')][1]");

    private static final Pattern INTEGER_PATTERN = Pattern.compile("\\d+");
    private static final Pattern MONEY_PATTERN = Pattern.compile("\\d+(?:[.,]\\d{2})?");

    public ShoppingCartPage(WebDriver driver) {
        this.driver = driver;
    }

    public boolean isCartEmpty() {
        return getCartBadgeCount() == 0;
    }

    public int getCartBadgeCount() {
        String badgeText = WaitUtils.waitForVisible(driver, cartLink).getText().trim();
        Matcher matcher = INTEGER_PATTERN.matcher(badgeText);
        if (matcher.find()) {
            return Integer.parseInt(matcher.group());
        }
        return 0;
    }

    public void editProductQuantity(String productName, int newQuantity) {
        findProductRowByName(productName);
        WaitUtils.waitForVisible(driver, By.xpath("//tr[@id='product']"));

        List<WebElement> editLinks = driver.findElements(By.xpath("//a[contains(@href,'#/product/') and contains(@href,'pageState=edit') and contains(translate(normalize-space(), 'abcdefghijklmnopqrstuvwxyz', 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'),'EDIT')]"));
        WebElement visibleEditLink = null;
        for (WebElement link : editLinks) {
            if (link.isDisplayed() && link.getSize().getHeight() > 0 && link.getSize().getWidth() > 0) {
                visibleEditLink = link;
                break;
            }
        }

        if (visibleEditLink == null) {
            throw new IllegalStateException("Aucun bouton EDIT visible n'a ete trouve dans le panier.");
        }

        ((JavascriptExecutor) driver).executeScript("arguments[0].click();", visibleEditLink);

        WebElement qtyInput = WaitUtils.waitForVisible(driver, quantityInput);
        qtyInput.click();
        qtyInput.sendKeys(Keys.chord(Keys.CONTROL, "a"));
        qtyInput.sendKeys(Keys.BACK_SPACE);
        qtyInput.sendKeys(String.valueOf(newQuantity));

        WaitUtils.waitForClickable(driver, addToCartButton).click();
    }

    public boolean hasProduct(String productName) {
        By productLink = By.xpath("//a[contains(normalize-space(), " + toXpathLiteral(productName) + ")]");
        return !driver.findElements(productLink).isEmpty();
    }

    public String getFirstProductName() {
        WebElement productRow = driver.findElement(By.xpath("//tr[@id='product']"));
        WebElement nameElement = productRow.findElement(By.xpath(".//h3"));
        String name = nameElement.getText().trim();
        if (!name.isEmpty()) {
            return name;
        }
        throw new IllegalStateException("Aucun nom de produit detecte dans le panier.");
    }

    public int getDisplayedQuantity(String productName) {
        WebElement row = findProductRowByName(productName);
        List<WebElement> quantityInputs = row.findElements(quantityInput);
        if (!quantityInputs.isEmpty()) {
            String quantity = quantityInputs.get(0).getAttribute("value");
            return Integer.parseInt(quantity.trim());
        }

        List<WebElement> labels = row.findElements(quantityLabelInRow);
        if (!labels.isEmpty()) {
            Matcher matcher = INTEGER_PATTERN.matcher(labels.get(0).getText());
            if (matcher.find()) {
                return Integer.parseInt(matcher.group());
            }
        }

        Matcher matcher = INTEGER_PATTERN.matcher(row.getText());
        if (matcher.find()) {
            return Integer.parseInt(matcher.group());
        }

        throw new IllegalStateException("Impossible de lire la quantite pour le produit: " + productName);
    }

    public BigDecimal getUnitPrice(String productName) {
        List<BigDecimal> amounts = getAmountsInProductRow(productName);
        if (amounts.size() == 1) {
            int qty = getDisplayedQuantity(productName);
            if (qty > 0) {
                return amounts.get(0).divide(BigDecimal.valueOf(qty), 2, java.math.RoundingMode.HALF_UP);
            }
        }

        return amounts.stream()
                .min(Comparator.naturalOrder())
                .orElseThrow(() -> new IllegalStateException("Prix unitaire introuvable pour: " + productName));
    }

    public BigDecimal getLineTotal(String productName) {
        List<BigDecimal> amounts = getAmountsInProductRow(productName);
        return amounts.stream()
                .max(Comparator.naturalOrder())
                .orElseThrow(() -> new IllegalStateException("Total ligne introuvable pour: " + productName));
    }

    public BigDecimal getCartTotal() {
        List<WebElement> cartTotals = driver.findElements(cartTotalAmount);
        if (!cartTotals.isEmpty()) {
            return parseMoney(cartTotals.get(0).getText());
        }

        List<WebElement> totalCandidates = driver.findElements(totalByLabel);
        if (!totalCandidates.isEmpty()) {
            return parseMoney(totalCandidates.get(0).getText());
        }

        List<BigDecimal> allRowTotals = new ArrayList<>();
        for (WebElement row : driver.findElements(productRows)) {
            List<WebElement> moneyElements = row.findElements(moneyInRow);
            for (WebElement money : moneyElements) {
                allRowTotals.add(parseMoney(money.getText()));
            }
        }

        return allRowTotals.stream()
                .max(Comparator.naturalOrder())
                .orElseThrow(() -> new IllegalStateException("Total panier introuvable"));
    }

    private WebElement findProductRowByName(String productName) {
        By productRowByName = By.xpath("//tr[@id='product']");
        WebElement row = WaitUtils.waitForVisible(driver, productRowByName);
        String rowName = row.findElement(By.xpath(".//h3")).getText().trim().toUpperCase(Locale.ROOT);
        String searchName = productName.trim().toUpperCase(Locale.ROOT);
        String[] rowNameParts = rowName.split("\\s+");
        String firstWord = rowNameParts.length > 0 ? rowNameParts[0] : "";
        if (rowName.contains(searchName) || (!firstWord.isEmpty() && searchName.contains(firstWord))) {
            return row;
        }
        throw new IllegalStateException("Produit '" + productName + "' non trouve dans le panier. Trouve: " + rowName);
    }

    private List<BigDecimal> getAmountsInProductRow(String productName) {
        WebElement row = findProductRowByName(productName);
        List<BigDecimal> amounts = new ArrayList<>();

        List<WebElement> moneyElements = row.findElements(moneyInRow);
        for (WebElement element : moneyElements) {
            amounts.add(parseMoney(element.getText()));
        }

        if (amounts.isEmpty()) {
            Matcher matcher = MONEY_PATTERN.matcher(row.getText());
            while (matcher.find()) {
                amounts.add(parseMoney(matcher.group()));
            }
        }

        if (amounts.isEmpty()) {
            throw new IllegalStateException("Aucun montant detecte pour le produit: " + productName);
        }

        return amounts;
    }

    private BigDecimal parseMoney(String value) {
        String cleanValue = value.replaceAll("[^0-9,.-]", "").trim();

        try {
            Number number = NumberFormat.getNumberInstance(Locale.US).parse(cleanValue.replace(",", ""));
            return BigDecimal.valueOf(number.doubleValue());
        } catch (ParseException e) {
            throw new IllegalArgumentException("Unable to parse monetary value: " + value, e);
        }
    }

    private String toXpathLiteral(String value) {
        if (!value.contains("'")) {
            return "'" + value + "'";
        }
        if (!value.contains("\"")) {
            return "\"" + value + "\"";
        }

        StringBuilder xpath = new StringBuilder("concat(");
        String[] parts = value.split("'");
        for (int i = 0; i < parts.length; i++) {
            if (i > 0) {
                xpath.append(", \"'\", ");
            }
            xpath.append("'").append(parts[i]).append("'");
        }
        xpath.append(")");
        return xpath.toString();
    }
}
