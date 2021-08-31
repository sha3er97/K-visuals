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
