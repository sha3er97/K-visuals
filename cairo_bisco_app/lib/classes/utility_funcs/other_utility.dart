import 'package:cairo_bisco_app/classes/Credentials.dart';
import 'package:cairo_bisco_app/classes/OverWeightReport.dart';
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

double getCorrespondingOverweight(
    prodReport, List<OverWeightReport> overweightList) {
  if (doesHaveCorrespondingOverweight(prodReport, overweightList)) {
    for (OverWeightReport report in overweightList) {
      if (report.day == prodReport.day &&
          report.month == prodReport.month &&
          report.line_index == prodReport.line_index &&
          report.year == prodReport.year) {
        print(report.day.toString() +
            " " +
            report.month.toString() +
            " " +
            report.line_index.toString() +
            " " +
            report.year.toString() +
            " " +
            report.percent.toString());
        return report.percent;
      }
    }
  }
  return 99.9;
}

bool doesHaveCorrespondingOverweight(
    prodReport, List<OverWeightReport> overweightList) {
  for (OverWeightReport report in overweightList) {
    if (report.day == prodReport.day &&
        report.month == prodReport.month &&
        report.line_index == prodReport.line_index &&
        report.year == prodReport.year) {
      return true;
    }
  }
  return false;
}
