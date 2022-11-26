import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '/classes/utility_funcs/date_time_utility.dart';
import '/classes/utility_funcs/other_utility.dart';
import '/classes/values/constants.dart';
import '/ui/error_success_screens/success.dart';
import 'CauseCount.dart';

class NRCReport {
  final String supName, type, area;
  final int reading, plant, year, month, day;

  NRCReport({
    required this.area,
    required this.reading,
    required this.type,
    required this.supName,
    required this.plant,
    required this.year,
    required this.month,
    required this.day,
  });

  NRCReport.fromJson(Map<String, Object?> json)
      : this(
    year: json['year']! as int,
          month: json['month']! as int,
          day: json['day']! as int,
          area: json['area']! as String,
          supName: json['supName']! as String,
          reading: json['reading']! as int,
          plant: json['plant']! as int,
          type: json['type']! as String,
        );

  Map<String, Object?> toJson() {
    return {
      'year': year,
      'month': month,
      'day': day,
      'area': area,
      'plant': plant,
      'supName': supName,
      'reading': reading,
      'type': type,
    };
  }

  static void addReport(
    String supName,
    String area,
    String type,
    int reading,
    int plant,
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
        plant: plant,
        reading: reading,
        type: type,
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
    String area,
    String type,
    int reading,
    int plant,
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
          'plant': plant,
          'supName': supName,
          'reading': reading,
          'type': type,
        })
        .then((value) => {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
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
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
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
    HashMap hashMap = HashMap<String, NRCReport>();
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
        print(
            'debug :: NRCReport filtered out due to its date --> ${report.data().day}');
        continue;
      }
      if (report.data().plant == refNum) hashMap[report.id] = report.data();
    }
    return hashMap as HashMap<String, NRCReport>;
  }

  // static NRCReport getFilteredReportOfInterval(
  //   List<QueryDocumentSnapshot<NRCReport>> reportsList,
  //   int month_from,
  //   int month_to,
  //   int day_from,
  //   int day_to,
  //   int year,
  //   int areaRequired,
  // ) {
  //   int temp_total_notes = 0;
  //   String temp_all_type = '';
  //
  //   for (var report in reportsList) {
  //     if (!isDayInInterval(
  //       report.data().day,
  //       report.data().month,
  //       month_from,
  //       month_to,
  //       day_from,
  //       day_to,
  //       year,
  //     )) {
  //       print('debug :: NRCReport filtered out due to its date --> ${report.data().day}');
  //       continue;
  //     }
  //
  //     if (areaRequired != TOTAL_PLANT && report.data().plant == areaRequired) {
  //       // all shifts all lines in one area
  //       temp_total_notes += report.data().reading;
  //       temp_all_type += report.data().type;
  //       // print('debug :: NRCReport chosen in second if');
  //     } else if (areaRequired == TOTAL_PLANT) {
  //       // all shifts all lines all areas
  //       temp_total_notes += report.data().reading;
  //       temp_all_type += report.data().type;
  //       // print('debug :: NRCReport chosen in third if');
  //     } else {
  //       // print('debug :: NRCReport filtered out due to conditions');
  //     }
  //   }
  //   //return the total in capsulized form
  //   return NRCReport(
  //     supName: '',
  //     reading: temp_total_notes,
  //     type: temp_all_type,
  //     shift_index: -1,
  //     area: areaRequired,
  //     year: -1,
  //     month: -1,
  //     day: -1,
  //   );
  // }

  static NRCReport getEmptyReport() {
    return NRCReport(
      supName: '',
      reading: 0,
      type: '',
      plant: -1,
      area: '',
      year: -1,
      month: -1,
      day: -1,
    );
  }

  static List<CauseCount> getIntervalReadings(
    List<QueryDocumentSnapshot<NRCReport>> reportsList,
    int month_from,
    int month_to,
    int day_from,
    int day_to,
    int year,
    String type,
  ) {
    HashMap<String, CauseCount> tempMap = HashMap<String, CauseCount>();
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
        // print(
        //     'debug :: NRC filtered out due to its date --> ${report.data().day}');
        continue;
      }
      if (stringFilterCheck(report.data().type, type, '-')
          // && intFilterCheck(report.data().plant, plant, TOTAL_PLANT)
          ) {
        if (tempMap[
                "${report.data().day}/${report.data().month}/${report.data().year}"] ==
            null) {
          tempMap["${report.data().day}/${report.data().month}/${report.data().year}"] =
              CauseCount(
                  "${report.data().day}/${report.data().month}/${report.data().year}",
                  report.data().reading);
        } else {
          tempMap["${report.data().day}/${report.data().month}/${report.data().year}"]!
              .incrementCount(report.data().reading);
        }
      } else {
        // print('debug :: NRC filtered out due to conditions');
      }
    }
    return tempMap.values.toList();
  }

  static List<CauseCount> getConsumptions(
    List<CauseCount> readings,
    int month_from,
    int day_from,
    int year,
  ) {
    readings.sort((b, a) => constructDateObjectFromString(b.causeName)
        .compareTo(constructDateObjectFromString(a.causeName))); //ascending
    int boundary = readings.length - 1;
    if (readings.length < 2) return readings;
    for (int i = readings.length - 1; i > 0; i--) {
      readings[i].decrementCount(readings[i - 1].count);
      int month = int.parse(readings[i - 1].causeName.split("/")[1]);
      int day = int.parse(readings[i - 1].causeName.split("/")[0]);
      if (DateTime(year, month, day)
              .isAfter(DateTime(year, month_from, day_from)) ||
          DateTime(year, month, day)
              .isAtSameMomentAs(DateTime(year, month_from, day_from))) {
        boundary = i - 1;
        // print("boundry reset to $boundary at $day/$month w.r.t $day_from/$month_from");
      } else {
        break;
        // print("boundry stays at $boundary at $day/$month w.r.t $day_from/$month_from");
      }
    }
    return readings.sublist(boundary, readings.length);
  }
}
