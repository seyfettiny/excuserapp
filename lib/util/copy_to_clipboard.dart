import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../constants/app_constants.dart';
import 'get_locale.dart';

class CopyClipboard {
  static Future<void> copyToClipboard(BuildContext context, String text) async {
    await Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(GetLocale.getLocale() == 'en'
          ? AppConstants.copiedEN
          : AppConstants.copiedTR),
    ));
  }
}
