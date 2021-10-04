import 'package:cairo_bisco_app/classes/utility_funcs/date_utility.dart';
import 'package:cairo_bisco_app/classes/values/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PeopleReport {
  final String supName;
  final int original_people,
      attended_people,
      shift_index,
      area,
      year,
      month,
      day;

  PeopleReport({
    required this.area,
    required this.original_people,
    required this.attended_people,
    required this.supName,
    required this.year,
    required this.shift_index,
    required this.month,
    required this.day,
  });

  PeopleReport.fromJson(Map<String, Object?> json)
      : this(
          year: json['year']! as int,
          month: json['month']! as int,
          day: json['day']! as int,
          area: json['area']! as int,
          shift_index: json['shift_index']! as int,
          supName: json['supName']! as String,
          original_people: json['original_people']! as int,
          attended_people: json['attended_people']! as int,
        );

  Map<String, Object?> toJson() {
    return {
      'year': year,
      'month': month,
      'day': day,
      'area': area,
      'shift_index': shift_index,
      'supName': supName,
      'original_people': original_people,
      'attended_people': attended_people,
    };
  }

  static void addReport(
    String supName,
    int original_people,
    int attended_people,
    int shift_index,
    int area,
    int year,
    int month,
    int day,
  ) async {
    final peopleReportRef = FirebaseFirestore.instance
        .collection(factory_name)
        .doc('people_reports')
        .collection(year.toString())
        .withConverter<PeopleReport>(
          fromFirestore: (snapshot, _) =>
              PeopleReport.fromJson(snapshot.data()!),
          toFirestore: (report, _) => report.toJson(),
        );
    await peopleReportRef.add(
      PeopleReport(
        supName: supName,
        shift_index: shift_index,
        attended_people: attended_people,
        original_people: original_people,
        area: area,
        year: year,
        month: month,
        day: day,
      ),
    );
  }

  static PeopleReport getFilteredReportOfInterval(
    List<QueryDocumentSnapshot<PeopleReport>> reportsList,
    int month_from,
    int month_to,
    int day_from,
    int day_to,
    int year,
    int areaRequired,
  ) {
    int temp_total_people = 0, temp_attended_people = 0;

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
        print('debug :: PeopleReport filtered out due to its date --> ' +
            report.data().day.toString());
        continue;
      }

      if (areaRequired != -1 && report.data().area == areaRequired) {
        // all shifts all lines in one area
        temp_total_people += report.data().original_people;
        temp_attended_people += report.data().attended_people;
        // print('debug :: PeopleReport chosen in second if');
      } else if (areaRequired == -1) {
        // all shifts all lines all areas
        temp_total_people += report.data().original_people;
        temp_attended_people += report.data().attended_people;
        // print('debug :: PeopleReport chosen in third if');
      } else {
        // print('debug :: PeopleReport filtered out due to conditions');
      }
    }
    //return the total in capsulized form
    return PeopleReport(
      supName: '',
      original_people: temp_total_people,
      attended_people: temp_attended_people,
      shift_index: -1,
      area: areaRequired,
      year: -1,
      month: -1,
      day: -1,
    );
  }

  static PeopleReport getEmptyReport() {
    return PeopleReport(
      supName: '',
      original_people: 0,
      attended_people: 0,
      shift_index: -1,
      area: -1,
      year: -1,
      month: -1,
      day: -1,
    );
  }
}
