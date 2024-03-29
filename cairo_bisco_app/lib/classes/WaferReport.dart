import 'dart:collection';

import 'package:cairo_bisco_app/classes/MiniProductionReport.dart';
import 'package:cairo_bisco_app/classes/SKU.dart';
import 'package:cairo_bisco_app/classes/utility_funcs/calculations_utility.dart';
import 'package:cairo_bisco_app/classes/utility_funcs/date_time_utility.dart';
import 'package:cairo_bisco_app/classes/utility_funcs/other_utility.dart';
import 'package:cairo_bisco_app/classes/values/constants.dart';
import 'package:cairo_bisco_app/ui/error_success_screens/success.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'CauseCount.dart';
import 'DownTimeReport.dart';
import 'Machine.dart';
import 'OverWeightReport.dart';

class WaferReport {
  final String supName,
      skuName,
      //3.0.8 additions
      creamScrapReason,
      ovenScrapReason,
      coolerScrapReason,
      cutterScrapReason,
      packingScrapReason,
      //3.0.9 additions
      mc1Type,
      mc2Type,
      mc3Type,
      mc4Type;
  final int shiftProductionPlan,
      productionInCartons,
      line_index,
      shift_index,
      area,
      year,
      month,
      day;
  final double ovenScrap,
      ovenRework,
      cutterScrap,
      cutterRework,
      creamScrap,
      creamRework,
      coolerScrap,
      coolerRework,
      packingScrap,
      packingRework,
      boxesWaste,
      cartonWaste,
      mc1FilmUsed,
      mc2FilmUsed,
      mc3FilmUsed,
      mc4FilmUsed,
      mc1WasteKg,
      mc2WasteKg,
      mc3WasteKg,
      mc4WasteKg,
      shiftHours,
      // wastedMinutes,
      mc1Speed,
      mc2Speed,
      //3.0.9 additions
      mc3Speed,
      mc4Speed;

  WaferReport({
    required this.area,
    required this.shift_index,
    required this.line_index,
    required this.supName,
    required this.skuName,
    required this.shiftProductionPlan,
    required this.productionInCartons,
    required this.ovenScrap,
    required this.ovenRework,
    required this.cutterScrap,
    required this.cutterRework,
    required this.creamScrap,
    required this.creamRework,
    required this.coolerScrap,
    required this.coolerRework,
    required this.mc1Speed,
    required this.mc2Speed,
    required this.packingScrap,
    required this.packingRework,
    required this.boxesWaste,
    required this.cartonWaste,
    required this.mc1FilmUsed,
    required this.mc2FilmUsed,
    required this.mc1WasteKg,
    required this.mc2WasteKg,
    required this.year,
    required this.month,
    required this.day,
    required this.shiftHours,
    // required this.wastedMinutes,
    //3.0.8 additions
    required this.creamScrapReason,
    required this.ovenScrapReason,
    required this.coolerScrapReason,
    required this.cutterScrapReason,
    required this.packingScrapReason,
    //3.0.9 additions
    required this.mc3Speed,
    required this.mc4Speed,
    required this.mc1Type,
    required this.mc2Type,
    required this.mc3Type,
    required this.mc4Type,
    required this.mc3FilmUsed,
    required this.mc4FilmUsed,
    required this.mc3WasteKg,
    required this.mc4WasteKg,
  });

