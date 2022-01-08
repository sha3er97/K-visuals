import 'dart:collection';
import 'dart:math';

import 'package:cairo_bisco_app/classes/utility_funcs/date_utility.dart';
import 'package:cairo_bisco_app/classes/values/constants.dart';
import 'package:cairo_bisco_app/ui/error_success_screens/success.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class QfsReport {
  final String supName;
  final int quality_incidents,
      food_safety_incidents,
      ccp_failure,
      consumer_complaints, //for backward compatibility
      pes_index, //for backward compatibility
      g6_index, //for backward compatibility
      line_index,
      shift_index,
      area,
      year,
      month,
      day;

  QfsReport({
    required this.area,
    required this.shift_index, //unused for now
    required this.line_index,
    required this.pes_index,
    required this.g6_index,
    required this.supName,
    required this.quality_incidents,
    required this.food_safety_incidents,
    required this.ccp_failure,
    required this.year,
    required this.month,
    required this.day,
    required this.consumer_complaints,
  });

  QfsReport.fromJson(Map<String, Object?> json)
      : this(
          year: json['year']! as int,
          month: json['month']! as int,
          day: json['day']! as int,
          area: json['area']! as int,
          shift_index: json['shift_index']! as int,
          line_index: json['line_index']! as int,
          supName: json['supName']! as String,
          quality_incidents: json['quality_incidents']! as int,
          food_safety_incidents: json['food_safety_incidents']! as int,
          ccp_failure: json['ccp_failure']! as int,

          //for backward compatibility
          consumer_complaints: json['consumer_complaints'] == null
              ? 0
              : json['consumer_complaints']! as int,
          pes_index: json['pes_index'] == null ? 0 : json['pes_index']! as int,
          g6_index: json['g6_index'] == null ? 0 : json['g6_index']! as int,
        );

  Map<String, Object?> toJson() {
    return {
      'year': year,
      'month': month,
      'day': day,
      'area': area,
      'shift_index': shift_index,
      'line_index': line_index,
      'supName': supName,
      'quality_incidents': quality_incidents,
      'food_safety_incidents': food_safety_incidents,
      'ccp_failure': ccp_failure,
      // 'consumer_complaints': consumer_complaints,
      // 'pes_index': pes_index,
      // 'g6_index': g6_index,
    };
  }

  static void addReport(
    String supName,
    int quality_incidents,
    int food_safety_incidents,
    int ccp_failure,
    int year,
    int month,
    int day,
    int shift_index,
    int line_index,
    int area,
  ) async {
    final qualityReportRef = FirebaseFirestore.instance
        .collection(factory_name)
        .doc('quality_reports')
        .collection(year.toString())
        .withConverter<QfsReport>(
          fromFirestore: (snapshot, _) => QfsReport.fromJson(snapshot.data()!),
          toFirestore: (report, _) => report.toJson(),
        );
    await qualityReportRef.add(
      QfsReport(
        supName: supName,
        quality_incidents: quality_incidents,
        food_safety_incidents: food_safety_incidents,
        ccp_failure: ccp_failure,
        consumer_complaints: 0,
        //for backward compatibility
        shift_index: shift_index,
        line_index: line_index,
        pes_index: 0,
        //for backward compatibility
        g6_index: 0,
        //for backward compatibility
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
    int quality_incidents,
    int food_safety_incidents,
    int ccp_failure,
    int year,
    int month,
    int day,
    int shift_index,
    int line_index,
    int area,
  ) async {
    final qualityReportRef = FirebaseFirestore.instance
        .collection(factory_name)
        .doc('quality_reports')
        .collection(year.toString())
        .withConverter<QfsReport>(
          fromFirestore: (snapshot, _) => QfsReport.fromJson(snapshot.data()!),
          toFirestore: (report, _) => report.toJson(),
        );
    await qualityReportRef
        .doc(id)
        .update({
          'year': year,
          'month': month,
          'day': day,
          'area': area,
          'shift_index': shift_index,
          'line_index': line_index,
          'supName': supName,
          'quality_incidents': quality_incidents,
          'food_safety_incidents': food_safety_incidents,
          'ccp_failure': ccp_failure,
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
    final qualityReportRef = FirebaseFirestore.instance
        .collection(factory_name)
        .doc('quality_reports')
        .collection(year.toString())
        .withConverter<QfsReport>(
          fromFirestore: (snapshot, _) => QfsReport.fromJson(snapshot.data()!),
          toFirestore: (report, _) => report.toJson(),
        );
    await qualityReportRef
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

  static HashMap<String, QfsReport> getAllReportsOfInterval(
    List<QueryDocumentSnapshot<QfsReport>> reportsList,
    int month_from,
    int month_to,
    int day_from,
    int day_to,
    int year,
    int refNum,
  ) {
    HashMap hashMap = new HashMap<String, QfsReport>();
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
        print('debug :: QfsReport filtered out due to its date --> ' +
            report.data().day.toString());
        continue;
      }
      if (report.data().area == refNum) hashMap[report.id] = report.data();
    }
    return hashMap as HashMap<String, QfsReport>;
  }

  static QfsReport getFilteredReportOfInterval(
      List<QueryDocumentSnapshot<QfsReport>> reportsList,
      int month_from,
      int month_to,
      int day_from,
      int day_to,
      int year,
      int areaRequired,
      int lineNumRequired) {
    int temp_quality_incidents = 0,
        temp_food_safety_incidents = 0,
        temp_ccp_failure = 0,
        temp_consumer_complaints = 0, //for backward compatibility
        temp_pes_index = 0, //for backward compatibility
        temp_g6_index = 0; //for backward compatibility
    int temp_month = month_from, temp_day = day_from, temp_year = year;

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
        print('debug :: QfsReport filtered out due to its date --> ' +
            report.data().day.toString());
        continue;
      }

      if (lineNumRequired != ALL_LINES &&
          areaRequired != TOTAL_PLANT &&
          report.data().line_index == lineNumRequired &&
          report.data().area == areaRequired) {
        //all shifts in one line in one area
        temp_quality_incidents += report.data().quality_incidents;
        temp_food_safety_incidents += report.data().food_safety_incidents;
        temp_ccp_failure += report.data().ccp_failure;
        temp_consumer_complaints +=
            report.data().consumer_complaints; //for backward compatibility
        temp_pes_index = max(temp_pes_index,
            report.data().pes_index); //for backward compatibility
        temp_g6_index = max(
            temp_g6_index, report.data().g6_index); //for backward compatibility
        temp_month = report.data().month;
        temp_day = report.data().day;
        temp_year = report.data().year;
        // print('debug :: QfsReport chosen in first if');
      } else if (lineNumRequired == ALL_LINES &&
          areaRequired != TOTAL_PLANT &&
          report.data().area == areaRequired) {
        // all shifts all lines in one area
        temp_quality_incidents += report.data().quality_incidents;
        temp_food_safety_incidents += report.data().food_safety_incidents;
        temp_ccp_failure += report.data().ccp_failure;
        temp_consumer_complaints +=
            report.data().consumer_complaints; //for backward compatibility
        temp_pes_index = max(temp_pes_index,
            report.data().pes_index); //for backward compatibility
        temp_g6_index = max(
            temp_g6_index, report.data().g6_index); //for backward compatibility
        temp_month = report.data().month;
        temp_day = report.data().day;
        temp_year = report.data().year;
        // print('debug :: QfsReport chosen in second if');
      } else if (areaRequired == TOTAL_PLANT) {
        // all shifts all lines all areas
        temp_quality_incidents += report.data().quality_incidents;
        temp_food_safety_incidents += report.data().food_safety_incidents;
        temp_ccp_failure += report.data().ccp_failure;
        temp_consumer_complaints +=
            report.data().consumer_complaints; //for backward compatibility
        temp_pes_index = max(temp_pes_index,
            report.data().pes_index); //for backward compatibility
        temp_g6_index = max(
            temp_g6_index, report.data().g6_index); //for backward compatibility
        temp_month = report.data().month;
        temp_day = report.data().day;
        temp_year = report.data().year;
        // print('debug :: QfsReport chosen in third if');
      } else {
        // print('debug :: QfsReport filtered out');
      }
    }
    //return the total in capsulized form
    return QfsReport(
      supName: '',
      quality_incidents: temp_quality_incidents,
      food_safety_incidents: temp_food_safety_incidents,
      ccp_failure: temp_ccp_failure,
      shift_index: -1,
      line_index: lineNumRequired,
      pes_index: temp_pes_index,
      //for backward compatibility
      g6_index: temp_g6_index,
      //for backward compatibility
      consumer_complaints: temp_consumer_complaints,
      //for backward compatibility
      area: areaRequired,
      year: temp_year,
      month: temp_month,
      day: temp_day,
    );
  }

  static QfsReport getEmptyReport() {
    return QfsReport(
      supName: '',
      quality_incidents: 0,
      food_safety_incidents: 0,
      ccp_failure: 0,
      consumer_complaints: 0,
      //for backward compatibility
      shift_index: 0,
      line_index: 1,
      pes_index: 0,
      //for backward compatibility
      g6_index: 0,
      //for backward compatibility
      area: -1,
      year: -1,
      month: -1,
      day: -1,
    );
  }
}
