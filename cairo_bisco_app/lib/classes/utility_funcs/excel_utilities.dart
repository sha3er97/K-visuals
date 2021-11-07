import 'dart:io';

import 'package:cairo_bisco_app/classes/BiscuitsReport.dart';
import 'package:cairo_bisco_app/classes/MaamoulReport.dart';
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

class ExcelUtilities {
  static var excel;
  late Sheet sheetObject;
  final int refNum;
  late String areaName;
  late List<OverWeightReport> overweightList;

  ExcelUtilities({required this.refNum}) {
    excel = Excel.createExcel(); // automatically creates 1 empty sheet: Sheet1
    areaName = prodType[refNum];
    sheetObject = excel[areaName];
    excel.delete('Sheet1');
  }

  void setOverweightList(List<OverWeightReport> overweightList) {
    this.overweightList = overweightList;
  }

  Future<void> saveFile(
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
        fileName = "/storage/emulated/0/Download" + '/K viuals' + fileName;
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
    }
  }

  double getCorrespondingOverweight(prodReport) {
    if (doesHaveCorrespondingOverweight(prodReport)) {
      for (OverWeightReport report in this.overweightList) {
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

  bool doesHaveCorrespondingOverweight(prodReport) {
    for (OverWeightReport report in this.overweightList) {
      if (report.day == prodReport.day &&
          report.month == prodReport.month &&
          report.line_index == prodReport.line_index &&
          report.year == prodReport.year) {
        return true;
      }
    }
    return false;
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
        totWeight = 0.0;
    int totCartons = 0;
    for (BiscuitsReport report in reportsList) {
      final theoreticals = [
        SKU.skuDetails[report.skuName]!.theoreticalShiftProd1,
        SKU.skuDetails[report.skuName]!.theoreticalShiftProd2,
        SKU.skuDetails[report.skuName]!.theoreticalShiftProd3,
        SKU.skuDetails[report.skuName]!.theoreticalShiftProd4
      ];
      totTheoreticals += theoreticals[report.line_index - 1];
      totKg += calculateProductionKg(report);
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
      avgOverweight = doesHaveCorrespondingOverweight(report)
          ? (avgOverweight == 0.0
              ? getCorrespondingOverweight(report)
              : (avgOverweight + getCorrespondingOverweight(report)) / 2)
          : avgOverweight;
      totScrap += calculateAllScrap(refNum, report);
      totWeight += calculateAllWeight(refNum, report);
      totCartons += report.productionInCartons;
      /////////////////////////////////////////////////////////////
      List<String> row = [
        constructDate(report.day, report.month, report.year),
        prodType[refNum],
        (report.shift_index + 1).toString(),
        "8",
        report.skuName,
        prod_lines4[report.line_index - 1],
        theoreticals[report.line_index - 1].toString(),
        "Kg",
        report.actualSpeed.toString(),
        calculateProductionKg(report).toString(),
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
        doesHaveCorrespondingOverweight(report)
            ? getCorrespondingOverweight(report).toString()
            : "-",
        calculateAllScrap(refNum, report).toString(),
        (calculateAllRework(refNum, report) *
            100 /
            calculateAllWeight(refNum, report))
            .toStringAsFixed(1),
        (calculateAllScrap(refNum, report) *
            100 /
            calculateAllWeight(refNum, report))
            .toStringAsFixed(1),
        "Speed Loss",
        "Availability%",
        "Quality%",
        calculateOeeFromOriginalReport(
            report, theoreticals[report.line_index - 1])
            .toStringAsFixed(1),
        doesHaveCorrespondingOverweight(report)
            ? (calculateProductionKg(report) *
            getCorrespondingOverweight(report))
                .toString()
            : "-",
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
      totTheoreticals.toString(),
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
      totMc1Waste.toString(),
      calculateWastePercent(totMc1Used, totMc1Waste).toStringAsFixed(1),
      totMc2Waste.toString(),
      calculateWastePercent(totMc2Used, totMc2Waste).toStringAsFixed(1),
      avgOverweight.toStringAsFixed(1),
      totScrap.toString(),
      (totRework * 100 / totWeight).toStringAsFixed(1),
      (totScrap * 100 / totWeight).toStringAsFixed(1),
      '-',
      '-',
      '-',
      calculateOeeFromRawNumbers(totKg, totTheoreticals).toStringAsFixed(1),
      (totKg * avgOverweight).toStringAsFixed(1),
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
        totWeight = 0.0;
    int totCartons = 0;
    for (WaferReport report in reportsList) {
      final theoreticals = [
        SKU.skuDetails[report.skuName]!.theoreticalShiftProd1,
        SKU.skuDetails[report.skuName]!.theoreticalShiftProd2,
        SKU.skuDetails[report.skuName]!.theoreticalShiftProd3,
        SKU.skuDetails[report.skuName]!.theoreticalShiftProd4
      ];
      totTheoreticals += theoreticals[report.line_index - 1];
      totKg += calculateProductionKg(report);
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
      avgOverweight = doesHaveCorrespondingOverweight(report)
          ? (avgOverweight == 0.0
              ? getCorrespondingOverweight(report)
              : (avgOverweight + getCorrespondingOverweight(report)) / 2)
          : avgOverweight;
      totScrap += calculateAllScrap(refNum, report);
      totWeight += calculateAllWeight(refNum, report);
      totCartons += report.productionInCartons;
      /////////////////////////////////////////////////////////////
      List<String> row = [
        constructDate(report.day, report.month, report.year),
        prodType[refNum],
        (report.shift_index + 1).toString(),
        "8",
        report.skuName,
        prod_lines4[report.line_index - 1],
        theoreticals[report.line_index - 1].toString(),
        "Kg",
        report.actualSpeed.toString(),
        calculateProductionKg(report).toString(),
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
        doesHaveCorrespondingOverweight(report)
            ? getCorrespondingOverweight(report).toString()
            : "-",
        calculateAllScrap(refNum, report).toString(),
        (calculateAllRework(refNum, report) *
            100 /
            calculateAllWeight(refNum, report))
            .toStringAsFixed(1),
        (calculateAllScrap(refNum, report) *
            100 /
            calculateAllWeight(refNum, report))
            .toStringAsFixed(1),
        "Speed Loss",
        "Availability%",
        "Quality%",
        calculateOeeFromOriginalReport(
            report, theoreticals[report.line_index - 1])
            .toStringAsFixed(1),
        doesHaveCorrespondingOverweight(report)
            ? (calculateProductionKg(report) *
            getCorrespondingOverweight(report))
                .toString()
            : "-",
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
      totTheoreticals.toString(),
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
      totMc1Waste.toString(),
      calculateWastePercent(totMc1Used, totMc1Waste).toStringAsFixed(1),
      totMc2Waste.toString(),
      calculateWastePercent(totMc2Used, totMc2Waste).toStringAsFixed(1),
      avgOverweight.toStringAsFixed(1),
      totScrap.toString(),
      (totRework * 100 / totWeight).toStringAsFixed(1),
      (totScrap * 100 / totWeight).toStringAsFixed(1),
      '-',
      '-',
      '-',
      calculateOeeFromRawNumbers(totKg, totTheoreticals).toStringAsFixed(1),
      (totKg * avgOverweight).toStringAsFixed(1),
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
        totWeight = 0.0;
    int totCartons = 0;
    for (MaamoulReport report in reportsList) {
      final theoreticals = [
        SKU.skuDetails[report.skuName]!.theoreticalShiftProd1,
        SKU.skuDetails[report.skuName]!.theoreticalShiftProd2,
        SKU.skuDetails[report.skuName]!.theoreticalShiftProd3,
        SKU.skuDetails[report.skuName]!.theoreticalShiftProd4
      ];
      totTheoreticals += theoreticals[report.line_index - 1];
      totKg += calculateProductionKg(report);
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
      avgOverweight = doesHaveCorrespondingOverweight(report)
          ? (avgOverweight == 0.0
              ? getCorrespondingOverweight(report)
              : (avgOverweight + getCorrespondingOverweight(report)) / 2)
          : avgOverweight;
      totScrap += calculateAllScrap(refNum, report);
      totWeight += calculateAllWeight(refNum, report);
      totCartons += report.productionInCartons;
      /////////////////////////////////////////////////////////////
      List<String> row = [
        constructDate(report.day, report.month, report.year),
        prodType[refNum],
        (report.shift_index + 1).toString(),
        "8",
        report.skuName,
        prod_lines4[report.line_index - 1],
        theoreticals[report.line_index - 1].toString(),
        "Kg",
        report.actualSpeed.toString(),
        calculateProductionKg(report).toString(),
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
        doesHaveCorrespondingOverweight(report)
            ? getCorrespondingOverweight(report).toString()
            : "-",
        calculateAllScrap(refNum, report).toString(),
        (calculateAllRework(refNum, report) *
            100 /
            calculateAllWeight(refNum, report))
            .toStringAsFixed(1),
        (calculateAllScrap(refNum, report) *
            100 /
            calculateAllWeight(refNum, report))
            .toStringAsFixed(1),
        "Speed Loss",
        "Availability%",
        "Quality%",
        calculateOeeFromOriginalReport(
            report, theoreticals[report.line_index - 1])
            .toStringAsFixed(1),
        doesHaveCorrespondingOverweight(report)
            ? (calculateProductionKg(report) *
            getCorrespondingOverweight(report))
                .toString()
            : "-",
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
      totTheoreticals.toString(),
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
      totMc1Waste.toString(),
      calculateWastePercent(totMc1Used, totMc1Waste).toStringAsFixed(1),
      totMc2Waste.toString(),
      calculateWastePercent(totMc2Used, totMc2Waste).toStringAsFixed(1),
      avgOverweight.toStringAsFixed(1),
      totScrap.toString(),
      (totRework * 100 / totWeight).toStringAsFixed(1),
      (totScrap * 100 / totWeight).toStringAsFixed(1),
      '-',
      '-',
      '-',
      calculateOeeFromRawNumbers(totKg, totTheoreticals).toStringAsFixed(1),
      (totKg * avgOverweight).toStringAsFixed(1),
      totCartons.toString(),
      '-',
      '-',
      '-',
    ];
    sheetObject.appendRow(tot);
  }
}
