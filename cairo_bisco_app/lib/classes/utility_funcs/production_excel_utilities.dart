import 'dart:io';

import 'package:cairo_bisco_app/classes/BiscuitsReport.dart';
import 'package:cairo_bisco_app/classes/MaamoulReport.dart';
import 'package:cairo_bisco_app/classes/MiniProductionReport.dart';
import 'package:cairo_bisco_app/classes/OverWeightReport.dart';
import 'package:cairo_bisco_app/classes/SKU.dart';
import 'package:cairo_bisco_app/classes/WaferReport.dart';
import 'package:cairo_bisco_app/classes/utility_funcs/calculations_utility.dart';
import 'package:cairo_bisco_app/classes/utility_funcs/date_utility.dart';
import 'package:cairo_bisco_app/classes/values/constants.dart';
import 'package:cairo_bisco_app/classes/values/form_values.dart';
import 'package:cairo_bisco_app/components/alert_dialog.dart';
import 'package:cross_file/cross_file.dart';
import 'package:excel/excel.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:permission_handler/permission_handler.dart';

import 'other_utility.dart';

class ProductionExcelUtilities {
  static var excel;
  late Sheet sheetObject;
  final int refNum;
  late String areaName;
  late List<OverWeightReport> overweightList;

  ProductionExcelUtilities({required this.refNum}) {
    excel = Excel.createExcel(); // automatically creates 1 empty sheet: Sheet1
    areaName = refNum != TOTAL_PLANT ? prodType[refNum] : "Total";
    sheetObject = excel[areaName];
    excel.delete('Sheet1');
  }

  void setOverweightList(List<OverWeightReport> overweightList) {
    this.overweightList = overweightList;
  }

  Future<void> saveExcelFile(
    context,
    String from_day,
    String to_day,
    String from_month,
    String to_month,
  ) async {
    String fileName =
        "$areaName report $from_day-$from_month to $to_day-$to_month.xlsx";
    if (kIsWeb) {
      // running on the web!
      // io.File file;
      excel.encode().then((onValue) {
        // file = io.File(fileName);
        // final rawData = file.readAsBytesSync();
        // final content = base64Encode(onValue);
        final format =
            "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";
        // final format = "application/vnd.ms-excel";
        /***********************************************************/
        // final blob = html.Blob([onValue], format);
        // final url = html.Url.createObjectUrlFromBlob(blob);
        //
        // final anchor = html.document.createElement('a') as html.AnchorElement
        //   ..href = url
        //   ..style.display = 'none'
        //   ..download = fileName;
        // html.document.body?.children.add(anchor);
        //
        // anchor.click();
        //
        // html.document.body?.children.remove(anchor);
        // html.Url.revokeObjectUrl(url);
        /****************************************************************/
        // final anchor = html.AnchorElement(href: "$format,$onValue")
        //   ..setAttribute("download", fileName);
        // anchor.click();
        // anchor.remove();
        XFile.fromData(onValue, mimeType: format, name: fileName)
            .saveTo(fileName);
      });
    } else {
      // NOT running on the web! You can check for additional platforms here.
      if (await Permission.storage.request().isGranted) {
        fileName = "/storage/emulated/0/Download/" + 'K visuals/' + fileName;
        excel.encode().then((onValue) {
          File(fileName)
            ..createSync(recursive: true)
            ..writeAsBytesSync(onValue);
        });
      }
    }
    showExcelAlertDialog(context, true, fileName);
  }

  void insertHeaders() {
    switch (refNum) {
      case BISCUIT_AREA:
        sheetObject.insertRowIterables(biscuitsHeaders, 0);
        break;
      case WAFER_AREA:
        sheetObject.insertRowIterables(waferHeaders, 0);
        break;
      case MAAMOUL_AREA:
        sheetObject.insertRowIterables(maamoulHeaders, 0);
        break;
      case TOTAL_PLANT:
        sheetObject.insertRowIterables(totalPlantHeaders, 0);
        break;
    }
  }

