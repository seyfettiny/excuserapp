import 'package:excuserapp/util/get_locale.dart';
import 'package:excuserapp/util/locator.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  setUpAll(() async {
    dotenv.testLoad(fileInput: '''API_URL=url
                API_KEY=key''');

    setupLocator();
  });
  test('getLocale', () {
    final result = GetLocale.getLocale();
    expect(result, 'en');
  });
}
