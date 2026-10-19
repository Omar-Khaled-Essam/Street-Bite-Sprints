import '../../domain/entities/order_entity.dart';
import '../../domain/repositories/order_repository.dart';
import '../models/order_model.dart';
import '../services/firestore_service.dart';

class OrderRepositoryImpl implements OrderRepository {
  OrderRepositoryImpl(this._store);

  final FirestoreService _store;

  @override
  Future<void> placeOrder(OrderEntity order) {
    return _store.saveOrder(OrderModel.fromEntity(order));
  }

  @override
  Stream<List<OrderEntity>> watchOrders(String userId) {
    return _store.watchOrders(userId);
  }
}
