class Validators {
  Validators._();

  static String? fullName(String? value, String required, String capital) {
    if (value == null || value.trim().isEmpty) return required;
    final trimmed = value.trim();
    if (trimmed[0] != trimmed[0].toUpperCase()) return capital;
    return null;
  }

  static String? email(String? value, String required, String invalid) {
    if (value == null || value.trim().isEmpty) return required;
    final regex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
    if (!regex.hasMatch(value.trim())) return invalid;
    return null;
  }

  static String? password(String? value, String required, String short) {
    if (value == null || value.isEmpty) return required;
    if (value.length < 6) return short;
    return null;
  }

  static String? confirm(
    String? value,
    String? original,
    String required,
    String mismatch,
  ) {
    if (value == null || value.isEmpty) return required;
    if (value != original) return mismatch;
    return null;
  }
}
