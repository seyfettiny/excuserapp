import 'package:envify/envify.dart';
part 'env.g.dart';

@Envify()
abstract class Env {
  static const bannerkey = _Env.bannerkey;
  static const interstitialkey = _Env.interstitialkey;
}