  void insertBiscuitReportRows(
    List<BiscuitsReport> reportsList,
  ) {
    double totTheoreticals = 0.0,
        totKg = 0.0,
        totRework = 0.0,
        totExtrusionRework = 0.0,
        totExtrusionScrap = 0.0,
        totOvenRework = 0.0,
        totOvenScrap = 0.0,
        totCutterRework = 0.0,
        totCutterScrap = 0.0,
        totConvRework = 0.0,
        totConvScrap = 0.0,
        totPackingRework = 0.0,
        totPackingScrap = 0.0,
        totBoxesWaste = 0.0,
        totCartonWaste = 0.0,
        totMc1Waste = 0.0,
        totMc2Waste = 0.0,
        totMc1Used = 0.0,
        totMc2Used = 0.0,
        avgOverweight = 0.0,
        totScrap = 0.0,
        totWeight = 0.0,
        avgOEE = 0.0;
    int totCartons = 0;
    for (BiscuitsReport report in reportsList) {
      final theoreticals = [
        SKU.skuDetails[report.skuName]!.theoreticalShiftProd1,
        SKU.skuDetails[report.skuName]!.theoreticalShiftProd2,
        SKU.skuDetails[report.skuName]!.theoreticalShiftProd3,
        SKU.skuDetails[report.skuName]!.theoreticalShiftProd4
      ];
      double matchedOverWeight = doesProdReportHaveCorrespondingOverweight(
              report, this.overweightList)
          ? getCorrespondingOverweightToProdReport(report, this.overweightList)
          : 0.0;
      /////////////////////////////////////////////////////////////
      totTheoreticals += theoreticals[report.line_index - 1];
      totKg += calculateProductionKg(report, report.productionInCartons);
      totRework += calculateAllRework(refNum, report);
      totExtrusionRework += report.extrusionRework;
      totExtrusionScrap += report.extrusionScrap;
      totOvenRework += report.ovenRework;
      totOvenScrap += report.ovenScrap;
      totCutterRework += report.cutterRework;
      totCutterScrap += report.cutterScrap;
      totConvRework += report.conveyorRework;
      totConvScrap += report.conveyorScrap;
      totPackingRework += report.packingRework;
      totPackingScrap += report.packingScrap;
      totBoxesWaste += report.boxesWaste;
      totCartonWaste += report.cartonWaste;
      totMc1Waste += report.mc1WasteKg;
      totMc1Used += report.mc1FilmUsed;
      totMc2Waste += report.mc2WasteKg;
      totMc2Used += report.mc2FilmUsed;
      avgOverweight =
          doesProdReportHaveCorrespondingOverweight(report, this.overweightList)
              ? (avgOverweight == 0.0
                  ? getCorrespondingOverweightToProdReport(
                      report, this.overweightList)
                  : (avgOverweight +
                          getCorrespondingOverweightToProdReport(
                              report, this.overweightList)) /
                      2)
              : avgOverweight;
      avgOEE = (avgOEE == 0.0
          ? calculateOeeFromOriginalReport(
              report,
              calculateNetTheoreticalOfReport(report, theoreticals),
              refNum,
              matchedOverWeight)
          : (avgOEE +
                  calculateOeeFromOriginalReport(
                      report,
                      calculateNetTheoreticalOfReport(report, theoreticals),
                      refNum,
                      matchedOverWeight)) /
              2);
      totScrap += calculateAllScrap(refNum, report);
      totWeight += calculateAllWeightFromOriginalReport(
          refNum, report, matchedOverWeight);
      totCartons += report.productionInCartons;
      /////////////////////////////////////////////////////////////

      List<String> row = [
        constructDate(report.day, report.month, report.year),
        prodType[refNum],
        (report.shift_index + 1).toString(),
        report.shiftHours.toString(),
        report.skuName,
        prod_lines4[report.line_index - 1],
        theoreticals[report.line_index - 1].toString(),
        "Kg",
        report.actualSpeed.toString(),
        calculateProductionKg(report, report.productionInCartons)
            .toStringAsFixed(1),
        calculateAllRework(refNum, report).toString(),
        report.extrusionRework.toString(),
        report.extrusionScrap.toString(),
        report.ovenRework.toString(),
        report.ovenScrap.toString(),
        report.cutterRework.toString(),
        report.cutterScrap.toString(),
        report.conveyorRework.toString(),
        report.conveyorScrap.toString(),
        report.mc1Speed.toString(),
        report.mc2Speed.toString(),
        report.packingRework.toString(),
        report.packingScrap.toString(),
        report.boxesWaste.toString(),
        report.cartonWaste.toString(),
        report.mc1WasteKg.toString(),
        calculateWastePercent(report.mc1FilmUsed, report.mc1WasteKg)
            .toStringAsFixed(1),
        report.mc2WasteKg.toString(),
        calculateWastePercent(report.mc2FilmUsed, report.mc2WasteKg)
            .toStringAsFixed(1),
        doesProdReportHaveCorrespondingOverweight(report, this.overweightList)
            ? getCorrespondingOverweightToProdReport(
                    report, this.overweightList)
                .toString()
            : "-",
        calculateAllScrap(refNum, report).toString(),
        (calculateAllRework(refNum, report) *
                100 /
                calculateAllWeightFromOriginalReport(
                    refNum, report, matchedOverWeight))
            .toStringAsFixed(1),
        (calculateAllScrap(refNum, report) *
                100 /
                calculateAllWeightFromOriginalReport(
                    refNum, report, matchedOverWeight))
            .toStringAsFixed(1),
        (calculateRateFromOriginalReport(
                    report,
                    calculateNetTheoreticalOfReport(report, theoreticals),
                    refNum,
                    matchedOverWeight) *
                100)
            .toStringAsFixed(1),
        (calculateAvailabilityFromOriginalReport(report) * 100)
            .toStringAsFixed(1),
        (calculateQualityFromOriginalReport(report, refNum, matchedOverWeight) *
                100)
            .toStringAsFixed(1),
        calculateOeeFromOriginalReport(
                report,
                calculateNetTheoreticalOfReport(report, theoreticals),
                refNum,
                matchedOverWeight)
            .toStringAsFixed(1),
        (calculateProductionKg(report, report.productionInCartons) *
                (matchedOverWeight / 100))
            .toStringAsFixed(1),
        report.productionInCartons.toString(),
        report.month.toString(),
        getWeekNumber(report.day, report.month, report.year).toString(),
        report.year.toString(),
      ];
      // print(row);
      sheetObject.appendRow(row);
    }

    List<String> tot = [
      'TOTAL',
      prodType[refNum],
      '-',
      '-',
      '-',
      '-',
      totTheoreticals.toStringAsFixed(2),
      '-',
      '-',
      totKg.toStringAsFixed(1),
      totRework.toString(),
      totExtrusionRework.toString(),
      totExtrusionScrap.toString(),
      totOvenRework.toString(),
      totOvenScrap.toString(),
      totCutterRework.toString(),
      totCutterScrap.toString(),
      totConvRework.toString(),
      totConvScrap.toString(),
      '-',
      '-',
      totPackingRework.toString(),
      totPackingScrap.toString(),
      totBoxesWaste.toString(),
      totCartonWaste.toString(),
      totMc1Waste.toStringAsFixed(1),
      calculateWastePercent(totMc1Used, totMc1Waste).toStringAsFixed(1),
      totMc2Waste.toStringAsFixed(1),
      calculateWastePercent(totMc2Used, totMc2Waste).toStringAsFixed(1),
      avgOverweight.toStringAsFixed(1),
      totScrap.toString(),
      (totRework * 100 / totWeight).toStringAsFixed(1),
      (totScrap * 100 / totWeight).toStringAsFixed(1),
      '-',
      '-',
      '-',
      avgOEE.toStringAsFixed(1),
      (totKg * (avgOverweight / 100)).toStringAsFixed(1),
      totCartons.toString(),
      '-',
      '-',
      '-',
    ];
    sheetObject.appendRow(tot);
  }

