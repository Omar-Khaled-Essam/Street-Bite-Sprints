import '../entities/order_entity.dart';

abstract class OrderRepository {
  Future<void> placeOrder(OrderEntity order);
  Stream<List<OrderEntity>> watchOrders(String userId);
}
