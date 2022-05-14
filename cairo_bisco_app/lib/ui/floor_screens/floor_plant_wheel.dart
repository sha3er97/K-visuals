import 'dart:async';

import 'package:cairo_bisco_app/classes/BiscuitsReport.dart';
import 'package:cairo_bisco_app/classes/EhsReport.dart';
import 'package:cairo_bisco_app/classes/MaamoulReport.dart';
import 'package:cairo_bisco_app/classes/MiniProductionReport.dart';
import 'package:cairo_bisco_app/classes/NRCReport.dart';
import 'package:cairo_bisco_app/classes/OverWeightReport.dart';
import 'package:cairo_bisco_app/classes/PeopleReport.dart';
import 'package:cairo_bisco_app/classes/QfsReport.dart';
import 'package:cairo_bisco_app/classes/WaferReport.dart';
import 'package:cairo_bisco_app/classes/utility_funcs/calculations_utility.dart';
import 'package:cairo_bisco_app/classes/utility_funcs/date_time_utility.dart';
import 'package:cairo_bisco_app/classes/values/TextStandards.dart';
import 'package:cairo_bisco_app/classes/values/colors.dart';
import 'package:cairo_bisco_app/classes/values/constants.dart';
import 'package:cairo_bisco_app/components/qfs_ehs_wigdets/6kpis_good_bad_indicator.dart';
import 'package:cairo_bisco_app/ui/error_success_screens/loading_screen.dart';
import 'package:cairo_bisco_app/ui/floor_screens/floor_dashboard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../classes/DownTimeReport.dart';

class FloorPlantWheel extends StatefulWidget {
  FloorPlantWheel({
    Key? key,
    required this.type,
    required this.lineNum,
  }) : super(key: key);
  final int lineNum;
  final String type;

  @override
  _FloorPlantWheelState createState() =>
      _FloorPlantWheelState(type: type, lineNum: lineNum);
}

