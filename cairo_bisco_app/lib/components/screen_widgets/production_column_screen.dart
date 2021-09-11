import 'package:cairo_bisco_app/classes/Rules.dart';
import 'package:cairo_bisco_app/classes/SKU.dart';
import 'package:cairo_bisco_app/classes/values/TextStandards.dart';
import 'package:cairo_bisco_app/classes/values/colors.dart';
import 'package:cairo_bisco_app/classes/values/constants.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class ProductionColScreen extends StatelessWidget {
  const ProductionColScreen({
    Key? key,
    required this.cartons,
    required this.targetProd,
    required this.oee,
    required this.scrap,
    required this.prodType,
    required this.lineNum,
    required this.productName,
  }) : super(key: key);
  final double cartons, oee, targetProd;
  final double scrap;
  final String prodType;
  final int lineNum;
  final String productName;

  @override
  Widget build(BuildContext context) {
    double actual = cartons * SKU.skuDetails[productName]!.cartonWeight;
    bool prodTargetDone = cartons - targetProd > 0;
    String arrowImg = prodTargetDone ? "up" : "down";
    String arrowImg2 =
        scrap < SKU.skuDetails[productName]!.targetScrap ? "up" : "down";

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
                color: KelloggColors.yellow,
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "انتاج الكراتين",
                        style: TextStyle(
                          color: KelloggColors.grey,
                          fontSize: mediumFontSize,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      subHeading(" $cartons الف "),
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
                        "انتاج بالطن",
                        style: TextStyle(
                          color: KelloggColors.grey,
                          fontSize: mediumFontSize,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      subHeading(actual.toStringAsFixed(1) + " طن "),
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
                          ? KelloggColors.green
                          : KelloggColors.cockRed,
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
                            (cartons - targetProd).toStringAsFixed(1) + " K",
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
                            ((cartons - targetProd) * 100 / targetProd)
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
                text: 'كفاءة المكن %',
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
          Center(
            child: Text('تكلفة الهالك',
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
                      constraints: BoxConstraints.tightFor(height: 150),
                      child: ElevatedButton.icon(
                        label: Text(" الف جنيه " +
                            (scrap * Plans.scrapKgCost).toStringAsFixed(1)),
                        style: ElevatedButton.styleFrom(
                          textStyle: TextStyle(
                              fontSize: largeButtonFont, fontFamily: 'MyFont'),
                          primary:
                              scrap < SKU.skuDetails[productName]!.targetScrap
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
