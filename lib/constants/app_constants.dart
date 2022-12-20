import 'dart:io';
import 'dart:ui';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AppConstants {
  static const gradientBgColorPairs = [
    [Color(0xFF12c2e9), Color(0xFFc471ed), Color(0xFFf64f59)],
    [Color(0xFF373B44), Color(0xFF4286f4)],
    [Color(0xFFFF0099), Color(0xFF493240)],
    [Color(0xFF1f4037), Color(0xFF99f2c8)],
    [Color(0xFF91EAE4), Color(0xFF86A8E7), Color(0xFF7F7FD5)],
    [Color(0xFF240b36), Color(0xFF240b36)],
    [Color(0xFFf12711), Color(0xFFf5af19)],
    [Color(0xFF6be585), Color(0xFFdd3e54)],
    [Color(0xFF8360c3), Color(0xFF2ebf91)],
    [Color(0xFF654ea3), Color(0xFFeaafc8)],
    [Color(0xFF333333), Color(0xFFdd1818)],
    [Color(0xFFb20a2c), Color(0xFFfffbd5)],
  ];
  static final BannerAd bannerAd = BannerAd(
    //ca-app-pub-3940256099942544/6300978111
    adUnitId: Platform.isAndroid
        ? 'ca-app-pub-3940256099942544/6300978111'
        : dotenv.env['BANNER_KEY_IOS']!,
    size: AdSize.banner,
    request: const AdRequest(),
    listener: const BannerAdListener(),
  );
  static const categoriesEN = [
    'Family',
    'Office',
    'Children',
    'College',
    'Party',
  ];
  static const categoriesTR = [
    'Aile',
    'Ofis',
    'Çocuklar',
    'Okul',
    'Parti',
  ];
  static const String copiedEN = 'Copied to clipboard';
  static const String copiedTR = 'Kopyalandı';
  static const String anotherExcuseEN = 'Another excuse';
  static const String anotherExcuseTR = 'Başka bir bahane';
}
