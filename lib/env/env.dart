import 'package:envify/envify.dart';
part 'env.g.dart';

@Envify()
abstract class Env {
  static const bannerkeyandroid = _Env.bannerkeyandroid;
  static const bannerkeyios = _Env.bannerkeyios;
  static const interstitialkey = _Env.interstitialkey;
}
