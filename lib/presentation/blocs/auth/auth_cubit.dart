import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/error/failures.dart';
import '../../../domain/usecases/login_user.dart';
import '../../../domain/usecases/register_user.dart';
import '../../../domain/repositories/auth_repository.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit({
    required AuthRepository authRepository,
    required LoginUser loginUser,
    required RegisterUser registerUser,
  }) : _authRepository = authRepository,
       _loginUser = loginUser,
       _registerUser = registerUser,
       super(const AuthInitial());

  final AuthRepository _authRepository;
  final LoginUser _loginUser;
  final RegisterUser _registerUser;

  Future<void> checkAuth() async {
    emit(const AuthLoading());
    final user = await _authRepository.currentUser();
    if (user == null) {
      emit(const AuthUnauthenticated());
    } else {
      emit(AuthAuthenticated(user));
    }
  }

  Future<void> login(String email, String password) async {
    emit(const AuthLoading());
    try {
      final user = await _loginUser(email: email, password: password);
      emit(AuthAuthenticated(user));
    } on Failure catch (e) {
      emit(AuthFailureState(e.message));
    } catch (_) {
      emit(const AuthFailureState('unknownError'));
    }
  }

  Future<void> register({
    required String fullName,
    required String email,
    required String password,
  }) async {
    emit(const AuthLoading());
    try {
      final user = await _registerUser(
        fullName: fullName,
        email: email,
        password: password,
      );
      emit(AuthAuthenticated(user));
    } on Failure catch (e) {
      emit(AuthFailureState(e.message));
    } catch (_) {
      emit(const AuthFailureState('unknownError'));
    }
  }

  Future<void> logout() async {
    await _authRepository.logout();
    emit(const AuthUnauthenticated());
  }

  Future<void> refreshUser() async {
    final user = await _authRepository.currentUser();
    if (user != null) emit(AuthAuthenticated(user));
  }
}
