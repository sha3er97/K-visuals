import 'dart:math';

import 'package:flutter/material.dart';

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

String constructDateString(int day, int month, int year) {
  return day.toString() + "/" + month.toString() + "/" + year.toString();
}

String constructTimeString(context, int hour, int minute) {
  return TimeOfDay(hour: hour, minute: minute).format(context);
  //return hour.toString() + ":" + minute.toString();
}

int getTimeDifference(
    int yearFrom,
    int monthFrom,
    int dayFrom,
    int yearTo,
    int monthTo,
    int dayTo,
    int hour_from,
    int minute_from,
    int hour_to,
    int minute_to) {
  final from =
      new DateTime(yearFrom, monthFrom, dayFrom, hour_from, minute_from);
  final to = new DateTime(yearTo, monthTo, dayTo, hour_to, minute_to);
  final diff = to.difference(from);
  return diff.inMinutes;
}

DateTime constructDateObject(int day, int month, int year) {
  return new DateTime(year, month, day);
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

List<DateTime> getDaysInInterval(
  DateTime start,
  DateTime end,
) {
  List<DateTime> out = [];
  DateTime tempDay = start;
  while (tempDay.isBefore(end)) {
    out.add(tempDay);
    tempDay = tempDay.add(Duration(days: 1));
  }
  out.add(end);
  return out;
}

bool isTimeInInterval(
  DateTime dateToCheck,
  DateTime dateFrom,
  DateTime dateAfter,
) {
  return (dateFrom.isBefore(dateToCheck) && dateAfter.isAfter(dateToCheck)) ||
      dateAfter.isAtSameMomentAs(dateToCheck) ||
      dateFrom.isAtSameMomentAs(dateToCheck);
}

bool isOverlappingInterval(
    int yearFrom,
    int monthFrom,
    int dayFrom,
    int yearTo,
    int monthTo,
    int dayTo,
    int hour_from,
    int minute_from,
    int hour_to,
    int minute_to,
    int yearFrom2,
    int monthFrom2,
    int dayFrom2,
    int yearTo2,
    int monthTo2,
    int dayTo2,
    int hour_from2,
    int minute_from2,
    int hour_to2,
    int minute_to2) {
  final from =
      new DateTime(yearFrom, monthFrom, dayFrom, hour_from, minute_from);
  final to = new DateTime(yearTo, monthTo, dayTo, hour_to, minute_to);
  final from2 =
      new DateTime(yearFrom2, monthFrom2, dayFrom2, hour_from2, minute_from2);
  final to2 = new DateTime(yearTo2, monthTo2, dayTo2, hour_to2, minute_to2);
  return (isTimeInInterval(from2, from, to) ||
      isTimeInInterval(to2, from, to) ||
      isTimeInInterval(to, from2, to2) ||
      isTimeInInterval(to, from2, to2));
}

List<DateTime> getOverlappingInterval(
    int yearFrom,
    int monthFrom,
    int dayFrom,
    int yearTo,
    int monthTo,
    int dayTo,
    int hour_from,
    int minute_from,
    int hour_to,
    int minute_to,
    int yearFrom2,
    int monthFrom2,
    int dayFrom2,
    int yearTo2,
    int monthTo2,
    int dayTo2,
    int hour_from2,
    int minute_from2,
    int hour_to2,
    int minute_to2) {
  final from =
      new DateTime(yearFrom, monthFrom, dayFrom, hour_from, minute_from);
  final to = new DateTime(yearTo, monthTo, dayTo, hour_to, minute_to);
  final from2 =
      new DateTime(yearFrom2, monthFrom2, dayFrom2, hour_from2, minute_from2);
  final to2 = new DateTime(yearTo2, monthTo2, dayTo2, hour_to2, minute_to2);
  return [
    from.compareTo(from2) < 0 ? from : from2, //take min
    to.compareTo(to2) > 0 ? to : to2 //take max
  ];
}
