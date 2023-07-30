import 'dart:io';
import 'dart:ui';

import '../constants/app_constants.dart';

class GetLocale {
  static String getLocale() {
    var locale = Locale(Platform.localeName);
    var supportedLocales = AppConstants.supportedLocales.values.toList();

    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.toString().compareTo(locale.toString()) == 0) {
        return supportedLocale.languageCode;
      }
    }
    return 'en';
  }
}
