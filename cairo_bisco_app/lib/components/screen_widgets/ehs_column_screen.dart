import 'package:cairo_bisco_app/classes/Rules.dart';
import 'package:cairo_bisco_app/classes/SKU.dart';
import 'package:cairo_bisco_app/classes/values/TextStandards.dart';
import 'package:cairo_bisco_app/classes/values/colors.dart';
import 'package:cairo_bisco_app/classes/values/constants.dart';
import 'package:cairo_bisco_app/components/qfs_ehs_wigdets/1kpi_good_bad_indicator.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class EHSColScreen extends StatelessWidget {
  const EHSColScreen({
    Key? key,
    required this.firstAid_incidents,
    required this.recordable_incidents,
    required this.nearMiss,
    required this.filmWaste,
    required this.productName,
  }) : super(key: key);
  final int firstAid_incidents, recordable_incidents, nearMiss;
  final double filmWaste;
  final String productName;

  @override
  Widget build(BuildContext context) {
    int days_in_interval = 1; //screen shows 1 day only

    return Column(
      children: [
        sectionTitle('الامن و السلامة'),
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
                    circleColor: firstAid_incidents > 0
                        ? KelloggColors.cockRed
                        : KelloggColors.green,
                    title: 'حوادث اسعافات اولية',
                    circleText: firstAid_incidents.toString(),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: minimumPadding),
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: minimumPadding),
                  child: KPI1GoodBadIndicator(
                    circleColor: recordable_incidents > 0
                        ? KelloggColors.cockRed
                        : KelloggColors.green,
                    title: 'حوادث مسجلة',
                    circleText: recordable_incidents.toString(),
                  ),
                ),
              ),
            ],
          ),
        ),
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
                    circleColor: nearMiss <
                            (Plans.monthlyNearMissTarget / monthDays) *
                                days_in_interval
                        ? KelloggColors.cockRed
                        : KelloggColors.green,
                    title: 'حوادث وشيكة',
                    circleText: nearMiss.toString(),
                  ),
                ),
              ),
            ],
          ),
        ),
        myDivider(),
        SfRadialGauge(
          title: GaugeTitle(
              text: 'هالك التغليف %',
              textStyle: TextStyle(
                  fontSize: largeFontSize,
                  fontWeight: FontWeight.bold,
                  color: KelloggColors.darkRed)),
          enableLoadingAnimation: true,
          animationDuration: 2000,
          axes: <RadialAxis>[
            RadialAxis(minimum: 0, maximum: maxScrap, pointers: <GaugePointer>[
              NeedlePointer(value: filmWaste, enableAnimation: true)
            ], ranges: <GaugeRange>[
              GaugeRange(
                  startValue: 0,
                  endValue: SKU.skuDetails[productName]!.targetFilmWaste,
                  color: KelloggColors.successGreen),
              GaugeRange(
                  startValue: SKU.skuDetails[productName]!.targetFilmWaste,
                  endValue: maxFilmWaste,
                  color: KelloggColors.clearRed)
            ], annotations: <GaugeAnnotation>[
              GaugeAnnotation(
                  widget: Text(
                    filmWaste.toStringAsFixed(1) + ' %',
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