  WaferReport.fromJson(Map<String, Object?> json)
      : this(
          year: json['year']! as int,
          month: json['month']! as int,
          day: json['day']! as int,
          area: json['area']! as int,
          shift_index: json['shift_index']! as int,
          line_index: json['line_index']! as int,
          shiftProductionPlan: json['shiftProductionPlan']! as int,
          productionInCartons: json['productionInCartons']! as int,
          supName: json['supName']! as String,
          skuName: json['skuName']! as String,
          ovenScrap: parseJsonToDouble(json['ovenScrap']!),
          ovenRework: parseJsonToDouble(json['ovenRework']!),
          cutterScrap: parseJsonToDouble(json['cutterScrap']!),
          cutterRework: parseJsonToDouble(json['cutterRework']!),
          creamScrap: parseJsonToDouble(json['creamScrap']!),
          creamRework: parseJsonToDouble(json['creamRework']!),
          coolerScrap: parseJsonToDouble(json['coolerScrap']!),
          coolerRework: parseJsonToDouble(json['coolerRework']!),
          mc1Speed: parseJsonToDouble(json['mc1Speed']!),
          mc2Speed: parseJsonToDouble(json['mc2Speed']!),
          packingScrap: parseJsonToDouble(json['packingScrap']!),
          packingRework: parseJsonToDouble(json['packingRework']!),
          boxesWaste: parseJsonToDouble(json['boxesWaste']!),
          cartonWaste: parseJsonToDouble(json['cartonWaste']!),
          mc1FilmUsed: parseJsonToDouble(json['mc1FilmUsed']!),
          mc2FilmUsed: parseJsonToDouble(json['mc2FilmUsed']!),
          mc1WasteKg: parseJsonToDouble(json['mc1WasteKg']!),
          mc2WasteKg: parseJsonToDouble(json['mc2WasteKg']!),
          shiftHours: parseJsonToDouble(json['shiftHours']!),
          // wastedMinutes: json['wastedMinutes'] == null
          //     ? 0
          //     : parseJsonToDouble(json['wastedMinutes']!),
          //3.0.8 additions
          creamScrapReason: json['creamScrapReason'] == null
              ? ''
              : json['creamScrapReason']! as String,
          cutterScrapReason: json['cutterScrapReason'] == null
              ? ''
              : json['cutterScrapReason']! as String,
          coolerScrapReason: json['coolerScrapReason'] == null
              ? ''
              : json['coolerScrapReason']! as String,
          ovenScrapReason: json['ovenScrapReason'] == null
              ? ''
              : json['ovenScrapReason']! as String,
          packingScrapReason: json['packingScrapReason'] == null
              ? ''
              : json['packingScrapReason']! as String,
          //3.0.9 additions
          mc1Type: json['mc1Type'] == null
              ? Machine.packingMachinesList[0]
              : json['mc1Type']! as String,
          mc2Type: json['mc2Type'] == null
              ? Machine.packingMachinesList[0]
              : json['mc2Type']! as String,
          mc3Type: json['mc3Type'] == null
              ? Machine.packingMachinesList[0]
              : json['mc3Type']! as String,
          mc4Type: json['mc4Type'] == null
              ? Machine.packingMachinesList[0]
              : json['mc4Type']! as String,
          mc3Speed: json['mc3Speed'] == null
              ? 0
              : parseJsonToDouble(json['mc3Speed']!),
          mc4Speed: json['mc4Speed'] == null
              ? 0
              : parseJsonToDouble(json['mc4Speed']!),
          mc3FilmUsed: json['mc3FilmUsed'] == null
              ? 0
              : parseJsonToDouble(json['mc3FilmUsed']!),
          mc4FilmUsed: json['mc4FilmUsed'] == null
              ? 0
              : parseJsonToDouble(json['mc4FilmUsed']!),
          mc3WasteKg: json['mc3WasteKg'] == null
              ? 0
              : parseJsonToDouble(json['mc3WasteKg']!),
          mc4WasteKg: json['mc4WasteKg'] == null
              ? 0
              : parseJsonToDouble(json['mc4WasteKg']!),
        );

  Map<String, Object?> toJson() {
    return {
      'year': year,
      'month': month,
      'day': day,
      'area': area,
      'shift_index': shift_index,
      'line_index': line_index,
      'supName': supName,
      'skuName': skuName,
      'shiftProductionPlan': shiftProductionPlan,
      'productionInCartons': productionInCartons,
      'ovenScrap': ovenScrap,
      'ovenRework': ovenRework,
      'cutterScrap': cutterScrap,
      'cutterRework': cutterRework,
      'creamScrap': creamScrap,
      'creamRework': creamRework,
      'coolerScrap': coolerScrap,
      'coolerRework': coolerRework,
      'mc1Speed': mc1Speed,
      'mc2Speed': mc2Speed,
      'packingScrap': packingScrap,
      'packingRework': packingRework,
      'boxesWaste': boxesWaste,
      'cartonWaste': cartonWaste,
      'mc1FilmUsed': mc1FilmUsed,
      'mc2FilmUsed': mc2FilmUsed,
      'mc1WasteKg': mc1WasteKg,
      'mc2WasteKg': mc2WasteKg,
      'shiftHours': shiftHours,
      // 'wastedMinutes': wastedMinutes,
      //3.0.8 additions
      'creamScrapReason': creamScrapReason,
      'ovenScrapReason': ovenScrapReason,
      'coolerScrapReason': coolerScrapReason,
      'cutterScrapReason': cutterScrapReason,
      'packingScrapReason': packingScrapReason,
      //3.0.9 additions
      'mc1Type': mc1Type,
      'mc2Type': mc2Type,
      'mc3Type': mc3Type,
      'mc4Type': mc4Type,
      'mc3Speed': mc3Speed,
      'mc4Speed': mc4Speed,
      'mc3FilmUsed': mc3FilmUsed,
      'mc4FilmUsed': mc4FilmUsed,
      'mc3WasteKg': mc3WasteKg,
      'mc4WasteKg': mc4WasteKg,
    };
  }

