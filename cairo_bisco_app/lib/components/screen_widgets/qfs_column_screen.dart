import 'package:cairo_bisco_app/classes/SKU.dart';
import 'package:cairo_bisco_app/components/qfs_ehs_wigdets/1kpi_good_bad_indicator.dart';
import 'package:cairo_bisco_app/classes/Rules.dart';
import 'package:cairo_bisco_app/classes/values/TextStandards.dart';
import 'package:cairo_bisco_app/classes/values/colors.dart';
import 'package:cairo_bisco_app/classes/values/constants.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class QFSColScreen extends StatelessWidget {
  const QFSColScreen({
    Key? key,
    required this.quality_incidents,
    required this.food_safety_incidents,
    required this.scrap,
    required this.productName,
  }) : super(key: key);
  final int quality_incidents, food_safety_incidents;
  final double scrap;
  final String productName;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: SizedBox(
            width: 300,
            height: 175,
            child: new Image.asset(
              'images/logo.png',
              // width: 300.0,
              height: 175.0,
              fit: BoxFit.scaleDown,
            ),
            // child: SvgPicture.asset('images/login.svg')
          ),
        ),
        sectionTitle('الجودة و سلامة الغذاء'),
        IntrinsicHeight(
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: minimumPadding),
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: minimumPadding),
                  child: KPI1GoodBadIndicator(
                    circleColor: quality_incidents > 0
                        ? KelloggColors.cockRed
                        : KelloggColors.green,
                    title: 'حوادث الجودة',
                    circleText: quality_incidents.toString(),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: minimumPadding),
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: minimumPadding),
                  child: KPI1GoodBadIndicator(
                    circleColor: food_safety_incidents > 0
                        ? KelloggColors.cockRed
                        : KelloggColors.green,
                    title: 'حوادث سلامة الغذاء',
                    circleText: food_safety_incidents.toString(),
                  ),
                ),
              ),
            ],
          ),
        ),
        myDivider(),
        SfRadialGauge(
          title: GaugeTitle(
              text: 'نسبة الهالك %',
              textStyle: TextStyle(
                  fontSize: largeFontSize,
                  fontWeight: FontWeight.bold,
                  color: KelloggColors.darkRed)),
          enableLoadingAnimation: true,
          animationDuration: 2000,
          axes: <RadialAxis>[
            RadialAxis(minimum: 0, maximum: maxScrap, pointers: <GaugePointer>[
              NeedlePointer(value: scrap, enableAnimation: true)
            ], ranges: <GaugeRange>[
              GaugeRange(
                  startValue: 0,
                  endValue: SKU.skuDetails[productName]!.targetScrap,
                  color: KelloggColors.successGreen),
              GaugeRange(
                  startValue: SKU.skuDetails[productName]!.targetScrap,
                  endValue: maxScrap,
                  color: KelloggColors.clearRed)
            ], annotations: <GaugeAnnotation>[
              GaugeAnnotation(
                  widget: Text(
                    scrap.toStringAsFixed(1) + ' %',
                    style: TextStyle(
                        fontSize: largeFontSize, fontWeight: FontWeight.bold),
                  ),
                  positionFactor: 0.5,
                  angle: 90)
            ])
          ],
        ),
      ],
    );
  }
}
