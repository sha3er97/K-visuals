import 'dart:collection';
import 'dart:math';

import 'package:cairo_bisco_app/classes/utility_funcs/date_utility.dart';
import 'package:cairo_bisco_app/classes/values/constants.dart';
import 'package:cairo_bisco_app/ui/error_success_screens/success.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

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
    String supName,
    int firstAid_incidents,
    int lostTime_incidents,
    int recordable_incidents,
    int nearMiss,
    int risk_assessment,
    int s7_index,
    int line_index,
    int shift_index,
    int area,
    int year,
    int month,
    int day,
  ) async {
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

  static void editReport(
    context,
    String id,
    String supName,
    int firstAid_incidents,
    int lostTime_incidents,
    int recordable_incidents,
    int nearMiss,
    int risk_assessment,
    int s7_index,
    int line_index,
    int shift_index,
    int area,
    int year,
    int month,
    int day,
  ) async {
    final ehsReportRef = FirebaseFirestore.instance
        .collection(factory_name)
        .doc('ehs_reports')
        .collection(year.toString())
        .withConverter<EhsReport>(
          fromFirestore: (snapshot, _) => EhsReport.fromJson(snapshot.data()!),
          toFirestore: (report, _) => report.toJson(),
        );
    await ehsReportRef
        .doc(id)
        .update({
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
        })
        .then((value) => {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text("Report Updated"),
              )),
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SuccessScreen())),
            })
        .catchError((error) => {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text("Failed to update Report: $error"),
              ))
            });
  }

  static void deleteReport(
    context,
    String id,
    int year,
  ) async {
    final ehsReportRef = FirebaseFirestore.instance
        .collection(factory_name)
        .doc('ehs_reports')
        .collection(year.toString())
        .withConverter<EhsReport>(
          fromFirestore: (snapshot, _) => EhsReport.fromJson(snapshot.data()!),
          toFirestore: (report, _) => report.toJson(),
        );
    await ehsReportRef
        .doc(id)
        .delete()
        .then((value) => {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text("Report Deleted"),
              )),
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SuccessScreen())),
            })
        .catchError((error) => {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text("Failed to delete Report: $error"),
              ))
            });
  }

  static HashMap<String, EhsReport> getAllReportsOfInterval(
    List<QueryDocumentSnapshot<EhsReport>> reportsList,
    int month_from,
    int month_to,
    int day_from,
    int day_to,
    int year,
    int refNum,
  ) {
    HashMap hashMap = new HashMap<String, EhsReport>();
    for (var report in reportsList) {
      if (!isDayInInterval(
        report.data().day,
        report.data().month,
        month_from,
        month_to,
        day_from,
        day_to,
        year,
      )) {
        print('debug :: EhsReport filtered out due to its date --> ' +
            report.data().day.toString());
        continue;
      }
      if (report.data().area == refNum) hashMap[report.id] = report.data();
    }
    return hashMap as HashMap<String, EhsReport>;
  }

  static EhsReport getFilteredReportOfInterval(
      List<QueryDocumentSnapshot<EhsReport>> reportsList,
      int month_from,
      int month_to,
      int day_from,
      int day_to,
      int year,
      int areaRequired,
      int lineNumRequired) {
    int temp_firstAid_incidents = 0,
        temp_lostTime_incidents = 0,
        temp_recordable_incidents = 0,
        temp_nearMiss = 0,
        temp_risk_assessment = 0,
        temp_s7_index = 0;
    for (var report in reportsList) {
      if (!isDayInInterval(
        report.data().day,
        report.data().month,
        month_from,
        month_to,
        day_from,
        day_to,
        year,
      )) {
        print('debug :: EhsReport filtered out due to its date --> ' +
            report.data().day.toString());
        continue;
      }

      if (lineNumRequired != -1 &&
          areaRequired != TOTAL_PLANT &&
          report.data().line_index == lineNumRequired &&
          report.data().area == areaRequired) {
        //all shifts in one line in one area
        temp_firstAid_incidents += report.data().firstAid_incidents;
        temp_lostTime_incidents += report.data().lostTime_incidents;
        temp_recordable_incidents += report.data().recordable_incidents;
        temp_nearMiss += report.data().nearMiss;
        temp_risk_assessment += report.data().risk_assessment;
        temp_s7_index = max(temp_s7_index, report.data().s7_index);
        // print('debug :: EhsReport chosen in first if');
      } else if (lineNumRequired == -1 &&
          areaRequired != TOTAL_PLANT &&
          report.data().area == areaRequired) {
        // all shifts all lines in one area
        temp_firstAid_incidents += report.data().firstAid_incidents;
        temp_lostTime_incidents += report.data().lostTime_incidents;
        temp_recordable_incidents += report.data().recordable_incidents;
        temp_nearMiss += report.data().nearMiss;
        temp_risk_assessment += report.data().risk_assessment;
        temp_s7_index = max(temp_s7_index, report.data().s7_index);
        // print('debug :: EhsReport chosen in second if');
      } else if (areaRequired == TOTAL_PLANT) {
        // all shifts all lines all areas
        temp_firstAid_incidents += report.data().firstAid_incidents;
        temp_lostTime_incidents += report.data().lostTime_incidents;
        temp_recordable_incidents += report.data().recordable_incidents;
        temp_nearMiss += report.data().nearMiss;
        temp_risk_assessment += report.data().risk_assessment;
        temp_s7_index = max(temp_s7_index, report.data().s7_index);
        // print('debug :: EhsReport chosen in third if');
      } else {
        // print('debug :: EhsReport filtered out due to conditions');
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
      line_index: lineNumRequired,
      lostTime_incidents: temp_lostTime_incidents,
      firstAid_incidents: temp_firstAid_incidents,
      area: areaRequired,
      year: -1,
      month: -1,
      day: -1,
    );
  }

  static EhsReport getEmptyReport() {
    return EhsReport(
      supName: '',
      s7_index: 0,
      risk_assessment: 0,
      nearMiss: 0,
      recordable_incidents: 0,
      shift_index: 0,
      line_index: 1,
      lostTime_incidents: 0,
      firstAid_incidents: 0,
      area: -1,
      year: -1,
      month: -1,
      day: -1,
    );
  }
}
