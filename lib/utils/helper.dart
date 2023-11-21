import 'dart:math';
import 'dart:ui';

class Helper {

  static Color randomColor() {
    Random rd = Random();
    return Color.fromRGBO(
        rd.nextInt(255),
        rd.nextInt(255),
        rd.nextInt(255),
        1,
    );
  }
}