  static void addReport(
    String supName,
    String skuName,
    double ovenScrap,
    double ovenRework,
    double cutterScrap,
    double cutterRework,
    double creamScrap,
    double creamRework,
    double coolerScrap,
    double coolerRework,
    double mc1Speed,
    double mc2Speed,
    double packingScrap,
    double packingRework,
    double boxesWaste,
    double cartonWaste,
    double mc1FilmUsed,
    double mc2FilmUsed,
    double mc3FilmUsed,
    double mc4FilmUsed,
    double mc1WasteKg,
    double mc2WasteKg,
    double mc3WasteKg,
    double mc4WasteKg,
    int shiftProductionPlan,
    int productionInCartons,
    int line_index,
    int shift_index,
    int area,
    int year,
    int month,
    int day,
    double shiftHours,
    // double wastedMinutes,
    //3.0.8 additions
    String creamScrapReason,
    String ovenScrapReason,
    String coolerScrapReason,
    String cutterScrapReason,
    String packingScrapReason,
    //3.0.9 additions
    double mc3Speed,
    double mc4Speed,
    String mc1Type,
    String mc2Type,
    String mc3Type,
    String mc4Type,
  ) async {
    final waferReportRef = FirebaseFirestore.instance
        .collection(factory_name)
        .doc('wafer_reports')
        .collection(year.toString())
        .withConverter<WaferReport>(
          fromFirestore: (snapshot, _) =>
              WaferReport.fromJson(snapshot.data()!),
          toFirestore: (report, _) => report.toJson(),
        );
    await waferReportRef.add(
      WaferReport(
        year: year,
        month: month,
        day: day,
        area: area,
        shift_index: shift_index,
        line_index: line_index,
        supName: supName,
        skuName: skuName,
        shiftProductionPlan: shiftProductionPlan,
        productionInCartons: productionInCartons,
        ovenScrap: ovenScrap,
        ovenRework: ovenRework,
        cutterScrap: cutterScrap,
        cutterRework: cutterRework,
        creamScrap: creamScrap,
        creamRework: creamRework,
        coolerScrap: coolerScrap,
        coolerRework: coolerRework,
        mc1Speed: mc1Speed,
        mc2Speed: mc2Speed,
        packingScrap: packingScrap,
        packingRework: packingRework,
        boxesWaste: boxesWaste,
        cartonWaste: cartonWaste,
        mc1FilmUsed: mc1FilmUsed,
        mc2FilmUsed: mc2FilmUsed,
        mc1WasteKg: mc1WasteKg,
        mc2WasteKg: mc2WasteKg,
        shiftHours: shiftHours,
        // wastedMinutes: wastedMinutes,
        //3.0.8 additions
        creamScrapReason: creamScrapReason,
        ovenScrapReason: ovenScrapReason,
        coolerScrapReason: coolerScrapReason,
        cutterScrapReason: cutterScrapReason,
        packingScrapReason: packingScrapReason,
        //3.0.9 additions
        mc1Type: mc1Type,
        mc2Type: mc2Type,
        mc3Type: mc3Type,
        mc4Type: mc4Type,
        mc3Speed: mc3Speed,
        mc4Speed: mc4Speed,
        mc3FilmUsed: mc3FilmUsed,
        mc4FilmUsed: mc4FilmUsed,
        mc3WasteKg: mc3WasteKg,
        mc4WasteKg: mc4WasteKg,
      ),
    );
  }

