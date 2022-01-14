import 'dart:collection';
import 'dart:math';

import 'package:cairo_bisco_app/classes/utility_funcs/calculations_utility.dart';
import 'package:cairo_bisco_app/classes/utility_funcs/date_utility.dart';
import 'package:cairo_bisco_app/classes/values/constants.dart';
import 'package:cairo_bisco_app/ui/error_success_screens/success.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class OverWeightReport {
  final String supName, skuName;
  final double percent;
  final int line_index,
      area,
      year,
      month,
      day,
      consumer_complaints,
      pes_index,
      g6_index;

  OverWeightReport({
    required this.area,
    required this.line_index,
    required this.supName,
    required this.year,
    required this.skuName,
    required this.percent,
    required this.consumer_complaints,
    required this.pes_index,
    required this.g6_index,
    required this.month,
    required this.day,
  });

  OverWeightReport.fromJson(Map<String, Object?> json)
      : this(
    year: json['year']! as int,
          month: json['month']! as int,
          day: json['day']! as int,
          area: json['area']! as int,
          line_index: json['line_index']! as int,
          supName: json['supName']! as String,
          consumer_complaints: json['consumer_complaints'] == null
              ? 0
              : json['consumer_complaints']! as int,
          skuName: json['skuName'] == null ? '-' : json['skuName']! as String,
          pes_index: json['pes_index'] == null ? 0 : json['pes_index']! as int,
          g6_index: json['g6_index'] == null ? 0 : json['g6_index']! as int,
          percent: parseJsonToDouble(json['percent']!),
        );

  Map<String, Object?> toJson() {
    return {
      'year': year,
      'month': month,
      'day': day,
      'area': area,
      'line_index': line_index,
      'supName': supName,
      'skuName': skuName,
      'percent': percent,
      'g6_index': g6_index,
      'pes_index': pes_index,
      'consumer_complaints': consumer_complaints,
    };
  }

  static void addReport(
    String supName,
    String skuName,
    double percent,
    int line_index,
    int area,
    int year,
    int month,
    int day,
    int g6_index,
    int pes_index,
    int consumer_complaints,
  ) async {
    final overWeightReportRef = FirebaseFirestore.instance
        .collection(factory_name)
        .doc('overWeight_reports')
        .collection(year.toString())
        .withConverter<OverWeightReport>(
          fromFirestore: (snapshot, _) =>
              OverWeightReport.fromJson(snapshot.data()!),
          toFirestore: (report, _) => report.toJson(),
        );
    await overWeightReportRef.add(
      OverWeightReport(
        supName: supName,
        skuName: skuName,
        percent: percent,
        line_index: line_index,
        area: area,
        year: year,
        month: month,
        day: day,
        consumer_complaints: consumer_complaints,
        pes_index: pes_index,
        g6_index: g6_index,
      ),
    );
  }

  static void editReport(
    context,
    String id,
    String supName,
    String skuName,
    double percent,
    int line_index,
    int area,
    int year,
    int month,
    int day,
    int g6_index,
    int pes_index,
    int consumer_complaints,
  ) async {
    final overWeightReportRef = FirebaseFirestore.instance
        .collection(factory_name)
        .doc('overWeight_reports')
        .collection(year.toString())
        .withConverter<OverWeightReport>(
          fromFirestore: (snapshot, _) =>
              OverWeightReport.fromJson(snapshot.data()!),
          toFirestore: (report, _) => report.toJson(),
        );
    await overWeightReportRef
        .doc(id)
        .update({
      'year': year,
      'month': month,
      'day': day,
      'area': area,
      'line_index': line_index,
      'supName': supName,
      'skuName': skuName,
      'percent': percent,
      'consumer_complaints': consumer_complaints,
      'pes_index': pes_index,
      'g6_index': g6_index,
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
    final overWeightReportRef = FirebaseFirestore.instance
        .collection(factory_name)
        .doc('overWeight_reports')
        .collection(year.toString())
        .withConverter<OverWeightReport>(
          fromFirestore: (snapshot, _) =>
              OverWeightReport.fromJson(snapshot.data()!),
          toFirestore: (report, _) => report.toJson(),
        );
    await overWeightReportRef
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

  static HashMap<String, OverWeightReport> getAllReportsOfInterval(
    List<QueryDocumentSnapshot<OverWeightReport>> reportsList,
    int month_from,
    int month_to,
    int day_from,
    int day_to,
    int year,
    int refNum,
  ) {
    HashMap hashMap = new HashMap<String, OverWeightReport>();
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
        print('debug :: OverWeightReport filtered out due to its date --> ' +
            report.data().day.toString());
        continue;
      }
      if (report.data().area == refNum || refNum == TOTAL_PLANT)
        hashMap[report.id] = report.data();
    }
    return hashMap as HashMap<String, OverWeightReport>;
  }

  static OverWeightReport getFilteredReportOfInterval(
    List<QueryDocumentSnapshot<OverWeightReport>> reportsList,
    int month_from,
    int month_to,
    int day_from,
    int day_to,
    int year,
    int areaRequired,
    int lineNumRequired,
  ) {
    double temp_percent = 0.0;
    int valid_reports_count = 0,
        temp_consumer_complaints = 0,
        temp_pes_index = 0,
        temp_g6_index = 0;
    int temp_month = month_from,
        temp_day = day_from,
        temp_year = year;
    String lastSkuName = '-';

    for (var report in reportsList) {
      if (!isDayInInterval(
        report
            .data()
            .day,
        report
            .data()
            .month,
        month_from,
        month_to,
        day_from,
        day_to,
        year,
      )) {
        print('debug :: OverWeightReport filtered out due to its date --> ' +
            report.data().day.toString());
        continue;
      }

      if (lineNumRequired != ALL_LINES &&
          areaRequired != TOTAL_PLANT &&
          report.data().line_index == lineNumRequired &&
          report.data().area == areaRequired) {
        //all shifts in one line in one area
        temp_percent += report
            .data()
            .percent;
        valid_reports_count++;
        temp_consumer_complaints += report
            .data()
            .consumer_complaints;
        temp_pes_index = max(temp_pes_index, report
            .data()
            .pes_index);
        temp_g6_index = max(temp_g6_index, report
            .data()
            .g6_index);
        temp_month = report
            .data()
            .month;
        temp_day = report
            .data()
            .day;
        temp_year = report
            .data()
            .year;
        lastSkuName = report
            .data()
            .skuName;
        print('debug :: OverWeightReport chosen in first if');
      } else if (lineNumRequired == ALL_LINES &&
          areaRequired != TOTAL_PLANT &&
          report.data().area == areaRequired) {
        // all shifts all lines in one area
        temp_percent += report.data().percent;
        valid_reports_count++;
        temp_consumer_complaints += report.data().consumer_complaints;
        temp_pes_index = max(temp_pes_index, report.data().pes_index);
        temp_g6_index = max(temp_g6_index, report.data().g6_index);
        temp_month = report.data().month;
        temp_day = report.data().day;
        temp_year = report.data().year;
        lastSkuName = report.data().skuName;
        print('debug :: OverWeightReport chosen in second if');
      } else if (areaRequired == TOTAL_PLANT) {
        // all shifts all lines all areas
        temp_percent += report.data().percent;
        valid_reports_count++;
        temp_consumer_complaints += report.data().consumer_complaints;
        temp_pes_index = max(temp_pes_index, report.data().pes_index);
        temp_g6_index = max(temp_g6_index, report.data().g6_index);
        temp_month = report.data().month;
        temp_day = report.data().day;
        temp_year = report.data().year;
        lastSkuName = report.data().skuName;
        print('debug :: OverWeightReport chosen in third if');
      } else {
        print('debug :: OverWeightReport filtered out due to conditions');
      }
    }
    //return the total in capsulized form
    return OverWeightReport(
      skuName: lastSkuName,
      supName: '',
      percent:
          valid_reports_count == 0 ? 0.0 : temp_percent / valid_reports_count,
      line_index: lineNumRequired,
      area: areaRequired,
      year: temp_year,
      month: temp_month,
      day: temp_day,
      pes_index: temp_pes_index,
      g6_index: temp_g6_index,
      consumer_complaints: temp_consumer_complaints,
    );
  }

  static OverWeightReport getEmptyReport() {
    return OverWeightReport(
      skuName: '',
      supName: '',
      percent: 0.0,
      line_index: 1,
      area: -1,
      year: -1,
      month: -1,
      day: -1,
      pes_index: 0,
      g6_index: 0,
      consumer_complaints: 0,
    );
  }
}
