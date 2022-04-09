import 'dart:collection';

import 'package:cairo_bisco_app/classes/Credentials.dart';
import 'package:cairo_bisco_app/classes/utility_funcs/date_utility.dart';
import 'package:cairo_bisco_app/classes/values/constants.dart';
import 'package:cairo_bisco_app/ui/error_success_screens/success.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DownTimeReport {
  final String supName,
      machine,
      responsible,
      rootCauseDrop,
      rootCauseDesc,
      causeType,
      skuName,
      wfCategory,
      approved_by,
      technicianName;
  final int line_index,
      shift_index,
      area,
      year,
      month,
      day,
      planned_index,
      hour_from,
      hour_to,
      minute_from,
      minute_to,
      isStopped_index,
      isApproved;

  DownTimeReport({
    required this.machine,
    required this.responsible,
    required this.rootCauseDrop,
    required this.rootCauseDesc,
    required this.wfCategory,
    required this.line_index,
    required this.planned_index,
    required this.hour_from,
    required this.hour_to,
    required this.minute_from,
    required this.minute_to,
    required this.isStopped_index,
    required this.area,
    required this.supName,
    required this.year,
    required this.shift_index,
    required this.month,
    required this.day,
    required this.causeType,
    required this.isApproved,
    required this.approved_by,
    required this.skuName,
    required this.technicianName,
  });

  DownTimeReport.fromJson(Map<String, Object?> json)
      : this(
          year: json['year']! as int,
          month: json['month']! as int,
          day: json['day']! as int,
          area: json['area']! as int,
          line_index: json['line_index']! as int,
          shift_index: json['shift_index']! as int,
          planned_index: json['planned_index']! as int,
          hour_from: json['hour_from']! as int,
          hour_to: json['hour_to']! as int,
          minute_from: json['minute_from']! as int,
          minute_to: json['minute_to']! as int,
          isStopped_index: json['isStopped_index']! as int,
          supName: json['supName']! as String,
          machine: json['machine']! as String,
          responsible: json['responsible']! as String,
          rootCauseDrop: json['rootCauseDrop']! as String,
          rootCauseDesc: json['rootCauseDesc']! as String,
          wfCategory: json['wfCategory']! as String,
          causeType: json['causeType']! as String,
          isApproved: json['isApproved']! as int,
          skuName: json['skuName']! as String,
          approved_by: json['approved_by']! as String,
          technicianName: json['technicianName'] == null
              ? ''
              : json['technicianName']! as String,
        );

  Map<String, Object?> toJson() {
    return {
      'year': year,
      'month': month,
      'day': day,
      'area': area,
      'shift_index': shift_index,
      'supName': supName,
      'line_index': line_index,
      'planned_index': planned_index,
      'hour_from': hour_from,
      'hour_to': hour_to,
      'minute_from': minute_from,
      'minute_to': minute_to,
      'isStopped_index': isStopped_index,
      'machine': machine,
      'responsible': responsible,
      'rootCauseDrop': rootCauseDrop,
      'rootCauseDesc': rootCauseDesc,
      'wfCategory': wfCategory,
      'causeType': causeType,
      'isApproved': isApproved,
      'approved_by': approved_by,
      'skuName': skuName,
      'technicianName': technicianName,
    };
  }

  static void addReport(
    String supName,
    String skuName,
    String machine,
    String responsible,
    String rootCauseDrop,
    String rootCauseDesc,
    String wfCategory,
    String causeType,
    int shift_index,
    int area,
    int year,
    int month,
    int day,
    int line_index,
    int planned_index,
    int hour_from,
    int hour_to,
    int minute_from,
    int minute_to,
    int isStopped_index,
    String technicianName,
  ) async {
    final downTimeReportRef = FirebaseFirestore.instance
        .collection(factory_name)
        .doc('downtime_reports')
        .collection(year.toString())
        .withConverter<DownTimeReport>(
          fromFirestore: (snapshot, _) =>
              DownTimeReport.fromJson(snapshot.data()!),
          toFirestore: (report, _) => report.toJson(),
        );
    await downTimeReportRef.add(
      DownTimeReport(
        year: year,
        month: month,
        day: day,
        area: area,
        shift_index: shift_index,
        supName: supName,
        skuName: skuName,
        line_index: line_index,
        planned_index: planned_index,
        hour_from: hour_from,
        hour_to: hour_to,
        minute_from: minute_from,
        minute_to: minute_to,
        isStopped_index: isStopped_index,
        machine: machine,
        responsible: responsible,
        rootCauseDrop: rootCauseDrop,
        rootCauseDesc: rootCauseDesc,
        wfCategory: wfCategory,
        causeType: causeType,
        isApproved: NO,
        approved_by: '',
        technicianName: technicianName,
      ),
    );
  }

  static void editReport(
    context,
    String id,
    String supName,
    String skuName,
    String machine,
    String responsible,
    String rootCauseDrop,
    String rootCauseDesc,
    String wfCategory,
    String causeType,
    int shift_index,
    int area,
    int year,
    int month,
    int day,
    int line_index,
    int planned_index,
    int hour_from,
    int hour_to,
    int minute_from,
    int minute_to,
    int isStopped_index,
    String technicianName,
  ) async {
    final downTimeReportRef = FirebaseFirestore.instance
        .collection(factory_name)
        .doc('downtime_reports')
        .collection(year.toString())
        .withConverter<DownTimeReport>(
          fromFirestore: (snapshot, _) =>
              DownTimeReport.fromJson(snapshot.data()!),
          toFirestore: (report, _) => report.toJson(),
        );
    await downTimeReportRef
        .doc(id)
        .update({
          'year': year,
          'month': month,
          'day': day,
          'area': area,
          'shift_index': shift_index,
          'supName': supName,
          'skuName': skuName,
          'line_index': line_index,
          'planned_index': planned_index,
          'hour_from': hour_from,
          'hour_to': hour_to,
          'minute_from': minute_from,
          'minute_to': minute_to,
          'isStopped_index': isStopped_index,
          'machine': machine,
          'responsible': responsible,
          'rootCauseDrop': rootCauseDrop,
          'rootCauseDesc': rootCauseDesc,
          'wfCategory': wfCategory,
          'causeType': causeType,
          'technicianName': technicianName,
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
    final downTimeReportRef = FirebaseFirestore.instance
        .collection(factory_name)
        .doc('downtime_reports')
        .collection(year.toString())
        .withConverter<DownTimeReport>(
          fromFirestore: (snapshot, _) =>
              DownTimeReport.fromJson(snapshot.data()!),
          toFirestore: (report, _) => report.toJson(),
        );
    await downTimeReportRef
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

  static HashMap<String, DownTimeReport> getPendingReports(
    List<QueryDocumentSnapshot<DownTimeReport>> reportsList,
  ) {
    HashMap hashMap = new HashMap<String, DownTimeReport>();
    for (var report in reportsList) {
      if ((Credentials.isUserOwner ||
              Credentials.userAuthority.compareTo(report.data().responsible) ==
                  0) &&
          report.data().isApproved == NO) hashMap[report.id] = report.data();
    }
    print(hashMap.length);
    return hashMap as HashMap<String, DownTimeReport>;
  }

  static HashMap<String, DownTimeReport> getAllReportsOfInterval(
    List<QueryDocumentSnapshot<DownTimeReport>> reportsList,
    int month_from,
    int month_to,
    int day_from,
    int day_to,
    int year,
    int refNum,
  ) {
    HashMap hashMap = new HashMap<String, DownTimeReport>();
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
        print('debug :: DownTimeReport filtered out due to its date --> ' +
            report.data().day.toString());
        continue;
      }
      if (report.data().area == refNum) hashMap[report.id] = report.data();
    }
    return hashMap as HashMap<String, DownTimeReport>;
  }

  static DownTimeReport getFilteredReportOfInterval(
    List<QueryDocumentSnapshot<DownTimeReport>> reportsList,
    int month_from,
    int month_to,
    int day_from,
    int day_to,
    int year,
    int areaRequired,
  ) {
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
        print('debug :: DownTimeReport filtered out due to its date --> ' +
            report.data().day.toString());
        continue;
      }

      if (areaRequired != TOTAL_PLANT && report.data().area == areaRequired) {
        // all shifts all lines in one area

        // print('debug :: DownTimeReport chosen in second if');
      } else if (areaRequired == TOTAL_PLANT) {
        // all shifts all lines all areas

        // print('debug :: DownTimeReport chosen in third if');
      } else {
        // print('debug :: DownTimeReport filtered out due to conditions');
      }
    }
    //return the total in capsulized form
    return DownTimeReport(
      supName: '',
      skuName: '',
      causeType: '',
      line_index: -1,
      planned_index: -1,
      hour_from: -1,
      hour_to: -1,
      minute_from: -1,
      minute_to: -1,
      isStopped_index: -1,
      machine: '',
      responsible: '',
      rootCauseDrop: '',
      rootCauseDesc: '',
      wfCategory: '',
      shift_index: -1,
      area: areaRequired,
      year: -1,
      month: -1,
      day: -1,
      isApproved: NO,
      approved_by: '',
      technicianName: '',
    );
  }

  static DownTimeReport getEmptyReport() {
    return DownTimeReport(
      supName: '',
      skuName: '',
      shift_index: 0,
      line_index: 1,
      planned_index: 0,
      hour_from: -1,
      hour_to: -1,
      minute_from: -1,
      minute_to: -1,
      isStopped_index: 0,
      causeType: '',
      machine: '',
      responsible: '',
      rootCauseDrop: '',
      rootCauseDesc: '',
      wfCategory: '',
      area: -1,
      year: -1,
      month: -1,
      day: -1,
      isApproved: NO,
      approved_by: '',
      technicianName: '',
    );
  }

  static Future<void> approveReport(context, String reportID) async {
    final downTimeReportRef = FirebaseFirestore.instance
        .collection(factory_name)
        .doc('downtime_reports')
        .collection(getYear().toString())
        .withConverter<DownTimeReport>(
          fromFirestore: (snapshot, _) =>
              DownTimeReport.fromJson(snapshot.data()!),
          toFirestore: (report, _) => report.toJson(),
        );
    await downTimeReportRef
        .doc(reportID)
        .update({
          'approved_by': Credentials.getUserName(),
          'isApproved': YES,
        })
        .then((value) => {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text("Report Approved"),
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
}
