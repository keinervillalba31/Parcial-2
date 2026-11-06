import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final languageProvider = NotifierProvider<LanguageNotifier, Locale>(
  LanguageNotifier.new,
);

class LanguageNotifier extends Notifier<Locale> {
  static const _key = 'languageCode';

  @override
  Locale build() {
    _load();
    return const Locale('es');
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    state = Locale(prefs.getString(_key) ?? 'es');
  }

  Future<void> changeLanguage(String code) async {
    state = Locale(code);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, code);
  }
}
