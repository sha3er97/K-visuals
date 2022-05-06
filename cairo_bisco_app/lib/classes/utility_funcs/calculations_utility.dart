import 'dart:math';

import 'package:cairo_bisco_app/classes/Credentials.dart';
import 'package:cairo_bisco_app/classes/MiniProductionReport.dart';
import 'package:cairo_bisco_app/classes/NRCReport.dart';
import 'package:cairo_bisco_app/classes/PeopleReport.dart';
import 'package:cairo_bisco_app/classes/Plans.dart';
import 'package:cairo_bisco_app/classes/QfsReport.dart';
import 'package:cairo_bisco_app/classes/values/constants.dart';

import '../EhsReport.dart';
import '../SKU.dart';
import 'date_time_utility.dart';

double parseJsonToDouble(dynamic dAmount) {
  double returnAmount = 0.00;
  String strAmount;

  try {
    if (dAmount == null || dAmount == 0) return 0.0;

    strAmount = dAmount.toString();

    // if (strAmount.contains('.')) {
    returnAmount = double.parse(strAmount);
    //} // Didn't need else since the input was either 0, an integer or a double
  } catch (e) {
    print('Error :: exception caught during json parse');
    return 0.000;
  }

  return returnAmount;
}

/***************************KPIS Calculator***********************************************/
double calculateMPSA(num plan, num done) {
  return (min(plan, done).toDouble() * 100) / max(plan, done);
}

double calculateRmMUV(int refNum, report, double matchedOverWeight) {
  if (report.productionInCartons == 0) return 0.0;
  //todo :: check the equation
  double target =
      calculateAllWeightFromOriginalReport(refNum, report, matchedOverWeight) *
          (SKU.skuDetails[report.skuName]!.targetScrap / 100);
  double res = ((calculateAllScrap(refNum, report) - target) /
          SKU.skuDetails[report.skuName]!.cartonWeight) *
      SKU.skuDetails[report.skuName]!.rm_cost;
  return double.parse(res.toStringAsFixed(2));
}

double calculatePmMUV(int refNum, report) {
  if (report.productionInCartons == 0) return 0.0;
  //todo :: check the equation
  double target = calculateAllUsedFilmWaste(report) *
      (SKU.skuDetails[report.skuName]!.targetFilmWaste / 100);
  double res = (calculateAllWastedFilmWaste(report) - target) *
      SKU.skuDetails[report.skuName]!.pm_cost;
  return double.parse(res.toStringAsFixed(2));
}

double calculateWastePercent(double used, double wasted) {
  double res = (wasted / used) * 100;
  return double.parse(res.toStringAsFixed(1));
}

double calculateScrapPercentFromMiniReport(
  MiniProductionReport report,
  double matchedOverWeight,
) {
  double res = report.scrap *
      100 /
      calculateAllWeightFromMiniReport(report, matchedOverWeight);
  return double.parse(res.toStringAsFixed(1));
}

double calculateReworkPercentFromMiniReport(
  MiniProductionReport report,
  double matchedOverWeight,
) {
  double res = report.rework *
      100 /
      calculateAllWeightFromMiniReport(report, matchedOverWeight);
  return double.parse(res.toStringAsFixed(1));
}

double calculateScrapPercentFromOriginalReport(
  int refNum,
  report,
  double matchedOverWeight,
) {
  double res = (calculateAllScrap(refNum, report) *
      100 /
      calculateAllWeightFromOriginalReport(refNum, report, matchedOverWeight));
  return double.parse(res.toStringAsFixed(1));
}

double calculateReworkPercentFromOriginalReport(
  int refNum,
  report,
  double matchedOverWeight,
) {
  double res = (calculateAllRework(refNum, report) *
      100 /
      calculateAllWeightFromOriginalReport(refNum, report, matchedOverWeight));
  return double.parse(res.toStringAsFixed(1));
}

String calculateDifferenceInCartonsTarget(MiniProductionReport report) {
  bool noWork = report.productionInCartons == 0;
  bool prodTargetDone =
      noWork || report.productionInCartons - report.shiftProductionPlan >= 0;
  return (prodTargetDone ? "" : "-") +
      (report.productionInCartons - report.shiftProductionPlan)
          .abs()
          .toString() +
      " C";
}
/*************************** utility functions ***********************************************/

