import 'dart:math';

import 'package:cairo_bisco_app/classes/MiniProductionReport.dart';
import 'package:cairo_bisco_app/classes/NRCReport.dart';
import 'package:cairo_bisco_app/classes/PeopleReport.dart';
import 'package:cairo_bisco_app/classes/Plans.dart';
import 'package:cairo_bisco_app/classes/QfsReport.dart';
import 'package:cairo_bisco_app/classes/values/constants.dart';

import '../EhsReport.dart';
import '../SKU.dart';

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
double calculateMPSA(int plan, int cartons) {
  if (cartons == 0) return 0.0;
  // return ((plan - cartons).abs().toDouble() * 100) / max(plan, cartons);
  return (min(plan, cartons).toDouble() * 100) / max(plan, cartons);
}

double calculateOeeFromMiniReport(MiniProductionReport report) {
  return (report.productionInKg.toDouble() / report.theoreticalAverage) * 100;
}

double calculateScrapMoney(double scrap) {
  return scrap * Plans.scrapKgCost;
}

double calculateWastePercent(double used, double wasted) {
  return (wasted / used) * 100;
}

double calculateScrapPercent(MiniProductionReport report) {
  return report.scrap *
      100 /
      (report.scrap + report.rework + report.productionInKg);
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

double calculateAllWeight(refNum, report) {
  return calculateAllRework(refNum, report) +
      calculateAllScrap(refNum, report) +
      report.productionInCartons * SKU.skuDetails[report.skuName]!.cartonWeight;
}

double calculateOeeFromOriginalReport(report, theoreticalKg) {
  return (calculateProductionKg(report) / theoreticalKg) * 100;
}

double calculateOeeFromRawNumbers(prodKg, theoreticalKg) {
  return (prodKg / theoreticalKg) * 100;
}

double calculateProductionKg(report) {
  return (report.productionInCartons *
      SKU.skuDetails[report.skuName]!.cartonWeight);
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

bool BadProductionDriver(MiniProductionReport report) {
  bool noWork = report.productionInCartons == 0;
  if (noWork)
    return false;
  else
    return calculateMPSA(
                report.shiftProductionPlan, report.productionInCartons) <
            Plans.mpsaTarget ||
        calculateOeeFromMiniReport(report) < Plans.targetOEE;
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
