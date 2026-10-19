// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'StreetBite';

  @override
  String get heroTitle => 'Food and groceries delivered to you';

  @override
  String get heroSubtitle => 'Enter your details to get started';

  @override
  String get continueLabel => 'Continue';

  @override
  String get loginTitle => 'Log in';

  @override
  String get signUpTitle => 'Sign up';

  @override
  String get fullName => 'Full name';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get confirmPassword => 'Confirm password';

  @override
  String get alreadyHaveAccount => 'Already have an account? Log in';

  @override
  String get noAccount => 'Don\'t have an account? Sign up';

  @override
  String get login => 'Log in';

  @override
  String get createAccount => 'Create account';

  @override
  String get nameCapitalError => 'Full name must start with a capital letter';

  @override
  String get emailError => 'Enter a valid email address';

  @override
  String get passwordError => 'Password must be at least 6 characters';

  @override
  String get confirmPasswordError => 'Passwords do not match';

  @override
  String get requiredField => 'This field is required';

  @override
  String get home => 'Home';

  @override
  String get browse => 'Browse';

  @override
  String get orders => 'Orders';

  @override
  String get profile => 'Profile';

  @override
  String get searchHint => 'Food, groceries, etc.';

  @override
  String get fastest => 'Fastest';

  @override
  String get recommended => 'Recommended';

  @override
  String get hotOffers => 'Hot Offers';

  @override
  String get featured => 'Featured';

  @override
  String get addToCart => 'Add to cart';

  @override
  String get addedToCart => 'Added to cart';

  @override
  String get viewCart => 'View cart';

  @override
  String get mealDetails => 'Meal details';

  @override
  String get category => 'Category';

  @override
  String get origin => 'Origin';

  @override
  String get instructions => 'Instructions';

  @override
  String get favouriteSaved => 'Saved to favourites';

  @override
  String get favouriteRemoved => 'Removed from favourites';

  @override
  String get cart => 'Order';

  @override
  String get cartEmpty => 'Your cart is empty';

  @override
  String get remove => 'Remove';

  @override
  String get subtotal => 'Subtotal';

  @override
  String get deliveryFee => 'Delivery fee';

  @override
  String get feesAndTaxes => 'Fees & Taxes';

  @override
  String get discount => 'Discount';

  @override
  String get seeMenu => 'See menu';

  @override
  String get delivery => 'Delivery';

  @override
  String get pickup => 'Pickup';

  @override
  String get checkout => 'Checkout';

  @override
  String get placeOrder => 'Place order';

  @override
  String get deliveryTime => 'Delivery Time';

  @override
  String get express => 'Express';

  @override
  String get standard => 'Standard';

  @override
  String get addPromo => 'Add promo';

  @override
  String get leaveAtDoor => 'Leave it at my door';

  @override
  String get addMoreDetails => 'Add more details';

  @override
  String get paymentCash => 'Cash on delivery';

  @override
  String get paymentCard => 'Card';

  @override
  String get orderPlaced => 'Order placed successfully';

  @override
  String get addCard => 'Add card';

  @override
  String get cardNumber => 'Card number';

  @override
  String get nameOnCard => 'Name';

  @override
  String get exp => 'Exp';

  @override
  String get cvv => 'CVV';

  @override
  String get zip => 'Zip';

  @override
  String get defaultPayment => 'Default payment method';

  @override
  String get deliveryAddress => 'Delivery address';

  @override
  String get adjustPin => 'Adjust pin';

  @override
  String get address => 'Address';

  @override
  String get apartment => 'Apartment';

  @override
  String get comment => 'Comment';

  @override
  String get nearbyVendors => 'Nearby Vendors';

  @override
  String get settings => 'Settings';

  @override
  String get contactUs => 'Contact us';

  @override
  String get helpCenter => 'Help center';

  @override
  String get darkMode => 'Dark mode';

  @override
  String get language => 'Language';

  @override
  String get english => 'English';

  @override
  String get arabic => 'Arabic';

  @override
  String get deviceDetails => 'Device details';

  @override
  String get favourites => 'Favourites';

  @override
  String get orderHistory => 'Order history';

  @override
  String get past => 'Past';

  @override
  String get biometricPrompt => 'Confirm your fingerprint to open Profile';

  @override
  String get biometricFailed => 'Biometric authentication failed';

  @override
  String get retry => 'Retry';

  @override
  String get networkError => 'We could not reach the menu. Please try again.';

  @override
  String get unknownError => 'Something went wrong. Please try again.';

  @override
  String get popular => 'Popular';

  @override
  String get newLabel => 'New';

  @override
  String get search => 'Search';

  @override
  String get categories => 'Categories';

  @override
  String get promoBannerTitle => '\$0 delivery fee over \$30';

  @override
  String get promoBannerBody => 'Use WELCOME30 promo code on any order';

  @override
  String get orderReceived => 'Order received';

  @override
  String get cookingOrder => 'Cooking your order';

  @override
  String get lookingCourier => 'Looking for courier';

  @override
  String get courierPicking => 'Courier is picking up order';

  @override
  String get orderDelivered => 'Order delivered';

  @override
  String get preparingOrder => 'Preparing your order';

  @override
  String arrivesIn(String range) {
    return 'Arrives in $range min';
  }

  @override
  String get contactCourier => 'Contact courier';

  @override
  String get help => 'Help';

  @override
  String itemsCount(int count) {
    return '$count items';
  }

  @override
  String get today => 'Today';

  @override
  String daysAgo(int count) {
    return '$count days ago';
  }

  @override
  String ratingDistance(String rating, String distance, String time) {
    return '$rating ★  ·  $distance  ·  $time';
  }

  @override
  String get logout => 'Log out';

  @override
  String get save => 'Save';

  @override
  String get themeToggle => 'Toggle theme';

  @override
  String get cuisine => 'Cuisine';

  @override
  String vendorRating(String rating) {
    return 'Rating $rating';
  }

  @override
  String get phoneHint => '(555) 555-1234';

  @override
  String get countryCode => '+1';

  @override
  String get meals => 'Meals';

  @override
  String get expressEta => '10-15 min';

  @override
  String get standardEta => '20-25 min';

  @override
  String get expressFee => '+ \$2.99';

  @override
  String get defaultAddressLabel => 'Park Way 145';

  @override
  String get defaultPhoneLabel => '(628) 222-1133';

  @override
  String get mainEntrance => 'Main entrance';

  @override
  String reviewsCount(int count) {
    return '($count)';
  }

  @override
  String get invalidCredentials => 'Incorrect email or password.';

  @override
  String get emailInUse => 'This email is already registered.';
}
