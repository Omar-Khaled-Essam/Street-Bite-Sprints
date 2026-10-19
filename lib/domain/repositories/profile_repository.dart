import '../entities/user_entity.dart';

abstract class ProfileRepository {
  Future<UserEntity> savePhoto({
    required String userId,
    required String photoPathOrData,
  });
  Future<UserEntity?> getProfile(String userId);
  Stream<List<String>> watchFavouriteIds(String userId);
  Future<void> toggleFavourite({
    required String userId,
    required String mealId,
  });
}
