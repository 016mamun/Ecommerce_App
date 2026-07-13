import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

final themeModeProvider = StateNotifierProvider<ThemeModeNotifier, ThemeMode>((ref) {
  return ThemeModeNotifier();
});

class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  static const _key = 'themeMode';
  final _box = Hive.box('app_cache');

  ThemeModeNotifier() : super(ThemeMode.dark) {
    final saved = _box.get(_key, defaultValue: 'dark') as String;
    state = saved == 'light' ? ThemeMode.light : ThemeMode.dark;
  }

  void toggle() {
    state = state == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    _box.put(_key, state == ThemeMode.dark ? 'dark' : 'light');
  }

  void setMode(ThemeMode mode) {
    state = mode;
    _box.put(_key, mode == ThemeMode.dark ? 'dark' : 'light');
  }
}
