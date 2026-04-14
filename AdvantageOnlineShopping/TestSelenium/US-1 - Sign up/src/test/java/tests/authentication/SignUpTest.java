package tests.authentication;

import automation.AppTest;
import org.openqa.selenium.By;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.ui.ExpectedConditions;
import org.testng.Assert;
import org.testng.annotations.Test;

public class SignUpTest extends AppTest {
   public SignUpTest() {
   }

   @Test(testName = "CT_US1_01")
   public void CT_US1_01_Inscription_Informations_Valides() {
      this.openUserMenu();
      ((WebElement)this.wait.until(ExpectedConditions.elementToBeClickable(By.className("create-new-account")))).click();
      ((WebElement)this.wait.until(ExpectedConditions.visibilityOfElementLocated(By.name("usernameRegisterPage")))).sendKeys("qa_auto_user");
      this.driver.findElement(By.name("emailRegisterPage")).sendKeys("qa_auto_user@test.com");
      this.driver.findElement(By.name("passwordRegisterPage")).sendKeys("Test@1234");
      this.driver.findElement(By.name("confirm_passwordRegisterPage")).sendKeys("Test@1234");
      this.driver.findElement(By.name("first_nameRegisterPage")).sendKeys("Test");
      this.driver.findElement(By.name("last_nameRegisterPage")).sendKeys("User");
      this.driver.findElement(By.name("phone_numberRegisterPage")).sendKeys("0600000000");
      this.jsClick(this.driver.findElement(By.name("i_agree")));
      this.waitForLoaderToDisappear();
      WebElement registerBtn = (WebElement)this.wait.until(ExpectedConditions.presenceOfElementLocated(By.id("register_btn")));
      this.jsClick(registerBtn);
      this.wait.until(ExpectedConditions.urlContains("advantageonlineshopping.com"));
      Assert.assertTrue(this.driver.getCurrentUrl().contains("advantageonlineshopping.com"), "La redirection vers la page Home après inscription a échoué");
      Assert.assertFalse(this.driver.getPageSource().contains("username already exist"), "L'inscription a échoué : le nom d'utilisateur existe déjà");
   }
}

