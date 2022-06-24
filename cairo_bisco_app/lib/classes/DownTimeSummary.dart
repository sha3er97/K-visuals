import 'dart:collection';

import 'package:cairo_bisco_app/classes/DownTimeReport.dart';
import 'package:cairo_bisco_app/classes/utility_funcs/date_time_utility.dart';
import 'package:cairo_bisco_app/classes/values/constants.dart';
import 'package:cairo_bisco_app/classes/values/form_values.dart';

class DownTimeSummary {
  final String dateFrom,
      dateTo,
      reportID,
      from_time,
      to_time,
      wastedMinutes,
      lineName,
      areaName,
      stoppedStatus,
      reportDateTime,
      //4.0.5 additions
      rootCauseDesc;
  final DownTimeReport reportDetails;

  DownTimeSummary({
    required this.dateFrom,
    required this.dateTo,
    required this.reportID,
    required this.from_time,
    required this.to_time,
    required this.reportDetails,
    required this.wastedMinutes,
    required this.lineName,
    required this.areaName,
    required this.stoppedStatus,
    required this.reportDateTime,
    //4.0.5 additions
    required this.rootCauseDesc,
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
        reportDetails: e.value,
        reportID: e.key,
        reportDateTime: constructDateString(
                e.value.report_day, e.value.report_month, e.value.report_year) +
            " " +
            constructTimeString(
                context, e.value.report_hour, e.value.report_minute),
        to_time:
            constructTimeString(context, e.value.hour_to, e.value.minute_to),
        from_time: constructTimeString(
            context, e.value.hour_from, e.value.minute_from),
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
        lineName: prod_lines4[e.value.line_index - 1],
        areaName: prodType[e.value.area],
        stoppedStatus: e.value.isStopped_index == YES //= there is product
            ? "Line Didn't Stop"
            : "Line Stopped",
        //4.0.5 additions
        rootCauseDesc: e.value.rootCauseDesc,
      );
      tempList.add(tempTitle);
    });
    return tempList;
  }
}
