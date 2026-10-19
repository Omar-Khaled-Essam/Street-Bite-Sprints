import 'payment_method.dart';

class CashPayment implements PaymentMethod {
  @override
  String get id => 'cash';

  @override
  String get label => 'Cash on delivery';

  @override
  Future<bool> pay(double amount) async {
    if (amount <= 0) return false;
    return true;
  }
}
