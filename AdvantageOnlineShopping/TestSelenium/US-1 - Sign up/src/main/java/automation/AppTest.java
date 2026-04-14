package automation;

import java.time.Duration;
import org.openqa.selenium.By;
import org.openqa.selenium.JavascriptExecutor;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.chrome.ChromeDriver;
import org.openqa.selenium.support.ui.ExpectedConditions;
import org.openqa.selenium.support.ui.WebDriverWait;
import org.testng.annotations.AfterMethod;
import org.testng.annotations.BeforeMethod;

public class AppTest {
   protected WebDriver driver;
   protected WebDriverWait wait;
   protected static final String BASE_URL = "https://www.advantageonlineshopping.com";

   public AppTest() {
   }

   @BeforeMethod
   public void setUp() {
      this.driver = new ChromeDriver();
      this.driver.manage().window().maximize();
      this.wait = new WebDriverWait(this.driver, Duration.ofSeconds(15L));
      this.driver.get("https://www.advantageonlineshopping.com");
   }

   @AfterMethod
   public void tearDown() {
      if (this.driver != null) {
         this.driver.quit();
      }

   }

   protected void jsClick(WebElement element) {
      ((JavascriptExecutor)this.driver).executeScript("arguments[0].click();", new Object[]{element});
   }

   protected void waitForLoaderToDisappear() {
      this.wait.until(ExpectedConditions.invisibilityOfElementLocated(By.cssSelector("div.loader")));
   }

   protected void openUserMenu() {
      ((WebElement)this.wait.until(ExpectedConditions.elementToBeClickable(By.id("menuUser")))).click();
   }
}
