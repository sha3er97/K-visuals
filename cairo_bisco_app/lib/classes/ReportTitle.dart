import 'dart:collection';

import 'package:cairo_bisco_app/classes/DownTimeReport.dart';
import 'package:cairo_bisco_app/classes/utility_funcs/date_utility.dart';

class ReportTitle {
  final String date, supName, reportID;
  final int shift, line;
  final dynamic reportDetails;

  ReportTitle({
    required this.date,
    required this.supName,
    required this.shift,
    required this.line,
    required this.reportDetails,
    required this.reportID,
  });

  /**
   * for OverWeight reports with no shifts
   */
  static List<ReportTitle> missingShiftReportToTitleList(
      HashMap<String, dynamic> map) {
    List<ReportTitle> tempList = [];
    map.entries.forEach((e) {
      ReportTitle tempTitle = ReportTitle(
        date: constructDateString(e.value.day, e.value.month, e.value.year),
        supName: e.value.supName,
        shift: -1,
        line: e.value.line_index - 1,
        reportDetails: e.value,
        reportID: e.key,
      );
      tempList.add(tempTitle);
    });
    return tempList;
  }

  /**
   * for People,NRC reports with no line
   */
  static List<ReportTitle> missingLineReportToTitleList(
      HashMap<String, dynamic> map) {
    List<ReportTitle> tempList = [];
    map.entries.forEach((e) {
      ReportTitle tempTitle = ReportTitle(
        date: constructDateString(e.value.day, e.value.month, e.value.year),
        supName: e.value.supName,
        shift: e.value.shift_index,
        line: -1,
        reportDetails: e.value,
        reportID: e.key,
      );
      tempList.add(tempTitle);
    });
    return tempList;
  }

  /**
   * for Production reports with all details
   */
  static List<ReportTitle> fullReportToTitleList(HashMap<String, dynamic> map) {
    List<ReportTitle> tempList = [];
    map.entries.forEach((e) {
      ReportTitle tempTitle = ReportTitle(
        date: constructDateString(e.value.day, e.value.month, e.value.year),
        supName: e.value.supName,
        shift: e.value.shift_index,
        line: e.value.line_index - 1,
        reportDetails: e.value,
        reportID: e.key,
      );
      tempList.add(tempTitle);
    });
    return tempList;
  }

  /**
   * for DownTime reports with all details
   */
  static List<ReportTitle> downTimeReportToTitleList(
      HashMap<String, DownTimeReport> map) {
    List<ReportTitle> tempList = [];
    map.entries.forEach((e) {
      ReportTitle tempTitle = ReportTitle(
        date: constructDateString(
            e.value.dayFrom, e.value.monthFrom, e.value.yearFrom),
        supName: e.value.supName,
        shift: e.value.shift_index,
        line: e.value.line_index - 1,
        reportDetails: e.value,
        reportID: e.key,
      );
      tempList.add(tempTitle);
    });
    return tempList;
  }
}
