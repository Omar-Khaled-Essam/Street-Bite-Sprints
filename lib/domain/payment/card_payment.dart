import 'payment_method.dart';

class CardPayment implements PaymentMethod {
  CardPayment({this.cardNumber});

  final String? cardNumber;

  @override
  String get id => 'card';

  @override
  String get label => 'Card';

  @override
  Future<bool> pay(double amount) async {
    if (amount <= 0) return false;
    if (cardNumber != null && cardNumber!.replaceAll(' ', '').length < 12) {
      return false;
    }
    return true;
  }
}
