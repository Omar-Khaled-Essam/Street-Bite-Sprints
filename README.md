# StreetBite V1.0

Bilingual Flutter food discovery and ordering app for the graduation capstone. Users discover street-food vendors, browse live meals from [TheMealDB](https://www.themealdb.com/api.php), place orders, save favourites, and manage profiles in English and Arabic with light and dark themes.

## Branding

- **Name:** StreetBite
- **Accent:** `#00C853` mint green from the Food Delivery UI kit
- **Logo:** rounded white mark with a lunch-dining icon (see `lib/presentation/widgets/app_logo.dart`)

## Architecture

Clean Architecture with GetIt (Singleton / Factory) and flutter_bloc:

```
lib/
  main.dart
  injection.dart
  core/          # theme, routes, Dio, errors, validators
  data/          # datasources, models, repositories, Firestore singleton
  domain/        # entities, repository contracts, use cases, payment SOLID
  presentation/  # screens, blocs/cubits, widgets
  l10n/          # app_en.arb, app_ar.arb
```

### Design patterns

| Pattern | Where | Why |
| --- | --- | --- |
| **Builder** | `AppUserBuilder` in `domain/entities/user_entity.dart` | Assemble Firebase/local user fields step by step during sign-up |
| **Factory** | `MealRepositoryFactory` in `data/repositories/meal_repository_impl.dart` | Choose remote TheMealDB vs cached SharedPreferences source |
| **Singleton** | `FirestoreService` and GetIt registrations | One Firestore/prefs façade and one Dio client for the app |

Payment follows SOLID: `PaymentMethod` interface with `CashPayment` and `CardPayment`, orchestrated by `PaymentProcessor`.

## Features

- Splash fade-in, welcome onboarding, email/password login and sign-up
- Persistent auth (Firebase when configured, otherwise local demo session)
- Home: MediaQuery grid, PageView banners, Hot Offers (5), theme + language toggles
- Live TheMealDB menu via Dio, cache restore, loading/error states
- Meal details, favourites in Firestore, CartBloc + SnackBar feedback
- Checkout, cash/card payment, orders in Firestore
- Nearby Vendors Google Map (5 cities) — bonus
- Profile with biometric gate, image_picker photo, device_info_plus — bonus
- EN/AR runtime toggle, light/dark `ThemeBloc`

### Demo login (local fallback)

When Firebase is not configured the app seeds:

- Email: `tester@streetbite.app`
- Password: `123456`

## Setup

1. Install Flutter 3.24+ and a JDK 17 toolchain.
2. From the repo root:

```bash
flutter pub get
flutter gen-l10n
flutter run
```

3. **Firebase (production path)**
   - Create a Firebase project, enable Authentication (email/password) and Cloud Firestore.
   - Run `flutterfire configure` and replace `lib/firebase_options.dart`.
   - Add `google-services.json` under `android/app/`.
4. **Google Maps**
   - Put an Android Maps SDK key in `android/app/src/main/AndroidManifest.xml` (`com.google.android.geo.API_KEY`).
5. Verify two window sizes (phone and large phone / tablet) — Home uses `MediaQuery` for grid columns.

### Android permissions

Declared in `AndroidManifest.xml`: Internet, network state, camera / gallery, biometric, coarse/fine location.

## Submission checklist (do these on your machine)

1. `flutter pub get && flutter gen-l10n && dart format . && flutter analyze`
2. Run `flutterfire configure`, add `android/app/google-services.json`, then add the `com.google.gms.google-services` Gradle plugin.
3. Paste your Google Maps key into `AndroidManifest.xml`.
4. Take the required screenshots (Splash, Login, Sign Up, Home EN/AR, Details, Cart, Vendor Map info window, Profile + device details, biometric prompt, dark mode) into `docs/screenshots/`.
5. Build the release APK, upload to Firebase App Distribution with two testers, add the dashboard screenshot to `docs/beta/`.
6. Run the Appium suite on an emulator and a physical phone; save PNGs to `docs/qa/screenshots/`.

## Beta distribution (Firebase App Distribution)

1. `flutter build apk --release`
2. Upload `build/app/outputs/flutter-apk/app-release.apk` in Firebase App Distribution.
3. Add at least two testers (example: `tester1@streetbite.app`, `tester2@streetbite.app`).
4. Drop dashboard screenshots into `docs/beta/` and link them here before submission.

Until the APK is uploaded, keep this checklist in the submission README with your screenshots.

## QA (bonus)

Manual artifacts live in `docs/qa/`. Appium + Java lives in `appium/`.

## Tests

```bash
flutter test
dart format .
```

## API

TheMealDB search: `https://www.themealdb.com/api/json/v1/1/search.php?s=`

Filter and lookup endpoints are used from `MealRemoteDataSource`.
