/*
    this screen will have 3 big buttons
    biscuits
    wafer
    maamoul
 *********************************/
import 'package:cairo_bisco_app/classes/values/colors.dart';
import 'package:cairo_bisco_app/classes/values/constants.dart';
import 'package:cairo_bisco_app/components/buttons/back_btn.dart';
import 'package:cairo_bisco_app/ui/supervisor_screens/supervisor_biscuits_production_form.dart';
import 'package:cairo_bisco_app/ui/supervisor_screens/supervisor_maamoul_production_form.dart';
import 'package:cairo_bisco_app/ui/supervisor_screens/supervisor_ehs_report.dart';
import 'package:cairo_bisco_app/ui/supervisor_screens/supervisor_overweight_report.dart';
import 'package:cairo_bisco_app/ui/supervisor_screens/supervisor_people_report.dart';
import 'package:cairo_bisco_app/ui/supervisor_screens/supervisor_qfs_report.dart';
import 'package:cairo_bisco_app/ui/supervisor_screens/supervisor_wafer_production_form.dart';
import 'package:flutter/material.dart';

class SupervisorChooseAreaPage extends StatelessWidget {
  SupervisorChooseAreaPage({
    Key? key,
    required this.type,
  }) : super(key: key);
  final int type;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KelloggColors.white,
      resizeToAvoidBottomInset: true,
      appBar: new AppBar(
        backgroundColor: KelloggColors.white.withOpacity(0),
        shadowColor: KelloggColors.white.withOpacity(0),
        leading: MyBackButton(
          admin: false,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(minimumPadding),
              child: Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(BoxImageBorder),
                  child: ConstrainedBox(
                    constraints: BoxConstraints.tightFor(
                        width: TightBoxWidth, height: LargeBoxHeight),
                    child: ElevatedButton.icon(
                      label: Text('Biscuits\nالبسكويت'),
                      style: ElevatedButton.styleFrom(
                        textStyle: TextStyle(
                            fontSize: largeButtonFont, fontFamily: 'MyFont'),
                        primary: KelloggColors.yellow,
                      ),
                      icon: ClipRRect(
                        borderRadius: BorderRadius.circular(iconImageBorder),
                        child: Container(
                          height: mediumIconSize,
                          width: mediumIconSize,
                          padding: EdgeInsets.all(minimumPadding / 2),
                          child: new Image.asset(
                            'images/colored_biscuit.png',
                          ),
                        ),
                      ),
                      onPressed: () {
                        if (type == PRODUCTION_REPORT) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BiscuitsProductionForm(),
                            ),
                          );
                        } else if (type == QFS_REPORT) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SupervisorQfsReport(
                                refNum: BISCUIT_AREA,
                              ),
                            ),
                          );
                        } else if (type == EHS_REPORT) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SupervisorEhsReport(
                                refNum: BISCUIT_AREA,
                              ),
                            ),
                          );
                        } else if (type == OVERWEIGHT_REPORT) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  SupervisorOverWeightReportForm(
                                refNum: BISCUIT_AREA,
                              ),
                            ),
                          );
                        } else if (type == PEOPLE_REPORT) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SupervisorPeopleReportForm(
                                refNum: BISCUIT_AREA,
                              ),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(minimumPadding),
              child: Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(BoxImageBorder),
                  child: ConstrainedBox(
                    constraints: BoxConstraints.tightFor(
                        width: TightBoxWidth, height: LargeBoxHeight),
                    child: ElevatedButton.icon(
                      label: Text('Wafer\nالويفر'),
                      style: ElevatedButton.styleFrom(
                        textStyle: TextStyle(
                            fontSize: largeButtonFont, fontFamily: 'MyFont'),
                        primary: KelloggColors.green,
                      ),
                      icon: ClipRRect(
                        borderRadius: BorderRadius.circular(iconImageBorder),
                        child: Container(
                          height: mediumIconSize,
                          width: mediumIconSize,
                          padding: EdgeInsets.all(minimumPadding / 2),
                          child: new Image.asset(
                            'images/colored_wafer.png',
                          ),
                        ),
                      ),
                      onPressed: () {
                        if (type == PRODUCTION_REPORT) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => WaferProductionForm(),
                            ),
                          );
                        } else if (type == QFS_REPORT) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SupervisorQfsReport(
                                refNum: WAFER_AREA,
                              ),
                            ),
                          );
                        } else if (type == EHS_REPORT) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SupervisorEhsReport(
                                refNum: WAFER_AREA,
                              ),
                            ),
                          );
                        } else if (type == OVERWEIGHT_REPORT) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  SupervisorOverWeightReportForm(
                                refNum: WAFER_AREA,
                              ),
                            ),
                          );
                        } else if (type == PEOPLE_REPORT) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SupervisorPeopleReportForm(
                                refNum: WAFER_AREA,
                              ),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(minimumPadding),
              child: Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(BoxImageBorder),
                  child: ConstrainedBox(
                    constraints: BoxConstraints.tightFor(
                        width: TightBoxWidth, height: LargeBoxHeight),
                    child: ElevatedButton.icon(
                      label: Text('Maamoul\nالمعمول'),
                      style: ElevatedButton.styleFrom(
                        textStyle: TextStyle(
                            fontSize: largeButtonFont, fontFamily: 'MyFont'),
                        padding: EdgeInsets.symmetric(
                            horizontal: defaultPadding,
                            vertical: minimumPadding),
                        primary: KelloggColors.cockRed,
                      ),
                      icon: ClipRRect(
                        borderRadius: BorderRadius.circular(iconImageBorder),
                        child: Container(
                          height: mediumIconSize,
                          width: mediumIconSize,
                          padding: EdgeInsets.all(minimumPadding / 2),
                          child: new Image.asset(
                            'images/colored_maamoul.png',
                          ),
                        ),
                      ),
                      onPressed: () {
                        if (type == PRODUCTION_REPORT) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MaamoulProductionForm(),
                            ),
                          );
                        } else if (type == QFS_REPORT) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SupervisorQfsReport(
                                refNum: MAAMOUL_AREA,
                              ),
                            ),
                          );
                        } else if (type == EHS_REPORT) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SupervisorEhsReport(
                                refNum: MAAMOUL_AREA,
                              ),
                            ),
                          );
                        } else if (type == OVERWEIGHT_REPORT) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  SupervisorOverWeightReportForm(
                                refNum: MAAMOUL_AREA,
                              ),
                            ),
                          );
                        } else if (type == PEOPLE_REPORT) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SupervisorPeopleReportForm(
                                refNum: MAAMOUL_AREA,
                              ),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
