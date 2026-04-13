package tests.authentication;

import automation.AppTest;
import org.openqa.selenium.By;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.ui.ExpectedConditions;
import org.testng.Assert;
import org.testng.annotations.Test;

public class SignUpTest extends AppTest {

    /*
     * Automation ID = CT_US1_01
     * Correspond au Test Case qTest :
     * CT_US1_01 – Inscription avec informations valides
     */

    @Test(testName = "CT_US1_01")
    public void CT_US1_01_Inscription_Informations_Valides() {

        // 1. Cliquer sur l'icône User (driver, wait et navigation déjà initialisés par AppTest)
        openUserMenu();

        // 2. Cliquer sur le lien "Create new account"
        wait.until(ExpectedConditions.elementToBeClickable(By.className("create-new-account"))).click();

        // 3. Remplir le formulaire d'inscription avec les identifiants partagés
        wait.until(ExpectedConditions.visibilityOfElementLocated(By.name("usernameRegisterPage"))).sendKeys(TEST_USERNAME);
        driver.findElement(By.name("emailRegisterPage")).sendKeys(TEST_USERNAME + "@test.com");
        driver.findElement(By.name("passwordRegisterPage")).sendKeys(TEST_PASSWORD);
        driver.findElement(By.name("confirm_passwordRegisterPage")).sendKeys(TEST_PASSWORD);
        driver.findElement(By.name("first_nameRegisterPage")).sendKeys("Test");
        driver.findElement(By.name("last_nameRegisterPage")).sendKeys("User");
        driver.findElement(By.name("phone_numberRegisterPage")).sendKeys("0600000000");

        // 4. Cocher la case "I agree"
        jsClick(driver.findElement(By.name("i_agree")));

        // 5. Attendre la disparition du loader puis cliquer sur Register
        waitForLoaderToDisappear();
        WebElement registerBtn = wait.until(ExpectedConditions.presenceOfElementLocated(By.id("register_btn")));
        jsClick(registerBtn);

        // 6. Vérifier la redirection vers la page Home après inscription
        wait.until(ExpectedConditions.urlContains("advantageonlineshopping.com"));

        // 7. Assertions
        Assert.assertTrue(
            driver.getCurrentUrl().contains("advantageonlineshopping.com"),
            "La redirection vers la page Home après inscription a échoué"
        );
        Assert.assertFalse(
            driver.getPageSource().contains("username already exist"),
            "L'inscription a échoué : le nom d'utilisateur existe déjà"
        );
    }
}
