import 'dart:math';
extension RandomNum on int {
  static int random(int min, int max) {
    final _random = Random();
    return min + _random.nextInt(max - min);
  }
}
