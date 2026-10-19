import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/constants/app_constants.dart';

class LocaleCubit extends Cubit<Locale> {
  LocaleCubit(this._prefs) : super(const Locale('en'));

  final SharedPreferences _prefs;

  Future<void> load() async {
    final code = _prefs.getString(AppConstants.localePrefsKey) ?? 'en';
    emit(Locale(code));
  }

  Future<void> toggle() async {
    final next = state.languageCode == 'en' ? 'ar' : 'en';
    await _prefs.setString(AppConstants.localePrefsKey, next);
    emit(Locale(next));
  }

  Future<void> setLocale(Locale locale) async {
    await _prefs.setString(AppConstants.localePrefsKey, locale.languageCode);
    emit(locale);
  }
}
