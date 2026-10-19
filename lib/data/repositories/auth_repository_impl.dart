import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_firebase_datasource.dart';
import '../datasources/auth_local_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({
    required bool firebaseEnabled,
    AuthFirebaseDataSource? firebase,
    required AuthLocalDataSource local,
  }) : _firebaseEnabled = firebaseEnabled,
       _firebase = firebase,
       _local = local;

  final bool _firebaseEnabled;
  final AuthFirebaseDataSource? _firebase;
  final AuthLocalDataSource _local;

  @override
  Stream<UserEntity?> authState() =>
      _firebaseEnabled ? _firebase!.authState() : _local.authState();

  @override
  Future<UserEntity?> currentUser() async =>
      _firebaseEnabled ? _firebase!.currentUser() : _local.currentUser();

  @override
  Future<UserEntity> login({required String email, required String password}) {
    if (_firebaseEnabled) return _firebase!.login(email, password);
    return _local.login(email, password);
  }

  @override
  Future<UserEntity> register({
    required String fullName,
    required String email,
    required String password,
  }) {
    if (_firebaseEnabled) {
      return _firebase!.register(
        fullName: fullName,
        email: email,
        password: password,
      );
    }
    return _local.register(
      fullName: fullName,
      email: email,
      password: password,
    );
  }

  @override
  Future<void> logout() =>
      _firebaseEnabled ? _firebase!.logout() : _local.logout();
}