double calculateAllUsedFilmWaste(report) {
  return report.mc1FilmUsed +
      report.mc2FilmUsed +
      report.mc3FilmUsed +
      report.mc4FilmUsed;
}

double calculateAllWastedFilmWaste(report) {
  return report.mc1WasteKg +
      report.mc2WasteKg +
      report.mc3WasteKg +
      report.mc4WasteKg;
}

double calculateAllScrap(int refNum, report) {
  switch (refNum) {
    case BISCUIT_AREA:
      return report.cutterScrap +
          report.packingScrap +
          report.conveyorScrap +
          report.ovenScrap +
          report.extrusionScrap;
    case WAFER_AREA:
      return report.cutterScrap +
          report.packingScrap +
          report.coolerScrap +
          report.creamScrap +
          report.ovenScrap;
    case MAAMOUL_AREA:
      return report.mixerScrap +
          report.packingScrap +
          report.stampingScrap +
          report.ovenScrap;
  }
  return 0;
}

double calculateAllRework(int refNum, report) {
  switch (refNum) {
    case BISCUIT_AREA:
      return report.packingRework +
          report.conveyorRework +
          report.cutterRework +
          report.ovenRework +
          report.extrusionRework;
    case WAFER_AREA:
      return report.packingRework +
          report.coolerRework +
          report.creamRework +
          report.cutterRework +
          report.ovenRework;
    case MAAMOUL_AREA:
      return report.packingRework +
          report.mixerRework +
          report.stampingRework +
          report.ovenRework;
  }
  return 0;
}

double calculateAllWeightFromOriginalReport(
  int refNum,
  report,
  double matchedOverWeight,
) {
  double allWeight = calculateAllRework(refNum, report) +
      calculateAllScrap(refNum, report) +
      calculateProductionKg(report, report.productionInCartons);
  return allWeight * (matchedOverWeight / 100) + allWeight;
}

double calculateAllWeightFromMiniReport(
  MiniProductionReport report,
  double matchedOverWeight,
) {
  double allWeight = report.scrap + report.rework + report.productionInKg;
  return allWeight * (matchedOverWeight / 100) + allWeight;
}

double calculateProductionKg(report, int cartons) {
  if (cartons == 0) return 0.0;
  return (cartons * SKU.skuDetails[report.skuName]!.cartonWeight);
}

double calculateNetTheoreticalOfReport(
  report,
  simpleTheoreticals,
) {
  double res, theo;
  if (Credentials.isSimpleCalculation) {
    theo = simpleTheoreticals[report.line_index - 1];
  } else {
    theo = getTheoreticalOfReport(report) *
        SKU.skuDetails[report.skuName]!.pieceWeight *
        60 * //60 mins/hr
        standardShiftHours /
        1000; //gm --> kg
  }
  res = theo *
      ((report.shiftHours - minutesToHours(report.wastedMinutes)) /
          standardShiftHours);
  return double.parse(res.toStringAsFixed(1));
}

double getTheoreticalOfReport(report) {
  double temp = 0;
  if (report.mc1Speed != 0) {
    temp += SKU.getMachineTheoretical(
        report.mc1Type, report.skuName, report.line_index);
  }
  if (report.mc2Speed != 0) {
    temp += SKU.getMachineTheoretical(
        report.mc2Type, report.skuName, report.line_index);
  }
  if (report.mc3Speed != 0) {
    temp += SKU.getMachineTheoretical(
        report.mc3Type, report.skuName, report.line_index);
  }
  if (report.mc4Speed != 0) {
    temp += SKU.getMachineTheoretical(
        report.mc4Type, report.skuName, report.line_index);
  }
  return temp;
}

double calculateOverweightKgFromOriginalReport(
    report, double matchedOverWeight) {
  double res = (calculateProductionKg(report, report.productionInCartons) *
      (matchedOverWeight / 100));
  return double.parse(res.toStringAsFixed(1));
}

double calculateOverweightKgFromMiniReport(
    MiniProductionReport report, double matchedOverWeight) {
  double res = report.productionInKg * (matchedOverWeight / 100);
  return double.parse(res.toStringAsFixed(1));
}

