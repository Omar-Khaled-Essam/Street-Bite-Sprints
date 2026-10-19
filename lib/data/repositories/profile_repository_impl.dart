import 'dart:convert';
import 'dart:io';

import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/profile_repository.dart';
import '../models/user_model.dart';
import '../services/firestore_service.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  ProfileRepositoryImpl(this._store);

  final FirestoreService _store;

  @override
  Future<UserEntity?> getProfile(String userId) => _store.getUser(userId);

  @override
  Future<UserEntity> savePhoto({
    required String userId,
    required String photoPathOrData,
  }) async {
    final existing = await _store.getUser(userId);
    if (existing == null) {
      throw StateError('Profile not found');
    }
    var encoded = photoPathOrData;
    if (!photoPathOrData.startsWith('data:') &&
        !photoPathOrData.startsWith('http')) {
      final bytes = await File(photoPathOrData).readAsBytes();
      encoded = 'data:image/jpeg;base64,${base64Encode(bytes)}';
    }
    final updated = UserModel.fromEntity(existing.copyWith(photoUrl: encoded));
    await _store.upsertUser(updated);
    return updated;
  }

  @override
  Stream<List<String>> watchFavouriteIds(String userId) =>
      _store.watchFavourites(userId);

  @override
  Future<void> toggleFavourite({
    required String userId,
    required String mealId,
  }) {
    return _store.toggleFavourite(userId, mealId);
  }
}
