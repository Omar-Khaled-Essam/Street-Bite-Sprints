# Test suites

## Login — GUI / positive / negative / mobile

| ID | Type | Steps | Expected |
| --- | --- | --- | --- |
| TC_LOGIN_001 | GUI | Open Login | Title, email, password, primary button, sign-up link visible |
| TC_LOGIN_002 | Positive | Enter `tester@streetbite.app` / `123456`, tap Log in | Home shell opens |
| TC_LOGIN_003 | Negative | Wrong password | Friendly error SnackBar, stay on Login |
| TC_LOGIN_004 | Negative | Empty fields, tap Log in | Required-field validation |
| TC_LOGIN_005 | Negative | Invalid email format | Email error message |
| TC_LOGIN_006 | Mobile | Kill app after login, relaunch | Session restored (Firebase or local) |
| TC_LOGIN_007 | Mobile | Rotate device on Login | Layout remains usable |

## Home

| ID | Type | Steps | Expected |
| --- | --- | --- | --- |
| TC_HOME_001 | GUI | Open Home | Address, search, categories, Fastest, Recommended, meal grid |
| TC_HOME_002 | Positive | Wait for TheMealDB | Grid shows image, name, category, add action |
| TC_HOME_003 | Positive | Tap add on a meal | SnackBar “Added to cart”, cart badge increments |
| TC_HOME_004 | Positive | Pull to refresh | Menu reloads |
| TC_HOME_005 | Negative | Airplane mode then open Home | Cached meals or friendly network error + Retry |
| TC_HOME_006 | Mobile | Scroll GridView | List scrolls smoothly |
| TC_HOME_007 | Positive | Toggle theme / language | Dark mode and AR/EN apply immediately |
| TC_HOME_008 | GUI | Two widths (phone / wide) | Grid is 2 or 3 columns via MediaQuery |
