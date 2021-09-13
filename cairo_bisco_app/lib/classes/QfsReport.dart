import 'dart:math';
import 'package:cairo_bisco_app/classes/values/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class QfsReport {
  final String supName;
  final int quality_incidents,
      food_safety_incidents,
      ccp_failure,
      consumer_complaints,
      pes_index,
      g6_index,
      line_index,
      shift_index,
      area,
      year,
      month,
      day;

  QfsReport(
      {required this.area,
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
      required this.consumer_complaints});

  QfsReport.fromJson(Map<String, Object?> json)
      : this(
          year: json['year']! as int,
          month: json['month']! as int,
          day: json['day']! as int,
          area: json['area']! as int,
          shift_index: json['shift_index']! as int,
          line_index: json['line']! as int,
          pes_index: json['pes']! as int,
          g6_index: json['g6']! as int,
          supName: json['supName']! as String,
          quality_incidents: json['quality_incidents']! as int,
          food_safety_incidents: json['food_safety_incidents']! as int,
          ccp_failure: json['ccp_failure']! as int,
          consumer_complaints: json['consumer_complaints']! as int,
        );

  Map<String, Object?> toJson() {
    return {
      'year': year,
      'month': month,
      'day': day,
      'area': area,
      'shift_index': shift_index,
      'line_index': line_index,
      'pes_index': pes_index,
      'g6_index': g6_index,
      'supName': supName,
      'quality_incidents': quality_incidents,
      'food_safety_incidents': food_safety_incidents,
      'ccp_failure': ccp_failure,
      'consumer_complaints': consumer_complaints,
    };
  }

  static void addReport(
      supName,
      quality_incidents,
      food_safety_incidents,
      ccp_failure,
      consumer_complaints,
      year,
      month,
      day,
      shift_index,
      line_index,
      pes_index,
      g6_index,
      area) async {
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
        consumer_complaints: consumer_complaints,
        shift_index: shift_index,
        line_index: line_index,
        pes_index: pes_index,
        g6_index: g6_index,
        area: area,
        year: year,
        month: month,
        day: day,
      ),
    );
  }

  static Future<QfsReport> getFilteredReportOfDay(
      year, month, day, areaRequired, lineNumRequired) async {
    final qualityReportRef = FirebaseFirestore.instance
        .collection(factory_name)
        .doc('quality_reports')
        .collection(year.toString())
        .withConverter<QfsReport>(
          fromFirestore: (snapshot, _) => QfsReport.fromJson(snapshot.data()!),
          toFirestore: (report, _) => report.toJson(),
        );

    List<QueryDocumentSnapshot<QfsReport>> reportsList =
        await qualityReportRef.get().then((snapshot) => snapshot.docs);
    int temp_quality_incidents = 0,
        temp_food_safety_incidents = 0,
        temp_ccp_failure = 0,
        temp_consumer_complaints = 0,
        temp_pes_index = 0,
        temp_g6_index = 0,
        temp_day = 0,
        temp_month = 0,
        temp_year = 0;
    for (var report in reportsList) {
      temp_day = report.data().day;
      temp_month = report.data().month;
      temp_year = report.data().year;
      if (lineNumRequired != -1 &&
          areaRequired != -1 &&
          report.data().line_index == lineNumRequired &&
          report.data().area.toString().compareTo(areaRequired.toString()) ==
              0) {
        //all shifts in one line in one area
        temp_quality_incidents += report.data().quality_incidents;
        temp_food_safety_incidents += report.data().food_safety_incidents;
        temp_ccp_failure += report.data().ccp_failure;
        temp_consumer_complaints += report.data().consumer_complaints;
        temp_pes_index = max(temp_pes_index, report.data().pes_index);
        temp_g6_index = max(temp_g6_index, report.data().g6_index);
      } else if (lineNumRequired == -1 &&
          areaRequired != -1 &&
          report.data().area.toString().compareTo(areaRequired.toString()) ==
              0) {
        // all shifts all lines in one area
        temp_quality_incidents += report.data().quality_incidents;
        temp_food_safety_incidents += report.data().food_safety_incidents;
        temp_ccp_failure += report.data().ccp_failure;
        temp_consumer_complaints += report.data().consumer_complaints;
        temp_pes_index = max(temp_pes_index, report.data().pes_index);
        temp_g6_index = max(temp_g6_index, report.data().g6_index);
      } else if (areaRequired == -1) {
        // all shifts all lines all areas
        temp_quality_incidents += report.data().quality_incidents;
        temp_food_safety_incidents += report.data().food_safety_incidents;
        temp_ccp_failure += report.data().ccp_failure;
        temp_consumer_complaints += report.data().consumer_complaints;
        temp_pes_index = max(temp_pes_index, report.data().pes_index);
        temp_g6_index = max(temp_g6_index, report.data().g6_index);
      }
    }
    //return the total in capsulized form
    return QfsReport(
      supName: '',
      quality_incidents: temp_quality_incidents,
      food_safety_incidents: temp_food_safety_incidents,
      ccp_failure: temp_ccp_failure,
      consumer_complaints: temp_consumer_complaints,
      shift_index: -1,
      line_index: -1,
      pes_index: temp_pes_index,
      g6_index: temp_g6_index,
      area: -1,
      year: temp_year,
      month: temp_month,
      day: temp_day,
    );
  }
}
