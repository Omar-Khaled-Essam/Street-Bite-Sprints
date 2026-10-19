import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/repositories/profile_repository.dart';
import '../../../domain/usecases/toggle_favourite.dart';

class FavouritesCubit extends Cubit<List<String>> {
  FavouritesCubit({
    required ProfileRepository repository,
    required ToggleFavourite toggleFavourite,
  }) : _repository = repository,
       _toggleFavourite = toggleFavourite,
       super(const []);

  final ProfileRepository _repository;
  final ToggleFavourite _toggleFavourite;
  StreamSubscription<List<String>>? _sub;
  String? _userId;

  void watch(String userId) {
    _userId = userId;
    _sub?.cancel();
    _sub = _repository.watchFavouriteIds(userId).listen(emit);
  }

  Future<void> toggle(String mealId) async {
    final userId = _userId;
    if (userId == null) return;
    await _toggleFavourite(userId: userId, mealId: mealId);
  }

  @override
  Future<void> close() {
    _sub?.cancel();
    return super.close();
  }
}
