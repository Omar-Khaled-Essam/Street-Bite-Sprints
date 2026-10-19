import '../entities/user_entity.dart';

abstract class AuthRepository {
  Stream<UserEntity?> authState();
  Future<UserEntity?> currentUser();
  Future<UserEntity> login({required String email, required String password});
  Future<UserEntity> register({
    required String fullName,
    required String email,
    required String password,
  });
  Future<void> logout();
}
