import 'package:cairo_bisco_app/classes/values/colors.dart';
import 'package:cairo_bisco_app/classes/values/constants.dart';
import 'package:cairo_bisco_app/classes/values/form_values.dart';
import 'package:cairo_bisco_app/ui/supervisor_screens/supervisor_biscuits_production_form.dart';
import 'package:cairo_bisco_app/ui/supervisor_screens/supervisor_choose_dt_type.dart';
import 'package:cairo_bisco_app/ui/supervisor_screens/supervisor_ehs_report.dart';
import 'package:cairo_bisco_app/ui/supervisor_screens/supervisor_maamoul_production_form.dart';
import 'package:cairo_bisco_app/ui/supervisor_screens/supervisor_nrc_report.dart';
import 'package:cairo_bisco_app/ui/supervisor_screens/supervisor_overweight_report.dart';
import 'package:cairo_bisco_app/ui/supervisor_screens/supervisor_people_report.dart';
import 'package:cairo_bisco_app/ui/supervisor_screens/supervisor_qfs_report.dart';
import 'package:cairo_bisco_app/ui/supervisor_screens/supervisor_wafer_production_form.dart';
import 'package:flutter/material.dart';

class ReportItem extends StatelessWidget {
  ReportItem({
    required this.date,
    required this.supName,
    required this.line,
    required this.shift,
    required this.refNum,
    required this.type,
    required this.reportDetails,
    required this.reportID,
    // required this.param_onPressed,
    // required this.btn_icon,
    required this.rootCause,
  });

  final String date, supName, reportID, rootCause;
  final int line, shift, refNum, type;
  final dynamic reportDetails;

  // final VoidCallback param_onPressed;

  // final IconData btn_icon;

  @override
  Widget build(BuildContext context) {
    Color gradientColor1 = KelloggColors.getGradient1(type);
    Color gradientColor2 = KelloggColors.getGradient2(type);
    Color mainColor = KelloggColors.getBaseColor(type);
    return Padding(
      padding: const EdgeInsets.all(minimumPadding),
      child: Center(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(BoxImageBorder),
          child: ConstrainedBox(
            constraints: BoxConstraints.tightFor(
              width: TightBoxWidth,
              height: regularBoxHeight,
            ),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment(0.99, 0.0),
                  // 10% of the width, so there are ten blinds.
                  colors: [gradientColor1, gradientColor2],
                  // red to yellow
                  tileMode:
                      TileMode.repeated, // repeats the gradient over the canvas
                ),
              ),
              child: ElevatedButton(
                child: Text(
                  date +
                      '\n' +
                      supName +
                      (type == DOWNTIME_REPORT ? '\n' + rootCause : "") +
                      (line > -1 ? '\n' + prod_lines4[line] : "") +
                      (shift > -1 ? '\n' + shifts[shift] : ""),
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 5,
                  style: TextStyle(
                    fontSize: aboveMediumFontSize,
                    fontFamily: 'MyFont',
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(
                    horizontal: defaultPadding,
                    vertical: minimumPadding,
                  ),
                  primary: mainColor,
                ),
                onPressed: () {
                  switch (type) {
                    case PRODUCTION_REPORT:
                      switch (refNum) {
                        case BISCUIT_AREA:
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BiscuitsProductionForm(
                                reportDetails: reportDetails,
                                isEdit: true,
                                reportID: reportID,
                              ),
                            ),
                          );
                          break;
                        case WAFER_AREA:
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => WaferProductionForm(
                                reportDetails: reportDetails,
                                isEdit: true,
                                reportID: reportID,
                              ),
                            ),
                          );
                          break;
                        case MAAMOUL_AREA:
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MaamoulProductionForm(
                                reportDetails: reportDetails,
                                isEdit: true,
                                reportID: reportID,
                              ),
                            ),
                          );
                          break;
                      }
                      break;
                    case QFS_REPORT:
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SupervisorQfsReport(
                            refNum: refNum,
                            reportDetails: reportDetails,
                            isEdit: true,
                            reportID: reportID,
                          ),
                        ),
                      );
                      break;
                    case EHS_REPORT:
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SupervisorEhsReport(
                            refNum: refNum,
                            reportDetails: reportDetails,
                            isEdit: true,
                            reportID: reportID,
                          ),
                        ),
                      );
                      break;
                    case OVERWEIGHT_REPORT:
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SupervisorOverWeightReportForm(
                            refNum: refNum,
                            reportDetails: reportDetails,
                            isEdit: true,
                            reportID: reportID,
                          ),
                        ),
                      );
                      break;
                    case PEOPLE_REPORT:
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SupervisorPeopleReportForm(
                            refNum: refNum,
                            reportDetails: reportDetails,
                            isEdit: true,
                            reportID: reportID,
                          ),
                        ),
                      );
                      break;
                    case NRC_REPORT:
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SupervisorNRCReportForm(
                            refNum: refNum,
                            reportDetails: reportDetails,
                            isEdit: true,
                            reportID: reportID,
                          ),
                        ),
                      );
                      break;
                    case DOWNTIME_REPORT:
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SupervisorChooseDtType(
                            refNum: refNum,
                            reportDetails: reportDetails,
                            isEdit: true,
                            reportID: reportID,
                          ),
                        ),
                      );
                      break;
                  }
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
