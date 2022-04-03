import 'dart:collection';

import 'package:cairo_bisco_app/classes/DownTimeReport.dart';
import 'package:cairo_bisco_app/classes/utility_funcs/date_utility.dart';

class DownTimeSummary {
  final String date,
      supName,
      reportID,
      from_time,
      to_time,
      root_cause,
      type,
      wastedMinutes;
  final DownTimeReport reportDetails;

  DownTimeSummary({
    required this.date,
    required this.supName,
    required this.reportID,
    required this.from_time,
    required this.to_time,
    required this.root_cause,
    required this.type,
    required this.reportDetails,
    required this.wastedMinutes,
  });

  static List<DownTimeSummary> makeList(
      context, HashMap<String, DownTimeReport> map) {
    List<DownTimeSummary> tempList = [];
    map.entries.forEach((e) {
      DownTimeSummary tempTitle = DownTimeSummary(
        date: constructDateString(e.value.day, e.value.month, e.value.year),
        supName: e.value.supName,
        reportDetails: e.value,
        reportID: e.key,
        type: e.value.causeType,
        to_time:
            constructTimeString(context, e.value.hour_to, e.value.minute_to),
        from_time: constructTimeString(
            context, e.value.hour_from, e.value.minute_from),
        root_cause: e.value.rootCauseDrop,
        wastedMinutes: getTimeDifference(e.value.hour_from, e.value.minute_from,
                e.value.hour_to, e.value.minute_to)
            .toString(),
      );
      tempList.add(tempTitle);
    });
    return tempList;
  }
}
