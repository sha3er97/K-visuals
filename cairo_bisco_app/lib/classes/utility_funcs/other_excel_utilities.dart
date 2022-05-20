import 'dart:io';
import 'dart:math';

import 'package:cairo_bisco_app/classes/DownTimeReport.dart';
import 'package:cairo_bisco_app/classes/EhsReport.dart';
import 'package:cairo_bisco_app/classes/OverWeightReport.dart';
import 'package:cairo_bisco_app/classes/QfsReport.dart';
import 'package:cairo_bisco_app/classes/utility_funcs/date_time_utility.dart';
import 'package:cairo_bisco_app/classes/values/constants.dart';
import 'package:cairo_bisco_app/classes/values/form_values.dart';
import 'package:cairo_bisco_app/components/alert_dialog.dart';
import 'package:cross_file/cross_file.dart';
import 'package:excel/excel.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:permission_handler/permission_handler.dart';

import '../values/excelHeaders.dart';

class OtherExcelUtilities {
  static var excel;
  late Sheet sheetObject;
  final int refNum;
  late String ReportType;

  OtherExcelUtilities({required this.refNum}) {
    excel = Excel.createExcel(); // automatically creates 1 empty sheet: Sheet1
    ReportType = reportTypeNames[refNum];
    sheetObject = excel[ReportType];
    excel.delete('Sheet1');
  }

  Future<void> saveExcelFile(
    context,
    String from_day,
    String to_day,
    String from_month,
    String to_month,
  ) async {
    String fileName =
        "$ReportType report $from_day-$from_month to $to_day-$to_month.xlsx";
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
      case QFS_REPORT:
        sheetObject.insertRowIterables(QfsHeaders, 0);
        break;
      case EHS_REPORT:
        sheetObject.insertRowIterables(EhsHeaders, 0);
        break;
      case DOWNTIME_REPORT:
        sheetObject.insertRowIterables(DownTimeHeaders, 0);
        break;
    }
  }

  void insertQfsReportRows(
    List<QfsReport> qfsReportsList,
    List<OverWeightReport> dailyReportsList,
  ) {
    int totQuality = 0, totFoodSafety = 0, totCCP = 0, totConsComplaints = 0;
    for (int i = 0; i < qfsReportsList.length; i++) {
      totQuality += qfsReportsList[i].quality_incidents;
      totFoodSafety += qfsReportsList[i].food_safety_incidents;
      totCCP += qfsReportsList[i].ccp_failure;
      totConsComplaints += qfsReportsList[i].consumer_complaints +
          dailyReportsList[i].consumer_complaints;
      List<dynamic> row = [
        constructDateString(qfsReportsList[i].day, qfsReportsList[i].month,
            qfsReportsList[i].year),
        qfsReportsList[i].quality_incidents,
        qfsReportsList[i].food_safety_incidents,
        qfsReportsList[i].ccp_failure,
        (qfsReportsList[i].consumer_complaints +
            dailyReportsList[i].consumer_complaints),
        G6[max(qfsReportsList[i].g6_index, dailyReportsList[i].g6_index)],
        Pes[max(qfsReportsList[i].pes_index, dailyReportsList[i].pes_index)],
        qfsReportsList[i].month,
        getWeekNumber(qfsReportsList[i].day, qfsReportsList[i].month,
            qfsReportsList[i].year),
        qfsReportsList[i].year,
      ];
      // print(row);
      sheetObject.appendRow(row);
    }
    List<dynamic> tot = [
      'TOTAL',
      totQuality,
      totFoodSafety,
      totCCP,
      totConsComplaints,
      '-',
      '-',
      '-',
      '-',
      '-',
    ];
    sheetObject.appendRow(tot);
  }

  void insertEhsReportRows(
    List<EhsReport> reportsList,
  ) {
    int totFirstAid = 0,
        totLostTime = 0,
        totRecordable = 0,
        totNearMiss = 0,
        totPreShift = 0;
    for (EhsReport report in reportsList) {
      totFirstAid += report.firstAid_incidents;
      totLostTime += report.lostTime_incidents;
      totRecordable += report.recordable_incidents;
      totNearMiss += report.nearMiss;
      totPreShift += report.risk_assessment;
      List<dynamic> row = [
        constructDateString(report.day, report.month, report.year),
        report.firstAid_incidents,
        report.lostTime_incidents,
        report.recordable_incidents,
        report.nearMiss,
        report.risk_assessment,
        S7[report.s7_index],
        report.month,
        getWeekNumber(report.day, report.month, report.year),
        report.year,
      ];
      // print(row);
      sheetObject.appendRow(row);
    }
    List<dynamic> tot = [
      'TOTAL',
      totFirstAid,
      totLostTime,
      totRecordable,
      totNearMiss,
      totPreShift,
      '-',
      '-',
      '-',
      '-',
    ];
    sheetObject.appendRow(tot);
  }

  void insertDtReportRows(
    List<DownTimeReport> reportsList,
  ) {
    int totMinutes = 0;
    for (DownTimeReport report in reportsList) {
      totMinutes += getTimeDifference(
          report.yearFrom,
          report.monthFrom,
          report.dayFrom,
          report.yearTo,
          report.monthTo,
          report.dayTo,
          report.hour_from,
          report.minute_from,
          report.hour_to,
          report.minute_to);
      List<dynamic> row = [
        constructDateString(report.dayFrom, report.monthFrom, report.yearFrom),
        prodType[report.area],
        report.shift_index + 1,
        report.supName,
        report.skuName,
        prod_lines4[report.line_index - 1],
        report.causeType,
        report.machine,
        report.isPlanned,
        constructTimeString(report.hour_from, report.minute_from),
        constructTimeString(report.hour_to, report.minute_to),
        getTimeDifference(
            report.yearFrom,
            report.monthFrom,
            report.dayFrom,
            report.yearTo,
            report.monthTo,
            report.dayTo,
            report.hour_from,
            report.minute_from,
            report.hour_to,
            report.minute_to),
        y_nDesc[report.isStopped_index],
        report.rootCauseDrop,
        report.rootCauseDesc,
        report.wfCategory,
        y_nDesc[report.isApproved],
        report.approved_by,
        y_nDesc[report.isRejected],
        report.rejected_by,
        report.rejectComment,
        report.technicianName,
        constructDateString(
                report.report_day, report.report_month, report.report_year) +
            " " +
            constructTimeString(report.report_hour, report.report_minute),
        report.monthFrom,
        getWeekNumber(report.dayFrom, report.monthFrom, report.yearFrom),
        report.yearFrom,
      ];
      // print(row);
      sheetObject.appendRow(row);
    }
    List<dynamic> tot = [
      'TOTAL',
      '-',
      '-',
      '-',
      '-',
      '-',
      '-',
      '-',
      '-',
      '-',
      '-',
      totMinutes,
      '-',
      '-',
      '-',
      '-',
      '-',
      '-',
      '-',
      '-',
      '-',
      '-',
      '-',
      '-',
      '-',
      '-',
    ];
    sheetObject.appendRow(tot);
  }
}
