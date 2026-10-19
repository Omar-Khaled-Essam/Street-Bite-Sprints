import 'package:firebase_auth/firebase_auth.dart';

import '../../core/error/exception_mapper.dart';
import '../../core/error/failures.dart';
import '../../domain/entities/user_entity.dart';
import '../models/user_model.dart';
import '../services/firestore_service.dart';

class AuthFirebaseDataSource {
  AuthFirebaseDataSource(this._auth, this._store);

  final FirebaseAuth _auth;
  final FirestoreService _store;
  final _mapper = const ExceptionMapper();

  Stream<UserEntity?> authState() {
    return _auth.authStateChanges().asyncMap((user) async {
      if (user == null) return null;
      final stored = await _store.getUser(user.uid);
      return stored ??
          AppUserBuilder()
              .setId(user.uid)
              .setEmail(user.email ?? '')
              .setFullName(user.displayName ?? user.email ?? 'Guest')
              .setPhotoUrl(user.photoURL)
              .build();
    });
  }

  Future<UserEntity?> currentUser() async {
    final user = _auth.currentUser;
    if (user == null) return null;
    return _store.getUser(user.uid);
  }

  Future<UserEntity> login(String email, String password) async {
    try {
      final cred = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = cred.user!;
      final stored = await _store.getUser(user.uid);
      return stored ??
          AppUserBuilder()
              .setId(user.uid)
              .setEmail(user.email ?? email)
              .setFullName(user.displayName ?? email)
              .build();
    } on FirebaseAuthException catch (e) {
      throw AuthFailure(_mapper.fromFirebase(e.code));
    }
  }

  Future<UserEntity> register({
    required String fullName,
    required String email,
    required String password,
  }) async {
    try {
      final cred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await cred.user!.updateDisplayName(fullName);
      final entity = AppUserBuilder()
          .setId(cred.user!.uid)
          .setFullName(fullName)
          .setEmail(email)
          .build();
      await _store.upsertUser(UserModel.fromEntity(entity));
      return entity;
    } on FirebaseAuthException catch (e) {
      throw AuthFailure(_mapper.fromFirebase(e.code));
    }
  }

  Future<void> logout() => _auth.signOut();
}
