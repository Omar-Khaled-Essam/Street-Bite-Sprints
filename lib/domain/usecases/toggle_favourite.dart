import '../repositories/profile_repository.dart';

class ToggleFavourite {
  ToggleFavourite(this._repository);

  final ProfileRepository _repository;

  Future<void> call({required String userId, required String mealId}) {
    return _repository.toggleFavourite(userId: userId, mealId: mealId);
  }
}
