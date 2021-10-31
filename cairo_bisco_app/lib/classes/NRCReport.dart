import 'dart:collection';

import 'package:cairo_bisco_app/classes/utility_funcs/date_utility.dart';
import 'package:cairo_bisco_app/classes/values/constants.dart';
import 'package:cairo_bisco_app/ui/error_success_screens/success.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class NRCReport {
  final String supName, notes_details;
  final int notes_count, shift_index, area, year, month, day;

  NRCReport({
    required this.area,
    required this.notes_count,
    required this.notes_details,
    required this.supName,
    required this.year,
    required this.shift_index,
    required this.month,
    required this.day,
  });

  NRCReport.fromJson(Map<String, Object?> json)
      : this(
          year: json['year']! as int,
          month: json['month']! as int,
          day: json['day']! as int,
          area: json['area']! as int,
          shift_index: json['shift_index']! as int,
          supName: json['supName']! as String,
          notes_count: json['notes_count']! as int,
          notes_details: json['notes_details']! as String,
        );

  Map<String, Object?> toJson() {
    return {
      'year': year,
      'month': month,
      'day': day,
      'area': area,
      'shift_index': shift_index,
      'supName': supName,
      'notes_count': notes_count,
      'notes_details': notes_details,
    };
  }

  static void addReport(
    String supName,
    int notes_count,
    String notes_details,
    int shift_index,
    int area,
    int year,
    int month,
    int day,
  ) async {
    final nrcReportRef = FirebaseFirestore.instance
        .collection(factory_name)
        .doc('nrc_reports')
        .collection(year.toString())
        .withConverter<NRCReport>(
          fromFirestore: (snapshot, _) => NRCReport.fromJson(snapshot.data()!),
          toFirestore: (report, _) => report.toJson(),
        );
    await nrcReportRef.add(
      NRCReport(
        supName: supName,
        shift_index: shift_index,
        notes_count: notes_count,
        notes_details: notes_details,
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
    int notes_count,
    String notes_details,
    int shift_index,
    int area,
    int year,
    int month,
    int day,
  ) async {
    final nrcReportRef = FirebaseFirestore.instance
        .collection(factory_name)
        .doc('nrc_reports')
        .collection(year.toString())
        .withConverter<NRCReport>(
          fromFirestore: (snapshot, _) => NRCReport.fromJson(snapshot.data()!),
          toFirestore: (report, _) => report.toJson(),
        );
    await nrcReportRef
        .doc(id)
        .update({
          'year': year,
          'month': month,
          'day': day,
          'area': area,
          'shift_index': shift_index,
          'supName': supName,
          'notes_count': notes_count,
          'notes_details': notes_details,
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
    final nrcReportRef = FirebaseFirestore.instance
        .collection(factory_name)
        .doc('nrc_reports')
        .collection(year.toString())
        .withConverter<NRCReport>(
          fromFirestore: (snapshot, _) => NRCReport.fromJson(snapshot.data()!),
          toFirestore: (report, _) => report.toJson(),
        );
    await nrcReportRef
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

  static HashMap<String, NRCReport> getAllReportsOfInterval(
    List<QueryDocumentSnapshot<NRCReport>> reportsList,
    int month_from,
    int month_to,
    int day_from,
    int day_to,
    int year,
    int refNum,
  ) {
    HashMap hashMap = new HashMap<String, NRCReport>();
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
        print('debug :: NRCReport filtered out due to its date --> ' +
            report.data().day.toString());
        continue;
      }
      if (report.data().area == refNum) hashMap[report.id] = report.data();
    }
    return hashMap as HashMap<String, NRCReport>;
  }

  static NRCReport getFilteredReportOfInterval(
    List<QueryDocumentSnapshot<NRCReport>> reportsList,
    int month_from,
    int month_to,
    int day_from,
    int day_to,
    int year,
    int areaRequired,
  ) {
    int temp_total_notes = 0;
    String temp_all_notes_details = '';

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
        print('debug :: NRCReport filtered out due to its date --> ' +
            report.data().day.toString());
        continue;
      }

      if (areaRequired != -1 && report.data().area == areaRequired) {
        // all shifts all lines in one area
        temp_total_notes += report.data().notes_count;
        temp_all_notes_details += report.data().notes_details;
        // print('debug :: NRCReport chosen in second if');
      } else if (areaRequired == -1) {
        // all shifts all lines all areas
        temp_total_notes += report.data().notes_count;
        temp_all_notes_details += report.data().notes_details;
        // print('debug :: NRCReport chosen in third if');
      } else {
        // print('debug :: NRCReport filtered out due to conditions');
      }
    }
    //return the total in capsulized form
    return NRCReport(
      supName: '',
      notes_count: temp_total_notes,
      notes_details: temp_all_notes_details,
      shift_index: -1,
      area: areaRequired,
      year: -1,
      month: -1,
      day: -1,
    );
  }

  static NRCReport getEmptyReport() {
    return NRCReport(
      supName: '',
      notes_count: 0,
      notes_details: '',
      shift_index: 0,
      area: -1,
      year: -1,
      month: -1,
      day: -1,
    );
  }
}
