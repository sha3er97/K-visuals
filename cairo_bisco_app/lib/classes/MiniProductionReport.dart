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
      theoreticalAverage;

  MiniProductionReport(
      {required this.area,
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
      required this.day});

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
    );
  }
}