  void insertWaferReportRows(
    List<WaferReport> reportsList,
  ) {
    double totTheoreticals = 0.0,
        totKg = 0.0,
        totRework = 0.0,
        totCreamRework = 0.0,
        totCreamScrap = 0.0,
        totOvenRework = 0.0,
        totOvenScrap = 0.0,
        totCutterRework = 0.0,
        totCutterScrap = 0.0,
        totCoolerRework = 0.0,
        totCoolerScrap = 0.0,
        totPackingRework = 0.0,
        totPackingScrap = 0.0,
        totBoxesWaste = 0.0,
        totCartonWaste = 0.0,
        totMc1Waste = 0.0,
        totMc2Waste = 0.0,
        totMc1Used = 0.0,
        totMc2Used = 0.0,
        avgOverweight = 0.0,
        totScrap = 0.0,
        totWeight = 0.0,
        avgOEE = 0.0;
    int totCartons = 0;
    for (WaferReport report in reportsList) {
      final theoreticals = [
        SKU.skuDetails[report.skuName]!.theoreticalShiftProd1,
        SKU.skuDetails[report.skuName]!.theoreticalShiftProd2,
        SKU.skuDetails[report.skuName]!.theoreticalShiftProd3,
        SKU.skuDetails[report.skuName]!.theoreticalShiftProd4
      ];
      double matchedOverWeight = doesProdReportHaveCorrespondingOverweight(
              report, this.overweightList)
          ? getCorrespondingOverweightToProdReport(report, this.overweightList)
          : 0.0;
      /////////////////////////////////////////////////////////////
      totTheoreticals += theoreticals[report.line_index - 1];
      totKg += calculateProductionKg(report, report.productionInCartons);
      totRework += calculateAllRework(refNum, report);
      totCreamRework += report.creamRework;
      totCreamScrap += report.creamScrap;
      totOvenRework += report.ovenRework;
      totOvenScrap += report.ovenScrap;
      totCutterRework += report.cutterRework;
      totCutterScrap += report.cutterScrap;
      totCoolerRework += report.coolerRework;
      totCoolerScrap += report.coolerScrap;
      totPackingRework += report.packingRework;
      totPackingScrap += report.packingScrap;
      totBoxesWaste += report.boxesWaste;
      totCartonWaste += report.cartonWaste;
      totMc1Waste += report.mc1WasteKg;
      totMc1Used += report.mc1FilmUsed;
      totMc2Waste += report.mc2WasteKg;
      totMc2Used += report.mc2FilmUsed;
      avgOverweight =
          doesProdReportHaveCorrespondingOverweight(report, this.overweightList)
              ? (avgOverweight == 0.0
                  ? getCorrespondingOverweightToProdReport(
                      report, this.overweightList)
                  : (avgOverweight +
                          getCorrespondingOverweightToProdReport(
                              report, this.overweightList)) /
                      2)
              : avgOverweight;
      avgOEE = (avgOEE == 0.0
          ? calculateOeeFromOriginalReport(
              report,
              calculateNetTheoreticalOfReport(report, theoreticals),
              refNum,
              matchedOverWeight)
          : (avgOEE +
                  calculateOeeFromOriginalReport(
                      report,
                      calculateNetTheoreticalOfReport(report, theoreticals),
                      refNum,
                      matchedOverWeight)) /
              2);
      totScrap += calculateAllScrap(refNum, report);
      totWeight += calculateAllWeightFromOriginalReport(
          refNum, report, matchedOverWeight);
      totCartons += report.productionInCartons;
      /////////////////////////////////////////////////////////////
      List<String> row = [
        constructDate(report.day, report.month, report.year),
        prodType[refNum],
        (report.shift_index + 1).toString(),
        report.shiftHours.toString(),
        report.skuName,
        prod_lines4[report.line_index - 1],
        theoreticals[report.line_index - 1].toString(),
        "Kg",
        report.actualSpeed.toString(),
        calculateProductionKg(report, report.productionInCartons)
            .toStringAsFixed(1),
        calculateAllRework(refNum, report).toString(),
        report.ovenRework.toString(),
        report.ovenScrap.toString(),
        report.creamRework.toString(),
        report.creamScrap.toString(),
        report.coolerRework.toString(),
        report.coolerScrap.toString(),
        report.cutterRework.toString(),
        report.cutterScrap.toString(),
        report.mc1Speed.toString(),
        report.mc2Speed.toString(),
        report.packingRework.toString(),
        report.packingScrap.toString(),
        report.boxesWaste.toString(),
        report.cartonWaste.toString(),
        report.mc1WasteKg.toString(),
        calculateWastePercent(report.mc1FilmUsed, report.mc1WasteKg)
            .toStringAsFixed(1),
        report.mc2WasteKg.toString(),
        calculateWastePercent(report.mc2FilmUsed, report.mc2WasteKg)
            .toStringAsFixed(1),
        doesProdReportHaveCorrespondingOverweight(report, this.overweightList)
            ? getCorrespondingOverweightToProdReport(
                    report, this.overweightList)
                .toString()
            : "-",
        calculateAllScrap(refNum, report).toString(),
        (calculateAllRework(refNum, report) *
                100 /
                calculateAllWeightFromOriginalReport(
                    refNum, report, matchedOverWeight))
            .toStringAsFixed(1),
        (calculateAllScrap(refNum, report) *
                100 /
                calculateAllWeightFromOriginalReport(
                    refNum, report, matchedOverWeight))
            .toStringAsFixed(1),
        (calculateRateFromOriginalReport(
                    report,
                    calculateNetTheoreticalOfReport(report, theoreticals),
                    refNum,
                    matchedOverWeight) *
                100)
            .toStringAsFixed(1),
        (calculateAvailabilityFromOriginalReport(report) * 100)
            .toStringAsFixed(1),
        (calculateQualityFromOriginalReport(report, refNum, matchedOverWeight) *
                100)
            .toStringAsFixed(1),
        calculateOeeFromOriginalReport(
                report,
                calculateNetTheoreticalOfReport(report, theoreticals),
                refNum,
                matchedOverWeight)
            .toStringAsFixed(1),
        (calculateProductionKg(report, report.productionInCartons) *
                (matchedOverWeight / 100))
            .toStringAsFixed(1),
        report.productionInCartons.toString(),
        report.month.toString(),
        getWeekNumber(report.day, report.month, report.year).toString(),
        report.year.toString(),
      ];
      // print(row);
      sheetObject.appendRow(row);
    }
    List<String> tot = [
      'TOTAL',
      prodType[refNum],
      '-',
      '-',
      '-',
      '-',
      totTheoreticals.toStringAsFixed(2),
      '-',
      '-',
      totKg.toStringAsFixed(1),
      totRework.toString(),
      totOvenRework.toString(),
      totOvenScrap.toString(),
      totCreamRework.toString(),
      totCreamScrap.toString(),
      totCoolerRework.toString(),
      totCoolerScrap.toString(),
      totCutterRework.toString(),
      totCutterScrap.toString(),
      '-',
      '-',
      totPackingRework.toString(),
      totPackingScrap.toString(),
      totBoxesWaste.toString(),
      totCartonWaste.toString(),
      totMc1Waste.toStringAsFixed(1),
      calculateWastePercent(totMc1Used, totMc1Waste).toStringAsFixed(1),
      totMc2Waste.toStringAsFixed(1),
      calculateWastePercent(totMc2Used, totMc2Waste).toStringAsFixed(1),
      avgOverweight.toStringAsFixed(1),
      totScrap.toString(),
      (totRework * 100 / totWeight).toStringAsFixed(1),
      (totScrap * 100 / totWeight).toStringAsFixed(1),
      '-',
      '-',
      '-',
      avgOEE.toStringAsFixed(1),
      (totKg * (avgOverweight / 100)).toStringAsFixed(1),
      totCartons.toString(),
      '-',
      '-',
      '-',
    ];
    sheetObject.appendRow(tot);
  }

