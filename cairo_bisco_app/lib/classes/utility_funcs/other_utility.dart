import 'package:cairo_bisco_app/classes/Credentials.dart';
import 'package:cairo_bisco_app/classes/MiniProductionReport.dart';
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
  if (Credentials.isUserKws)
    return true;
  else if (Credentials.isUserOwner && inEditPeriod(day, month, year))
    return true;
  else {
    if (supName.compareTo(Credentials.getUserName()) == 0 &&
        inEditPeriod(day, month, year))
      return true;
    else
      return false;
  }
}

double getCorrespondingOverweightToProdReport(
    prodReport, List<OverWeightReport> overweightList) {
  double out = 99.9;
  for (OverWeightReport report in overweightList) {
    if (report.day == prodReport.day &&
        report.month == prodReport.month &&
        report.line_index == prodReport.line_index &&
        report.year == prodReport.year) {
      if (report.skuName.compareTo(prodReport.skuName) == 0 || out == 99.9) {
        out = report.percent;
      }
      //return report.percent;
    }
  }
  //return 99.9;
  return out;
}

bool doesProdReportHaveCorrespondingOverweight(
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

double getCorrespondingOverweightToMiniReport(
    MiniProductionReport prodReport, List<OverWeightReport> overweightList) {
  double out = 99.9;

  for (OverWeightReport report in overweightList) {
    if (report.day == prodReport.day &&
        report.month == prodReport.month &&
        report.year == prodReport.year) {
      if (report.skuName.compareTo(prodReport.skuName) == 0 || out == 99.9) {
        out = report.percent;
      }
      //return report.percent;
    }
  }
//return 99.9;
  return out;
}

bool doesMiniReportHaveCorrespondingOverweight(
    MiniProductionReport prodReport, List<OverWeightReport> overweightList) {
  for (OverWeightReport report in overweightList) {
    if (report.day == prodReport.day &&
        report.month == prodReport.month &&
        report.year == prodReport.year) {
      return true;
    }
  }
  return false;
}

bool intFilterCheck(
  int reportValue,
  int valueToCheck,
  int totalCode,
) {
  return (valueToCheck != totalCode && reportValue == valueToCheck) ||
      valueToCheck == totalCode;
}

bool stringFilterCheck(
  String reportValue,
  String valueToCheck,
  String totalCode,
) {
  bool isTotal = valueToCheck.compareTo(totalCode) == 0;
  return (!isTotal && reportValue.compareTo(valueToCheck) == 0) || isTotal;
}
