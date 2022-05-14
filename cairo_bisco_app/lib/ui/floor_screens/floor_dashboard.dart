import 'dart:async';

import 'package:cairo_bisco_app/classes/BiscuitsReport.dart';
import 'package:cairo_bisco_app/classes/EhsReport.dart';
import 'package:cairo_bisco_app/classes/MaamoulReport.dart';
import 'package:cairo_bisco_app/classes/MiniProductionReport.dart';
import 'package:cairo_bisco_app/classes/OverWeightReport.dart';
import 'package:cairo_bisco_app/classes/QfsReport.dart';
import 'package:cairo_bisco_app/classes/WaferReport.dart';
import 'package:cairo_bisco_app/classes/utility_funcs/date_time_utility.dart';
import 'package:cairo_bisco_app/classes/values/TextStandards.dart';
import 'package:cairo_bisco_app/classes/values/colors.dart';
import 'package:cairo_bisco_app/classes/values/constants.dart';
import 'package:cairo_bisco_app/components/screen_widgets/ehs_column_screen.dart';
import 'package:cairo_bisco_app/components/screen_widgets/production_column_screen.dart';
import 'package:cairo_bisco_app/components/screen_widgets/qfs_column_screen.dart';
import 'package:cairo_bisco_app/ui/error_success_screens/loading_screen.dart';
import 'package:cairo_bisco_app/ui/floor_screens/floor_plant_wheel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../classes/DownTimeReport.dart';

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
  final qualityReportRef = FirebaseFirestore.instance
      .collection(factory_name)
      .doc('quality_reports')
      .collection(getYear())
      .withConverter<QfsReport>(
        fromFirestore: (snapshot, _) => QfsReport.fromJson(snapshot.data()!),
        toFirestore: (report, _) => report.toJson(),
      );
  final overWeightReportRef = FirebaseFirestore.instance
      .collection(factory_name)
      .doc('overWeight_reports')
      .collection(getYear())
      .withConverter<OverWeightReport>(
        fromFirestore: (OverWeightSnapshot, _) =>
            OverWeightReport.fromJson(OverWeightSnapshot.data()!),
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
  final biscuitsReportRef = FirebaseFirestore.instance
      .collection(factory_name)
      .doc('biscuits_reports')
      .collection(getYear())
      .withConverter<BiscuitsReport>(
        fromFirestore: (snapshot, _) =>
            BiscuitsReport.fromJson(snapshot.data()!),
        toFirestore: (report, _) => report.toJson(),
      );
  final waferReportRef = FirebaseFirestore.instance
      .collection(factory_name)
      .doc('wafer_reports')
      .collection(getYear())
      .withConverter<WaferReport>(
        fromFirestore: (snapshot, _) => WaferReport.fromJson(snapshot.data()!),
        toFirestore: (report, _) => report.toJson(),
      );
  final maamoulReportRef = FirebaseFirestore.instance
      .collection(factory_name)
      .doc('maamoul_reports')
      .collection(getYear())
      .withConverter<MaamoulReport>(
        fromFirestore: (snapshot, _) =>
            MaamoulReport.fromJson(snapshot.data()!),
        toFirestore: (report, _) => report.toJson(),
      );

  final downTimeReportRef = FirebaseFirestore.instance
      .collection(factory_name)
      .doc('downtime_reports')
      .collection(getYear())
      .withConverter<DownTimeReport>(
        fromFirestore: (snapshot, _) =>
            DownTimeReport.fromJson(snapshot.data()!),
        toFirestore: (report, _) => report.toJson(),
      );

  @override
  Widget build(BuildContext context) {
    final productionRefs = [
      biscuitsReportRef,
      waferReportRef,
      maamoulReportRef
    ];
    final int refNum = prodType.indexOf(type);
    Timer(
        Duration(seconds: floorScreenDashBoardDuration),
        () => {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => FloorPlantWheel(
                    type: type,
                    lineNum: lineNum,
                  ),
                ),
              )
            });
    return Scaffold(
      backgroundColor: KelloggColors.white,
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: StreamBuilder<QuerySnapshot>(
            stream: productionRefs[refNum].snapshots(),
            builder: (BuildContext context,
                AsyncSnapshot<QuerySnapshot> productionSnapshot) {
              if (productionSnapshot.hasError) {
                return ErrorMessageHeading('Something went wrong');
              } else if (productionSnapshot.connectionState ==
                  ConnectionState.waiting) {
                return ColorLoader();
              } else {
                return FutureBuilder<QuerySnapshot>(
                  future: overWeightReportRef.get(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> overweightSnapshot) {
                    if (overweightSnapshot.hasError) {
                      return ErrorMessageHeading('Something went wrong');
                    } else if (overweightSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return ColorLoader();
                    } else {
                      return FutureBuilder<QuerySnapshot>(
                        future: downTimeReportRef.get(),
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> downTimeSnapshot) {
                          if (downTimeSnapshot.hasError) {
                            return ErrorMessageHeading('Something went wrong');
                          } else if (downTimeSnapshot.connectionState ==
                              ConnectionState.waiting) {
                            return ColorLoader();
                          } else {
                            List<QueryDocumentSnapshot<DownTimeReport>>
                                dtReportsList = downTimeSnapshot.data!.docs
                                    as List<
                                        QueryDocumentSnapshot<DownTimeReport>>;
                            int temp_wasted_minutes =
                                DownTimeReport.getWastedMinutesOfCriteria(
                              dtReportsList,
                              int.parse(getMonth()),
                              int.parse(getMonth()),
                              int.parse(getDay()),
                              int.parse(getDay()),
                              int.parse(getYear()),
                              prodType.indexOf(type),
                              lineNum,
                              ALL_SHIFTS,
                            );

                            List<QueryDocumentSnapshot<OverWeightReport>>
                                reportsList =
                                overweightSnapshot.data!.docs as List<
                                    QueryDocumentSnapshot<OverWeightReport>>;
                            OverWeightReport temp_overweight =
                                OverWeightReport.getFilteredReportOfInterval(
                                    reportsList,
                                    int.parse(getMonth()),
                                    int.parse(getMonth()),
                                    int.parse(getDay()),
                                    int.parse(getDay()),
                                    int.parse(getYear()),
                                    prodType.indexOf(type),
                                    lineNum);

                            List<OverWeightReport> overweightTempList =
                                OverWeightReport.getAllReportsOfInterval(
                              reportsList,
                              int.parse(getMonth()),
                              int.parse(getMonth()),
                              int.parse(getDay()),
                              int.parse(getDay()),
                              int.parse(getYear()),
                              refNum,
                            ).values.toList();

                            MiniProductionReport temp_report;
                            switch (refNum) {
                              case BISCUIT_AREA:
                                List<QueryDocumentSnapshot<BiscuitsReport>>
                                    biscuitsReportsList =
                                    productionSnapshot.data!.docs as List<
                                        QueryDocumentSnapshot<BiscuitsReport>>;
                                temp_report =
                                    BiscuitsReport.getFilteredReportOfInterval(
                                      biscuitsReportsList,
                                  int.parse(getMonth()),
                                  int.parse(getMonth()),
                                  int.parse(getDay()),
                                  int.parse(getDay()),
                                  int.parse(getYear()),
                                  lineNum,
                                  overweightTempList,
                                  dtReportsList,
                                );
                                break;
                              case WAFER_AREA:
                                List<QueryDocumentSnapshot<WaferReport>>
                                    waferReportsList =
                                    productionSnapshot.data!.docs as List<
                                        QueryDocumentSnapshot<WaferReport>>;
                                temp_report =
                                    WaferReport.getFilteredReportOfInterval(
                                      waferReportsList,
                                  int.parse(getMonth()),
                                  int.parse(getMonth()),
                                  int.parse(getDay()),
                                  int.parse(getDay()),
                                  int.parse(getYear()),
                                  lineNum,
                                  overweightTempList,
                                  dtReportsList,
                                );
                                break;
                              default: //case MAAMOUL_AREA :
                                List<QueryDocumentSnapshot<MaamoulReport>>
                                    maamoulReportsList =
                                    productionSnapshot.data!.docs as List<
                                        QueryDocumentSnapshot<MaamoulReport>>;
                                temp_report =
                                    MaamoulReport.getFilteredReportOfInterval(
                                      maamoulReportsList,
                                  int.parse(getMonth()),
                                  int.parse(getMonth()),
                                  int.parse(getDay()),
                                  int.parse(getDay()),
                                  int.parse(getYear()),
                                  lineNum,
                                  overweightTempList,
                                  dtReportsList,
                                );
                                break;
                            }
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: minimumPadding),
                                        child: Column(
                                          children: [
                                            // sectionTitle('الانتاج'),
                                            Center(
                                              child: ProductionColScreen(
                                                report: temp_report,
                                                prodType: type,
                                                lineNum: lineNum,
                                                overweight:
                                                    temp_overweight.percent,
                                                wastedMinutes:
                                                    temp_wasted_minutes,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: defaultPadding),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: minimumPadding),
                                        child: StreamBuilder<QuerySnapshot>(
                                          stream: ehsReportRef.snapshots(),
                                          builder: (BuildContext context,
                                              AsyncSnapshot<QuerySnapshot>
                                                  snapshot) {
                                            if (snapshot.hasError) {
                                              return ErrorMessageHeading(
                                                  'Something went wrong');
                                            } else if (snapshot
                                                    .connectionState ==
                                                ConnectionState.waiting) {
                                              return ColorLoader();
                                            } else {
                                              try {
                                                List<
                                                        QueryDocumentSnapshot<
                                                            EhsReport>>
                                                    reportsList =
                                                    snapshot.data!.docs as List<
                                                        QueryDocumentSnapshot<
                                                            EhsReport>>;
                                                EhsReport temp_ehs = EhsReport
                                                    .getFilteredReportOfInterval(
                                                        reportsList,
                                                        int.parse(getMonth()),
                                                        int.parse(getMonth()),
                                                        int.parse(getDay()),
                                                        int.parse(getDay()),
                                                        int.parse(getYear()),
                                                        prodType.indexOf(type),
                                                        lineNum);
                                                return EHSColScreen(
                                                  recordable_incidents: temp_ehs
                                                      .recordable_incidents,
                                                  firstAid_incidents: temp_ehs
                                                      .firstAid_incidents,
                                                  nearMiss: temp_ehs.nearMiss,
                                                  report: temp_report,
                                                );
                                              } catch (e) {
                                                print(e);
                                                return ErrorMessageHeading(
                                                    'Something went wrong');
                                              }
                                            }
                                          },
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: defaultPadding),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: minimumPadding),
                                        child: StreamBuilder<QuerySnapshot>(
                                          stream: qualityReportRef.snapshots(),
                                          builder: (BuildContext context,
                                              AsyncSnapshot<QuerySnapshot>
                                                  snapshot) {
                                            if (snapshot.hasError) {
                                              return ErrorMessageHeading(
                                                  'Something went wrong');
                                            } else if (snapshot
                                                    .connectionState ==
                                                ConnectionState.waiting) {
                                              return ErrorMessageHeading(
                                                  'Loading');
                                            } else {
                                              try {
                                                List<
                                                        QueryDocumentSnapshot<
                                                            QfsReport>>
                                                    reportsList =
                                                    snapshot.data!.docs as List<
                                                        QueryDocumentSnapshot<
                                                            QfsReport>>;
                                                QfsReport temp_qfs = QfsReport
                                                    .getFilteredReportOfInterval(
                                                        reportsList,
                                                        int.parse(getMonth()),
                                                        int.parse(getMonth()),
                                                        int.parse(getDay()),
                                                        int.parse(getDay()),
                                                        int.parse(getYear()),
                                                        prodType.indexOf(type),
                                                        lineNum);
                                                return QFSColScreen(
                                                  report: temp_report,
                                                  quality_incidents: temp_qfs
                                                      .quality_incidents,
                                                  food_safety_incidents: temp_qfs
                                                      .food_safety_incidents,
                                                  overweight:
                                                      temp_overweight.percent,
                                                );
                                              } catch (e) {
                                                print(e);
                                                return ErrorMessageHeading(
                                                    'Something went wrong');
                                              }
                                            }
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            );
                          }
                        },
                      );
                    }
                  },
                );
              }
            }),
      ),
    );
  }
}
