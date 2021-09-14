import 'dart:math';
import 'package:cairo_bisco_app/classes/values/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EhsReport {
  final String supName;
  final int firstAid_incidents,
      lostTime_incidents,
      recordable_incidents,
      nearMiss,
      risk_assessment,
      s7_index,
      line_index,
      shift_index,
      area,
      year,
      month,
      day;

  EhsReport(
      {required this.area,
      required this.shift_index, //unused for now
      required this.line_index,
      required this.nearMiss,
      required this.risk_assessment,
      required this.supName,
      required this.firstAid_incidents,
      required this.lostTime_incidents,
      required this.recordable_incidents,
      required this.year,
      required this.month,
      required this.day,
      required this.s7_index});

  EhsReport.fromJson(Map<String, Object?> json)
      : this(
          year: json['year']! as int,
          month: json['month']! as int,
          day: json['day']! as int,
          area: json['area']! as int,
          shift_index: json['shift_index']! as int,
          line_index: json['line_index']! as int,
          s7_index: json['s7_index']! as int,
          nearMiss: json['nearMiss']! as int,
          supName: json['supName']! as String,
          risk_assessment: json['risk_assessment']! as int,
          firstAid_incidents: json['firstAid_incidents']! as int,
          lostTime_incidents: json['lostTime_incidents']! as int,
          recordable_incidents: json['recordable_incidents']! as int,
        );

  Map<String, Object?> toJson() {
    return {
      'year': year,
      'month': month,
      'day': day,
      'area': area,
      'shift_index': shift_index,
      'line_index': line_index,
      'recordable_incidents': recordable_incidents,
      'lostTime_incidents': lostTime_incidents,
      'supName': supName,
      'firstAid_incidents': firstAid_incidents,
      'risk_assessment': risk_assessment,
      'nearMiss': nearMiss,
      's7_index': s7_index,
    };
  }

  static void addReport(
      supName,
      firstAid_incidents,
      lostTime_incidents,
      recordable_incidents,
      nearMiss,
      risk_assessment,
      s7_index,
      line_index,
      shift_index,
      area,
      year,
      month,
      day) async {
    final ehsReportRef = FirebaseFirestore.instance
        .collection(factory_name)
        .doc('ehs_reports')
        .collection(year.toString())
        .withConverter<EhsReport>(
          fromFirestore: (snapshot, _) => EhsReport.fromJson(snapshot.data()!),
          toFirestore: (report, _) => report.toJson(),
        );
    await ehsReportRef.add(
      EhsReport(
        supName: supName,
        firstAid_incidents: firstAid_incidents,
        lostTime_incidents: lostTime_incidents,
        recordable_incidents: recordable_incidents,
        nearMiss: nearMiss,
        shift_index: shift_index,
        line_index: line_index,
        risk_assessment: risk_assessment,
        s7_index: s7_index,
        area: area,
        year: year,
        month: month,
        day: day,
      ),
    );
  }

  static EhsReport getFilteredReportOfInterval(reportsList, month_from,
      month_to, day_from, day_to, areaRequired, lineNumRequired) {
    int temp_firstAid_incidents = 0,
        temp_lostTime_incidents = 0,
        temp_recordable_incidents = 0,
        temp_nearMiss = 0,
        temp_risk_assessment = 0,
        temp_s7_index = 0;
    for (var report in reportsList) {
      if (report.data().day < day_from ||
          report.data().day > day_to ||
          report.data().month < month_from ||
          report.data().month > month_to) continue;

      if (lineNumRequired != -1 &&
          areaRequired != -1 &&
          report.data().line_index == lineNumRequired &&
          report.data().area == areaRequired) {
        //all shifts in one line in one area
        temp_firstAid_incidents += report.data().firstAid_incidents as int;
        temp_lostTime_incidents += report.data().lostTime_incidents as int;
        temp_recordable_incidents += report.data().recordable_incidents as int;
        temp_nearMiss += report.data().nearMiss as int;
        temp_risk_assessment += report.data().risk_assessment as int;
        temp_s7_index = max(temp_s7_index, report.data().s7_index);
      } else if (lineNumRequired == -1 &&
          areaRequired != -1 &&
          report.data().area == areaRequired) {
        // all shifts all lines in one area
        temp_firstAid_incidents += report.data().firstAid_incidents as int;
        temp_lostTime_incidents += report.data().lostTime_incidents as int;
        temp_recordable_incidents += report.data().recordable_incidents as int;
        temp_nearMiss += report.data().nearMiss as int;
        temp_risk_assessment += report.data().risk_assessment as int;
        temp_s7_index = max(temp_s7_index, report.data().s7_index);
      } else if (areaRequired == -1) {
        // all shifts all lines all areas
        temp_firstAid_incidents += report.data().firstAid_incidents as int;
        temp_lostTime_incidents += report.data().lostTime_incidents as int;
        temp_recordable_incidents += report.data().recordable_incidents as int;
        temp_nearMiss += report.data().nearMiss as int;
        temp_risk_assessment += report.data().risk_assessment as int;
        temp_s7_index = max(temp_s7_index, report.data().s7_index);
      } else {
        // print('debug :: report filtered out');
      }
    }
    //return the total in capsulized form
    return EhsReport(
      supName: '',
      s7_index: temp_s7_index,
      risk_assessment: temp_risk_assessment,
      nearMiss: temp_nearMiss,
      recordable_incidents: temp_recordable_incidents,
      shift_index: -1,
      line_index: -1,
      lostTime_incidents: temp_lostTime_incidents,
      firstAid_incidents: temp_firstAid_incidents,
      area: -1,
      year: -1,
      month: -1,
      day: -1,
    );
  }
}