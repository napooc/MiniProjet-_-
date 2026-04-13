package tests.authentication;

import automation.AppTest;
import org.openqa.selenium.By;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.ui.ExpectedConditions;
import org.testng.Assert;
import org.testng.annotations.Test;

public class SignInTest extends AppTest {

    /*
     * Automation ID = CT_US2_01
     * Correspond au Test Case qTest :
     * CT_US2_01 – Connexion avec identifiants valides
     */

    @Test(testName = "CT_US2_01")
    public void CT_US2_01_Connexion_Identifiants_Valides() {

        // 1. Cliquer sur l'icône User (driver, wait et navigation déjà initialisés par AppTest)
        openUserMenu();

        // 2. Saisir le username (créé par SignUpTest)
        wait.until(ExpectedConditions.visibilityOfElementLocated(By.name("username"))).sendKeys(TEST_USERNAME);

        // 3. Saisir le mot de passe
        wait.until(ExpectedConditions.visibilityOfElementLocated(By.name("password"))).sendKeys(TEST_PASSWORD);

        // 4. Attendre la disparition du loader puis cliquer sur Sign In via JS
        waitForLoaderToDisappear();
        WebElement signInBtn = wait.until(ExpectedConditions.presenceOfElementLocated(By.id("sign_in_btn")));
        jsClick(signInBtn);

        // 5. Attendre que la connexion soit effectuée (disparition du panneau login)
        wait.until(ExpectedConditions.invisibilityOfElementLocated(By.name("username")));

        // 6. Assertions
        Assert.assertTrue(
            driver.getCurrentUrl().contains("advantageonlineshopping.com"),
            "La redirection vers la page Home a échoué"
        );
        Assert.assertTrue(
            driver.getPageSource().toLowerCase().contains(TEST_USERNAME.toLowerCase()),
            "La connexion a échoué : le nom d'utilisateur n'est pas affiché"
        );
    }
}
