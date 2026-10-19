import '../entities/order_entity.dart';
import '../repositories/order_repository.dart';

class PlaceOrder {
  PlaceOrder(this._repository);

  final OrderRepository _repository;

  Future<void> call(OrderEntity order) => _repository.placeOrder(order);
}
