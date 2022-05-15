import 'package:envify/envify.dart';
part 'env.g.dart';

@Envify()
abstract class Env {
  static const bannerkey = _Env.key;
  static const interstitialkey = _Env.key;
}
