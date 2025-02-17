import 'package:flutter/material.dart';

class LocaleProvider extends ChangeNotifier {
  Locale _locale = const Locale('en');

  Locale get locale => _locale;

  void setLocale(Locale locale) {
    if (!['en', 'zh_CN', 'zh_TW'].contains(locale.toString())) return;
    
    _locale = locale;
    notifyListeners();
  }
}
