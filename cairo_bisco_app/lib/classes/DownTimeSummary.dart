import 'dart:collection';

import 'package:cairo_bisco_app/classes/DownTimeReport.dart';
import 'package:cairo_bisco_app/classes/utility_funcs/date_time_utility.dart';
import 'package:cairo_bisco_app/classes/values/constants.dart';
import 'package:cairo_bisco_app/classes/values/form_values.dart';

class DownTimeSummary {
  final String dateFrom,
      dateTo,
      supName,
      reportID,
      from_time,
      to_time,
      root_cause,
      type,
      wastedMinutes,
      technicianName,
      responsible,
      lineName,
      areaName,
      stoppedStatus,
      //4.0.1 additions
      rejected_by,
      rejectComment;
  final DownTimeReport reportDetails;
  final int is_rejected;

  DownTimeSummary({
    required this.dateFrom,
    required this.dateTo,
    required this.supName,
    required this.reportID,
    required this.from_time,
    required this.to_time,
    required this.root_cause,
    required this.type,
    required this.reportDetails,
    required this.wastedMinutes,
    required this.technicianName,
    required this.responsible,
    required this.lineName,
    required this.areaName,
    required this.stoppedStatus,
    //4.0.1 additions
    required this.rejectComment,
    required this.rejected_by,
    required this.is_rejected,
  });

  static List<DownTimeSummary> makeList(
      context, HashMap<String, DownTimeReport> map) {
    List<DownTimeSummary> tempList = [];
    map.entries.forEach((e) {
      DownTimeSummary tempTitle = DownTimeSummary(
        dateFrom: constructDateString(
            e.value.dayFrom, e.value.monthFrom, e.value.yearFrom),
        dateTo:
            constructDateString(e.value.dayTo, e.value.monthTo, e.value.yearTo),
        supName: e.value.supName,
        reportDetails: e.value,
        reportID: e.key,
        type: e.value.causeType,
        to_time: constructTimeString(e.value.hour_to, e.value.minute_to),
        from_time: constructTimeString(e.value.hour_from, e.value.minute_from),
        root_cause: e.value.rootCauseDrop,
        wastedMinutes: getTimeDifference(
                e.value.yearFrom,
                e.value.monthFrom,
                e.value.dayFrom,
                e.value.yearTo,
                e.value.monthTo,
                e.value.dayTo,
                e.value.hour_from,
                e.value.minute_from,
                e.value.hour_to,
                e.value.minute_to)
            .toString(),
        technicianName: e.value.technicianName,
        responsible: e.value.responsible,
        lineName: prod_lines4[e.value.line_index - 1],
        areaName: prodType[e.value.area],
        stoppedStatus: e.value.isStopped_index == YES //= there is product
            ? "Line Didn't Stop"
            : "Line Stopped",
        //4.0.1 additions
        rejectComment: e.value.rejectComment,
        rejected_by: e.value.rejected_by,
        is_rejected: e.value.isRejected,
      );
      tempList.add(tempTitle);
    });
    return tempList;
  }
}
