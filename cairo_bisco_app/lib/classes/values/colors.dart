import 'package:cairo_bisco_app/classes/values/constants.dart';
import 'package:flutter/material.dart';

class KelloggColors {
  static const Color darkRed = Color(0xff96162d);
  static const Color orange = Color(0xffef3423);
  static const Color cockRed = Color(0xffcf1648);
  static const Color clearRed = Color(0xffe0002b);
  static const Color yellow = Color(0xffeeae32);
  static const Color white = Color(0xffffffff);
  static const Color successGreen = Color(0xff34ff00);
  static const Color green = Color(0xff07984c);
  static const Color darkBlue = Color(0xff0249ae);
  static const Color grey = Color(0xffA7A7A7);

  static Color getGradient1(int type) {
    switch (type) {
      case PRODUCTION_REPORT:
        return orange;
      case QFS_REPORT:
        return cockRed;
      case EHS_REPORT:
        return grey;
      case OVERWEIGHT_REPORT:
        return grey;
      case PEOPLE_REPORT:
        return grey;
      case NRC_REPORT:
        return grey;
    }
    return white;
  }

  static Color getGradient2(int type) {
    switch (type) {
      case PRODUCTION_REPORT:
        return yellow;
      case QFS_REPORT:
        return grey;
      case EHS_REPORT:
        return cockRed;
      case OVERWEIGHT_REPORT:
        return darkBlue;
      case PEOPLE_REPORT:
        return orange;
      case NRC_REPORT:
        return white;
    }
    return white;
  }

  static Color getBaseColor(int type) {
    switch (type) {
      case PRODUCTION_REPORT:
        return yellow.withOpacity(0.5);
      case QFS_REPORT:
        return green.withOpacity(0.5);
      case EHS_REPORT:
        return cockRed.withOpacity(0.5);
      case OVERWEIGHT_REPORT:
        return cockRed.withOpacity(0.5);
      case PEOPLE_REPORT:
        return yellow.withOpacity(0.5);
      case NRC_REPORT:
        return darkBlue.withOpacity(0.5);
    }
    return white;
  }
}
