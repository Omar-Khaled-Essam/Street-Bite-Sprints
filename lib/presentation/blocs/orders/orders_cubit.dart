import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/order_entity.dart';
import '../../../domain/repositories/order_repository.dart';

class OrdersCubit extends Cubit<List<OrderEntity>> {
  OrdersCubit(this._repository) : super(const []);

  final OrderRepository _repository;
  StreamSubscription<List<OrderEntity>>? _sub;

  void watch(String userId) {
    _sub?.cancel();
    _sub = _repository.watchOrders(userId).listen(emit);
  }

  @override
  Future<void> close() {
    _sub?.cancel();
    return super.close();
  }
}
