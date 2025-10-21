import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// 语言状态管理器，负责维护当前语言并持久化用户选择
class LocaleProvider extends ChangeNotifier {
  LocaleProvider() {
    _loadSavedLocale();
  }

  static const String _storageKey = 'selected_locale';

  Locale _locale = const Locale('zh');

  Locale get locale => _locale;

  Future<void> switchLocale(Locale locale) async {
    if (_locale == locale) {
      return;
    }
    _locale = locale;
    notifyListeners();
    await _persistLocale(locale);
  }

  Future<void> _loadSavedLocale() async {
    final SharedPreferences preferences =
        await SharedPreferences.getInstance();
    final String? storedCode = preferences.getString(_storageKey);
    if (storedCode == null || storedCode.isEmpty) {
      return;
    }
    _locale = Locale(storedCode);
    notifyListeners();
  }

  Future<void> _persistLocale(Locale locale) async {
    final SharedPreferences preferences =
        await SharedPreferences.getInstance();
    await preferences.setString(_storageKey, locale.languageCode);
  }
}
