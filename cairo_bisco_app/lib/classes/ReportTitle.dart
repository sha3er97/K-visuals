import 'package:cairo_bisco_app/classes/utility_funcs/date_utility.dart';

class ReportTitle {
  final String date, supName;
  final int shift, line;
  final dynamic reportDetails;

  ReportTitle({
    required this.date,
    required this.supName,
    required this.shift,
    required this.line,
    required this.reportDetails,
  });

  /**
   * for QFS,EHS,OverWeight reports with no shifts
   */
  static List<ReportTitle> missingShiftReportToTitleList(reportsList) {
    List<ReportTitle> tempList = [];
    for (var report in reportsList) {
      ReportTitle tempTitle = ReportTitle(
        date: constructDate(report.day, report.month, report.year),
        supName: report.supName,
        shift: -1,
        line: report.line_index - 1,
        reportDetails: report,
      );
      tempList.add(tempTitle);
    }
    return tempList;
  }

  /**
   * for People,NRC reports with no line
   */
  static List<ReportTitle> missingLineReportToTitleList(reportsList) {
    List<ReportTitle> tempList = [];
    for (var report in reportsList) {
      ReportTitle tempTitle = ReportTitle(
        date: constructDate(report.day, report.month, report.year),
        supName: report.supName,
        shift: report.shift_index,
        line: -1,
        reportDetails: report,
      );
      tempList.add(tempTitle);
    }
    return tempList;
  }

  /**
   * for Production reports with all details
   */
  static List<ReportTitle> fullReportToTitleList(reportsList) {
    List<ReportTitle> tempList = [];
    for (var report in reportsList) {
      ReportTitle tempTitle = ReportTitle(
        date: constructDate(report.day, report.month, report.year),
        supName: report.supName,
        shift: report.shift_index,
        line: report.line_index - 1,
        reportDetails: report,
      );
      tempList.add(tempTitle);
    }
    return tempList;
  }
}
