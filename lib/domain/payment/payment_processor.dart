import 'payment_method.dart';

/// Open/Closed: new payment types can be added without changing this processor.
class PaymentProcessor {
  const PaymentProcessor();

  Future<bool> process(PaymentMethod method, double amount) {
    return method.pay(amount);
  }
}
