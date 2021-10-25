import 'package:cairo_bisco_app/classes/MiniProductionReport.dart';
import 'package:cairo_bisco_app/classes/Plans.dart';
import 'package:cairo_bisco_app/classes/SKU.dart';
import 'package:cairo_bisco_app/classes/utility_funcs/calculations_utility.dart';
import 'package:cairo_bisco_app/classes/values/TextStandards.dart';
import 'package:cairo_bisco_app/classes/values/colors.dart';
import 'package:cairo_bisco_app/classes/values/constants.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class ProductionLine extends StatelessWidget {
  const ProductionLine({
    Key? key,
    required this.overweight,
    required this.report,
  }) : super(key: key);
  final MiniProductionReport report;

  final double overweight;

  @override
  Widget build(BuildContext context) {
    bool noWork = report.productionInCartons == 0;
    double actual = noWork
        ? 0
        : report.productionInCartons *
            SKU.skuDetails[report.skuName]!.cartonWeight;
    bool prodTargetDone =
        noWork || report.productionInCartons - report.shiftProductionPlan >= 0;
    String arrowImg = prodTargetDone ? "up" : "down";
    String arrowImg2 = BadOverweightDriver(overweight) ? "down" : "up";
    String arrowImg3 = noWork
        ? "up"
        : calculateScrapPercent(report) <
                SKU.skuDetails[report.skuName]!.targetScrap
            ? "up"
            : "down";
    String arrowImg4 = noWork
        ? "up"
        : calculateMPSA(
                    report.shiftProductionPlan, report.productionInCartons) >
                Plans.mpsaTarget
            ? "up"
            : "down";

    return Container(
      margin: EdgeInsets.all(defaultPadding),
      padding: EdgeInsets.all(defaultPadding),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: subHeading(report.skuName),
          ),
          SizedBox(height: defaultPadding),
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: minimumPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Cartons",
                        style: TextStyle(
                          color: KelloggColors.grey,
                          fontSize: minimumFontSize,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      subHeading((report.productionInCartons / 1000)
                              .toStringAsFixed(1) +
                          " K"),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: minimumPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        "Actual",
                        style: TextStyle(
                          color: KelloggColors.grey,
                          fontSize: minimumFontSize,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      subHeading((actual / 1000).toStringAsFixed(1) + " K"),
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
                  // Spacer(flex: 1), //push numbers away
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
                                    (prodTargetDone ? "" : "-") +
                                        ((report.productionInCartons -
                                                        report
                                                            .shiftProductionPlan)
                                                    .abs() /
                                                1000)
                                            .toStringAsFixed(2) +
                                        " K",
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
                                    (prodTargetDone ? "" : "-") +
                                        ((report.productionInCartons -
                                                        report
                                                            .shiftProductionPlan)
                                                    .abs() *
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
                text: 'OEE%',
                textStyle: TextStyle(
                    fontSize: largeFontSize,
                    fontWeight: FontWeight.bold,
                    color: KelloggColors.darkRed)),
            enableLoadingAnimation: true,
            animationDuration: 2000,
            axes: <RadialAxis>[
              RadialAxis(minimum: 0, maximum: 100, pointers: <GaugePointer>[
                NeedlePointer(
                    value: calculateOeeFromMiniReport(report),
                    enableAnimation: true)
              ], ranges: <GaugeRange>[
                GaugeRange(
                    startValue: Plans.targetOEE - 1,
                    endValue: Plans.targetOEE + 1,
                    color: KelloggColors.green),
                // GaugeRange(startValue: 50, endValue: 100, color: Colors.orange),
                // GaugeRange(startValue: 100, endValue: 150, color: Colors.red)
              ], annotations: <GaugeAnnotation>[
                GaugeAnnotation(
                    widget: Text(
                      calculateOeeFromMiniReport(report).toStringAsFixed(1) +
                          ' %',
                      style: TextStyle(
                          fontSize: largeFontSize, fontWeight: FontWeight.bold),
                    ),
                    positionFactor: 0.5,
                    angle: 90)
              ])
            ],
          ),
          SizedBox(height: defaultPadding),
          SfRadialGauge(
            title: GaugeTitle(
                text: 'Scrap%',
                textStyle: TextStyle(
                    fontSize: largeFontSize,
                    fontWeight: FontWeight.bold,
                    color: KelloggColors.darkRed)),
            enableLoadingAnimation: true,
            animationDuration: 2000,
            axes: <RadialAxis>[
              RadialAxis(
                  minimum: 0,
                  maximum: maxScrap,
                  pointers: <GaugePointer>[
                    NeedlePointer(
                        value: calculateScrapPercent(report),
                        enableAnimation: true)
                  ],
                  ranges: <GaugeRange>[
                    GaugeRange(
                        startValue: 0,
                        endValue: noWork
                            ? maxScrap / 2
                            : SKU.skuDetails[report.skuName]!.targetScrap,
                        color: KelloggColors.successGreen),
                    GaugeRange(
                        startValue: noWork
                            ? maxScrap / 2
                            : SKU.skuDetails[report.skuName]!.targetScrap,
                        endValue: maxScrap,
                        color: KelloggColors.clearRed)
                  ],
                  annotations: <GaugeAnnotation>[
                    GaugeAnnotation(
                        widget: Text(
                          calculateScrapPercent(report).toStringAsFixed(1) +
                              ' %',
                          style: TextStyle(
                              fontSize: largeFontSize,
                              fontWeight: FontWeight.bold),
                        ),
                        positionFactor: 0.5,
                        angle: 90)
                  ])
            ],
          ),
          Center(
            child: Text('Over Weight%',
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
                constraints: BoxConstraints.tightFor(height: regularBoxHeight),
                child: ElevatedButton.icon(
                  label: Text(overweight.toStringAsFixed(1) + " %"),
                  style: ElevatedButton.styleFrom(
                    textStyle: TextStyle(
                        fontSize: largeButtonFont, fontFamily: 'MyFont'),
                    primary: BadOverweightDriver(overweight)
                        ? KelloggColors.green
                        : KelloggColors.cockRed,
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
          SfRadialGauge(
            title: GaugeTitle(
                text: 'Film Waste%',
                textStyle: TextStyle(
                    fontSize: largeFontSize,
                    fontWeight: FontWeight.bold,
                    color: KelloggColors.darkRed)),
            enableLoadingAnimation: true,
            animationDuration: 2000,
            axes: <RadialAxis>[
              RadialAxis(
                  minimum: 0,
                  maximum: maxScrap,
                  pointers: <GaugePointer>[
                    NeedlePointer(
                        value: calculateWastePercent(
                            report.totalFilmUsed, report.totalFilmWasted),
                        enableAnimation: true)
                  ],
                  ranges: <GaugeRange>[
                    GaugeRange(
                        startValue: 0,
                        endValue: noWork
                            ? maxFilmWaste / 2
                            : SKU.skuDetails[report.skuName]!.targetFilmWaste,
                        color: KelloggColors.successGreen),
                    GaugeRange(
                        startValue: noWork
                            ? maxFilmWaste / 2
                            : SKU.skuDetails[report.skuName]!.targetFilmWaste,
                        endValue: maxFilmWaste,
                        color: KelloggColors.clearRed)
                  ],
                  annotations: <GaugeAnnotation>[
                    GaugeAnnotation(
                        widget: Text(
                          calculateWastePercent(report.totalFilmUsed,
                                      report.totalFilmWasted)
                                  .toStringAsFixed(1) +
                              ' %',
                          style: TextStyle(
                              fontSize: largeFontSize,
                              fontWeight: FontWeight.bold),
                        ),
                        positionFactor: 0.5,
                        angle: 90)
                  ])
            ],
          ),
          Center(
            child: Text('Scrap Cost (EGP)',
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
                constraints: BoxConstraints.tightFor(height: regularBoxHeight),
                child: ElevatedButton.icon(
                  label: Text(
                      calculateScrapMoney(report.scrap).toStringAsFixed(1) +
                          " K EGP "),
                  style: ElevatedButton.styleFrom(
                    textStyle: TextStyle(
                        fontSize: largeButtonFont, fontFamily: 'MyFont'),
                    primary: BadFinanceDriver(report)
                        ? KelloggColors.green
                        : KelloggColors.cockRed,
                  ),
                  icon: ClipRRect(
                    borderRadius: BorderRadius.circular(iconImageBorder),
                    child: Container(
                      height: mediumIconSize,
                      width: mediumIconSize,
                      padding: EdgeInsets.all(minimumPadding / 2),
                      child: new Image.asset(
                        'images/$arrowImg3.png',
                      ),
                    ),
                  ),
                  onPressed: () {},
                ),
              ),
            ),
          ),
          SizedBox(height: defaultPadding),
          Center(
            child: Text('MPSA %',
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
                constraints: BoxConstraints.tightFor(height: regularBoxHeight),
                child: ElevatedButton.icon(
                  label: Text(calculateMPSA(report.shiftProductionPlan,
                              report.productionInCartons)
                          .toStringAsFixed(1) +
                      " %"),
                  style: ElevatedButton.styleFrom(
                    textStyle: TextStyle(
                        fontSize: largeButtonFont, fontFamily: 'MyFont'),
                    primary: noWork
                        ? KelloggColors.green
                        : calculateMPSA(report.shiftProductionPlan,
                                    report.productionInCartons) >
                                Plans.mpsaTarget
                            ? KelloggColors.green
                            : KelloggColors.cockRed,
                  ),
                  icon: ClipRRect(
                    borderRadius: BorderRadius.circular(iconImageBorder),
                    child: Container(
                      height: mediumIconSize,
                      width: mediumIconSize,
                      padding: EdgeInsets.all(minimumPadding / 2),
                      child: new Image.asset(
                        'images/$arrowImg4.png',
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
