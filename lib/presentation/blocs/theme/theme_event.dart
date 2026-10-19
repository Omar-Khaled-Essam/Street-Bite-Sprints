import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class ThemeEvent extends Equatable {
  const ThemeEvent();

  @override
  List<Object?> get props => [];
}

class ThemeStarted extends ThemeEvent {
  const ThemeStarted();
}

class ThemeToggled extends ThemeEvent {
  const ThemeToggled();
}

class ThemeChanged extends ThemeEvent {
  const ThemeChanged(this.mode);

  final ThemeMode mode;

  @override
  List<Object?> get props => [mode];
}
