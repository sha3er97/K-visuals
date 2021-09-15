import 'package:cairo_bisco_app/classes/EhsReport.dart';
import 'package:cairo_bisco_app/classes/QfsReport.dart';
import 'package:cairo_bisco_app/classes/utility_funcs/date_utility.dart';
import 'package:cairo_bisco_app/classes/values/TextStandards.dart';
import 'package:cairo_bisco_app/classes/values/colors.dart';
import 'package:cairo_bisco_app/classes/values/constants.dart';
import 'package:cairo_bisco_app/components/screen_widgets/ehs_column_screen.dart';
import 'package:cairo_bisco_app/components/screen_widgets/production_column_screen.dart';
import 'package:cairo_bisco_app/components/screen_widgets/qfs_column_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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

  final int lineNum; //=-1 at total
  final String type; // have the area name 'biscuits'
  String productName = 'MAMUL معمول';

  @override
  Widget build(BuildContext context) {
    final qualityReportRef = FirebaseFirestore.instance
        .collection(factory_name)
        .doc('quality_reports')
        .collection(getYear())
        .withConverter<QfsReport>(
          fromFirestore: (snapshot, _) => QfsReport.fromJson(snapshot.data()!),
          toFirestore: (report, _) => report.toJson(),
        );
    final ehsReportRef = FirebaseFirestore.instance
        .collection(factory_name)
        .doc('ehs_reports')
        .collection(getYear())
        .withConverter<EhsReport>(
          fromFirestore: (snapshot, _) => EhsReport.fromJson(snapshot.data()!),
          toFirestore: (report, _) => report.toJson(),
        );
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
                        // sectionTitle('الانتاج'),
                        Center(
                            child: ProductionColScreen(
                          cartons: 5.3,
                          targetProd: 5.5,
                          oee: 53.3,
                          scrap: 4.3,
                          prodType: type,
                          lineNum: lineNum,
                          productName: productName,
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
                    child: StreamBuilder<QuerySnapshot>(
                      stream: ehsReportRef.snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasError) {
                          return ErrorMessageHeading('Something went wrong');
                        } else if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return ErrorMessageHeading("Loading");
                        } else {
                          try {
                            List<QueryDocumentSnapshot<EhsReport>> reportsList =
                                snapshot.data!.docs
                                    as List<QueryDocumentSnapshot<EhsReport>>;
                            // print("ehs ::" + reportsList.length.toString());
                            EhsReport temp_ehs =
                                EhsReport.getFilteredReportOfInterval(
                                    reportsList,
                                    int.parse(getMonth()),
                                    int.parse(getMonth()),
                                    int.parse(getDay()),
                                    int.parse(getDay()),
                                    int.parse(getYear()),
                                    prodType.indexOf(type),
                                    lineNum);
                            return EHSColScreen(
                              recordable_incidents:
                                  temp_ehs.recordable_incidents,
                              firstAid_incidents: temp_ehs.firstAid_incidents,
                              nearMiss: temp_ehs.nearMiss,
                              filmWaste: 4.5,
                              productName: productName,
                            );
                          } catch (e) {
                            print(e);
                            return ErrorMessageHeading('Something went wrong');
                          }
                        }
                      },
                    ),
                  ),
                ),
                SizedBox(width: defaultPadding),
                Expanded(
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: minimumPadding),
                    child: StreamBuilder<QuerySnapshot>(
                      stream: qualityReportRef.snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasError) {
                          return ErrorMessageHeading('Something went wrong');
                        } else if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return ErrorMessageHeading('Loading');
                        } else {
                          try {
                            List<QueryDocumentSnapshot<QfsReport>> reportsList =
                                snapshot.data!.docs
                                    as List<QueryDocumentSnapshot<QfsReport>>;
                            // print("qfs ::" + reportsList.length.toString());
                            QfsReport temp_qfs =
                                QfsReport.getFilteredReportOfInterval(
                                    reportsList,
                                    int.parse(getMonth()),
                                    int.parse(getMonth()),
                                    int.parse(getDay()),
                                    int.parse(getDay()),
                                    int.parse(getYear()),
                                    prodType.indexOf(type),
                                    lineNum);
                            return QFSColScreen(
                              quality_incidents: temp_qfs.quality_incidents,
                              food_safety_incidents:
                                  temp_qfs.food_safety_incidents,
                              scrap: 5.3,
                              productName: productName,
                            );
                          } catch (e) {
                            print(e);
                            return ErrorMessageHeading('Something went wrong');
                          }
                        }
                      },
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
