import 'package:cairo_bisco_app/classes/values/constants.dart';

int getRefIdx(int type, int refNum) {
  if (type == PRODUCTION_REPORT && refNum == BISCUIT_AREA)
    return 0;
  else if (type == PRODUCTION_REPORT && refNum == WAFER_AREA)
    return 1;
  else if (type == PRODUCTION_REPORT && refNum == WAFER_AREA)
    return 2;
  else
    return type;
}
