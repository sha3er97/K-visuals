import 'package:cairo_bisco_app/components/values/colors.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../values/constants.dart';

late PieChartSectionData biscuitsSection;
late PieChartSectionData waferSection;
late PieChartSectionData maamoulSection;
late PieChartSectionData elseSection;

class Chart extends StatelessWidget {
  const Chart({
    Key? key,
    required this.totalProduction,
    required this.totalTonnage,
    required this.biscuits,
    required this.wafer,
    required this.maamoul,
    // required this.scrap,
  }) : super(key: key);

  final double totalProduction,
      totalTonnage,
      biscuits,
      wafer,
      maamoul; //add scrap;

  @override
  Widget build(BuildContext context) {
    biscuitsSection = PieChartSectionData(
      color: KelloggColors.yellow,
      value: biscuits,
      showTitle: false,
      radius: 25,
    );
    waferSection = PieChartSectionData(
      color: KelloggColors.green,
      value: wafer,
      showTitle: false,
      radius: 22,
    );
    maamoulSection = PieChartSectionData(
      color: KelloggColors.cockRed,
      value: maamoul,
      showTitle: false,
      radius: 19,
    );
    elseSection = PieChartSectionData(
      color: KelloggColors.darkRed.withOpacity(0.1),
      value: totalTonnage - totalProduction,
      showTitle: false,
      radius: 13,
    );
    return SizedBox(
      height: 200,
      child: Stack(
        children: [
          PieChart(
            PieChartData(
              sectionsSpace: 0,
              centerSpaceRadius: 70,
              startDegreeOffset: -90,
              sections: paiChartSelectionData,
            ),
          ),
          Positioned.fill(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: defaultPadding),
                Text("Final product"),
                SizedBox(height: defaultPadding),
                Text(
                  totalProduction.toString() + " K", //29.1
                  style: Theme.of(context).textTheme.headline4!.copyWith(
                        color: KelloggColors.darkBlue,
                        fontWeight: FontWeight.w600,
                        height: 0.5,
                      ),
                ),
                Text("of " + totalTonnage.toString() + " K") //128 GB
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// List<PieChartSectionData> paiChartSelectionData = [
//   PieChartSectionData(
//     color: KelloggColors.darkRed,
//     value: 25,
//     showTitle: false,
//     radius: 25,
//   ),
//   PieChartSectionData(
//     color: KelloggColors.yellow, //Color(0xFF26E5FF),
//     value: 20,
//     showTitle: false,
//     radius: 22,
//   ),
//   PieChartSectionData(
//     color: KelloggColors.clearRed, //Color(0xFFFFCF26),
//     value: 10,
//     showTitle: false,
//     radius: 19,
//   ),
// PieChartSectionData(
//   color: Color(0xFFEE2727),
//   value: 15,
//   showTitle: false,
//   radius: 16,
// ),
//   PieChartSectionData(
//     color: KelloggColors.darkRed.withOpacity(0.1),
//     value: 25,
//     showTitle: false,
//     radius: 13,
//   ),

List<PieChartSectionData> paiChartSelectionData = [
  biscuitsSection,
  waferSection,
  maamoulSection,
  elseSection,
];
