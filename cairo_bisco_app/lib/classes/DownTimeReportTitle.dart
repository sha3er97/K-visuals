import 'dart:collection';

import 'package:cairo_bisco_app/classes/DownTimeReport.dart';
import 'package:cairo_bisco_app/classes/utility_funcs/date_time_utility.dart';

class DownTimeReportTitle {
  final String date, supName, reportID, rootCause;
  final int shift, line;
  final dynamic reportDetails;

  DownTimeReportTitle({
    required this.date,
    required this.supName,
    required this.shift,
    required this.line,
    required this.reportDetails,
    required this.reportID,
    required this.rootCause,
  });

  /**
   * for DownTime reports with all details
   */
  static List<DownTimeReportTitle> downTimeReportToTitleList(
      HashMap<String, DownTimeReport> map) {
    List<DownTimeReportTitle> tempList = [];
    map.entries.forEach((e) {
      DownTimeReportTitle tempTitle = DownTimeReportTitle(
        date: constructDateString(
            e.value.dayFrom, e.value.monthFrom, e.value.yearFrom),
        supName: e.value.supName,
        shift: e.value.shift_index,
        line: e.value.line_index - 1,
        reportDetails: e.value,
        reportID: e.key,
        rootCause: e.value.rootCauseDrop,
      );
      tempList.add(tempTitle);
    });
    return tempList;
  }
}
