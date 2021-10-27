import 'package:cairo_bisco_app/classes/utility_funcs/calculations_utility.dart';
import 'package:cairo_bisco_app/classes/utility_funcs/date_utility.dart';
import 'package:cairo_bisco_app/classes/values/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'MiniProductionReport.dart';
import 'SKU.dart';

class WaferReport {
  final String supName, skuName;
  final int shiftProductionPlan,
      productionInCartons,
      line_index,
      shift_index,
      area,
      year,
      month,
      day;
  final double actualSpeed,
      ovenScrap,
      ovenRework,
      cutterScrap,
      cutterRework,
      creamScrap,
      creamRework,
      coolerScrap,
      coolerRework,
      mc1Speed,
      mc2Speed,
      packingScrap,
      packingRework,
      boxesWaste,
      cartonWaste,
      mc1FilmUsed,
      mc2FilmUsed,
      mc1WasteKg,
      mc2WasteKg;

  WaferReport(
      {required this.area,
      required this.shift_index,
      required this.line_index,
      required this.supName,
      required this.skuName,
      required this.shiftProductionPlan,
      required this.productionInCartons,
      required this.actualSpeed,
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
      required this.day});

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
          actualSpeed: parseJsonToDouble(json['actualSpeed']!),
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
      'actualSpeed': actualSpeed,
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
    };
  }

  static void addReport(
    String supName,
    String skuName,
    double actualSpeed,
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
    double mc1WasteKg,
    double mc2WasteKg,
    int shiftProductionPlan,
    int productionInCartons,
    int line_index,
    int shift_index,
    int area,
    int year,
    int month,
    int day,
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
        actualSpeed: actualSpeed,
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
      ),
    );
  }

  static List<WaferReport> getAllReportsOfInterval(
    List<QueryDocumentSnapshot<WaferReport>> reportsList,
    int month_from,
    int month_to,
    int day_from,
    int day_to,
    int year,
  ) {
    List<WaferReport> tempList = [];
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
      tempList.add(report.data());
    }
    return tempList;
  }

  static MiniProductionReport getFilteredReportOfInterval(
    List<QueryDocumentSnapshot<WaferReport>> reportsList,
    int month_from,
    int month_to,
    int day_from,
    int day_to,
    int year,
    int lineNumRequired,
  ) {
    double temp_scrap = 0.0,
        temp_used_film = 0.0,
        temp_wasted_film = 0.0,
        temp_productionInKg = 0.0,
        temp_rework = 0.0,
        temp_theoreticalPlan = 0.0;
    int temp_productionInCartons = 0, temp_productionPlan = 0;
    String lastSkuName = '-';
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
        print('debug :: WaferReport filtered out due to its date --> ' +
            report.data().day.toString());
        continue;
      }

      if (lineNumRequired == -1 ||
          (lineNumRequired != -1 &&
              report.data().line_index == lineNumRequired)) {
        final theoreticals = [
          SKU.skuDetails[report.data().skuName]!.theoreticalShiftProd1,
          SKU.skuDetails[report.data().skuName]!.theoreticalShiftProd2,
          SKU.skuDetails[report.data().skuName]!.theoreticalShiftProd3,
          SKU.skuDetails[report.data().skuName]!.theoreticalShiftProd4
        ];
        print(theoreticals);
        //all shifts in one line in one area
        temp_productionInCartons += report.data().productionInCartons;
        temp_productionInKg += report.data().productionInCartons *
            SKU.skuDetails[report.data().skuName]!.cartonWeight;

        temp_theoreticalPlan += theoreticals[report.data().line_index - 1];

        temp_productionPlan += report.data().shiftProductionPlan;
        temp_scrap += calculateAllScrap(WAFER_AREA, report.data());
        temp_rework += calculateAllRework(WAFER_AREA, report.data());
        temp_wasted_film += report.data().mc2WasteKg + report.data().mc1WasteKg;
        temp_used_film += report.data().mc2FilmUsed + report.data().mc1FilmUsed;
        lastSkuName = report.data().skuName;
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
      year: -1,
      month: -1,
      day: -1,
      scrap: temp_scrap,
      productionInCartons: temp_productionInCartons,
      productionInKg: temp_productionInKg,
      totalFilmWasted: temp_wasted_film,
      totalFilmUsed: temp_used_film == 0 ? 1 : temp_used_film,
      rework: temp_rework,
      shiftProductionPlan: temp_productionPlan == 0 ? 1 : temp_productionPlan,
      theoreticalAverage: temp_theoreticalPlan == 0 ? 1 : temp_theoreticalPlan,
    );
  }
}
