import 'dart:io';

import 'package:cairo_bisco_app/classes/BiscuitsReport.dart';
import 'package:cairo_bisco_app/classes/MaamoulReport.dart';
import 'package:cairo_bisco_app/classes/MiniProductionReport.dart';
import 'package:cairo_bisco_app/classes/OverWeightReport.dart';
import 'package:cairo_bisco_app/classes/SKU.dart';
import 'package:cairo_bisco_app/classes/WaferReport.dart';
import 'package:cairo_bisco_app/classes/utility_funcs/calculations_utility.dart';
import 'package:cairo_bisco_app/classes/utility_funcs/date_time_utility.dart';
import 'package:cairo_bisco_app/classes/values/constants.dart';
import 'package:cairo_bisco_app/classes/values/form_values.dart';
import 'package:cairo_bisco_app/components/alert_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cross_file/cross_file.dart';
import 'package:excel/excel.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:permission_handler/permission_handler.dart';

import '../DownTimeReport.dart';
import 'other_utility.dart';

class ProductionExcelUtilities {
  static var excel;
  late Sheet sheetObject;
  final int refNum;
  late dynamic areaName;
  late List<OverWeightReport> overweightList;

  // List<List<dynamic>> csvData=[[]];

  ProductionExcelUtilities({required this.refNum}) {
    excel = Excel.createExcel(); // automatically creates 1 empty sheet: Sheet1
    areaName = refNum != TOTAL_PLANT ? prodType[refNum] : "Total";
    sheetObject = excel[areaName];
    excel.delete('Sheet1');
  }

  void setOverweightList(List<OverWeightReport> overweightList) {
    this.overweightList = overweightList;
  }

  // Future<void> saveCSVFile(
  //   context,
  //   dynamic from_day,
  //   dynamic to_day,
  //   dynamic from_month,
  //   dynamic to_month,
  // ) async {
  //   String extension = "csv";
  //   final format = 'text/csv';
  //   dynamic fileName =
  //       "$areaName report $from_day-$from_month to $to_day-$to_month.$extension";
  //   List<List<String>> data = [
  //     ["No.", "Name", "Roll No."],
  //     ["1", "0", "3"],
  //     ["2", "1", "4"],
  //     ["3", "2", "5"]
  //   ];
  //   String csvData = ListToCsvConverter().convert(data);
  //   // final String directory = (await getApplicationSupportDirectory()).path;
  //   // final path = "$directory/$fileName";
  //   // print(path);
  //   XFile.fromData(csvData, mimeType: format, name: fileName).saveTo(fileName);
  //   final File file = File(fileName);
  //   await file.writeAsString(csvData);
  // }

