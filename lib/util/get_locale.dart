import 'locator.dart';

class GetLocale {
  static String getLocale() {
    var locale = locator<String>();
    locale = locale.substring(0, 2);
    return locale;
  }
}
