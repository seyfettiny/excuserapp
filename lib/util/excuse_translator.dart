import 'package:devicelocale/devicelocale.dart';
import 'package:translator/translator.dart';

import '../features/excuse/data/models/excuse_model.dart';

class ExcuseTranslator {
  final GoogleTranslator translator;

  ExcuseTranslator(this.translator);

  Future<ExcuseModel> translateModel(ExcuseModel excuse) async {
    var locale = await Devicelocale.currentLocale;
    var localeCode = locale!.substring(0, 2);
    return translator
        .translate(excuse.excuse, from: 'en', to: localeCode)
        .then((translation) {
      return excuse.copyWith(
        id: excuse.id,
        category: excuse.category,
        excuse: translation.text,
      );
    });
  }

  Future<List<String>> translateCategory(List<String> categories) async {
    var locale = await Devicelocale.currentLocale;
    var localeCode = locale!.substring(0, 2);
    List<String> result = [];
    for (var element in categories) {
      result.add(await translator
          .translate(element, from: 'en', to: localeCode)
          .then((translation) {
        return translation.text;
      }));
    }
    return result;
  }

  Future<String> translateText(String text) async {
    var locale = await Devicelocale.currentLocale;
    var localeCode = locale!.substring(0, 2);
    return translator
        .translate(text, from: 'en', to: localeCode)
        .then((translation) {
      return translation.text;
    });
  }
}
