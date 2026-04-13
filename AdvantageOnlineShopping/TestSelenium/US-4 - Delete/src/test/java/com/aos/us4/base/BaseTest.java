package com.aos.us4.base;

import com.aos.us4.utils.ChatKiller;
import com.aos.us4.utils.ConfigReader;
import com.aos.us4.utils.DriverFactory;
import com.aos.us4.utils.ScreenshotHelper;
import com.aventstack.extentreports.ExtentReports;
import com.aventstack.extentreports.ExtentTest;
import com.aventstack.extentreports.Status;
import com.aventstack.extentreports.reporter.ExtentSparkReporter;
import org.openqa.selenium.WebDriver;
import org.testng.ITestResult;
import org.testng.annotations.AfterMethod;
import org.testng.annotations.AfterSuite;
import org.testng.annotations.BeforeMethod;
import org.testng.annotations.BeforeSuite;

import java.io.File;

public class BaseTest {

    protected WebDriver driver;
    protected ExtentTest extentTest;
    private static ExtentReports extentReports;

    @BeforeSuite
    public void setUpSuite() {
        String reportPath = ConfigReader.get("report.path");
        new File(reportPath).mkdirs();

        ExtentSparkReporter spark = new ExtentSparkReporter(reportPath + "/" + ConfigReader.get("report.name"));
        spark.config().setDocumentTitle("Test Report - US4 Delete Product");
        spark.config().setReportName("US4 - Delete Product from Cart");

        extentReports = new ExtentReports();
        extentReports.attachReporter(spark);
        extentReports.setSystemInfo("Application", "Advantage Online Shopping");
        extentReports.setSystemInfo("User Story", "US-4: Delete product from cart");
        extentReports.setSystemInfo("Browser", ConfigReader.get("browser").toUpperCase());
        extentReports.setSystemInfo("Environment", "Test");
    }

    @BeforeMethod
    public void setUp(ITestResult result) {
        DriverFactory.initDriver();
        driver = DriverFactory.getDriver();
        driver.navigate().to(ConfigReader.get("base.url"));
        try { Thread.sleep(2000); } catch (InterruptedException ignored) {}
        ChatKiller.kill(driver);
        ensureOnMainSite();
        String testName = result.getMethod().getMethodName();
        String testDesc = result.getMethod().getDescription();
        extentTest = extentReports.createTest(testName, testDesc != null ? testDesc : testName);
    }

    @AfterMethod
    public void tearDown(ITestResult result) {
        if (result.getStatus() == ITestResult.FAILURE) {
            String screenshot = ScreenshotHelper.captureScreenshotAsBase64(driver);
            if (screenshot != null && extentTest != null) {
                extentTest.fail("Test failed").addScreenCaptureFromBase64String(screenshot);
            }
            if (result.getThrowable() != null && extentTest != null) {
                extentTest.fail(result.getThrowable());
            }
        } else if (result.getStatus() == ITestResult.SUCCESS && extentTest != null) {
            extentTest.pass("Test passed");
        } else if (result.getStatus() == ITestResult.SKIP && extentTest != null) {
            extentTest.skip("Test skipped");
        }
        DriverFactory.quitDriver();
    }

    @AfterSuite
    public void tearDownSuite() {
        if (extentReports != null) {
            extentReports.flush();
        }
    }

    protected void ensureOnMainSite() {
        String url = driver.getCurrentUrl();
        if (url != null && url.contains("chat.html")) {
            driver.navigate().to(ConfigReader.get("base.url"));
            try { Thread.sleep(2000); } catch (InterruptedException ignored) {}
            ChatKiller.kill(driver);
        }
    }

    protected void logStep(String description) {
        if (extentTest != null) extentTest.log(Status.INFO, description);
    }

    protected void logPass(String description) {
        if (extentTest != null) extentTest.pass(description);
    }

    protected void logFail(String description) {
        if (extentTest != null) extentTest.fail(description);
    }
}