  Future<void> saveExcelFile(
    context,
    dynamic from_day,
    dynamic to_day,
    dynamic from_month,
    dynamic to_month,
  ) async {
    String extension = "xlsx";
    dynamic fileName =
        "$areaName report $from_day-$from_month to $to_day-$to_month.$extension";
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
    List<QueryDocumentSnapshot<DownTimeReport>> downTimeList,
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
        totMc3Used = 0.0,
        totMc4Used = 0.0,
        totMc3Waste = 0.0,
        totMc4Waste = 0.0,
        avgOverweight = 0.0,
        totScrap = 0.0,
        totWeight = 0.0,
        avgOEE = 0.0;
    int totCartons = 0, totStoppedMinutes = 0, reportStoppedMinutes;
    reportsList.sort((a, b) {
      return (constructDateObject(a.day, a.month, a.year))
          .compareTo(constructDateObject(b.day, b.month, b.year));
    });
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
      reportStoppedMinutes = DownTimeReport.getWastedMinutesOfCriteria(
          downTimeList,
          report.month,
          report.month,
          report.day,
          report.day,
          report.year,
          report.area,
          report.line_index,
          report.shift_index);
      totStoppedMinutes += reportStoppedMinutes;
      /////////////////////////////////////////////////////////////
      totTheoreticals += calculateNetTheoreticalOfReport(
          report, theoreticals, reportStoppedMinutes);
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
      totMc3Waste += report.mc3WasteKg;
      totMc3Used += report.mc3FilmUsed;
      totMc4Waste += report.mc4WasteKg;
      totMc4Used += report.mc4FilmUsed;
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
              calculateNetTheoreticalOfReport(
                  report, theoreticals, reportStoppedMinutes),
              refNum,
              matchedOverWeight,
              reportStoppedMinutes)
          : (avgOEE +
                  calculateOeeFromOriginalReport(
                      report,
                      calculateNetTheoreticalOfReport(
                          report, theoreticals, reportStoppedMinutes),
                      refNum,
                      matchedOverWeight,
                      reportStoppedMinutes)) /
              2);
      totScrap += calculateAllScrap(refNum, report);
      totWeight += calculateAllWeightFromOriginalReport(
          refNum, report, matchedOverWeight);
      totCartons += report.productionInCartons;
      /////////////////////////////////////////////////////////////

      List<dynamic> row = [
        constructDateString(report.day, report.month, report.year),
        prodType[refNum],
        (report.shift_index + 1),
        report.shiftHours,
        reportStoppedMinutes,
        report.skuName,
        prod_lines4[report.line_index - 1],
        calculateNetTheoreticalOfReport(
            report, theoreticals, reportStoppedMinutes),
        "Kg",
        calculateProductionKg(report, report.productionInCartons),
        calculateAllRework(refNum, report),
        report.extrusionRework,
        report.extrusionScrap,
        report.extrusionScrapReason,
        report.ovenRework,
        report.ovenScrap,
        report.ovenScrapReason,
        report.cutterRework,
        report.cutterScrap,
        report.cutterScrapReason,
        report.conveyorRework,
        report.conveyorScrap,
        report.conveyorScrapReason,
        report.mc1Speed,
        report.mc2Speed,
        report.mc3Speed,
        report.mc4Speed,
        report.packingRework,
        report.packingScrap,
        report.packingScrapReason,
        report.boxesWaste,
        report.cartonWaste,
        report.mc1WasteKg,
        calculateWastePercent(report.mc1FilmUsed, report.mc1WasteKg),
        report.mc2WasteKg,
        calculateWastePercent(report.mc2FilmUsed, report.mc2WasteKg),
        report.mc3WasteKg,
        calculateWastePercent(report.mc3FilmUsed, report.mc3WasteKg),
        report.mc4WasteKg,
        calculateWastePercent(report.mc4FilmUsed, report.mc4WasteKg),
        doesProdReportHaveCorrespondingOverweight(report, this.overweightList)
            ? getCorrespondingOverweightToProdReport(
                report, this.overweightList)
            : "-",
        calculateAllScrap(refNum, report),
        calculateReworkPercentFromOriginalReport(
            refNum, report, matchedOverWeight),
        calculateScrapPercentFromOriginalReport(
            refNum, report, matchedOverWeight),
        (calculateRateFromOriginalReport(
                report,
                calculateNetTheoreticalOfReport(
                    report, theoreticals, reportStoppedMinutes),
                refNum,
                matchedOverWeight) *
            100),
        (calculateAvailabilityFromOriginalReport(report, reportStoppedMinutes) *
            100),
        (calculateQualityFromOriginalReport(report, refNum, matchedOverWeight) *
            100),
        calculateOeeFromOriginalReport(
            report,
            calculateNetTheoreticalOfReport(
                report, theoreticals, reportStoppedMinutes),
            refNum,
            matchedOverWeight,
            reportStoppedMinutes),
        calculateOverweightKgFromOriginalReport(report, matchedOverWeight),
        report.productionInCartons,
        report.month,
        getWeekNumber(report.day, report.month, report.year),
        report.year,
      ];
      // print(row);
      sheetObject.appendRow(row);
    }

    List<dynamic> tot = [
      'TOTAL',
      prodType[refNum],
      '-',
      '-',
      totStoppedMinutes,
      '-',
      '-',
      totTheoreticals,
      '-',
      totKg,
      totRework,
      totExtrusionRework,
      totExtrusionScrap,
      '-',
      totOvenRework,
      totOvenScrap,
      '-',
      totCutterRework,
      totCutterScrap,
      '-',
      totConvRework,
      totConvScrap,
      '-',
      '-',
      '-',
      '-',
      '-',
      totPackingRework,
      totPackingScrap,
      '-',
      totBoxesWaste,
      totCartonWaste,
      totMc1Waste,
      calculateWastePercent(totMc1Used, totMc1Waste),
      totMc2Waste,
      calculateWastePercent(totMc2Used, totMc2Waste),
      totMc3Waste,
      calculateWastePercent(totMc3Used, totMc3Waste),
      totMc4Waste,
      calculateWastePercent(totMc4Used, totMc4Waste),
      double.parse(avgOverweight.toStringAsFixed(2)),
      totScrap,
      double.parse((totRework * 100 / totWeight).toStringAsFixed(2)),
      double.parse((totScrap * 100 / totWeight).toStringAsFixed(2)),
      '-',
      '-',
      '-',
      double.parse(avgOEE.toStringAsFixed(2)),
      double.parse((totKg * (avgOverweight / 100)).toStringAsFixed(2)),
      totCartons,
      '-',
      '-',
      '-',
    ];
    sheetObject.appendRow(tot);
  }

  void insertWaferReportRows(
    List<WaferReport> reportsList,
    List<QueryDocumentSnapshot<DownTimeReport>> downTimeList,
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
        totMc3Used = 0.0,
        totMc4Used = 0.0,
        totMc3Waste = 0.0,
        totMc4Waste = 0.0,
        avgOverweight = 0.0,
        totScrap = 0.0,
        totWeight = 0.0,
        avgOEE = 0.0;
    int totCartons = 0, totStoppedMinutes = 0, reportStoppedMinutes;
    reportsList.sort((a, b) {
      return (constructDateObject(a.day, a.month, a.year))
          .compareTo(constructDateObject(b.day, b.month, b.year));
    });
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
      reportStoppedMinutes = DownTimeReport.getWastedMinutesOfCriteria(
          downTimeList,
          report.month,
          report.month,
          report.day,
          report.day,
          report.year,
          report.area,
          report.line_index,
          report.shift_index);
      totStoppedMinutes += reportStoppedMinutes;
      /////////////////////////////////////////////////////////////
      totTheoreticals += calculateNetTheoreticalOfReport(
          report, theoreticals, reportStoppedMinutes);
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
      totMc3Waste += report.mc3WasteKg;
      totMc3Used += report.mc3FilmUsed;
      totMc4Waste += report.mc4WasteKg;
      totMc4Used += report.mc4FilmUsed;
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
              calculateNetTheoreticalOfReport(
                  report, theoreticals, reportStoppedMinutes),
              refNum,
              matchedOverWeight,
              reportStoppedMinutes)
          : (avgOEE +
                  calculateOeeFromOriginalReport(
                      report,
                      calculateNetTheoreticalOfReport(
                          report, theoreticals, reportStoppedMinutes),
                      refNum,
                      matchedOverWeight,
                      reportStoppedMinutes)) /
              2);
      totScrap += calculateAllScrap(refNum, report);
      totWeight += calculateAllWeightFromOriginalReport(
          refNum, report, matchedOverWeight);
      totCartons += report.productionInCartons;
      /////////////////////////////////////////////////////////////
      List<dynamic> row = [
        constructDateString(report.day, report.month, report.year),
        prodType[refNum],
        (report.shift_index + 1),
        report.shiftHours,
        reportStoppedMinutes,
        report.skuName,
        prod_lines4[report.line_index - 1],
        calculateNetTheoreticalOfReport(
            report, theoreticals, reportStoppedMinutes),
        "Kg",
        calculateProductionKg(report, report.productionInCartons),
        calculateAllRework(refNum, report),
        report.ovenRework,
        report.ovenScrap,
        report.ovenScrapReason,
        report.creamRework,
        report.creamScrap,
        report.creamScrapReason,
        report.coolerRework,
        report.coolerScrap,
        report.coolerScrapReason,
        report.cutterRework,
        report.cutterScrap,
        report.cutterScrapReason,
        report.mc1Speed,
        report.mc2Speed,
        report.mc3Speed,
        report.mc4Speed,
        report.packingRework,
        report.packingScrap,
        report.packingScrapReason,
        report.boxesWaste,
        report.cartonWaste,
        report.mc1WasteKg,
        calculateWastePercent(report.mc1FilmUsed, report.mc1WasteKg),
        report.mc2WasteKg,
        calculateWastePercent(report.mc2FilmUsed, report.mc2WasteKg),
        report.mc3WasteKg,
        calculateWastePercent(report.mc3FilmUsed, report.mc3WasteKg),
        report.mc4WasteKg,
        calculateWastePercent(report.mc4FilmUsed, report.mc4WasteKg),
        doesProdReportHaveCorrespondingOverweight(report, this.overweightList)
            ? getCorrespondingOverweightToProdReport(
                report, this.overweightList)
            : "-",
        calculateAllScrap(refNum, report),
        calculateReworkPercentFromOriginalReport(
            refNum, report, matchedOverWeight),
        calculateScrapPercentFromOriginalReport(
            refNum, report, matchedOverWeight),
        (calculateRateFromOriginalReport(
                report,
                calculateNetTheoreticalOfReport(
                    report, theoreticals, reportStoppedMinutes),
                refNum,
                matchedOverWeight) *
            100),
        (calculateAvailabilityFromOriginalReport(report, reportStoppedMinutes) *
            100),
        (calculateQualityFromOriginalReport(report, refNum, matchedOverWeight) *
            100),
        calculateOeeFromOriginalReport(
            report,
            calculateNetTheoreticalOfReport(
                report, theoreticals, reportStoppedMinutes),
            refNum,
            matchedOverWeight,
            reportStoppedMinutes),
        calculateOverweightKgFromOriginalReport(report, matchedOverWeight),
        report.productionInCartons,
        report.month,
        getWeekNumber(report.day, report.month, report.year),
        report.year,
      ];
      // print(row);
      sheetObject.appendRow(row);
    }
    List<dynamic> tot = [
      'TOTAL',
      prodType[refNum],
      '-',
      '-',
      totStoppedMinutes,
      '-',
      '-',
      totTheoreticals,
      '-',
      totKg,
      totRework,
      totOvenRework,
      totOvenScrap,
      '-',
      totCreamRework,
      totCreamScrap,
      '-',
      totCoolerRework,
      totCoolerScrap,
      '-',
      totCutterRework,
      totCutterScrap,
      '-',
      '-',
      '-',
      '-',
      '-',
      totPackingRework,
      totPackingScrap,
      '-',
      totBoxesWaste,
      totCartonWaste,
      totMc1Waste,
      calculateWastePercent(totMc1Used, totMc1Waste),
      totMc2Waste,
      calculateWastePercent(totMc2Used, totMc2Waste),
      totMc3Waste,
      calculateWastePercent(totMc3Used, totMc3Waste),
      totMc4Waste,
      calculateWastePercent(totMc4Used, totMc4Waste),
      double.parse(avgOverweight.toStringAsFixed(2)),
      totScrap,
      double.parse((totRework * 100 / totWeight).toStringAsFixed(2)),
      double.parse((totScrap * 100 / totWeight).toStringAsFixed(2)),
      '-',
      '-',
      '-',
      double.parse(avgOEE.toStringAsFixed(2)),
      double.parse((totKg * (avgOverweight / 100)).toStringAsFixed(2)),
      totCartons,
      '-',
      '-',
      '-',
    ];
    sheetObject.appendRow(tot);
  }

  void insertMaamoulReportRows(
    List<MaamoulReport> reportsList,
    List<QueryDocumentSnapshot<DownTimeReport>> downTimeList,
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
        totMc3Used = 0.0,
        totMc4Used = 0.0,
        totMc3Waste = 0.0,
        totMc4Waste = 0.0,
        avgOverweight = 0.0,
        totScrap = 0.0,
        totWeight = 0.0,
        avgOEE = 0.0;
    int totCartons = 0, totStoppedMinutes = 0, reportStoppedMinutes;
    reportsList.sort((a, b) {
      return (constructDateObject(a.day, a.month, a.year))
          .compareTo(constructDateObject(b.day, b.month, b.year));
    });
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
      reportStoppedMinutes = DownTimeReport.getWastedMinutesOfCriteria(
          downTimeList,
          report.month,
          report.month,
          report.day,
          report.day,
          report.year,
          report.area,
          report.line_index,
          report.shift_index);
      totStoppedMinutes += reportStoppedMinutes;
      /////////////////////////////////////////////////////////////
      totTheoreticals += calculateNetTheoreticalOfReport(
          report, theoreticals, reportStoppedMinutes);
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
      totMc3Waste += report.mc3WasteKg;
      totMc3Used += report.mc3FilmUsed;
      totMc4Waste += report.mc4WasteKg;
      totMc4Used += report.mc4FilmUsed;
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
              calculateNetTheoreticalOfReport(
                  report, theoreticals, reportStoppedMinutes),
              refNum,
              matchedOverWeight,
              reportStoppedMinutes)
          : (avgOEE +
                  calculateOeeFromOriginalReport(
                      report,
                      calculateNetTheoreticalOfReport(
                          report, theoreticals, reportStoppedMinutes),
                      refNum,
                      matchedOverWeight,
                      reportStoppedMinutes)) /
              2);
      totScrap += calculateAllScrap(refNum, report);
      totWeight += calculateAllWeightFromOriginalReport(
          refNum, report, matchedOverWeight);
      totCartons += report.productionInCartons;
      /////////////////////////////////////////////////////////////
      List<dynamic> row = [
        constructDateString(report.day, report.month, report.year),
        prodType[refNum],
        (report.shift_index + 1),
        report.shiftHours,
        reportStoppedMinutes,
        report.skuName,
        prod_lines4[report.line_index - 1],
        calculateNetTheoreticalOfReport(
            report, theoreticals, reportStoppedMinutes),
        "Kg",
        calculateProductionKg(report, report.productionInCartons),
        calculateAllRework(refNum, report),
        report.mixerRework,
        report.mixerScrap,
        report.mixerScrapReason,
        report.stampingRework,
        report.stampingScrap,
        report.stampingScrapReason,
        report.ovenRework,
        report.ovenScrap,
        report.ovenScrapReason,
        report.mc1Speed,
        report.mc2Speed,
        report.mc3Speed,
        report.mc4Speed,
        report.packingRework,
        report.packingScrap,
        report.packingScrapReason,
        report.boxesWaste,
        report.cartonWaste,
        report.mc1WasteKg,
        calculateWastePercent(report.mc1FilmUsed, report.mc1WasteKg),
        report.mc2WasteKg,
        calculateWastePercent(report.mc2FilmUsed, report.mc2WasteKg),
        report.mc3WasteKg,
        calculateWastePercent(report.mc3FilmUsed, report.mc3WasteKg),
        report.mc4WasteKg,
        calculateWastePercent(report.mc4FilmUsed, report.mc4WasteKg),
        doesProdReportHaveCorrespondingOverweight(report, this.overweightList)
            ? getCorrespondingOverweightToProdReport(
                report, this.overweightList)
            : "-",
        calculateAllScrap(refNum, report),
        calculateReworkPercentFromOriginalReport(
            refNum, report, matchedOverWeight),
        calculateScrapPercentFromOriginalReport(
            refNum, report, matchedOverWeight),
        (calculateRateFromOriginalReport(
                report,
                calculateNetTheoreticalOfReport(
                    report, theoreticals, reportStoppedMinutes),
                refNum,
                matchedOverWeight) *
            100),
        (calculateAvailabilityFromOriginalReport(report, reportStoppedMinutes) *
            100),
        (calculateQualityFromOriginalReport(report, refNum, matchedOverWeight) *
            100),
        calculateOeeFromOriginalReport(
            report,
            calculateNetTheoreticalOfReport(
                report, theoreticals, reportStoppedMinutes),
            refNum,
            matchedOverWeight,
            reportStoppedMinutes),
        calculateOverweightKgFromOriginalReport(report, matchedOverWeight),
        report.productionInCartons,
        report.month,
        getWeekNumber(report.day, report.month, report.year),
        report.year,
      ];
      // print(row);
      sheetObject.appendRow(row);
    }
    List<dynamic> tot = [
      'TOTAL',
      prodType[refNum],
      '-',
      '-',
      totStoppedMinutes,
      '-',
      '-',
      totTheoreticals,
      '-',
      totKg,
      totRework,
      totMixerRework,
      totMixerScrap,
      '-',
      totStampingRework,
      totStampingScrap,
      '-',
      totOvenRework,
      totOvenScrap,
      '-',
      '-',
      '-',
      '-',
      '-',
      totPackingRework,
      totPackingScrap,
      '-',
      totBoxesWaste,
      totCartonWaste,
      totMc1Waste,
      calculateWastePercent(totMc1Used, totMc1Waste),
      totMc2Waste,
      calculateWastePercent(totMc2Used, totMc2Waste),
      totMc3Waste,
      calculateWastePercent(totMc3Used, totMc3Waste),
      totMc4Waste,
      calculateWastePercent(totMc4Used, totMc4Waste),
      double.parse(avgOverweight.toStringAsFixed(2)),
      totScrap,
      double.parse((totRework * 100 / totWeight).toStringAsFixed(2)),
      double.parse((totScrap * 100 / totWeight).toStringAsFixed(2)),
      '-',
      '-',
      '-',
      double.parse(avgOEE.toStringAsFixed(2)),
      double.parse((totKg * (avgOverweight / 100)).toStringAsFixed(2)),
      totCartons,
      '-',
      '-',
      '-',
    ];
    sheetObject.appendRow(tot);
  }

  void insertTotalReportRows(
    List<MiniProductionReport> reportsList,
    List<QueryDocumentSnapshot<DownTimeReport>> downTimeList,
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
    int totCartons = 0, totStoppedMinutes = 0, reportStoppedMinutes;
    reportsList.sort((a, b) {
      return (constructDateObject(a.day, a.month, a.year))
          .compareTo(constructDateObject(b.day, b.month, b.year));
    });
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
      /////////////////////////////////////////////////////////////
      reportStoppedMinutes = DownTimeReport.getWastedMinutesOfCriteria(
        downTimeList,
        report.month,
        report.month,
        report.day,
        report.day,
        report.year,
        report.area,
        report.line_index,
        report.shift_index,
      );
      totStoppedMinutes += reportStoppedMinutes;
      /////////////////////////////////////////////////////////////
      totKg += report.productionInKg;
      totRework += report.rework;
      totScrap += report.scrap;
      totWeight += calculateAllWeightFromMiniReport(report, matchedOverWeight);
      totCartons += report.productionInCartons;
      totOverWeightKg +=
          calculateOverweightKgFromMiniReport(report, matchedOverWeight);
      avgOEE = calculateOeeFromMiniReport(
                  report, matchedOverWeight, reportStoppedMinutes) ==
              0.0
          ? avgOEE
          : (avgOEE == 0.0
              ? calculateOeeFromMiniReport(
                  report, matchedOverWeight, reportStoppedMinutes)
              : (avgOEE +
                      calculateOeeFromMiniReport(
                          report, matchedOverWeight, reportStoppedMinutes)) /
                  2);
      /////////////////////////////////////////////////////////////
      List<dynamic> row = [
        constructDateString(report.day, report.month, report.year),
        report.planInKg,
        report.productionInKg,
        report.productionInCartons,
        doesMiniReportHaveCorrespondingOverweight(report, this.overweightList)
            ? getCorrespondingOverweightToMiniReport(
                report, this.overweightList)
            : "-",
        calculateOverweightKgFromMiniReport(report, matchedOverWeight),
        report.scrap,
        calculateScrapPercentFromMiniReport(report, matchedOverWeight),
        calculateReworkPercentFromMiniReport(report, matchedOverWeight),
        calculateWastePercent(report.totalFilmUsed, report.totalFilmWasted),
        (calculateRate(report, matchedOverWeight) * 100),
        (calculateAvailability(report, reportStoppedMinutes) * 100),
        (calculateQuality(report, matchedOverWeight) * 100),
        calculateOeeFromMiniReport(
            report, matchedOverWeight, reportStoppedMinutes),
        report.rmMUV,
        report.month,
        getWeekNumber(report.day, report.month, report.year),
        report.year,
      ];
      sheetObject.appendRow(row);
    }
    List<dynamic> tot = [
      'TOTAL',
      totPlanKg,
      totKg,
      totCartons,
      totStoppedMinutes,
      double.parse(avgOverweight.toStringAsFixed(2)),
      double.parse(totOverWeightKg.toStringAsFixed(2)),
      totScrap,
      double.parse((totScrap * 100 / totWeight).toStringAsFixed(2)),
      double.parse((totRework * 100 / totWeight).toStringAsFixed(2)),
      calculateWastePercent(totFilmUsed, totFilmWaste),
      '-',
      '-',
      '-',
      double.parse(avgOEE.toStringAsFixed(2)),
      totRmMuv,
      '-',
      '-',
      '-',
    ];
    sheetObject.appendRow(tot);
  }
}
