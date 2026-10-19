import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class RegisterUser {
  RegisterUser(this._repository);

  final AuthRepository _repository;

  Future<UserEntity> call({
    required String fullName,
    required String email,
    required String password,
  }) {
    return _repository.register(
      fullName: fullName,
      email: email,
      password: password,
    );
  }
}
