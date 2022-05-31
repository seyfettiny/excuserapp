import 'package:envify/envify.dart';

part 'env.g.dart';

@Envify()
abstract class Env {
  static const bannerKeyAndroid = _Env.bannerKeyAndroid;
  static const bannerKeyIos = _Env.bannerKeyIos;
  static const interstitialKey = _Env.interstitialKey;
  static const apiUrl = _Env.apiUrl;
  static const apiKey = _Env.apiKey;
}
