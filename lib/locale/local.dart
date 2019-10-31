import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show SynchronousFuture;

class AppLocalizations {
  AppLocalizations(this.locale);

  final Locale locale;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'apptitle': 'Todo List',
      'secondScreenTitle':'Add a new task'
    },
    'hi': {
      'apptitle': 'करने के लिए सूची',
      'secondScreenTitle':'एक नया कार्य जोड़ें',
      'seondScreenItem':'कुछ करने के लिए दर्ज करें'

    },
    
  };

  String getval(String val) {
    print(this.locale.languageCode);
    return _localizedValues[locale.languageCode][val];
  }
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'hi'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(AppLocalizations(locale));
  }

  @override
  bool shouldReload(AppLocalizationsDelegate old) => false;
}
