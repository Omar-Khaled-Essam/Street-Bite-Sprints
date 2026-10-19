package com.streetbite;

import io.appium.java_client.AppiumBy;
import org.openqa.selenium.WebElement;
import org.testng.Assert;
import org.testng.annotations.Test;

public class HomeTests extends BaseTest {

  @Test
  public void scrollMealsGrid() throws Exception {
    driver.findElement(AppiumBy.xpath("//android.widget.EditText[1]")).sendKeys("tester@streetbite.app");
    driver.findElement(AppiumBy.xpath("//android.widget.EditText[2]")).sendKeys("123456");
    driver.findElement(AppiumBy.accessibilityId("Log in")).click();
    driver.findElement(AppiumBy.androidUIAutomator(
        "new UiScrollable(new UiSelector().scrollable(true)).scrollForward()"));
    screenshot("home_scroll");
  }

  @Test
  public void addMealShowsSnackbar() throws Exception {
    driver.findElement(AppiumBy.xpath("//android.widget.EditText[1]")).sendKeys("tester@streetbite.app");
    driver.findElement(AppiumBy.xpath("//android.widget.EditText[2]")).sendKeys("123456");
    driver.findElement(AppiumBy.accessibilityId("Log in")).click();
    WebElement add = driver.findElement(AppiumBy.androidUIAutomator(
        "new UiSelector().descriptionContains(\"Add\")"));
    add.click();
    Assert.assertTrue(
        driver.getPageSource().contains("Added to cart")
            || driver.getPageSource().contains("تمت"));
    screenshot("add_to_cart_snackbar");
  }
}
