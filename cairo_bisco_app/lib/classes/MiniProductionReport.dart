import 'package:cairo_bisco_app/classes/values/constants.dart';

class MiniProductionReport {
  final String skuName;
  final int shiftProductionPlan,
      productionInCartons,
      line_index,
      shift_index,
      area,
      year,
      month,
      day;
  final double scrap,
      rework,
      totalFilmUsed,
      totalFilmWasted,
      productionInKg,
      theoreticalAverage,
      rmMUV,
      pmMUV;

  MiniProductionReport({
    required this.area,
    required this.shift_index, //unused for now
    required this.line_index,
    required this.skuName,
    required this.theoreticalAverage,
    required this.shiftProductionPlan,
    required this.productionInCartons,
    required this.productionInKg,
    required this.scrap,
    required this.rework,
    required this.totalFilmUsed,
    required this.totalFilmWasted,
    required this.year,
    required this.month,
    required this.day,
    required this.rmMUV,
    required this.pmMUV,
  });

  static MiniProductionReport getEmptyReport() {
    return MiniProductionReport(
      skuName: '-',
      shift_index: -1,
      line_index: -1,
      area: -1,
      year: -1,
      month: -1,
      day: -1,
      scrap: 0.0,
      productionInCartons: 0,
      productionInKg: 0.0,
      totalFilmWasted: 0.0,
      totalFilmUsed: 0.0,
      rework: 0.0,
      shiftProductionPlan: 0,
      theoreticalAverage: 0.0,
      rmMUV: 0.0,
      pmMUV: 0.0,
    );
  }

  static MiniProductionReport mergeReports(
    List<MiniProductionReport> reportsList,
  ) {
    double temp_scrap = 0.0,
        temp_used_film = 0.0,
        temp_wasted_film = 0.0,
        temp_productionInKg = 0.0,
        temp_rework = 0.0,
        temp_theoreticalPlan = 0.0,
        temp_rm_muv = 0.0,
        temp_pm_muv = 0.0;
    int temp_productionInCartons = 0, temp_productionPlan = 0;
    for (var report in reportsList) {
      temp_productionInCartons += report.productionInCartons;
      temp_productionInKg += report.productionInKg;
      temp_theoreticalPlan += report.theoreticalAverage;
      temp_productionPlan += report.shiftProductionPlan;
      temp_scrap += report.scrap;
      temp_rework += report.rework;
      temp_wasted_film += report.totalFilmWasted;
      temp_used_film += report.totalFilmUsed;
      temp_rm_muv += report.rmMUV;
      temp_pm_muv += report.pmMUV;
    }
    //return the total in capsulized form
    return MiniProductionReport(
      skuName: 'total',
      shift_index: -1,
      line_index: -1,
      area: TOTAL_PLANT,
      year: -1,
      month: -1,
      day: -1,
      scrap: temp_scrap,
      productionInCartons: temp_productionInCartons,
      productionInKg: temp_productionInKg,
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
    );
  }
}
