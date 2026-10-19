import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/constants/app_constants.dart';
import 'theme_event.dart';
import 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc(this._prefs) : super(const ThemeState(ThemeMode.light)) {
    on<ThemeStarted>(_onStarted);
    on<ThemeToggled>(_onToggled);
    on<ThemeChanged>(_onChanged);
  }

  final SharedPreferences _prefs;

  Future<void> _onStarted(ThemeStarted event, Emitter<ThemeState> emit) async {
    final stored = _prefs.getString(AppConstants.themePrefsKey);
    if (stored == 'dark') emit(const ThemeState(ThemeMode.dark));
  }

  Future<void> _onToggled(ThemeToggled event, Emitter<ThemeState> emit) async {
    final next = state.isDark ? ThemeMode.light : ThemeMode.dark;
    await _prefs.setString(AppConstants.themePrefsKey, next.name);
    emit(ThemeState(next));
  }

  Future<void> _onChanged(ThemeChanged event, Emitter<ThemeState> emit) async {
    await _prefs.setString(AppConstants.themePrefsKey, event.mode.name);
    emit(ThemeState(event.mode));
  }
}
