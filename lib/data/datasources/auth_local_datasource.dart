import 'dart:async';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../../core/constants/app_constants.dart';
import '../../core/error/failures.dart';
import '../../domain/entities/user_entity.dart';
import '../models/user_model.dart';

class AuthLocalDataSource {
  AuthLocalDataSource(this._prefs) {
    _seedDemoUser();
  }

  final SharedPreferences _prefs;
  final _controller = StreamController<UserEntity?>.broadcast();

  Stream<UserEntity?> authState() async* {
    yield currentUser();
    yield* _controller.stream;
  }

  UserEntity? currentUser() {
    final raw = _prefs.getString(AppConstants.sessionUserKey);
    if (raw == null) return null;
    return UserModel.fromJson(jsonDecode(raw) as Map<String, dynamic>);
  }

  Future<UserEntity> login(String email, String password) async {
    final users = _readUsers();
    final match = users.cast<Map<String, dynamic>?>().firstWhere(
      (u) => u!['email'] == email && u['password'] == password,
      orElse: () => null,
    );
    if (match == null) {
      throw const AuthFailure('invalidCredentials');
    }
    final user = UserModel.fromJson(match);
    await _prefs.setString(AppConstants.sessionUserKey, jsonEncode(user.toJson()));
    _controller.add(user);
    return user;
  }

  Future<UserEntity> register({
    required String fullName,
    required String email,
    required String password,
  }) async {
    final users = _readUsers();
    if (users.any((u) => u['email'] == email)) {
      throw const AuthFailure('emailInUse');
    }
    final user = AppUserBuilder()
        .setId(const Uuid().v4())
        .setFullName(fullName)
        .setEmail(email)
        .build();
    users.add({...UserModel.fromEntity(user).toJson(), 'password': password});
    await _prefs.setString(AppConstants.localUsersKey, jsonEncode(users));
    await _prefs.setString(
      AppConstants.sessionUserKey,
      jsonEncode(UserModel.fromEntity(user).toJson()),
    );
    _controller.add(user);
    return user;
  }

  Future<void> logout() async {
    await _prefs.remove(AppConstants.sessionUserKey);
    _controller.add(null);
  }

  void _seedDemoUser() {
    final users = _readUsers();
    if (users.any((u) => u['email'] == 'tester@streetbite.app')) return;
    final user = AppUserBuilder()
        .setId('demo-user')
        .setFullName('Vlad S.')
        .setEmail('tester@streetbite.app')
        .build();
    users.add({
      ...UserModel.fromEntity(user).toJson(),
      'password': '123456',
    });
    _prefs.setString(AppConstants.localUsersKey, jsonEncode(users));
  }

  List<Map<String, dynamic>> _readUsers() {
    final raw = _prefs.getString(AppConstants.localUsersKey);
    if (raw == null) return [];
    return (jsonDecode(raw) as List<dynamic>)
        .map((e) => Map<String, dynamic>.from(e as Map))
        .toList();
  }
}
