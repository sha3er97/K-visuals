import 'package:cairo_bisco_app/components/screen_widgets/ehs_column_screen.dart';
import 'package:cairo_bisco_app/components/screen_widgets/production_column_screen.dart';
import 'package:cairo_bisco_app/components/qfs_ehs_wigdets/1kpi_good_bad_indicator.dart';
import 'package:cairo_bisco_app/components/qfs_ehs_wigdets/6kpis_good_bad_indicator.dart';
import 'package:cairo_bisco_app/components/screen_widgets/qfs_column_screen.dart';
import 'package:cairo_bisco_app/components/values/Rules.dart';
import 'package:cairo_bisco_app/components/values/TextStandards.dart';
import 'package:cairo_bisco_app/components/values/colors.dart';
import 'package:cairo_bisco_app/components/values/constants.dart';
import 'package:cairo_bisco_app/components/values/form_values.dart';
import 'package:flutter/material.dart';

class FloorDashBoard extends StatefulWidget {
  FloorDashBoard({
    Key? key,
    required this.type,
    required this.lineNum,
  }) : super(key: key);
  final int lineNum;
  final String type;

  @override
  _FloorDashBoardState createState() =>
      _FloorDashBoardState(type: type, lineNum: lineNum);
}

class _FloorDashBoardState extends State<FloorDashBoard> {
  _FloorDashBoardState({
    required this.type,
    required this.lineNum,
  });

  final int lineNum;
  final String type;

  @override
  Widget build(BuildContext context) {
    bool isTotal = lineNum == -1;
    return Scaffold(
      backgroundColor: KelloggColors.white,
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: minimumPadding),
                    child: Column(
                      children: [
                        sectionTitle('الانتاج'),
                        Center(
                            child: ProductionColScreen(
                          cartons: 5.3,
                          actual: 5.3,
                          targetProd: 5.5,
                          oee: 53.3,
                          money: 4.3,
                        )),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: defaultPadding),
                Expanded(
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: minimumPadding),
                    child: EHSColScreen(
                      recordable_incidents: 0,
                      firstAid_incidents: 1,
                      nearMiss: 0,
                      filmWaste: 4.5,
                    ),
                  ),
                ),
                SizedBox(width: defaultPadding),
                Expanded(
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: minimumPadding),
                    child: QFSColScreen(
                      quality_incidents: 3,
                      food_safety_incidents: 0,
                      scrap: 5.3,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
