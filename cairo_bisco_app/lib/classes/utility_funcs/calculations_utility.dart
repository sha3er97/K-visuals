import 'dart:math';

import 'package:cairo_bisco_app/classes/MiniProductionReport.dart';
import 'package:cairo_bisco_app/classes/NRCReport.dart';
import 'package:cairo_bisco_app/classes/PeopleReport.dart';
import 'package:cairo_bisco_app/classes/Plans.dart';
import 'package:cairo_bisco_app/classes/QfsReport.dart';
import 'package:cairo_bisco_app/classes/values/constants.dart';

import '../EhsReport.dart';
import '../SKU.dart';
import 'date_utility.dart';

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
  return ((calculateAllScrap(refNum, report) - target) /
          SKU.skuDetails[report.skuName]!.cartonWeight) *
      SKU.skuDetails[report.skuName]!.rm_cost;
}

double calculatePmMUV(int refNum, report) {
  if (report.productionInCartons == 0) return 0.0;
  //todo :: check the equation
  double target = calculateAllUsedFilmWaste(report) *
      (SKU.skuDetails[report.skuName]!.targetFilmWaste / 100);
  return (calculateAllWastedFilmWaste(report) - target) *
      SKU.skuDetails[report.skuName]!.pm_cost;
}

double calculateWastePercent(double used, double wasted) {
  return (wasted / used) * 100;
}

double calculateScrapPercent(
  MiniProductionReport report,
  double matchedOverWeight,
) {
  return report.scrap *
      100 /
      calculateAllWeightFromMiniReport(report, matchedOverWeight);
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
  return report.mc1FilmUsed + report.mc2FilmUsed;
}

double calculateAllWastedFilmWaste(report) {
  return report.mc1WasteKg + report.mc2WasteKg;
}

double calculateAllScrap(refNum, report) {
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

double calculateAllRework(refNum, report) {
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
  theoreticals,
) {
  return theoreticals[report.line_index - 1] *
      ((report.shiftHours - minutesToHours(report.wastedMinutes)) /
          standardShiftHours);
}

/*************************OEE calculations*********************************/
double calculateOeeFromOriginalReport(
  report,
  theoreticalKg,
  int refNum,
  double matchedOverWeight,
) {
  return calculateRateFromOriginalReport(
          report, theoreticalKg, refNum, matchedOverWeight) *
      calculateQualityFromOriginalReport(report, refNum, matchedOverWeight) *
      calculateAvailabilityFromOriginalReport(report) *
      100;
}

double calculateAvailabilityFromOriginalReport(report) {
  return report.shiftHours == 0.0
      ? 0.0
      : (report.shiftHours - minutesToHours(report.wastedMinutes)) /
          report.shiftHours;
}

double calculateRateFromOriginalReport(
  report,
  theoreticalKg,
  int refNum,
  double matchedOverWeight,
) {
  return theoreticalKg == 0.0
      ? 0.0
      : calculateAllWeightFromOriginalReport(
              refNum, report, matchedOverWeight) /
          theoreticalKg;
}

double calculateQualityFromOriginalReport(
  report,
  int refNum,
  double matchedOverWeight,
) {
  double totWeight =
      calculateAllWeightFromOriginalReport(refNum, report, matchedOverWeight);
  return totWeight == 0.0
      ? 0.0
      : calculateProductionKg(report, report.productionInCartons) / totWeight;
}

/***********************************/
double calculateOeeFromMiniReport(
  MiniProductionReport report,
  double matchedOverWeight,
) {
  // return (report.productionInKg.toDouble() / report.theoreticalAverage) * 100;
  return calculateRate(report, matchedOverWeight) *
      calculateQuality(report, matchedOverWeight) *
      calculateAvailability(report) *
      100;
}

double calculateAvailability(MiniProductionReport report) {
  return report.plannedHours == 0.0
      ? 0.0
      : (report.plannedHours - minutesToHours(report.wastedMinutes)) /
          report.plannedHours;
}

double calculateRate(
  MiniProductionReport report,
  double matchedOverWeight,
) {
  return report.theoreticalAverage == 0.0
      ? 0.0
      : calculateAllWeightFromMiniReport(report, matchedOverWeight) /
          report.theoreticalAverage;
}

double calculateQuality(
  MiniProductionReport report,
  double matchedOverWeight,
) {
  double totWeight =
      calculateAllWeightFromMiniReport(report, matchedOverWeight);
  return totWeight == 0.0 ? 0.0 : report.productionInKg / totWeight;
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
