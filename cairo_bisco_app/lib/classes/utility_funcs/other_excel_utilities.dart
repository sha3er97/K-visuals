import 'dart:io';
import 'dart:math';

import 'package:cairo_bisco_app/classes/EhsReport.dart';
import 'package:cairo_bisco_app/classes/OverWeightReport.dart';
import 'package:cairo_bisco_app/classes/QfsReport.dart';
import 'package:cairo_bisco_app/classes/utility_funcs/date_utility.dart';
import 'package:cairo_bisco_app/classes/values/constants.dart';
import 'package:cairo_bisco_app/classes/values/form_values.dart';
import 'package:cairo_bisco_app/components/alert_dialog.dart';
import 'package:cross_file/cross_file.dart';
import 'package:excel/excel.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:permission_handler/permission_handler.dart';

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
      List<String> row = [
        constructDateString(qfsReportsList[i].day, qfsReportsList[i].month,
            qfsReportsList[i].year),
        qfsReportsList[i].quality_incidents.toString(),
        qfsReportsList[i].food_safety_incidents.toString(),
        qfsReportsList[i].ccp_failure.toString(),
        (qfsReportsList[i].consumer_complaints +
                dailyReportsList[i].consumer_complaints)
            .toString(),
        G6[max(qfsReportsList[i].g6_index, dailyReportsList[i].g6_index)],
        Pes[max(qfsReportsList[i].pes_index, dailyReportsList[i].pes_index)],
        qfsReportsList[i].month.toString(),
        getWeekNumber(qfsReportsList[i].day, qfsReportsList[i].month,
                qfsReportsList[i].year)
            .toString(),
        qfsReportsList[i].year.toString(),
      ];
      // print(row);
      sheetObject.appendRow(row);
    }
    List<String> tot = [
      'TOTAL',
      totQuality.toString(),
      totFoodSafety.toString(),
      totCCP.toString(),
      totConsComplaints.toString(),
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
      List<String> row = [
        constructDateString(report.day, report.month, report.year),
        report.firstAid_incidents.toString(),
        report.lostTime_incidents.toString(),
        report.recordable_incidents.toString(),
        report.nearMiss.toString(),
        report.risk_assessment.toString(),
        S7[report.s7_index],
        report.month.toString(),
        getWeekNumber(report.day, report.month, report.year).toString(),
        report.year.toString(),
      ];
      // print(row);
      sheetObject.appendRow(row);
    }
    List<String> tot = [
      'TOTAL',
      totFirstAid.toString(),
      totLostTime.toString(),
      totRecordable.toString(),
      totNearMiss.toString(),
      totPreShift.toString(),
      '-',
      '-',
      '-',
      '-',
    ];
    sheetObject.appendRow(tot);
  }
}
