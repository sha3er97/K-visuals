import 'package:cairo_bisco_app/classes/Credentials.dart';
import 'package:cairo_bisco_app/classes/values/constants.dart';

import 'date_utility.dart';

int getRefIdx(int type, int refNum) {
  if (type == PRODUCTION_REPORT && refNum == BISCUIT_AREA)
    return 0;
  else if (type == PRODUCTION_REPORT && refNum == WAFER_AREA)
    return 1;
  else if (type == PRODUCTION_REPORT && refNum == MAAMOUL_AREA)
    return 2;
  else
    return type;
}

bool canEditThisReport(String supName, int day, int month, int year) {
  if (Credentials.isUserOwner)
    return true;
  else {
    if (supName.compareTo(Credentials.getUserName()) == 0 &&
        inEditPeriod(day, month, year))
      return true;
    else
      return false;
  }
}
