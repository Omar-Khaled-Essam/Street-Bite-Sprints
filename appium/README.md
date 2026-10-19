# StreetBite Appium (Java)

Five scenarios on a shared `BaseTest`:

1. Valid login
2. Invalid credentials
3. Empty login fields
4. Home GridView scroll
5. Add to cart SnackBar

```bash
# Start Appium 2
appium

# Point at an APK
set STREETBITE_APK=..\build\app\outputs\flutter-apk\app-debug.apk

mvn test
```

Re-run `LoginTests` on a physical device and save PNGs from `appium/screenshots/` into `docs/qa/screenshots/`.
