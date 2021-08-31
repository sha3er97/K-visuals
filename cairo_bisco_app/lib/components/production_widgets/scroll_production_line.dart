import 'package:cairo_bisco_app/components/values/Rules.dart';
import 'package:cairo_bisco_app/components/values/TextStandards.dart';
import 'package:cairo_bisco_app/components/values/colors.dart';
import 'package:cairo_bisco_app/components/values/constants.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class ProductionLine extends StatelessWidget {
  const ProductionLine({
    Key? key,
    required this.cartons,
    required this.actual,
    required this.oee,
    required this.scrap,
    required this.overweight,
    required this.filmWaste,
    required this.productName,
    required this.targetProd,
    required this.money,
  }) : super(key: key);

  final String productName;
  final double cartons,
      actual,
      oee,
      scrap,
      overweight,
      filmWaste,
      targetProd,
      money;

  @override
  Widget build(BuildContext context) {
    bool prodTargetDone = actual - targetProd > 0;
    String arrowImg = prodTargetDone ? "up" : "down";
    bool overweightNormal = overweight < Plans.targetOverWeightAbove &&
        overweight > Plans.targetOverWeightBelow;
    String arrowImg2 = overweightNormal ? "up" : "down";
    String arrowImg3 = money > Plans.targetMinimumMoney ? "up" : "down";

    return Container(
      margin: EdgeInsets.all(defaultPadding),
      padding: EdgeInsets.all(defaultPadding),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              productName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  color: KelloggColors.darkRed,
                  fontSize: 18.0,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.2),
            ),
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
                          fontSize: 12.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      subHeading("$cartons K"),
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
                          fontSize: 12.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      subHeading("$actual K"),
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
                    width: 2, color: KelloggColors.darkRed.withOpacity(0.1)),
                borderRadius: const BorderRadius.all(
                  Radius.circular(minimumPadding),
                ),
              ),
              child: Row(
                children: [
                  SizedBox(width: minimumPadding),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10.0), //or 15.0
                    child: Container(
                      height: 25.0,
                      width: 25.0,
                      padding: EdgeInsets.all(minimumPadding / 2),
                      color: prodTargetDone
                          ? KelloggColors.green.withOpacity(0.5)
                          : KelloggColors.clearRed,
                      child: new Image.asset(
                        'images/$arrowImg.png',
                      ),
                    ),
                  ),
                  Spacer(flex: 2), //push numbers away
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: minimumPadding / 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            (actual - targetProd).toStringAsFixed(1) + " K",
                            style: TextStyle(
                                color: prodTargetDone
                                    ? KelloggColors.green.withOpacity(0.5)
                                    : KelloggColors.clearRed,
                                fontSize: 16.0,
                                fontWeight: FontWeight.w500,
                                letterSpacing: 1.2),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: minimumPadding),
                  VerticalDivider(
                    color: KelloggColors.grey,
                    thickness: 2,
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            ((actual - targetProd) * 100 / targetProd)
                                    .toStringAsFixed(1) +
                                " %",
                            style: TextStyle(
                                color: prodTargetDone
                                    ? KelloggColors.green
                                    : KelloggColors.cockRed,
                                fontSize: 16.0,
                                fontWeight: FontWeight.w500,
                                letterSpacing: 1.2),
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
                NeedlePointer(value: oee, enableAnimation: true)
              ], ranges: <GaugeRange>[
                GaugeRange(
                    startValue: Plans.targetOEE - 1,
                    endValue: Plans.targetOEE + 1,
                    color: KelloggColors.darkBlue),
                // GaugeRange(startValue: 50, endValue: 100, color: Colors.orange),
                // GaugeRange(startValue: 100, endValue: 150, color: Colors.red)
              ], annotations: <GaugeAnnotation>[
                GaugeAnnotation(
                    widget: Text(
                      oee.toStringAsFixed(1) + ' %',
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
                    NeedlePointer(value: scrap, enableAnimation: true)
                  ],
                  ranges: <GaugeRange>[
                    GaugeRange(
                        startValue: 0,
                        endValue: Plans.targetScrap,
                        color: KelloggColors.successGreen),
                    GaugeRange(
                        startValue: Plans.targetScrap,
                        endValue: maxScrap,
                        color: KelloggColors.clearRed)
                  ],
                  annotations: <GaugeAnnotation>[
                    GaugeAnnotation(
                        widget: Text(
                          scrap.toStringAsFixed(1) + ' %',
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
                  borderRadius: BorderRadius.circular(15.0),
                  //or 15.0
                  child: ConstrainedBox(
                      constraints:
                          BoxConstraints.tightFor(width: 200, height: 150),
                      child: ElevatedButton.icon(
                        label: Text(overweight.toStringAsFixed(1) + " %"),
                        style: ElevatedButton.styleFrom(
                          textStyle: TextStyle(
                              fontSize: largeButtonFont, fontFamily: 'Poppins'),
                          primary: overweightNormal
                              ? KelloggColors.green
                              : KelloggColors.cockRed,
                        ),
                        icon: ClipRRect(
                          borderRadius: BorderRadius.circular(10.0), //or 15.0
                          child: Container(
                            height: 50.0,
                            width: 50.0,
                            padding: EdgeInsets.all(minimumPadding / 2),
                            child: new Image.asset(
                              'images/$arrowImg2.png',
                            ),
                          ),
                        ),
                        onPressed: () {},
                      )))),
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
                    NeedlePointer(value: filmWaste, enableAnimation: true)
                  ],
                  ranges: <GaugeRange>[
                    GaugeRange(
                        startValue: 0,
                        endValue: Plans.targetFilmWaste,
                        color: KelloggColors.successGreen),
                    GaugeRange(
                        startValue: Plans.targetFilmWaste,
                        endValue: maxFilmWaste,
                        color: KelloggColors.clearRed)
                  ],
                  annotations: <GaugeAnnotation>[
                    GaugeAnnotation(
                        widget: Text(
                          filmWaste.toStringAsFixed(1) + ' %',
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
            child: Text('RM MUV (EGP)',
                style: TextStyle(
                    fontSize: largeFontSize,
                    fontWeight: FontWeight.bold,
                    color: KelloggColors.darkRed)),
          ),
          SizedBox(height: defaultPadding),
          Center(
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(15.0),
                  //or 15.0
                  child: ConstrainedBox(
                      constraints:
                          BoxConstraints.tightFor(height: 150, width: 200),
                      child: ElevatedButton.icon(
                        label: Text(money.toStringAsFixed(1) + " EGP "),
                        style: ElevatedButton.styleFrom(
                          textStyle: TextStyle(
                              fontSize: largeButtonFont, fontFamily: 'Poppins'),
                          primary: money > Plans.targetMinimumMoney
                              ? KelloggColors.green
                              : KelloggColors.cockRed,
                        ),
                        icon: ClipRRect(
                          borderRadius: BorderRadius.circular(10.0), //or 15.0
                          child: Container(
                            height: 50.0,
                            width: 50.0,
                            padding: EdgeInsets.all(minimumPadding / 2),
                            child: new Image.asset(
                              'images/$arrowImg2.png',
                            ),
                          ),
                        ),
                        onPressed: () {},
                      )))),
          SizedBox(height: defaultPadding),
        ],
      ),
    );
  }
}