  static void editReport(
    context,
    String id,
    String supName,
    String skuName,
    double ovenScrap,
    double ovenRework,
    double cutterScrap,
    double cutterRework,
    double creamScrap,
    double creamRework,
    double coolerScrap,
    double coolerRework,
    double mc1Speed,
    double mc2Speed,
    double packingScrap,
    double packingRework,
    double boxesWaste,
    double cartonWaste,
    double mc1FilmUsed,
    double mc2FilmUsed,
    double mc3FilmUsed,
    double mc4FilmUsed,
    double mc1WasteKg,
    double mc2WasteKg,
    double mc3WasteKg,
    double mc4WasteKg,
    int shiftProductionPlan,
    int productionInCartons,
    int line_index,
    int shift_index,
    int area,
    int year,
    int month,
    int day,
    double shiftHours,
    // double wastedMinutes,
    //3.0.8 additions
    String creamScrapReason,
    String ovenScrapReason,
    String coolerScrapReason,
    String cutterScrapReason,
    String packingScrapReason,
    //3.0.9 additions
    double mc3Speed,
    double mc4Speed,
    String mc1Type,
    String mc2Type,
    String mc3Type,
    String mc4Type,
  ) async {
    final waferReportRef = FirebaseFirestore.instance
        .collection(factory_name)
        .doc('wafer_reports')
        .collection(year.toString())
        .withConverter<WaferReport>(
          fromFirestore: (snapshot, _) =>
              WaferReport.fromJson(snapshot.data()!),
          toFirestore: (report, _) => report.toJson(),
        );
    await waferReportRef
        .doc(id)
        .update({
          'year': year,
          'month': month,
          'day': day,
          'area': area,
          'shift_index': shift_index,
          'line_index': line_index,
          'supName': supName,
          'skuName': skuName,
          'shiftProductionPlan': shiftProductionPlan,
          'productionInCartons': productionInCartons,
          'ovenScrap': ovenScrap,
          'ovenRework': ovenRework,
          'cutterScrap': cutterScrap,
          'cutterRework': cutterRework,
          'creamScrap': creamScrap,
          'creamRework': creamRework,
          'coolerScrap': coolerScrap,
          'coolerRework': coolerRework,
          'mc1Speed': mc1Speed,
          'mc2Speed': mc2Speed,
          'packingScrap': packingScrap,
          'packingRework': packingRework,
          'boxesWaste': boxesWaste,
          'cartonWaste': cartonWaste,
          'mc1FilmUsed': mc1FilmUsed,
          'mc2FilmUsed': mc2FilmUsed,
          'mc1WasteKg': mc1WasteKg,
          'mc2WasteKg': mc2WasteKg,
          'shiftHours': shiftHours,
          // 'wastedMinutes': wastedMinutes,
          //3.0.8 additions
          'creamScrapReason': creamScrapReason,
          'ovenScrapReason': ovenScrapReason,
          'coolerScrapReason': coolerScrapReason,
          'cutterScrapReason': cutterScrapReason,
          'packingScrapReason': packingScrapReason,
          //3.0.9 additions
          'mc1Type': mc1Type,
          'mc2Type': mc2Type,
          'mc3Type': mc3Type,
          'mc4Type': mc4Type,
          'mc3Speed': mc3Speed,
          'mc4Speed': mc4Speed,
          'mc3FilmUsed': mc3FilmUsed,
          'mc4FilmUsed': mc4FilmUsed,
          'mc3WasteKg': mc3WasteKg,
          'mc4WasteKg': mc4WasteKg,
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
    final waferReportRef = FirebaseFirestore.instance
        .collection(factory_name)
        .doc('wafer_reports')
        .collection(year.toString())
        .withConverter<WaferReport>(
          fromFirestore: (snapshot, _) =>
              WaferReport.fromJson(snapshot.data()!),
          toFirestore: (report, _) => report.toJson(),
        );
    await waferReportRef
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

  static HashMap<String, WaferReport> getAllReportsOfInterval(
    List<QueryDocumentSnapshot<WaferReport>> reportsList,
    int month_from,
    int month_to,
    int day_from,
    int day_to,
    int year,
  ) {
    HashMap hashMap = new HashMap<String, WaferReport>();
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
        // print('debug :: WaferReport filtered out due to its date --> ' +
        //     report.data().day.toString());
        continue;
      }
      hashMap[report.id] = report.data();
    }
    return hashMap as HashMap<String, WaferReport>;
  }

  static MiniProductionReport getFilteredReportOfInterval(
    List<QueryDocumentSnapshot<WaferReport>> reportsList,
    int month_from,
    int month_to,
    int day_from,
    int day_to,
    int year,
    int lineNumRequired,
    List<OverWeightReport> overweightList,
    List<QueryDocumentSnapshot<DownTimeReport>> downTimeList,
  ) {
    double temp_scrap = 0.0,
        temp_used_film = 0.0,
        temp_wasted_film = 0.0,
        temp_productionInKg = 0.0,
        temp_planInKg = 0.0,
        temp_rework = 0.0,
        temp_theoreticalPlan = 0.0,
        temp_rm_muv = 0.0,
        temp_pm_muv = 0.0,
        // temp_wasted_minutes = 0.0,
        temp_all_shift_hours = 0.0;
    int temp_productionInCartons = 0, temp_productionPlan = 0;
    String lastSkuName = '-';
    int temp_month = month_from, temp_day = day_from, temp_year = year;

    // String lastSkuName = SKU.biscuitSKU[0];
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
        // print('debug :: WaferReport filtered out due to its date --> ' +
        //     report.data().day.toString());
        continue;
      }
      double matchedOverWeight = doesProdReportHaveCorrespondingOverweight(
              report.data(), overweightList)
          ? getCorrespondingOverweightToProdReport(
              report.data(), overweightList)
          : 0.0;
      /////////////////////////////////////////////////////////////
      int reportStoppedMinutes = DownTimeReport.getWastedMinutesOfCriteria(
          downTimeList,
          report.data().month,
          report.data().month,
          report.data().day,
          report.data().day,
          report.data().year,
          report.data().area,
          report.data().line_index,
          report.data().shift_index);
      /////////////////////////////////////////////////////////////
      if (lineNumRequired == ALL_LINES ||
          (lineNumRequired != ALL_LINES &&
              report.data().line_index == lineNumRequired)) {
        print(
            'debug :: WaferReport date --> ${report.data().day}/${report.data().month} -- ${report.data().skuName}');
        final simpleTheoreticals = [
          SKU.skuDetails[report.data().skuName]!.theoreticalShiftProd1,
          SKU.skuDetails[report.data().skuName]!.theoreticalShiftProd2,
          SKU.skuDetails[report.data().skuName]!.theoreticalShiftProd3,
          SKU.skuDetails[report.data().skuName]!.theoreticalShiftProd4
        ];
        //all shifts in one line in one area
        temp_productionInCartons += report.data().productionInCartons;
        temp_productionInKg += calculateProductionKg(
            report.data(), report.data().productionInCartons);
        temp_planInKg += calculateProductionKg(
            report.data(), report.data().shiftProductionPlan);

        temp_theoreticalPlan += calculateNetTheoreticalOfReport(
            report.data(), simpleTheoreticals, reportStoppedMinutes);

        temp_productionPlan += report.data().shiftProductionPlan;
        temp_scrap += calculateAllScrap(WAFER_AREA, report.data());
        temp_rework += calculateAllRework(WAFER_AREA, report.data());
        temp_wasted_film += calculateAllWastedFilmWaste(report.data());
        temp_used_film += calculateAllUsedFilmWaste(report.data());
        lastSkuName = report.data().skuName;
        temp_rm_muv +=
            calculateRmMUV(WAFER_AREA, report.data(), matchedOverWeight);
        temp_pm_muv += calculatePmMUV(WAFER_AREA, report.data());
        temp_all_shift_hours += report.data().shiftHours;
        // temp_wasted_minutes += report.data().wastedMinutes;
        temp_month = report.data().month;
        temp_day = report.data().day;
        temp_year = report.data().year;
        print('debug :: WaferReport chosen in first if');
      } else {
        print(
            'debug :: WaferReport filtered out due to conditions ,  lineNum =' +
                lineNumRequired.toString());
      }
    }
    //return the total in capsulized form
    return MiniProductionReport(
      skuName: lastSkuName,
      shift_index: -1,
      line_index: -1,
      area: -1,
      year: temp_year,
      month: temp_month,
      day: temp_day,
      scrap: temp_scrap,
      productionInCartons: temp_productionInCartons,
      productionInKg: temp_productionInKg,
      planInKg: temp_planInKg,
      totalFilmWasted: temp_wasted_film,
      // totalFilmUsed: temp_used_film == 0 ? 1 : temp_used_film,
      totalFilmUsed: temp_used_film,
      rework: temp_rework,
      // shiftProductionPlan: temp_productionPlan == 0 ? 1 : temp_productionPlan,
      // theoreticalAverage: temp_theoreticalPlan == 0 ? 1 : temp_theoreticalPlan,
      shiftProductionPlan: temp_productionPlan,
      theoreticalAverage: temp_theoreticalPlan,
      pmMUV: temp_pm_muv,
      rmMUV: temp_rm_muv,
      // wastedMinutes: temp_wasted_minutes,
      plannedHours: temp_all_shift_hours,
    );
  }

  static MiniProductionReport getProductionOfInterval(
    List<QueryDocumentSnapshot<WaferReport>> reportsList,
    int month_from,
    int month_to,
    int day_from,
    int day_to,
    int year,
  ) {
    double temp_productionInKg = 0.0;
    int temp_productionInCartons = 0;
    int temp_month = month_from, temp_day = day_from, temp_year = year;

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
        // print('debug :: BarReport filtered out due to its date --> ' +
        //     report.data().day.toString());
        continue;
      }
      temp_productionInCartons += report.data().productionInCartons;
      temp_productionInKg += calculateProductionKg(
          report.data(), report.data().productionInCartons);
      temp_month = report.data().month;
      temp_day = report.data().day;
      temp_year = report.data().year;
    }
    //return the total in capsulized form
    return MiniProductionReport(
      skuName: '-',
      shift_index: -1,
      line_index: -1,
      area: -1,
      year: temp_year,
      month: temp_month,
      day: temp_day,
      scrap: 0,
      productionInCartons: temp_productionInCartons,
      productionInKg: temp_productionInKg,
      planInKg: 0,
      totalFilmWasted: 0,
      totalFilmUsed: 0,
      shiftProductionPlan: 0,
      theoreticalAverage: 0,
      pmMUV: 0,
      rmMUV: 0,
      plannedHours: 0,
      rework: 0,
    );
  }

  static WaferReport getEmptyReport() {
    return WaferReport(
      supName: '',
      shift_index: 0,
      line_index: 1,
      area: 1,
      year: -1,
      month: -1,
      day: -1,
      mc2FilmUsed: 0.0,
      ovenScrap: 0.0,
      cutterScrap: 0.0,
      mc1Speed: 0.0,
      cutterRework: 0.0,
      shiftProductionPlan: 0,
      mc1WasteKg: 0.0,
      ovenRework: 0.0,
      mc2Speed: 0.0,
      mc2WasteKg: 0.0,
      cartonWaste: 0.0,
      packingRework: 0.0,
      mc1FilmUsed: 0.0,
      productionInCartons: 0,
      boxesWaste: 0.0,
      packingScrap: 0.0,
      skuName: '',
      coolerScrap: 0.0,
      creamRework: 0.0,
      coolerRework: 0.0,
      creamScrap: 0.0,
      shiftHours: standardShiftHours,
      // wastedMinutes: 0.0,
      //3.0.8 additions
      creamScrapReason: '',
      ovenScrapReason: '',
      coolerScrapReason: '',
      cutterScrapReason: '',
      packingScrapReason: '',
      //3.0.9 additions
      mc3Speed: 0.0,
      mc4Speed: 0.0,
      mc1Type: '',
      mc2Type: '',
      mc3Type: '',
      mc4Type: '',
      mc3FilmUsed: 0.0,
      mc3WasteKg: 0.0,
      mc4FilmUsed: 0.0,
      mc4WasteKg: 0.0,
    );
  }

  static MiniProductionReport getScrapDashboardSummary(
    List<QueryDocumentSnapshot<WaferReport>> reportsList,
    int month_from,
    int month_to,
    int day_from,
    int day_to,
    int year,
    int lineNumRequired,
    String sku,
    // List<OverWeightReport> overweightList,
  ) {
    double temp_scrap = 0.0,
        temp_productionInKg = 0.0,
        temp_used_film = 0.0,
        temp_wasted_film = 0.0,
        temp_rework = 0.0;
    int temp_month = month_from, temp_day = day_from, temp_year = year;

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
        // print('debug :: BiscuitsReport filtered out due to its date --> ' +
        //     report.data().day.toString());
        continue;
      }
      // double matchedOverWeight = doesProdReportHaveCorrespondingOverweight(
      //     report.data(), overweightList)
      //     ? getCorrespondingOverweightToProdReport(
      //     report.data(), overweightList)
      //     : 0.0;
      /////////////////////////////////////////////////////////////
      if (intFilterCheck(report.data().line_index, lineNumRequired, 0) &&
          stringFilterCheck(report.data().skuName, sku, '-')) {
        temp_productionInKg += calculateProductionKg(
            report.data(), report.data().productionInCartons);

        temp_scrap += calculateAllScrap(WAFER_AREA, report.data());
        temp_rework += calculateAllRework(WAFER_AREA, report.data());
        temp_wasted_film += calculateAllWastedFilmWaste(report.data());
        temp_used_film += calculateAllUsedFilmWaste(report.data());
        temp_month = report.data().month;
        temp_day = report.data().day;
        temp_year = report.data().year;
      }
    }
    //return the total in capsulized form
    return MiniProductionReport(
      skuName: '',
      shift_index: -1,
      line_index: -1,
      area: -1,
      year: temp_year,
      month: temp_month,
      day: temp_day,
      scrap: temp_scrap,
      productionInCartons: -1,
      productionInKg: temp_productionInKg,
      planInKg: -1,
      totalFilmWasted: temp_wasted_film,
      // totalFilmUsed: temp_used_film == 0 ? 1 : temp_used_film,
      totalFilmUsed: temp_used_film,
      rework: temp_rework,
      // shiftProductionPlan: temp_productionPlan == 0 ? 1 : temp_productionPlan,
      // theoreticalAverage: temp_theoreticalPlan == 0 ? 1 : temp_theoreticalPlan,
      shiftProductionPlan: -1,
      theoreticalAverage: -1,
      pmMUV: -1,
      rmMUV: -1,
      // wastedMinutes: temp_wasted_minutes,
      plannedHours: -1,
    );
  }

  static List<CauseCount> getScrapDistribution(
    List<QueryDocumentSnapshot<WaferReport>> reportsList,
    int month_from,
    int month_to,
    int day_from,
    int day_to,
    int year,
    int line_index,
    String sku,
  ) {
    HashMap<String, CauseCount> tempMap = new HashMap<String, CauseCount>();
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
        print('debug :: WaferReport filtered out due to its date --> ' +
            report.data().day.toString());
        continue;
      }
      if (stringFilterCheck(report.data().skuName, sku, '-') &&
          intFilterCheck(report.data().line_index, line_index, 0)) {
        for (int i = 0; i < scrapAreas[WAFER_AREA].length; i++) {
          if (tempMap[scrapAreas[WAFER_AREA][i]] == null) {
            switch (i) {
              case 0:
                tempMap[scrapAreas[WAFER_AREA][i]] = new CauseCount(
                    scrapAreas[WAFER_AREA][i], report.data().ovenScrap);
                break;
              case 1:
                tempMap[scrapAreas[WAFER_AREA][i]] = new CauseCount(
                    scrapAreas[WAFER_AREA][i], report.data().packingScrap);
                break;
              case 2:
                tempMap[scrapAreas[WAFER_AREA][i]] = new CauseCount(
                    scrapAreas[WAFER_AREA][i], report.data().creamScrap);
                break;
              case 3:
                tempMap[scrapAreas[WAFER_AREA][i]] = new CauseCount(
                    scrapAreas[WAFER_AREA][i], report.data().coolerScrap);
                break;
              case 4:
                tempMap[scrapAreas[WAFER_AREA][i]] = new CauseCount(
                    scrapAreas[WAFER_AREA][i], report.data().cutterScrap);
                break;
            }
          } else {
            switch (i) {
              case 0:
                tempMap[scrapAreas[WAFER_AREA][i]]!
                    .incrementCount(report.data().ovenScrap);
                break;
              case 1:
                tempMap[scrapAreas[WAFER_AREA][i]]!
                    .incrementCount(report.data().packingScrap);
                break;
              case 2:
                tempMap[scrapAreas[WAFER_AREA][i]]!
                    .incrementCount(report.data().creamScrap);
                break;
              case 3:
                tempMap[scrapAreas[WAFER_AREA][i]]!
                    .incrementCount(report.data().coolerScrap);
                break;
              case 4:
                tempMap[scrapAreas[WAFER_AREA][i]]!
                    .incrementCount(report.data().cutterScrap);
                break;
            }
          }
        }
      } else {
        print('debug :: WaferReport filtered out due to conditions');
      }
    }
    return tempMap.values.toList();
  }
}