/*************************OEE calculations*********************************/
double calculateOeeFromOriginalReport(
  report,
  theoreticalKg,
  int refNum,
  double matchedOverWeight,
) {
  double res = calculateRateFromOriginalReport(
          report, theoreticalKg, refNum, matchedOverWeight) *
      calculateQualityFromOriginalReport(report, refNum, matchedOverWeight) *
      calculateAvailabilityFromOriginalReport(report) *
      100;
  return double.parse(res.toStringAsFixed(1));
}

double calculateAvailabilityFromOriginalReport(report) {
  double res = (report.shiftHours - minutesToHours(report.wastedMinutes)) /
      report.shiftHours;
  return report.shiftHours == 0.0 ? 0.0 : double.parse(res.toStringAsFixed(2));
}

double calculateRateFromOriginalReport(
  report,
  theoreticalKg,
  int refNum,
  double matchedOverWeight,
) {
  double res =
      calculateAllWeightFromOriginalReport(refNum, report, matchedOverWeight) /
          theoreticalKg;
  return theoreticalKg == 0.0 ? 0.0 : double.parse(res.toStringAsFixed(2));
}

double calculateQualityFromOriginalReport(
  report,
  int refNum,
  double matchedOverWeight,
) {
  double totWeight =
      calculateAllWeightFromOriginalReport(refNum, report, matchedOverWeight);
  double res =
      calculateProductionKg(report, report.productionInCartons) / totWeight;
  return totWeight == 0.0 ? 0.0 : double.parse(res.toStringAsFixed(2));
}

/***********************************/
double calculateOeeFromMiniReport(
  MiniProductionReport report,
  double matchedOverWeight,
) {
  // return (report.productionInKg.toDouble() / report.theoreticalAverage) * 100;
  double res = calculateRate(report, matchedOverWeight) *
      calculateQuality(report, matchedOverWeight) *
      calculateAvailability(report) *
      100;
  return double.parse(res.toStringAsFixed(1));
}

double calculateAvailability(MiniProductionReport report) {
  double res = (report.plannedHours - minutesToHours(report.wastedMinutes)) /
      report.plannedHours;
  return report.plannedHours == 0.0
      ? 0.0
      : double.parse(res.toStringAsFixed(2));
}

double calculateRate(
  MiniProductionReport report,
  double matchedOverWeight,
) {
  double res = calculateAllWeightFromMiniReport(report, matchedOverWeight) /
      report.theoreticalAverage;
  return report.theoreticalAverage == 0.0
      ? 0.0
      : double.parse(res.toStringAsFixed(2));
}

double calculateQuality(
  MiniProductionReport report,
  double matchedOverWeight,
) {
  double totWeight =
      calculateAllWeightFromMiniReport(report, matchedOverWeight);
  double res = report.productionInKg / totWeight;
  return totWeight == 0.0 ? 0.0 : double.parse(res.toStringAsFixed(2));
}

/************************************DRIVERS*************************************************/
bool BadQFSDriver(QfsReport report) {
  return report.quality_incidents > 0 || report.food_safety_incidents > 0;
}

bool BadEHSDriver(EhsReport report) {
  return report.recordable_incidents > 0 ||
      report.firstAid_incidents > 0 ||
      report.lostTime_incidents > 0;
}

bool BadProductionDriver(
  MiniProductionReport report,
  double matchedOverWeight,
) {
  bool noWork = report.productionInCartons == 0;
  if (noWork)
    return false;
  else
    return calculateMPSA(report.planInKg, report.productionInKg) <
            Plans.mpsaTarget ||
        calculateOeeFromMiniReport(report, matchedOverWeight) < Plans.targetOEE;
}

bool BadPeopleDriver(PeopleReport report) {
  return (1 - (report.attended_people.toDouble() / report.original_people)) *
          100 >
      Plans.target_absence;
}

bool BadNRCDriver(NRCReport report) {
  return report.notes_count > 0;
}

bool BadFinanceDriver(MiniProductionReport report) {
  bool isTotal = report.skuName.compareTo('total') == 0;

  bool noWork = report.productionInCartons == 0;
  if (noWork || isTotal)
    return false;
  else
    return report.scrap < SKU.skuDetails[report.skuName]!.targetScrap;
}

bool BadOverweightDriver(double overweight) {
  return overweight > Plans.targetOverWeightAbove;
}

bool BadNearMissIndicator(int nearMiss, int days_in_interval) {
  return nearMiss.toDouble() <=
      (Plans.monthlyNearMissTarget.toDouble() / monthDays) * days_in_interval;
}
