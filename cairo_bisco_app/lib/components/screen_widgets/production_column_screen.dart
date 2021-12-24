import 'package:cairo_bisco_app/classes/MiniProductionReport.dart';
import 'package:cairo_bisco_app/classes/Plans.dart';
import 'package:cairo_bisco_app/classes/utility_funcs/calculations_utility.dart';
import 'package:cairo_bisco_app/classes/values/TextStandards.dart';
import 'package:cairo_bisco_app/classes/values/colors.dart';
import 'package:cairo_bisco_app/classes/values/constants.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class ProductionColScreen extends StatelessWidget {
  const ProductionColScreen({
    Key? key,
    required this.lineNum,
    required this.report,
    required this.prodType,
    required this.overweight,
  }) : super(key: key);
  final MiniProductionReport report;

  final int lineNum;
  final String prodType;
  final double overweight;

  @override
  Widget build(BuildContext context) {
    bool noWork = report.productionInCartons == 0;

    bool prodTargetDone =
        noWork || report.productionInCartons - report.shiftProductionPlan >= 0;
    String arrowImg = prodTargetDone ? "up" : "down";

    String arrowImg2 = report.rmMUV + report.pmMUV <= 0 ? "up" : "down";

    return Container(
      margin: EdgeInsets.all(defaultPadding),
      padding: EdgeInsets.all(defaultPadding),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              prodType,
              style: TextStyle(
                color: KelloggColors.darkBlue,
                fontSize: largeFontSize,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(
            height: minimumPadding,
          ),
          Center(
            child: Text(
              lineNum == -1 ? 'اجمالي المنطقة' : ' $lineNum خط  ',
              style: TextStyle(
                color: KelloggColors.darkRed,
                fontSize: largeFontSize,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(
            height: defaultPadding,
          ),
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: minimumPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "انتاج الكراتين",
                        style: TextStyle(
                          color: KelloggColors.grey,
                          fontSize: mediumFontSize,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      subHeading(report.productionInCartons.toString()),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: minimumPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "الخطة بالكراتين",
                        style: TextStyle(
                          color: KelloggColors.grey,
                          fontSize: minimumFontSize,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      subHeading(report.shiftProductionPlan.toString()),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: minimumPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "انتاج بالطن",
                        style: TextStyle(
                          color: KelloggColors.grey,
                          fontSize: mediumFontSize,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      subHeading(
                          (report.productionInKg / 1000).toStringAsFixed(2) +
                              " K "),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: defaultPadding),
          IntrinsicHeight(
            child: Container(
              padding: EdgeInsets.all(minimumPadding),
              decoration: BoxDecoration(
                border: Border.all(
                    width: borderWidth,
                    color: KelloggColors.darkRed.withOpacity(0.1)),
                borderRadius: const BorderRadius.all(
                  Radius.circular(minimumPadding),
                ),
              ),
              child: Row(
                children: [
                  SizedBox(width: minimumPadding),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(iconImageBorder),
                    child: Container(
                      height: smallIconSize,
                      width: smallIconSize,
                      padding: EdgeInsets.all(minimumPadding / 2),
                      color: prodTargetDone
                          ? KelloggColors.green
                          : KelloggColors.cockRed,
                      child: new Image.asset(
                        'images/$arrowImg.png',
                      ),
                    ),
                  ),
                  // Spacer(flex: 2), //push numbers away
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: minimumPadding / 10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: minimumPadding / 10),
                              child: Column(
                                // mainAxisAlignment: MainAxisAlignment.center,
                                // crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    calculateDifferenceInCartonsTarget(report),
                                    style: TextStyle(
                                      color: prodTargetDone
                                          ? KelloggColors.green
                                          : KelloggColors.cockRed,
                                      fontSize: aboveMediumFontSize,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(width: minimumPadding),
                          VerticalDivider(
                            color: KelloggColors.grey,
                            thickness: borderWidth,
                            indent: 0,
                            endIndent: 0,
                            width: 10,
                          ),
                          SizedBox(width: minimumPadding),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: minimumPadding / 10),
                              child: Column(
                                // crossAxisAlignment: CrossAxisAlignment.end,
                                // mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    (report.productionInCartons *
                                                100 /
                                                report.shiftProductionPlan)
                                            .toStringAsFixed(1) +
                                        " %",
                                    style: TextStyle(
                                      color: prodTargetDone
                                          ? KelloggColors.green
                                          : KelloggColors.cockRed,
                                      fontSize: aboveMediumFontSize,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: defaultPadding),
          SfRadialGauge(
            title: GaugeTitle(
                text: 'كفاءة المكن %',
                textStyle: TextStyle(
                    fontSize: largeFontSize,
                    fontWeight: FontWeight.bold,
                    color: KelloggColors.darkRed)),
            enableLoadingAnimation: true,
            animationDuration: 2000,
            axes: <RadialAxis>[
              RadialAxis(minimum: 0, maximum: 100, pointers: <GaugePointer>[
                NeedlePointer(
                    value: calculateOeeFromMiniReport(report, overweight),
                    enableAnimation: true)
              ], ranges: <GaugeRange>[
                GaugeRange(
                    startValue: Plans.targetOEE - oeeMargin,
                    endValue: Plans.targetOEE + oeeMargin,
                    color: KelloggColors.darkBlue),
                // GaugeRange(startValue: 50, endValue: 100, color: Colors.orange),
                // GaugeRange(startValue: 100, endValue: regularBoxHeight, color: Colors.red)
              ], annotations: <GaugeAnnotation>[
                GaugeAnnotation(
                    widget: Text(
                      calculateOeeFromMiniReport(report, overweight)
                              .toStringAsFixed(1) +
                          ' %',
                      style: TextStyle(
                          fontSize: largeFontSize, fontWeight: FontWeight.bold),
                    ),
                    positionFactor: 0.5,
                    angle: 90)
              ])
            ],
          ),
          Center(
            child: Text('فرق تكلفة الهالك عن المستهدف',
                style: TextStyle(
                    fontSize: largeFontSize,
                    fontWeight: FontWeight.bold,
                    color: KelloggColors.darkRed)),
          ),
          SizedBox(height: defaultPadding),
          Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(BoxImageBorder),
              child: ConstrainedBox(
                constraints: BoxConstraints.tightFor(height: kpiBoxHeight),
                child: ElevatedButton.icon(
                  label: Text(((report.rmMUV + report.pmMUV) / 1000)
                          .toStringAsFixed(2) +
                      " الف جنيه "),
                  style: ElevatedButton.styleFrom(
                    textStyle: TextStyle(
                        fontSize: largeButtonFont, fontFamily: 'MyFont'),
                    primary: report.rmMUV + report.pmMUV > 0
                        ? KelloggColors.cockRed
                        : KelloggColors.green,
                  ),
                  icon: ClipRRect(
                    borderRadius: BorderRadius.circular(iconImageBorder),
                    child: Container(
                      height: mediumIconSize,
                      width: mediumIconSize,
                      padding: EdgeInsets.all(minimumPadding / 2),
                      child: new Image.asset(
                        'images/$arrowImg2.png',
                      ),
                    ),
                  ),
                  onPressed: () {},
                ),
              ),
            ),
          ),
          SizedBox(height: defaultPadding),
        ],
      ),
    );
  }
}
