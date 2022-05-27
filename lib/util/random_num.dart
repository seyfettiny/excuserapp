import 'dart:math';

class RandomNum {
  static int random(int min, int max) {
    return min + (Random().nextInt(max - min));
  }
}
