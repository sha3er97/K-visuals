/*
this screen will contain
1- navigation drawer (today production details/production in interval/QFS/EHS)
2 - Big title and today date
3 - today's numbers of the whole plant : production
4- qfs brief
5- ehs brief
 *********************************/
import 'package:cairo_bisco_app/classes/BiscuitsReport.dart';
import 'package:cairo_bisco_app/classes/EhsReport.dart';
import 'package:cairo_bisco_app/classes/MaamoulReport.dart';
import 'package:cairo_bisco_app/classes/MiniProductionReport.dart';
import 'package:cairo_bisco_app/classes/Plans.dart';
import 'package:cairo_bisco_app/classes/QfsReport.dart';
import 'package:cairo_bisco_app/classes/WaferReport.dart';
import 'package:cairo_bisco_app/classes/utility_funcs/calculations_utility.dart';
import 'package:cairo_bisco_app/classes/utility_funcs/date_utility.dart';
import 'package:cairo_bisco_app/classes/values/TextStandards.dart';
import 'package:cairo_bisco_app/classes/values/colors.dart';
import 'package:cairo_bisco_app/classes/values/constants.dart';
import 'package:cairo_bisco_app/components/production_widgets/chart.dart';
import 'package:cairo_bisco_app/components/production_widgets/production_info_card.dart';
import 'package:cairo_bisco_app/components/qfs_ehs_wigdets/6kpis_good_bad_indicator.dart';
import 'package:cairo_bisco_app/components/special_components/side_menu.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

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

  int days_in_interval = 1; //screen shows 1 day only

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KelloggColors.white,
      key: _scaffoldKey,
      drawer: SideMenu(),
      appBar: new AppBar(
        backgroundColor: KelloggColors.white.withOpacity(0),
        shadowColor: KelloggColors.white.withOpacity(0),
        leading: new IconButton(
          icon: new Icon(
            Icons.menu,
            color: KelloggColors.darkRed,
          ),
          onPressed: () => _scaffoldKey.currentState!.openDrawer(),
        ),
      ),
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: subHeading('Plant overview'),
            ),
            Center(child: smallerHeading(todayDateText())),
            SizedBox(height: defaultPadding),
            sectionTitle('Production'),
            FutureBuilder<QuerySnapshot>(
                future: biscuitsReportRef.get(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> biscuitsSnapshot) {
                  if (biscuitsSnapshot.hasError) {
                    return ErrorMessageHeading('Something went wrong');
                  } else if (biscuitsSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return ErrorMessageHeading("Loading");
                  } else {
                    return FutureBuilder<QuerySnapshot>(
                        future: waferReportRef.get(),
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> waferSnapshot) {
                          if (waferSnapshot.hasError) {
                            return ErrorMessageHeading('Something went wrong');
                          } else if (waferSnapshot.connectionState ==
                              ConnectionState.waiting) {
                            return ErrorMessageHeading("Loading");
                          } else {
                            return FutureBuilder<QuerySnapshot>(
                                future: maamoulReportRef.get(),
                                builder: (BuildContext context,
                                    AsyncSnapshot<QuerySnapshot>
                                        maamoulSnapshot) {
                                  if (maamoulSnapshot.hasError) {
                                    return ErrorMessageHeading(
                                        'Something went wrong');
                                  } else if (maamoulSnapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return ErrorMessageHeading("Loading");
                                  } else {
                                    List<QueryDocumentSnapshot<BiscuitsReport>>
                                        biscuitsReportsList =
                                        biscuitsSnapshot.data!.docs as List<
                                            QueryDocumentSnapshot<
                                                BiscuitsReport>>;
                                    MiniProductionReport temp_biscuit_report =
                                        BiscuitsReport
                                            .getFilteredReportOfInterval(
                                      biscuitsReportsList,
                                      int.parse(getMonth()),
                                      int.parse(getMonth()),
                                      int.parse(getDay()),
                                      int.parse(getDay()),
                                      int.parse(getYear()),
                                      -1,
                                    );
                                    List<QueryDocumentSnapshot<WaferReport>>
                                        waferReportsList =
                                        waferSnapshot.data!.docs as List<
                                            QueryDocumentSnapshot<WaferReport>>;
                                    MiniProductionReport temp_wafer_report =
                                        WaferReport.getFilteredReportOfInterval(
                                      waferReportsList,
                                      int.parse(getMonth()),
                                      int.parse(getMonth()),
                                      int.parse(getDay()),
                                      int.parse(getDay()),
                                      int.parse(getYear()),
                                      -1,
                                    );
                                    List<QueryDocumentSnapshot<MaamoulReport>>
                                        maamoulReportsList =
                                        maamoulSnapshot.data!.docs as List<
                                            QueryDocumentSnapshot<
                                                MaamoulReport>>;
                                    MiniProductionReport temp_maamoul_report =
                                        MaamoulReport
                                            .getFilteredReportOfInterval(
                                      maamoulReportsList,
                                      int.parse(getMonth()),
                                      int.parse(getMonth()),
                                      int.parse(getDay()),
                                      int.parse(getDay()),
                                      int.parse(getYear()),
                                      -1,
                                    );
                                    return Chart(
                                      biscuits:
                                          temp_biscuit_report.productionInKg,
                                      wafer: temp_wafer_report.productionInKg,
                                      maamoul:
                                          temp_maamoul_report.productionInKg,
                                      other: temp_biscuit_report.scrap +
                                          temp_biscuit_report.rework +
                                          temp_wafer_report.scrap +
                                          temp_wafer_report.rework +
                                          temp_maamoul_report.scrap +
                                          temp_maamoul_report.rework,
                                    );
                                  }
                                });
                          }
                        });
                  }
                }),
            /////////////////////////////////////////////////////////////////////////
            FutureBuilder<QuerySnapshot>(
              future: biscuitsReportRef.get(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return ErrorMessageHeading('Something went wrong');
                } else if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return ErrorMessageHeading("Loading");
                } else {
                  try {
                    List<QueryDocumentSnapshot<BiscuitsReport>> reportsList =
                        snapshot.data!.docs
                            as List<QueryDocumentSnapshot<BiscuitsReport>>;
                    MiniProductionReport temp_report =
                        BiscuitsReport.getFilteredReportOfInterval(
                      reportsList,
                      int.parse(getMonth()),
                      int.parse(getMonth()),
                      int.parse(getDay()),
                      int.parse(getDay()),
                      int.parse(getYear()),
                      -1,
                    );
                    // setState(() {
                    // biscuitsKg = temp_report.productionInKg;
                    // biscuitsCartons = temp_report.productionInCartons;
                    // biscuitsNonProducts =
                    //     temp_report.rework + temp_report.scrap;
                    // });
                    return ProductionInfoCard(
                      image: "colored_biscuit",
                      title: "Biscuits",
                      background: KelloggColors.yellow,
                      amountInKgs: temp_report.productionInKg,
                      numOfCartons: temp_report.productionInCartons,
                    );
                  } catch (e) {
                    print(e);
                    return ErrorMessageHeading('Something went wrong');
                  }
                }
              },
            ),
            FutureBuilder<QuerySnapshot>(
              future: waferReportRef.get(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return ErrorMessageHeading('Something went wrong');
                } else if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return ErrorMessageHeading("Loading");
                } else {
                  try {
                    List<QueryDocumentSnapshot<WaferReport>> reportsList =
                        snapshot.data!.docs
                            as List<QueryDocumentSnapshot<WaferReport>>;
                    MiniProductionReport temp_report =
                        WaferReport.getFilteredReportOfInterval(
                      reportsList,
                      int.parse(getMonth()),
                      int.parse(getMonth()),
                      int.parse(getDay()),
                      int.parse(getDay()),
                      int.parse(getYear()),
                      -1,
                    );
                    // setState(() {
                    // waferKg = temp_report.productionInKg;
                    // waferCartons = temp_report.productionInCartons;
                    // waferNonProducts =
                    //     temp_report.rework + temp_report.scrap;
                    // });
                    return ProductionInfoCard(
                      image: "colored_wafer",
                      title: "Wafer",
                      background: KelloggColors.green,
                      amountInKgs: temp_report.productionInKg,
                      numOfCartons: temp_report.productionInCartons,
                    );
                  } catch (e) {
                    print(e);
                    return ErrorMessageHeading('Something went wrong');
                  }
                }
              },
            ),
            FutureBuilder<QuerySnapshot>(
              future: maamoulReportRef.get(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return ErrorMessageHeading('Something went wrong');
                } else if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return ErrorMessageHeading("Loading");
                } else {
                  try {
                    List<QueryDocumentSnapshot<MaamoulReport>> reportsList =
                        snapshot.data!.docs
                            as List<QueryDocumentSnapshot<MaamoulReport>>;
                    MiniProductionReport temp_report =
                        MaamoulReport.getFilteredReportOfInterval(
                      reportsList,
                      int.parse(getMonth()),
                      int.parse(getMonth()),
                      int.parse(getDay()),
                      int.parse(getDay()),
                      int.parse(getYear()),
                      -1,
                    );
                    // setState(() {
                    // maamoulKg = temp_report.productionInKg;
                    // maamoulCartons = temp_report.productionInCartons;
                    // maamoulNonProducts =
                    //     temp_report.rework + temp_report.scrap;
                    // });
                    return ProductionInfoCard(
                      image: "colored_maamoul",
                      title: "Maamoul",
                      background: KelloggColors.cockRed,
                      amountInKgs: temp_report.productionInKg,
                      numOfCartons: temp_report.productionInCartons,
                    );
                  } catch (e) {
                    print(e);
                    return ErrorMessageHeading('Something went wrong');
                  }
                }
              },
            ),
            ///////////////////////////////////////////////////////////////////
            FutureBuilder<QuerySnapshot>(
                future: biscuitsReportRef.get(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> biscuitsSnapshot) {
                  if (biscuitsSnapshot.hasError) {
                    return ErrorMessageHeading('Something went wrong');
                  } else if (biscuitsSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return ErrorMessageHeading("Loading");
                  } else {
                    return FutureBuilder<QuerySnapshot>(
                        future: waferReportRef.get(),
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> waferSnapshot) {
                          if (waferSnapshot.hasError) {
                            return ErrorMessageHeading('Something went wrong');
                          } else if (waferSnapshot.connectionState ==
                              ConnectionState.waiting) {
                            return ErrorMessageHeading("Loading");
                          } else {
                            return FutureBuilder<QuerySnapshot>(
                                future: maamoulReportRef.get(),
                                builder: (BuildContext context,
                                    AsyncSnapshot<QuerySnapshot>
                                        maamoulSnapshot) {
                                  if (maamoulSnapshot.hasError) {
                                    return ErrorMessageHeading(
                                        'Something went wrong');
                                  } else if (maamoulSnapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return ErrorMessageHeading("Loading");
                                  } else {
                                    List<QueryDocumentSnapshot<BiscuitsReport>>
                                        biscuitsReportsList =
                                        biscuitsSnapshot.data!.docs as List<
                                            QueryDocumentSnapshot<
                                                BiscuitsReport>>;
                                    MiniProductionReport temp_biscuit_report =
                                        BiscuitsReport
                                            .getFilteredReportOfInterval(
                                      biscuitsReportsList,
                                      int.parse(getMonth()),
                                      int.parse(getMonth()),
                                      int.parse(getDay()),
                                      int.parse(getDay()),
                                      int.parse(getYear()),
                                      -1,
                                    );
                                    List<QueryDocumentSnapshot<WaferReport>>
                                        waferReportsList =
                                        waferSnapshot.data!.docs as List<
                                            QueryDocumentSnapshot<WaferReport>>;
                                    MiniProductionReport temp_wafer_report =
                                        WaferReport.getFilteredReportOfInterval(
                                      waferReportsList,
                                      int.parse(getMonth()),
                                      int.parse(getMonth()),
                                      int.parse(getDay()),
                                      int.parse(getDay()),
                                      int.parse(getYear()),
                                      -1,
                                    );
                                    List<QueryDocumentSnapshot<MaamoulReport>>
                                        maamoulReportsList =
                                        maamoulSnapshot.data!.docs as List<
                                            QueryDocumentSnapshot<
                                                MaamoulReport>>;
                                    MiniProductionReport temp_maamoul_report =
                                        MaamoulReport
                                            .getFilteredReportOfInterval(
                                      maamoulReportsList,
                                      int.parse(getMonth()),
                                      int.parse(getMonth()),
                                      int.parse(getDay()),
                                      int.parse(getDay()),
                                      int.parse(getYear()),
                                      -1,
                                    );
                                    return ProductionInfoCard(
                                      image: "recycle",
                                      title: "Scrap and rework",
                                      background: KelloggColors.white,
                                      amountInKgs: temp_biscuit_report.scrap +
                                          temp_biscuit_report.rework +
                                          temp_wafer_report.scrap +
                                          temp_wafer_report.rework +
                                          temp_maamoul_report.scrap +
                                          temp_maamoul_report.rework,
                                      numOfCartons: -1,
                                    );
                                  }
                                });
                          }
                        });
                  }
                }),
            //////////////////////////////////////////////////////////////////
            sectionTitle('QFS'),
            FutureBuilder<QuerySnapshot>(
              future: qualityReportRef.get(),
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
                    QfsReport temp_qfs = QfsReport.getFilteredReportOfInterval(
                        reportsList,
                        int.parse(getMonth()),
                        int.parse(getMonth()),
                        int.parse(getDay()),
                        int.parse(getDay()),
                        int.parse(getYear()),
                        -1,
                        -1);
                    return KPI6GoodBadIndicator(
                      isScreenOnly: false,
                      color1: temp_qfs.quality_incidents > 0
                          ? KelloggColors.cockRed
                          : KelloggColors.green,
                      title1: 'Quality\nIncidents',
                      color2: temp_qfs.food_safety_incidents > 0
                          ? KelloggColors.cockRed
                          : KelloggColors.green,
                      title2: 'Food Safety\nIncidents',
                      color3: temp_qfs.ccp_failure > 0
                          ? KelloggColors.cockRed
                          : KelloggColors.green,
                      title3: 'CCP\nFailures',
                      color4: temp_qfs.pes_index == 2
                          ? KelloggColors.cockRed
                          : temp_qfs.pes_index == 1
                              ? KelloggColors.yellow
                              : KelloggColors.green,
                      title4: 'PES\n(B&C Defects)',
                      color5: temp_qfs.consumer_complaints > 0
                          ? KelloggColors.cockRed
                          : KelloggColors.green,
                      title5: 'Consumer\nComplaints',
                      color6: temp_qfs.g6_index == 2
                          ? KelloggColors.cockRed
                          : temp_qfs.g6_index == 1
                              ? KelloggColors.yellow
                              : KelloggColors.green,
                      title6: 'G6 Escalation',
                    );
                  } catch (e) {
                    print(e);
                    return ErrorMessageHeading('Something went wrong');
                  }
                }
              },
            ),
            sectionTitle('EHS'),
            FutureBuilder<QuerySnapshot>(
              future: ehsReportRef.get(),
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
                    EhsReport temp_ehs = EhsReport.getFilteredReportOfInterval(
                        reportsList,
                        int.parse(getMonth()),
                        int.parse(getMonth()),
                        int.parse(getDay()),
                        int.parse(getDay()),
                        int.parse(getYear()),
                        -1,
                        -1);
                    return KPI6GoodBadIndicator(
                      isScreenOnly: false,
                      color1: temp_ehs.firstAid_incidents > 0
                          ? KelloggColors.cockRed
                          : KelloggColors.green,
                      title1: 'First Aid\nIncidents',
                      color2: temp_ehs.lostTime_incidents > 0
                          ? KelloggColors.cockRed
                          : KelloggColors.green,
                      title2: 'Lost Time\nIncidents',
                      color3: temp_ehs.recordable_incidents > 0
                          ? KelloggColors.cockRed
                          : KelloggColors.green,
                      title3: 'Recordable\nIncidents',
                      color4: BadNearMissIndicator(
                              temp_ehs.nearMiss, days_in_interval)
                          ? KelloggColors.cockRed
                          : KelloggColors.green,
                      title4: 'Near Miss',
                      color5: temp_ehs.risk_assessment > Plans.highRisksBoundary
                          ? KelloggColors.cockRed
                          : temp_ehs.risk_assessment > Plans.mediumRisksBoundary
                              ? KelloggColors.yellow
                              : KelloggColors.green,
                      title5: 'pre-shift\nRisk\nAssessment',
                      color6: temp_ehs.s7_index == 1
                          ? KelloggColors.cockRed
                          : KelloggColors.green,
                      title6: 'S7 Tours',
                    );
                  } catch (e) {
                    print(e);
                    return ErrorMessageHeading('Something went wrong');
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
