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
    bool isTotal = report.skuName.compareTo('total') == 0;
    bool noWork = report.productionInCartons == 0;
    bool prodTargetDone =
        noWork || report.productionInCartons - report.shiftProductionPlan >= 0;
    String arrowImg = prodTargetDone ? "up" : "down";
    String arrowImg2 = BadOverweightDriver(overweight) ? "down" : "up";
    String arrowImg3 = noWork
        ? "up"
        : calculateMPSA(report.planInKg, report.productionInKg) >
                Plans.mpsaTarget
            ? "up"
            : "down";
    String arrowImg4 = report.rmMUV <= 0 ? "up" : "down";
    String arrowImg5 = report.pmMUV <= 0 ? "up" : "down";

    return Container(
      margin: EdgeInsets.symmetric(vertical: defaultPadding),
      // padding: EdgeInsets.all(defaultPadding),
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
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Cartons",
                        style: TextStyle(
                          color: KelloggColors.grey,
                          fontSize: minimumFontSize,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      subHeading(report.productionInCartons.toString() + " C"),
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
                        "Plan",
                        style: TextStyle(
                          color: KelloggColors.grey,
                          fontSize: minimumFontSize,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      subHeading(report.shiftProductionPlan.toString() + " C"),
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
                        "Actual",
                        style: TextStyle(
                          color: KelloggColors.grey,
                          fontSize: minimumFontSize,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      subHeading(
                          (report.productionInKg / 1000).toStringAsFixed(2) +
                              " K"),
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
          Center(
            child: Text('Stopped Time',
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
                constraints: BoxConstraints.tightFor(height: minimumBoxHeight),
                child: ElevatedButton.icon(
                  label: Text(
                      report.wastedMinutes.round().toString() + " Minutes"),
                  style: ElevatedButton.styleFrom(
                      textStyle: TextStyle(
                          fontSize: aboveMediumFontSize, fontFamily: 'MyFont'),
                      primary: KelloggColors.grey),
                  icon: ClipRRect(
                    borderRadius: BorderRadius.circular(iconImageBorder),
                    child: Container(
                      height: mediumIconSize,
                      width: mediumIconSize,
                      padding: EdgeInsets.all(minimumPadding / 2),
                      child: new Image.asset(
                        'images/safety.png',
                        color: KelloggColors.white,
                      ),
                    ),
                  ),
                  onPressed: () {},
                ),
              ),
            ),
          ),
          SizedBox(height: minimumPadding),
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
                    value: calculateOeeFromMiniReport(report, overweight),
                    enableAnimation: true)
              ], ranges: <GaugeRange>[
                GaugeRange(
                    startValue: Plans.targetOEE - oeeMargin,
                    endValue: Plans.targetOEE + oeeMargin,
                    color: KelloggColors.green),
                // GaugeRange(startValue: 50, endValue: 100, color: Colors.orange),
                // GaugeRange(startValue: 100, endValue: 150, color: Colors.red)
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
          SizedBox(height: minimumPadding),
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
                        value: calculateScrapPercent(report, overweight),
                        enableAnimation: true)
                  ],
                  ranges: <GaugeRange>[
                    GaugeRange(
                        startValue: 0,
                        endValue: noWork
                            ? Plans.universalTargetScrap
                            : (isTotal
                                ? Plans.universalTargetScrap
                                : SKU.skuDetails[report.skuName]!.targetScrap),
                        color: KelloggColors.successGreen),
                    GaugeRange(
                        startValue: noWork
                            ? Plans.universalTargetScrap
                            : (isTotal
                                ? Plans.universalTargetScrap
                                : SKU.skuDetails[report.skuName]!.targetScrap),
                        endValue: maxScrap,
                        color: KelloggColors.clearRed)
                  ],
                  annotations: <GaugeAnnotation>[
                    GaugeAnnotation(
                        widget: Text(
                          calculateScrapPercent(report, overweight)
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
                  label: Text(overweight.toStringAsFixed(2) + " %"),
                  style: ElevatedButton.styleFrom(
                    textStyle: TextStyle(
                        fontSize: largeButtonFont, fontFamily: 'MyFont'),
                    primary: BadOverweightDriver(overweight)
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
          SizedBox(height: minimumPadding),
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
              RadialAxis(minimum: 0, maximum: maxFilmWaste, pointers: <
                  GaugePointer>[
                NeedlePointer(
                    value: calculateWastePercent(
                        report.totalFilmUsed, report.totalFilmWasted),
                    enableAnimation: true)
              ], ranges: <GaugeRange>[
                GaugeRange(
                    startValue: 0,
                    endValue: noWork
                        ? Plans.universalTargetFilmWaste
                        : (isTotal
                            ? Plans.universalTargetFilmWaste
                            : SKU.skuDetails[report.skuName]!.targetFilmWaste),
                    color: KelloggColors.successGreen),
                GaugeRange(
                    startValue: noWork
                        ? Plans.universalTargetFilmWaste
                        : (isTotal
                            ? Plans.universalTargetFilmWaste
                            : SKU.skuDetails[report.skuName]!.targetFilmWaste),
                    endValue: maxFilmWaste,
                    color: KelloggColors.clearRed)
              ], annotations: <GaugeAnnotation>[
                GaugeAnnotation(
                    widget: Text(
                      calculateWastePercent(
                                  report.totalFilmUsed, report.totalFilmWasted)
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
          //////////////////////////////////////////////////////////////////////////////////
          Center(
            child: Text('RM MUV (EGP)',
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
                      (report.rmMUV / 1000).toStringAsFixed(2) + " K EGP "),
                  style: ElevatedButton.styleFrom(
                    textStyle: TextStyle(
                        fontSize: largeButtonFont, fontFamily: 'MyFont'),
                    primary: report.rmMUV > 0
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
          //////////////////////////////////////////////////////////////////////////////////
          Center(
            child: Text('PM MUV (EGP)',
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
                      (report.pmMUV / 1000).toStringAsFixed(2) + " K EGP "),
                  style: ElevatedButton.styleFrom(
                    textStyle: TextStyle(
                        fontSize: largeButtonFont, fontFamily: 'MyFont'),
                    primary: report.pmMUV > 0
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
                        'images/$arrowImg5.png',
                      ),
                    ),
                  ),
                  onPressed: () {},
                ),
              ),
            ),
          ),
          SizedBox(height: defaultPadding),
          //////////////////////////////////////////////////////////////////////////////////
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
                  label: Text(
                      calculateMPSA(report.planInKg, report.productionInKg)
                              .toStringAsFixed(1) +
                          " %"),
                  style: ElevatedButton.styleFrom(
                    textStyle: TextStyle(
                        fontSize: largeButtonFont, fontFamily: 'MyFont'),
                    primary: noWork
                        ? KelloggColors.green
                        : calculateMPSA(
                                    report.planInKg, report.productionInKg) >=
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
        ],
      ),
    );
  }
}
