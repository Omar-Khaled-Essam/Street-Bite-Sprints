package com.streetbite;

import io.appium.java_client.AppiumBy;
import org.openqa.selenium.WebElement;
import org.testng.Assert;
import org.testng.annotations.Test;

public class LoginTests extends BaseTest {

  private void openLogin() {
    try {
      driver.findElement(AppiumBy.accessibilityId("Continue")).click();
    } catch (Exception ignored) {
      // Already on login after splash.
    }
  }

  @Test
  public void validLogin() throws Exception {
    openLogin();
    driver.findElement(AppiumBy.xpath("//android.widget.EditText[1]")).sendKeys("tester@streetbite.app");
    driver.findElement(AppiumBy.xpath("//android.widget.EditText[2]")).sendKeys("123456");
    driver.findElement(AppiumBy.accessibilityId("Log in")).click();
    WebElement home = driver.findElement(AppiumBy.accessibilityId("Home"));
    Assert.assertTrue(home.isDisplayed());
    screenshot("login_valid_emulator");
  }

  @Test
  public void invalidCredentials() throws Exception {
    openLogin();
    driver.findElement(AppiumBy.xpath("//android.widget.EditText[1]")).sendKeys("wrong@streetbite.app");
    driver.findElement(AppiumBy.xpath("//android.widget.EditText[2]")).sendKeys("badpass");
    driver.findElement(AppiumBy.accessibilityId("Log in")).click();
    Assert.assertTrue(driver.getPageSource().contains("Incorrect")
        || driver.getPageSource().contains("invalid"));
    screenshot("login_invalid");
  }

  @Test
  public void emptyFields() throws Exception {
    openLogin();
    driver.findElement(AppiumBy.accessibilityId("Log in")).click();
    Assert.assertTrue(driver.getPageSource().contains("required")
        || driver.getPageSource().contains("This field"));
    screenshot("login_empty");
  }
}