class _FloorPlantWheelState extends State<FloorPlantWheel> {
  _FloorPlantWheelState({
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
  final nrcReportRef = FirebaseFirestore.instance
      .collection(factory_name)
      .doc('nrc_reports')
      .collection(getYear())
      .withConverter<NRCReport>(
        fromFirestore: (snapshot, _) => NRCReport.fromJson(snapshot.data()!),
        toFirestore: (report, _) => report.toJson(),
      );
  final peopleReportRef = FirebaseFirestore.instance
      .collection(factory_name)
      .doc('people_reports')
      .collection(getYear())
      .withConverter<PeopleReport>(
        fromFirestore: (snapshot, _) => PeopleReport.fromJson(snapshot.data()!),
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
        Duration(seconds: floorScreenWheelDuration),
        () => {
              // Navigator.pop(context),
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => FloorDashBoard(
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                type,
                style: TextStyle(
                  color: KelloggColors.darkBlue,
                  fontSize: largeButtonFont,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(
              height: minimumPadding,
            ),
            Center(
              child: Text(
                lineNum == ALL_LINES ? 'اجمالي المنطقة' : ' $lineNum خط  ',
                style: TextStyle(
                  color: KelloggColors.darkRed,
                  fontSize: largeFontSize,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            // Center(
            //   child:
            FutureBuilder<QuerySnapshot>(
              future: productionRefs[refNum].get(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> productionSnapshot) {
                if (productionSnapshot.hasError) {
                  return ErrorMessageHeading('Something went wrong');
                } else if (productionSnapshot.connectionState ==
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
                                as List<QueryDocumentSnapshot<DownTimeReport>>;
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
                        return FutureBuilder<QuerySnapshot>(
                          future: overWeightReportRef.get(),
                          builder: (BuildContext context,
                              AsyncSnapshot<QuerySnapshot> overweightSnapshot) {
                            if (overweightSnapshot.hasError) {
                              return ErrorMessageHeading(
                                  'Something went wrong');
                            } else if (overweightSnapshot.connectionState ==
                                ConnectionState.waiting) {
                              return ColorLoader();
                            } else {
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
                                          QueryDocumentSnapshot<
                                              BiscuitsReport>>;
                                  temp_report = BiscuitsReport
                                      .getFilteredReportOfInterval(
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
                              return FutureBuilder<QuerySnapshot>(
                                future: qualityReportRef.get(),
                                builder: (BuildContext context,
                                    AsyncSnapshot<QuerySnapshot>
                                        qualitySnapshot) {
                                  if (qualitySnapshot.hasError) {
                                    return ErrorMessageHeading(
                                        'Something went wrong');
                                  } else if (qualitySnapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return ColorLoader();
                                  } else {
                                    List<QueryDocumentSnapshot<QfsReport>>
                                        reportsList =
                                        qualitySnapshot.data!.docs as List<
                                            QueryDocumentSnapshot<QfsReport>>;
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
                                    return FutureBuilder<QuerySnapshot>(
                                      future: ehsReportRef.get(),
                                      builder: (BuildContext context,
                                          AsyncSnapshot<QuerySnapshot>
                                              ehsSnapshot) {
                                        if (ehsSnapshot.hasError) {
                                          return ErrorMessageHeading(
                                              'Something went wrong');
                                        } else if (ehsSnapshot
                                                .connectionState ==
                                            ConnectionState.waiting) {
                                          return ColorLoader();
                                        } else {
                                          List<QueryDocumentSnapshot<EhsReport>>
                                              reportsList =
                                              ehsSnapshot.data!.docs as List<
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
                                          return FutureBuilder<QuerySnapshot>(
                                            future: peopleReportRef.get(),
                                            builder: (BuildContext context,
                                                AsyncSnapshot<QuerySnapshot>
                                                    peopleSnapshot) {
                                              if (peopleSnapshot.hasError) {
                                                return ErrorMessageHeading(
                                                    'Something went wrong');
                                              } else if (peopleSnapshot
                                                      .connectionState ==
                                                  ConnectionState.waiting) {
                                                return ColorLoader();
                                              } else {
                                                List<
                                                        QueryDocumentSnapshot<
                                                            PeopleReport>>
                                                    reportsList =
                                                    peopleSnapshot.data!.docs
                                                        as List<
                                                            QueryDocumentSnapshot<
                                                                PeopleReport>>;
                                                PeopleReport temp_people =
                                                    PeopleReport
                                                        .getFilteredReportOfInterval(
                                                  reportsList,
                                                  int.parse(getMonth()),
                                                  int.parse(getMonth()),
                                                  int.parse(getDay()),
                                                  int.parse(getDay()),
                                                  int.parse(getYear()),
                                                  prodType.indexOf(type),
                                                );
                                                return FutureBuilder<
                                                    QuerySnapshot>(
                                                  future: nrcReportRef.get(),
                                                  builder:
                                                      (BuildContext context,
                                                          AsyncSnapshot<
                                                                  QuerySnapshot>
                                                              nrcSnapshot) {
                                                    if (nrcSnapshot.hasError) {
                                                      return ErrorMessageHeading(
                                                          'Something went wrong');
                                                    } else if (nrcSnapshot
                                                            .connectionState ==
                                                        ConnectionState
                                                            .waiting) {
                                                      return ColorLoader();
                                                    } else {
                                                      List<
                                                              QueryDocumentSnapshot<
                                                                  NRCReport>>
                                                          nrcReportsList =
                                                          nrcSnapshot.data!.docs
                                                              as List<
                                                                  QueryDocumentSnapshot<
                                                                      NRCReport>>;
                                                      NRCReport temp_nrc = NRCReport
                                                          .getFilteredReportOfInterval(
                                                        nrcReportsList,
                                                        int.parse(getMonth()),
                                                        int.parse(getMonth()),
                                                        int.parse(getDay()),
                                                        int.parse(getDay()),
                                                        int.parse(getYear()),
                                                        prodType.indexOf(type),
                                                      );

                                                      //plant wheel body
                                                      return KPI6GoodBadIndicator(
                                                        color1: BadQFSDriver(
                                                                temp_qfs)
                                                            ? KelloggColors
                                                                .cockRed
                                                            : KelloggColors
                                                                .green,
                                                        title1:
                                                            'الجودة و\nسلامة الغذاء',
                                                        color2: BadEHSDriver(
                                                                temp_ehs)
                                                            ? KelloggColors
                                                                .cockRed
                                                            : KelloggColors
                                                                .green,
                                                        title2:
                                                            'سلامة العاملين',
                                                        color3: BadProductionDriver(
                                                                temp_report,
                                                                temp_overweight
                                                                    .percent,
                                                                temp_wasted_minutes)
                                                            ? KelloggColors
                                                                .cockRed
                                                            : KelloggColors
                                                                .green,
                                                        title3: 'الانتاج',
                                                        color4: BadPeopleDriver(
                                                                temp_people)
                                                            ? KelloggColors
                                                                .cockRed
                                                            : KelloggColors
                                                                .green,
                                                        title4: 'العمالة',
                                                        color5: BadNRCDriver(
                                                                temp_nrc)
                                                            ? KelloggColors
                                                                .cockRed
                                                            : KelloggColors
                                                                .green,
                                                        title5:
                                                            'الموارد الطبيعية',
                                                        color6:
                                                            BadFinanceDriver(
                                                                    temp_report)
                                                                ? KelloggColors
                                                                    .cockRed
                                                                : KelloggColors
                                                                    .green,
                                                        title6: 'الاداء المالي',
                                                        isScreenOnly: true,
                                                      );
                                                    }
                                                  },
                                                );
                                              }
                                            },
                                          );
                                        }
                                      },
                                    );
                                  }
                                },
                              );
                            }
                          },
                        );
                      }
                    },
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
