package example.us3add;

import io.github.bonigarcia.wdm.WebDriverManager;
import java.time.Duration;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.chrome.ChromeDriver;
import org.openqa.selenium.chrome.ChromeOptions;

/**
 * Robot equivalent: config/setup_teardown.resource
 * - Open Application  → setUp()
 * - Close Application → tearDown()
 */
public abstract class BaseTest {

    protected WebDriver driver;

    // Robot: ${URL}
    protected static final String BASE_URL = "http://advantageonlineshopping.com/#/";

    // Robot: ${QTE_MAX}
    protected static final int QTE_MAX = 10;

    @BeforeEach
    void setUp() {
        WebDriverManager.chromedriver().setup();
        ChromeOptions options = new ChromeOptions();
        options.addArguments("--start-maximized");
        driver = new ChromeDriver(options);
        driver.manage().timeouts().implicitlyWait(Duration.ZERO);
        driver.get(BASE_URL);
    }

    @AfterEach
    void tearDown() {
        if (driver != null) {
            driver.quit();
        }
    }
}
