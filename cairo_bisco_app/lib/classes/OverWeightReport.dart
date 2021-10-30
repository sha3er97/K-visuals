import 'dart:collection';

import 'package:cairo_bisco_app/classes/utility_funcs/date_utility.dart';
import 'package:cairo_bisco_app/classes/values/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OverWeightReport {
  final String supName;
  final double percent;
  final int line_index, area, year, month, day;

  OverWeightReport({
    required this.area,
    required this.line_index,
    required this.supName,
    required this.year,
    required this.percent,
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
          percent: json['percent']! as double,
        );

  Map<String, Object?> toJson() {
    return {
      'year': year,
      'month': month,
      'day': day,
      'area': area,
      'line_index': line_index,
      'supName': supName,
      'percent': percent,
    };
  }

  static void addReport(
    String supName,
    double percent,
    int line_index,
    int area,
    int year,
    int month,
    int day,
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
        percent: percent,
        line_index: line_index,
        area: area,
        year: year,
        month: month,
        day: day,
      ),
    );
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
      if (report.data().area == refNum) hashMap[report.id] = report.data();
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
    int valid_reports_count = 0;

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

      if (lineNumRequired != -1 &&
          areaRequired != -1 &&
          report.data().line_index == lineNumRequired &&
          report.data().area == areaRequired) {
        //all shifts in one line in one area
        temp_percent += report.data().percent;
        valid_reports_count++;
        print('debug :: OverWeightReport chosen in first if');
      } else if (lineNumRequired == -1 &&
          areaRequired != -1 &&
          report.data().area == areaRequired) {
        // all shifts all lines in one area
        temp_percent += report.data().percent;
        valid_reports_count++;
        print('debug :: OverWeightReport chosen in second if');
      } else if (areaRequired == -1) {
        // all shifts all lines all areas
        temp_percent += report.data().percent;
        valid_reports_count++;
        print('debug :: OverWeightReport chosen in third if');
      } else {
        print('debug :: OverWeightReport filtered out due to conditions');
      }
    }
    //return the total in capsulized form
    return OverWeightReport(
      supName: '',
      percent: temp_percent / valid_reports_count,
      line_index: lineNumRequired,
      area: areaRequired,
      year: -1,
      month: -1,
      day: -1,
    );
  }

  static OverWeightReport getEmptyReport() {
    return OverWeightReport(
      supName: '',
      percent: 0.0,
      line_index: -1,
      area: -1,
      year: -1,
      month: -1,
      day: -1,
    );
  }
}
