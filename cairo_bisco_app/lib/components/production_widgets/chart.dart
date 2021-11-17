import 'package:cairo_bisco_app/classes/values/colors.dart';
import 'package:cairo_bisco_app/classes/values/constants.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

late PieChartSectionData biscuitsSection;
late PieChartSectionData waferSection;
late PieChartSectionData maamoulSection;
late PieChartSectionData elseSection;

class Chart extends StatelessWidget {
  const Chart({
    Key? key,
    required this.other,
    required this.biscuits,
    required this.wafer,
    required this.maamoul,
  }) : super(key: key);

  final double other, biscuits, wafer, maamoul;

  @override
  Widget build(BuildContext context) {
    // print("chart : $biscuits , $wafer , $maamoul , $other");
    biscuitsSection = PieChartSectionData(
      color: KelloggColors.yellow,
      value: biscuits + dummyChartExtra,
      showTitle: false,
      radius: chartRadiusCircle1111,
    );
    waferSection = PieChartSectionData(
      color: KelloggColors.green,
      value: wafer + dummyChartExtra,
      showTitle: false,
      radius: chartRadiusCircle111,
    );
    maamoulSection = PieChartSectionData(
      color: KelloggColors.cockRed,
      value: maamoul + dummyChartExtra,
      showTitle: false,
      radius: chartRadiusCircle11,
    );
    elseSection = PieChartSectionData(
      color: KelloggColors.darkRed.withOpacity(0.1),
      value: other + dummyChartExtra,
      showTitle: false,
      radius: chartRadiusCircle1,
    );
    return SizedBox(
      height: 200,
      child: Stack(
        children: [
          PieChart(
            PieChartData(
              sectionsSpace: 0,
              centerSpaceRadius: chartInnerRadius,
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
                  ((biscuits + wafer + maamoul) / 1000).toStringAsFixed(2) +
                      " T",
                  style: Theme.of(context).textTheme.headline4!.copyWith(
                        color: KelloggColors.darkBlue,
                        fontWeight: FontWeight.w600,
                        height: 0.5,
                      ),
                ),
                Text("of " +
                    ((biscuits + wafer + maamoul + other) / 1000)
                        .toStringAsFixed(2) +
                    " T"),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

List<PieChartSectionData> paiChartSelectionData = [
  biscuitsSection,
  waferSection,
  maamoulSection,
  elseSection,
];
