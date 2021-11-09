import 'package:cairo_bisco_app/classes/MiniProductionReport.dart';
import 'package:cairo_bisco_app/classes/Plans.dart';
import 'package:cairo_bisco_app/classes/SKU.dart';
import 'package:cairo_bisco_app/classes/utility_funcs/calculations_utility.dart';
import 'package:cairo_bisco_app/classes/values/TextStandards.dart';
import 'package:cairo_bisco_app/classes/values/colors.dart';
import 'package:cairo_bisco_app/classes/values/constants.dart';
import 'package:cairo_bisco_app/components/qfs_ehs_wigdets/1kpi_good_bad_indicator.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class QFSColScreen extends StatelessWidget {
  const QFSColScreen({
    Key? key,
    required this.quality_incidents,
    required this.food_safety_incidents,
    required this.report,
  }) : super(key: key);
  final int quality_incidents, food_safety_incidents;
  final MiniProductionReport report;

  @override
  Widget build(BuildContext context) {
    bool noWork = report.productionInCartons == 0;

    return Column(
      children: [
        Center(
          child: SizedBox(
            width: TightBoxWidth,
            height: logoHeight,
            child: new Image.asset(
              'images/logo.png',
              height: logoHeight,
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
              NeedlePointer(
                  value: calculateScrapPercent(report), enableAnimation: true)
            ], ranges: <GaugeRange>[
              GaugeRange(
                  startValue: 0,
                  endValue: noWork
                      ? Plans.universalTargetScrap
                      : SKU.skuDetails[report.skuName]!.targetScrap,
                  color: KelloggColors.successGreen),
              GaugeRange(
                  startValue: noWork
                      ? Plans.universalTargetScrap
                      : SKU.skuDetails[report.skuName]!.targetScrap,
                  endValue: maxScrap,
                  color: KelloggColors.clearRed)
            ], annotations: <GaugeAnnotation>[
              GaugeAnnotation(
                  widget: Text(
                    calculateScrapPercent(report).toStringAsFixed(1) + ' %',
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
