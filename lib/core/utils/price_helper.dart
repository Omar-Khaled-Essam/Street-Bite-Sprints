/// Deterministic prices because TheMealDB does not expose them.
class PriceHelper {
  PriceHelper._();

  static double fromId(String id) {
    final numeric = int.tryParse(id) ?? id.hashCode.abs();
    final dollars = 7 + (numeric % 18);
    final cents = (numeric % 90) + 9;
    return dollars + (cents / 100);
  }

  static String format(double value) => '\$${value.toStringAsFixed(2)}';
}
