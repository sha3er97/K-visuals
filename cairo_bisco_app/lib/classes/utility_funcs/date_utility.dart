String getMonth() {
  DateTime now = new DateTime.now();
  if (now.hour < 16) //before 4 pm we are still yesterday
  {
    now = now.subtract(Duration(days: 1));
  }
  return now.month.toString();
}

String getYear() {
  DateTime now = new DateTime.now();
  if (now.hour < 16) //before 4 pm we are still yesterday
  {
    now = now.subtract(Duration(days: 1));
  }
  return now.year.toString();
}

String getDay() {
  DateTime now = new DateTime.now();

  if (now.hour < 16) //before 4 pm we are still yesterday
  {
    now = now.subtract(Duration(days: 1));
  }
  return now.day.toString();
}

String todayDateText() {
  DateTime now = new DateTime.now();

  if (now.hour < 16) //before 4 pm we are still yesterday
  {
    now = now.subtract(Duration(days: 1));
  }
  int day = now.day;
  int year = now.year;
  int month = now.month;
  return day.toString() + "/" + month.toString() + "/" + year.toString();
}

bool isDayInInterval(
  int check_day,
  int check_month,
  int month_from,
  int month_to,
  int day_from,
  int day_to,
  int year,
) {
  DateTime dateFrom = DateTime(year, month_from, day_from);
  DateTime dateAfter = DateTime(year, month_to, day_to);
  DateTime dateToCheck = DateTime(year, check_month, check_day);

  return (dateFrom.isBefore(dateToCheck) && dateAfter.isAfter(dateToCheck)) ||
      dateAfter.isAtSameMomentAs(dateToCheck) ||
      dateFrom.isAtSameMomentAs(dateToCheck);
}

String constructDate(int day, int month, int year) {
  return day.toString() + "/" + month.toString() + "/" + year.toString();
}

int getWeekNumber(int day, int month, int year) {
  final yearStart = new DateTime(year, 1, 1);
  final reportDate = new DateTime(year, month, day);
  final diff = reportDate.difference(yearStart);
//   final firstMonday = startOfYear.weekday;
//   final daysInFirstWeek = 8 - firstMonday;
//   final diff = date.difference(startOfYear);
//   var weeks = ((diff.inDays - daysInFirstWeek) / 7).ceil();
// // It might differ how you want to treat the first week
//   if(daysInFirstWeek > 3) {
//     weeks += 1;
//   }
  return (diff.inDays / 7).ceil();
}

bool inEditPeriod(int day, int month, int year) {
  DateTime now = new DateTime.now();

  final reportDate = new DateTime(year, month, day);
  final authorityEnd = now.add(Duration(days: 2));
  final diff = reportDate.difference(authorityEnd);
  return (diff.inDays <= 2 && year == now.year && month == now.month);
}

double minutesToHours(double minutes) {
  return minutes / 60;
}
