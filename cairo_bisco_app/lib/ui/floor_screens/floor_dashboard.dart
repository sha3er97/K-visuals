import 'package:cairo_bisco_app/classes/QfsReport.dart';
import 'package:cairo_bisco_app/classes/values/colors.dart';
import 'package:cairo_bisco_app/classes/values/constants.dart';
import 'package:cairo_bisco_app/components/screen_widgets/ehs_column_screen.dart';
import 'package:cairo_bisco_app/components/screen_widgets/production_column_screen.dart';
import 'package:cairo_bisco_app/components/screen_widgets/qfs_column_screen.dart';
import 'package:cairo_bisco_app/components/utility_funcs/date_utility.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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

    bool isTotal = lineNum == -1;
    //TODO :: if is total add or average all targets
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
                    child: EHSColScreen(
                      recordable_incidents: 0,
                      firstAid_incidents: 1,
                      nearMiss: 0,
                      filmWaste: 4.5,
                      productName: productName,
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
                          return Text('Something went wrong');
                        } else if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Text("Loading");
                        } else {
                          List<QueryDocumentSnapshot<QfsReport>> reportsList =
                              snapshot.data!.docs
                                  as List<QueryDocumentSnapshot<QfsReport>>;
                          print(reportsList.length);
                          try {
                            QfsReport temp_qfs =
                                QfsReport.getFilteredReportOfDay(
                                    reportsList,
                                    int.parse(getMonth()),
                                    int.parse(getMonth()),
                                    int.parse(getDay()),
                                    int.parse(getDay()),
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
                            return Text('Something went wrong');
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
