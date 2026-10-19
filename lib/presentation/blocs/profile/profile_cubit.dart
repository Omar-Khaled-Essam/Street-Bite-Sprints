import 'package:device_info_plus/device_info_plus.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../../domain/entities/user_entity.dart';
import '../../../domain/repositories/profile_repository.dart';

class ProfileViewState extends Equatable {
  const ProfileViewState({this.user, this.deviceLabel = '', this.busy = false});

  final UserEntity? user;
  final String deviceLabel;
  final bool busy;

  ProfileViewState copyWith({
    UserEntity? user,
    String? deviceLabel,
    bool? busy,
  }) {
    return ProfileViewState(
      user: user ?? this.user,
      deviceLabel: deviceLabel ?? this.deviceLabel,
      busy: busy ?? this.busy,
    );
  }

  @override
  List<Object?> get props => [user, deviceLabel, busy];
}

class ProfileCubit extends Cubit<ProfileViewState> {
  ProfileCubit(this._repository) : super(const ProfileViewState());

  final ProfileRepository _repository;
  final _picker = ImagePicker();

  Future<void> load(UserEntity user) async {
    final stored = await _repository.getProfile(user.id) ?? user;
    emit(state.copyWith(user: stored, deviceLabel: await _readDevice()));
  }

  Future<void> pickPhoto() async {
    final user = state.user;
    if (user == null) return;
    final file = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
    );
    if (file == null) return;
    emit(state.copyWith(busy: true));
    final updated = await _repository.savePhoto(
      userId: user.id,
      photoPathOrData: file.path,
    );
    emit(state.copyWith(user: updated, busy: false));
  }

  Future<String> _readDevice() async {
    final plugin = DeviceInfoPlugin();
    try {
      if (defaultTargetPlatform == TargetPlatform.android) {
        final info = await plugin.androidInfo;
        return '${info.brand} ${info.model} · Android ${info.version.release}';
      }
      if (defaultTargetPlatform == TargetPlatform.iOS) {
        final info = await plugin.iosInfo;
        return '${info.name} · iOS ${info.systemVersion}';
      }
      if (defaultTargetPlatform == TargetPlatform.windows) {
        final info = await plugin.windowsInfo;
        return '${info.computerName} · Windows ${info.displayVersion}';
      }
    } catch (_) {
      return 'Unknown device';
    }
    return defaultTargetPlatform.name;
  }
}
