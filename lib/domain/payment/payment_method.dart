/// SOLID — Interface Segregation / Dependency Inversion:
/// checkout depends on this abstraction, not on cash or card details.
abstract class PaymentMethod {
  String get id;
  String get label;
  Future<bool> pay(double amount);
}
