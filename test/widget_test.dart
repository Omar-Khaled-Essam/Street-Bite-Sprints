import 'package:flutter_test/flutter_test.dart';
import 'package:streetbrite/core/utils/price_helper.dart';
import 'package:streetbrite/core/utils/validators.dart';
import 'package:streetbrite/domain/entities/user_entity.dart';
import 'package:streetbrite/domain/payment/cash_payment.dart';

void main() {
  test('full name must start with a capital letter', () {
    expect(Validators.fullName('omar', 'r', 'c'), 'c');
    expect(Validators.fullName('Omar', 'r', 'c'), isNull);
  });

  test('password requires six characters', () {
    expect(Validators.password('123', 'r', 's'), 's');
    expect(Validators.password('123456', 'r', 's'), isNull);
  });

  test('builder pattern constructs a user', () {
    final user = AppUserBuilder()
        .setId('1')
        .setFullName('Vlad S.')
        .setEmail('vlad@streetbite.app')
        .build();
    expect(user.email, contains('@'));
  });

  test('cash payment accepts positive totals', () async {
    expect(await CashPayment().pay(10), isTrue);
    expect(await CashPayment().pay(0), isFalse);
  });

  test('price helper is deterministic', () {
    expect(PriceHelper.fromId('52772'), PriceHelper.fromId('52772'));
  });
}