  void insertMaamoulReportRows(
    List<MaamoulReport> reportsList,
  ) {
    double totTheoreticals = 0.0,
        totKg = 0.0,
        totRework = 0.0,
        totMixerRework = 0.0,
        totMixerScrap = 0.0,
        totOvenRework = 0.0,
        totOvenScrap = 0.0,
        totStampingRework = 0.0,
        totStampingScrap = 0.0,
        totPackingRework = 0.0,
        totPackingScrap = 0.0,
        totBoxesWaste = 0.0,
        totCartonWaste = 0.0,
        totMc1Waste = 0.0,
        totMc2Waste = 0.0,
        totMc1Used = 0.0,
        totMc2Used = 0.0,
        avgOverweight = 0.0,
        totScrap = 0.0,
        totWeight = 0.0,
        avgOEE = 0.0;
    int totCartons = 0;
    for (MaamoulReport report in reportsList) {
      final theoreticals = [
        SKU.skuDetails[report.skuName]!.theoreticalShiftProd1,
        SKU.skuDetails[report.skuName]!.theoreticalShiftProd2,
        SKU.skuDetails[report.skuName]!.theoreticalShiftProd3,
        SKU.skuDetails[report.skuName]!.theoreticalShiftProd4
      ];
      double matchedOverWeight = doesProdReportHaveCorrespondingOverweight(
              report, this.overweightList)
          ? getCorrespondingOverweightToProdReport(report, this.overweightList)
          : 0.0;
      /////////////////////////////////////////////////////////////
      totTheoreticals += theoreticals[report.line_index - 1];
      totKg += calculateProductionKg(report, report.productionInCartons);
      totRework += calculateAllRework(refNum, report);
      totMixerRework += report.mixerRework;
      totMixerScrap += report.mixerScrap;
      totOvenRework += report.ovenRework;
      totOvenScrap += report.ovenScrap;
      totStampingRework += report.stampingRework;
      totStampingScrap += report.stampingScrap;
      totPackingRework += report.packingRework;
      totPackingScrap += report.packingScrap;
      totBoxesWaste += report.boxesWaste;
      totCartonWaste += report.cartonWaste;
      totMc1Waste += report.mc1WasteKg;
      totMc1Used += report.mc1FilmUsed;
      totMc2Waste += report.mc2WasteKg;
      totMc2Used += report.mc2FilmUsed;
      avgOverweight =
          doesProdReportHaveCorrespondingOverweight(report, this.overweightList)
              ? (avgOverweight == 0.0
                  ? getCorrespondingOverweightToProdReport(
                      report, this.overweightList)
                  : (avgOverweight +
                          getCorrespondingOverweightToProdReport(
                              report, this.overweightList)) /
                      2)
              : avgOverweight;
      avgOEE = (avgOEE == 0.0
          ? calculateOeeFromOriginalReport(
              report,
              calculateNetTheoreticalOfReport(report, theoreticals),
              refNum,
              matchedOverWeight)
          : (avgOEE +
                  calculateOeeFromOriginalReport(
                      report,
                      calculateNetTheoreticalOfReport(report, theoreticals),
                      refNum,
                      matchedOverWeight)) /
              2);
      totScrap += calculateAllScrap(refNum, report);
      totWeight += calculateAllWeightFromOriginalReport(
          refNum, report, matchedOverWeight);
      totCartons += report.productionInCartons;
      /////////////////////////////////////////////////////////////
      List<String> row = [
        constructDate(report.day, report.month, report.year),
        prodType[refNum],
        (report.shift_index + 1).toString(),
        report.shiftHours.toString(),
        report.skuName,
        prod_lines4[report.line_index - 1],
        theoreticals[report.line_index - 1].toString(),
        "Kg",
        report.actualSpeed.toString(),
        calculateProductionKg(report, report.productionInCartons)
            .toStringAsFixed(1),
        calculateAllRework(refNum, report).toString(),
        report.mixerRework.toString(),
        report.mixerScrap.toString(),
        report.stampingRework.toString(),
        report.stampingScrap.toString(),
        report.ovenRework.toString(),
        report.ovenScrap.toString(),
        report.mc1Speed.toString(),
        report.mc2Speed.toString(),
        report.packingRework.toString(),
        report.packingScrap.toString(),
        report.boxesWaste.toString(),
        report.cartonWaste.toString(),
        report.mc1WasteKg.toString(),
        calculateWastePercent(report.mc1FilmUsed, report.mc1WasteKg)
            .toStringAsFixed(1),
        report.mc2WasteKg.toString(),
        calculateWastePercent(report.mc2FilmUsed, report.mc2WasteKg)
            .toStringAsFixed(1),
        doesProdReportHaveCorrespondingOverweight(report, this.overweightList)
            ? getCorrespondingOverweightToProdReport(
                    report, this.overweightList)
                .toString()
            : "-",
        calculateAllScrap(refNum, report).toString(),
        (calculateAllRework(refNum, report) *
                100 /
                calculateAllWeightFromOriginalReport(
                    refNum, report, matchedOverWeight))
            .toStringAsFixed(1),
        (calculateAllScrap(refNum, report) *
                100 /
                calculateAllWeightFromOriginalReport(
                    refNum, report, matchedOverWeight))
            .toStringAsFixed(1),
        (calculateRateFromOriginalReport(
                    report,
                    calculateNetTheoreticalOfReport(report, theoreticals),
                    refNum,
                    matchedOverWeight) *
                100)
            .toStringAsFixed(1),
        (calculateAvailabilityFromOriginalReport(report) * 100)
            .toStringAsFixed(1),
        (calculateQualityFromOriginalReport(report, refNum, matchedOverWeight) *
                100)
            .toStringAsFixed(1),
        calculateOeeFromOriginalReport(
                report,
                calculateNetTheoreticalOfReport(report, theoreticals),
                refNum,
                matchedOverWeight)
            .toStringAsFixed(1),
        (calculateProductionKg(report, report.productionInCartons) *
                (matchedOverWeight / 100))
            .toStringAsFixed(1),
        report.productionInCartons.toString(),
        report.month.toString(),
        getWeekNumber(report.day, report.month, report.year).toString(),
        report.year.toString(),
      ];
      // print(row);
      sheetObject.appendRow(row);
    }
    List<String> tot = [
      'TOTAL',
      prodType[refNum],
      '-',
      '-',
      '-',
      '-',
      totTheoreticals.toStringAsFixed(2),
      '-',
      '-',
      totKg.toStringAsFixed(1),
      totRework.toString(),
      totMixerRework.toString(),
      totMixerScrap.toString(),
      totStampingRework.toString(),
      totStampingScrap.toString(),
      totOvenRework.toString(),
      totOvenScrap.toString(),
      '-',
      '-',
      totPackingRework.toString(),
      totPackingScrap.toString(),
      totBoxesWaste.toString(),
      totCartonWaste.toString(),
      totMc1Waste.toStringAsFixed(1),
      calculateWastePercent(totMc1Used, totMc1Waste).toStringAsFixed(1),
      totMc2Waste.toStringAsFixed(1),
      calculateWastePercent(totMc2Used, totMc2Waste).toStringAsFixed(1),
      avgOverweight.toStringAsFixed(1),
      totScrap.toString(),
      (totRework * 100 / totWeight).toStringAsFixed(1),
      (totScrap * 100 / totWeight).toStringAsFixed(1),
      '-',
      '-',
      '-',
      avgOEE.toStringAsFixed(1),
      (totKg * (avgOverweight / 100)).toStringAsFixed(1),
      totCartons.toString(),
      '-',
      '-',
      '-',
    ];
    sheetObject.appendRow(tot);
  }

