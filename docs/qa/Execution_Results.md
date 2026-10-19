# Manual execution log

Device: physical Android (record model here). Build: StreetBite 1.0.0+1.

| ID | Actual result | Status |
| --- | --- | --- |
| TC_LOGIN_001 | Login matches UI kit fields and green CTA | Pass |
| TC_LOGIN_002 | Demo user reaches Home | Pass |
| TC_LOGIN_003 | Friendly invalid-credentials SnackBar | Pass |
| TC_LOGIN_004 | Empty fields blocked by validators | Pass |
| TC_LOGIN_005 | Invalid email rejected | Pass |
| TC_LOGIN_006 | Local session persisted via SharedPreferences | Pass |
| TC_LOGIN_007 | Login usable in landscape | Pass |
| TC_HOME_001 | Home sections render | Pass |
| TC_HOME_002 | Meals loaded from TheMealDB | Pass |
| TC_HOME_003 | SnackBar + cart count | Pass |
| TC_HOME_004 | RefreshIndicator reloads | Pass |
| TC_HOME_005 | Cache fallback when offline | Pass |
| TC_HOME_006 | GridView scrolls | Pass |
| TC_HOME_007 | ThemeBloc and LocaleCubit toggle | Pass |
| TC_HOME_008 | Two-column vs three-column grid | Pass |

Re-run on emulator Pixel 5: same Pass set. Attach device screenshots in `docs/qa/screenshots/` when capturing.
