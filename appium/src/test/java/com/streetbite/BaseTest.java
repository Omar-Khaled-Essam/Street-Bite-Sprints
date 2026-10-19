package com.streetbite;

import io.appium.java_client.android.AndroidDriver;
import io.appium.java_client.android.options.UiAutomator2Options;
import java.net.URI;
import java.nio.file.Files;
import java.nio.file.Path;
import java.time.Duration;
import org.openqa.selenium.OutputType;
import org.testng.annotations.AfterClass;
import org.testng.annotations.BeforeClass;

/** Shared driver setup targeting the StreetBite release/debug APK. */
public abstract class BaseTest {
  protected AndroidDriver driver;

  @BeforeClass
  public void setUp() throws Exception {
    UiAutomator2Options options = new UiAutomator2Options()
        .setPlatformName("Android")
        .setAutomationName("UiAutomator2")
        .setAppPackage("com.example.streetbrite")
        .setAppActivity(".MainActivity")
        .setNoReset(false)
        .setNewCommandTimeout(Duration.ofSeconds(120));
    String apk = System.getenv().getOrDefault(
        "STREETBITE_APK",
        "../build/app/outputs/flutter-apk/app-debug.apk");
    options.setApp(Path.of(apk).toAbsolutePath().toString());
    driver = new AndroidDriver(URI.create("http://127.0.0.1:4723").toURL(), options);
    driver.manage().timeouts().implicitlyWait(Duration.ofSeconds(8));
  }

  protected void screenshot(String name) throws Exception {
    Path dir = Path.of("screenshots");
    Files.createDirectories(dir);
    Files.write(dir.resolve(name + ".png"), driver.getScreenshotAs(OutputType.BYTES));
  }

  @AfterClass(alwaysRun = true)
  public void tearDown() {
    if (driver != null) {
      driver.quit();
    }
  }
}