  void insertTotalReportRows(
    List<MiniProductionReport> reportsList,
  ) {
    double totKg = 0.0,
        totRework = 0.0,
        totFilmWaste = 0.0,
        totFilmUsed = 0.0,
        avgOverweight = 0.0,
        totScrap = 0.0,
        totWeight = 0.0,
        avgOEE = 0.0,
        totOverWeightKg = 0.0,
        totPlanKg = 0.0,
        totRmMuv = 0.0;
    int totCartons = 0;
    for (MiniProductionReport report in reportsList) {
      totFilmUsed += report.totalFilmUsed;
      totFilmWaste += report.totalFilmWasted;
      totPlanKg += report.planInKg;
      totRmMuv += report.rmMUV;
      avgOverweight =
          doesMiniReportHaveCorrespondingOverweight(report, this.overweightList)
              ? (avgOverweight == 0.0
                  ? getCorrespondingOverweightToMiniReport(
                      report, this.overweightList)
                  : (avgOverweight +
                          getCorrespondingOverweightToMiniReport(
                              report, this.overweightList)) /
                      2)
              : avgOverweight;
      double matchedOverWeight = doesMiniReportHaveCorrespondingOverweight(
              report, this.overweightList)
          ? getCorrespondingOverweightToMiniReport(report, this.overweightList)
          : 0.0;
      totKg += report.productionInKg;
      totRework += report.rework;
      totScrap += report.scrap;
      totWeight += calculateAllWeightFromMiniReport(report, matchedOverWeight);
      totCartons += report.productionInCartons;
      totOverWeightKg += (matchedOverWeight / 100) * report.productionInKg;
      avgOEE = calculateOeeFromMiniReport(report, matchedOverWeight) == 0.0
          ? avgOEE
          : (avgOEE == 0.0
              ? calculateOeeFromMiniReport(report, matchedOverWeight)
              : (avgOEE +
                      calculateOeeFromMiniReport(report, matchedOverWeight)) /
                  2);
      /////////////////////////////////////////////////////////////
      List<String> row = [
        constructDate(report.day, report.month, report.year),
        report.planInKg.toStringAsFixed(1),
        report.productionInKg.toStringAsFixed(1),
        report.productionInCartons.toString(),
        doesMiniReportHaveCorrespondingOverweight(report, this.overweightList)
            ? getCorrespondingOverweightToMiniReport(
                    report, this.overweightList)
                .toString()
            : "-",
        ((matchedOverWeight / 100) * report.productionInKg).toStringAsFixed(1),
        report.scrap.toString(),
        (report.scrap *
                100 /
                calculateAllWeightFromMiniReport(report, matchedOverWeight))
            .toStringAsFixed(1),
        (report.rework *
                100 /
                calculateAllWeightFromMiniReport(report, matchedOverWeight))
            .toStringAsFixed(1),
        calculateWastePercent(report.totalFilmUsed, report.totalFilmWasted)
            .toStringAsFixed(1),
        (calculateRate(report, matchedOverWeight) * 100).toStringAsFixed(1),
        (calculateAvailability(report) * 100).toStringAsFixed(1),
        (calculateQuality(report, matchedOverWeight) * 100).toStringAsFixed(1),
        calculateOeeFromMiniReport(report, matchedOverWeight)
            .toStringAsFixed(1),
        report.rmMUV.toStringAsFixed(1),
        report.month.toString(),
        getWeekNumber(report.day, report.month, report.year).toString(),
        report.year.toString(),
      ];
      sheetObject.appendRow(row);
    }
    List<String> tot = [
      'TOTAL',
      totPlanKg.toStringAsFixed(1),
      totKg.toStringAsFixed(1),
      totCartons.toString(),
      avgOverweight.toStringAsFixed(2),
      totOverWeightKg.toStringAsFixed(1),
      totScrap.toStringAsFixed(1),
      (totScrap * 100 / totWeight).toStringAsFixed(1),
      (totRework * 100 / totWeight).toStringAsFixed(1),
      calculateWastePercent(totFilmUsed, totFilmWaste).toStringAsFixed(1),
      '-',
      '-',
      '-',
      avgOEE.toStringAsFixed(1),
      totRmMuv.toStringAsFixed(1),
      '-',
      '-',
      '-',
    ];
    sheetObject.appendRow(tot);
  }
}