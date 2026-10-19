import 'package:equatable/equatable.dart';

/// Immutable user entity. Constructed with [AppUserBuilder] (Builder Pattern)
/// so required auth fields can be assembled step-by-step during sign-up.
class UserEntity extends Equatable {
  const UserEntity({
    required this.id,
    required this.fullName,
    required this.email,
    this.photoUrl,
    this.phone,
  });

  final String id;
  final String fullName;
  final String email;
  final String? photoUrl;
  final String? phone;

  UserEntity copyWith({String? fullName, String? photoUrl, String? phone}) {
    return UserEntity(
      id: id,
      fullName: fullName ?? this.fullName,
      email: email,
      photoUrl: photoUrl ?? this.photoUrl,
      phone: phone ?? this.phone,
    );
  }

  @override
  List<Object?> get props => [id, fullName, email, photoUrl, phone];
}

/// Builder Pattern: collects user fields, validates them, then builds [UserEntity].
class AppUserBuilder {
  String? id;
  String? fullName;
  String? email;
  String? photoUrl;
  String? phone;

  AppUserBuilder setId(String value) {
    id = value;
    return this;
  }

  AppUserBuilder setFullName(String value) {
    fullName = value;
    return this;
  }

  AppUserBuilder setEmail(String value) {
    email = value;
    return this;
  }

  AppUserBuilder setPhotoUrl(String? value) {
    photoUrl = value;
    return this;
  }

  AppUserBuilder setPhone(String? value) {
    phone = value;
    return this;
  }

  UserEntity build() {
    if (id == null || id!.isEmpty) {
      throw StateError('User id is required');
    }
    if (fullName == null || fullName!.isEmpty) {
      throw StateError('User full name is required');
    }
    if (email == null || email!.isEmpty) {
      throw StateError('User email is required');
    }
    return UserEntity(
      id: id!,
      fullName: fullName!,
      email: email!,
      photoUrl: photoUrl,
      phone: phone,
    );
  }
}
