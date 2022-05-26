import 'dart:io';

import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../../../env/env.dart';

class AppConstants {
  static const backgrounds = [
    'assets/images/2.png',
    'assets/images/5.jpg',
    'assets/images/13.jpg',
    'assets/images/16.jpg',
    'assets/images/21.jpg',
    'assets/images/31.jpg',
    'assets/images/45.jpg',
  ];
  static const categories = [
    'Family',
    'Office',
    'Children',
    'Colleague',
    'Party',
  ];
  static final BannerAd bannerAd = BannerAd(
    //ca-app-pub-3940256099942544/6300978111
    adUnitId: Platform.isAndroid
        ? 'ca-app-pub-3940256099942544/6300978111'
        : Env.bannerKeyIos,
    size: AdSize.banner,
    request: const AdRequest(),
    listener: const BannerAdListener(),
  );
}
