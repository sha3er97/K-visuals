String getMonth() {
  DateTime now = new DateTime.now();
  return now.month.toString();
}

String getYear() {
  DateTime now = new DateTime.now();
  return now.year.toString();
}

String getDay() {
  DateTime now = new DateTime.now();
  if (now.hour < 16) //before 4 pm we are still yesterday
    return (now.day - 1).toString();
  else
    return now.day.toString();
}

String todayDateText() {
  DateTime now = new DateTime.now();
  int year = now.year;
  int month = now.month;
  int day;
  if (now.hour < 16) //before 4 pm we are still yesterday
    day = now.day - 1;
  else
    day = now.day;

  return day.toString() + "/" + month.toString() + "/" + year.toString();
}

bool isDayInInterval(
  int check_day,
  int check_month,
  int month_from,
  int month_to,
  int day_from,
  int day_to,
) {
  if (check_month < month_from) return false;
  if (check_month > month_to) return false;
  //month here is in interval for sure
  if (check_month == month_to || check_month == month_from) {
    //month is either from or to or both
    //--> check for both sides
    if (check_month == month_to && check_day > day_to) return false;
    if (check_month == month_from && check_day < day_from) return false;
  }
  return true;
}
