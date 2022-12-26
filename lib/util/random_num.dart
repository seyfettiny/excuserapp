import 'dart:math';
extension RandomNum on int {
  static int random(int min, int max) {
    final random = Random();
    return min + random.nextInt(max - min);
  }
}
