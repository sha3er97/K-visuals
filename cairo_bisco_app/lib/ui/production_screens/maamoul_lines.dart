import 'package:cairo_bisco_app/classes/MaamoulReport.dart';
import 'package:cairo_bisco_app/classes/MiniProductionReport.dart';
import 'package:cairo_bisco_app/classes/OverWeightReport.dart';
import 'package:cairo_bisco_app/classes/values/TextStandards.dart';
import 'package:cairo_bisco_app/classes/values/colors.dart';
import 'package:cairo_bisco_app/classes/values/constants.dart';
import 'package:cairo_bisco_app/components/production_widgets/scroll_production_line.dart';
import 'package:cairo_bisco_app/ui/error_success_screens/loading_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import '../../classes/DownTimeReport.dart';

class MaamoulLines extends StatefulWidget {
  MaamoulLines({
    Key? key,
    required this.from_day,
    required this.to_day,
    required this.from_month,
    required this.to_month,
    required this.chosenYear,
  }) : super(key: key);
  final String from_day, to_day, from_month, to_month, chosenYear;

  @override
  _MaamoulLinesState createState() => _MaamoulLinesState(
        from_day: from_day,
        to_day: to_day,
        from_month: from_month,
        to_month: to_month,
        chosenYear: chosenYear,
      );
}

class _MaamoulLinesState extends State<MaamoulLines> {
  _MaamoulLinesState({
    required this.from_day,
    required this.to_day,
    required this.from_month,
    required this.to_month,
    required this.chosenYear,
  });

  final String from_day, to_day, from_month, to_month, chosenYear;

  @override
  Widget build(BuildContext context) {
    final maamoulReportRef = FirebaseFirestore.instance
        .collection(factory_name)
        .doc('maamoul_reports')
        .collection(chosenYear)
        .withConverter<MaamoulReport>(
          fromFirestore: (snapshot, _) =>
              MaamoulReport.fromJson(snapshot.data()!),
          toFirestore: (report, _) => report.toJson(),
        );
    final overWeightReportRef = FirebaseFirestore.instance
        .collection(factory_name)
        .doc('overWeight_reports')
        .collection(chosenYear)
        .withConverter<OverWeightReport>(
          fromFirestore: (snapshot, _) =>
              OverWeightReport.fromJson(snapshot.data()!),
          toFirestore: (report, _) => report.toJson(),
        );
    final downTimeReportRef = FirebaseFirestore.instance
        .collection(factory_name)
        .doc('downtime_reports')
        .collection(chosenYear)
        .withConverter<DownTimeReport>(
          fromFirestore: (snapshot, _) =>
              DownTimeReport.fromJson(snapshot.data()!),
          toFirestore: (report, _) => report.toJson(),
        );
    return DefaultTabController(
      // The number of tabs / content sections to display.
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: KelloggColors.darkRed,
          bottom: TabBar(
            tabs: [
              Tab(
                // icon: Icon(Icons.directions_car),
                text: "Line 1",
              ),
              Tab(
                // icon: Icon(Icons.directions_car),
                text: "Line 2",
              ),
              Tab(
                // icon: Icon(Icons.directions_car),
                text: "Total",
              ),
              Tab(
                icon: Icon(
                  Icons.web,
                ),
                text: "WebView",
              ),
            ],
          ),
        ),
        resizeToAvoidBottomInset: true,
        backgroundColor: KelloggColors.white,
        body: TabBarView(
          children: [
            SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FutureBuilder<QuerySnapshot>(
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
                                  AsyncSnapshot<QuerySnapshot>
                                      downTimeSnapshot) {
                                if (downTimeSnapshot.hasError) {
                                  return ErrorMessageHeading(
                                      'Something went wrong');
                                } else if (downTimeSnapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return ColorLoader();
                                } else {
                                  List<QueryDocumentSnapshot<OverWeightReport>>
                                      reportsList =
                                      overweightSnapshot.data!.docs as List<
                                          QueryDocumentSnapshot<
                                              OverWeightReport>>;
                                  OverWeightReport temp_overweight_report =
                                      OverWeightReport
                                          .getFilteredReportOfInterval(
                                    reportsList,
                                    int.parse(from_month),
                                    int.parse(to_month),
                                    int.parse(from_day),
                                    int.parse(to_day),
                                    int.parse(chosenYear),
                                    MAAMOUL_AREA,
                                    1,
                                  );
                                  List<OverWeightReport> overweightTempList =
                                      OverWeightReport.getAllReportsOfInterval(
                                    reportsList,
                                    int.parse(from_month),
                                    int.parse(to_month),
                                    int.parse(from_day),
                                    int.parse(to_day),
                                    int.parse(chosenYear),
                                    MAAMOUL_AREA,
                                  ).values.toList();
                                  return FutureBuilder<QuerySnapshot>(
                                    future: maamoulReportRef.get(),
                                    builder: (BuildContext context,
                                        AsyncSnapshot<QuerySnapshot>
                                            productionSnapshot) {
                                      if (productionSnapshot.hasError) {
                                        return ErrorMessageHeading(
                                            'Something went wrong');
                                      } else if (productionSnapshot
                                              .connectionState ==
                                          ConnectionState.waiting) {
                                        return ColorLoader();
                                      } else {
                                        try {
                                          List<
                                                  QueryDocumentSnapshot<
                                                      DownTimeReport>>
                                              dtReportsList =
                                              downTimeSnapshot.data!.docs
                                                  as List<
                                                      QueryDocumentSnapshot<
                                                          DownTimeReport>>;
                                          int temp_wasted_minutes =
                                              DownTimeReport
                                                  .getWastedMinutesOfCriteria(
                                            dtReportsList,
                                            int.parse(from_month),
                                            int.parse(to_month),
                                            int.parse(from_day),
                                            int.parse(to_day),
                                            int.parse(chosenYear),
                                            MAAMOUL_AREA,
                                            1,
                                            ALL_SHIFTS,
                                          );
                                          List<
                                                  QueryDocumentSnapshot<
                                                      MaamoulReport>>
                                              reportsList =
                                              productionSnapshot.data!.docs
                                                  as List<
                                                      QueryDocumentSnapshot<
                                                          MaamoulReport>>;
                                          MiniProductionReport temp_report =
                                              MaamoulReport
                                                  .getFilteredReportOfInterval(
                                            reportsList,
                                            int.parse(from_month),
                                            int.parse(to_month),
                                            int.parse(from_day),
                                            int.parse(to_day),
                                            int.parse(chosenYear),
                                            1,
                                            overweightTempList,
                                            dtReportsList,
                                          );
                                          return Center(
                                            child: ProductionLine(
                                              report: temp_report,
                                              overweight: temp_overweight_report
                                                  .percent,
                                              isWebView: false,
                                              wastedMinutes:
                                                  temp_wasted_minutes,
                                            ),
                                          );
                                        } catch (e) {
                                          print(e);
                                          return ErrorMessageHeading(
                                              'Something went wrong');
                                        }
                                      }
                                    },
                                  );
                                }
                              });
                        }
                      }),
                ],
              ),
            ),
            SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FutureBuilder<QuerySnapshot>(
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
                                  AsyncSnapshot<QuerySnapshot>
                                      downTimeSnapshot) {
                                if (downTimeSnapshot.hasError) {
                                  return ErrorMessageHeading(
                                      'Something went wrong');
                                } else if (downTimeSnapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return ColorLoader();
                                } else {
                                  List<QueryDocumentSnapshot<DownTimeReport>>
                                      dtReportsList =
                                      downTimeSnapshot.data!.docs as List<
                                          QueryDocumentSnapshot<
                                              DownTimeReport>>;
                                  int temp_wasted_minutes =
                                      DownTimeReport.getWastedMinutesOfCriteria(
                                    dtReportsList,
                                    int.parse(from_month),
                                    int.parse(to_month),
                                    int.parse(from_day),
                                    int.parse(to_day),
                                    int.parse(chosenYear),
                                    MAAMOUL_AREA,
                                    2,
                                    ALL_SHIFTS,
                                  );
                                  List<QueryDocumentSnapshot<OverWeightReport>>
                                      reportsList =
                                      overweightSnapshot.data!.docs as List<
                                          QueryDocumentSnapshot<
                                              OverWeightReport>>;
                                  OverWeightReport temp_overweight_report =
                                      OverWeightReport
                                          .getFilteredReportOfInterval(
                                    reportsList,
                                    int.parse(from_month),
                                    int.parse(to_month),
                                    int.parse(from_day),
                                    int.parse(to_day),
                                    int.parse(chosenYear),
                                    MAAMOUL_AREA,
                                    2,
                                  );
                                  List<OverWeightReport> overweightTempList =
                                      OverWeightReport.getAllReportsOfInterval(
                                    reportsList,
                                    int.parse(from_month),
                                    int.parse(to_month),
                                    int.parse(from_day),
                                    int.parse(to_day),
                                    int.parse(chosenYear),
                                    MAAMOUL_AREA,
                                  ).values.toList();
                                  return FutureBuilder<QuerySnapshot>(
                                    future: maamoulReportRef.get(),
                                    builder: (BuildContext context,
                                        AsyncSnapshot<QuerySnapshot>
                                            productionSnapshot) {
                                      if (productionSnapshot.hasError) {
                                        return ErrorMessageHeading(
                                            'Something went wrong');
                                      } else if (productionSnapshot
                                              .connectionState ==
                                          ConnectionState.waiting) {
                                        return ColorLoader();
                                      } else {
                                        try {
                                          List<
                                                  QueryDocumentSnapshot<
                                                      MaamoulReport>>
                                              reportsList =
                                              productionSnapshot.data!.docs
                                                  as List<
                                                      QueryDocumentSnapshot<
                                                          MaamoulReport>>;
                                          MiniProductionReport temp_report =
                                              MaamoulReport
                                                  .getFilteredReportOfInterval(
                                            reportsList,
                                            int.parse(from_month),
                                            int.parse(to_month),
                                            int.parse(from_day),
                                            int.parse(to_day),
                                            int.parse(chosenYear),
                                            2,
                                            overweightTempList,
                                            dtReportsList,
                                          );
                                          return Center(
                                            child: ProductionLine(
                                              report: temp_report,
                                              overweight: temp_overweight_report
                                                  .percent,
                                              isWebView: false,
                                              wastedMinutes:
                                                  temp_wasted_minutes,
                                            ),
                                          );
                                        } catch (e) {
                                          print(e);
                                          return ErrorMessageHeading(
                                              'Something went wrong');
                                        }
                                      }
                                    },
                                  );
                                }
                              });
                        }
                      }),
                ],
              ),
            ),
            SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FutureBuilder<QuerySnapshot>(
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
                                  AsyncSnapshot<QuerySnapshot>
                                      downTimeSnapshot) {
                                if (downTimeSnapshot.hasError) {
                                  return ErrorMessageHeading(
                                      'Something went wrong');
                                } else if (downTimeSnapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return ColorLoader();
                                } else {
                                  List<QueryDocumentSnapshot<DownTimeReport>>
                                      dtReportsList =
                                      downTimeSnapshot.data!.docs as List<
                                          QueryDocumentSnapshot<
                                              DownTimeReport>>;
                                  int temp_wasted_minutes =
                                      DownTimeReport.getWastedMinutesOfCriteria(
                                    dtReportsList,
                                    int.parse(from_month),
                                    int.parse(to_month),
                                    int.parse(from_day),
                                    int.parse(to_day),
                                    int.parse(chosenYear),
                                    MAAMOUL_AREA,
                                    ALL_LINES,
                                    ALL_SHIFTS,
                                  );
                                  List<QueryDocumentSnapshot<OverWeightReport>>
                                      reportsList =
                                      overweightSnapshot.data!.docs as List<
                                          QueryDocumentSnapshot<
                                              OverWeightReport>>;
                                  OverWeightReport temp_overweight_report =
                                      OverWeightReport
                                          .getFilteredReportOfInterval(
                                    reportsList,
                                    int.parse(from_month),
                                    int.parse(to_month),
                                    int.parse(from_day),
                                    int.parse(to_day),
                                    int.parse(chosenYear),
                                    MAAMOUL_AREA,
                                    ALL_LINES,
                                  );
                                  List<OverWeightReport> overweightTempList =
                                      OverWeightReport.getAllReportsOfInterval(
                                    reportsList,
                                    int.parse(from_month),
                                    int.parse(to_month),
                                    int.parse(from_day),
                                    int.parse(to_day),
                                    int.parse(chosenYear),
                                    MAAMOUL_AREA,
                                  ).values.toList();
                                  return FutureBuilder<QuerySnapshot>(
                                    future: maamoulReportRef.get(),
                                    builder: (BuildContext context,
                                        AsyncSnapshot<QuerySnapshot>
                                            productionSnapshot) {
                                      if (productionSnapshot.hasError) {
                                        return ErrorMessageHeading(
                                            'Something went wrong');
                                      } else if (productionSnapshot
                                              .connectionState ==
                                          ConnectionState.waiting) {
                                        return ColorLoader();
                                      } else {
                                        try {
                                          List<
                                                  QueryDocumentSnapshot<
                                                      MaamoulReport>>
                                              reportsList =
                                              productionSnapshot.data!.docs
                                                  as List<
                                                      QueryDocumentSnapshot<
                                                          MaamoulReport>>;
                                          MiniProductionReport temp_report =
                                              MaamoulReport
                                                  .getFilteredReportOfInterval(
                                            reportsList,
                                            int.parse(from_month),
                                            int.parse(to_month),
                                            int.parse(from_day),
                                            int.parse(to_day),
                                            int.parse(chosenYear),
                                            ALL_LINES,
                                            overweightTempList,
                                            dtReportsList,
                                          );
                                          return Center(
                                            child: ProductionLine(
                                              report: temp_report,
                                              overweight: temp_overweight_report
                                                  .percent,
                                              isWebView: false,
                                              wastedMinutes:
                                                  temp_wasted_minutes,
                                            ),
                                          );
                                        } catch (e) {
                                          print(e);
                                          return ErrorMessageHeading(
                                              'Something went wrong');
                                        }
                                      }
                                    },
                                  );
                                }
                              });
                        }
                      }),
                ],
              ),
            ),
            ///////////////////////////////////////////////////////
            SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FutureBuilder<QuerySnapshot>(
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
                                  AsyncSnapshot<QuerySnapshot>
                                      downTimeSnapshot) {
                                if (downTimeSnapshot.hasError) {
                                  return ErrorMessageHeading(
                                      'Something went wrong');
                                } else if (downTimeSnapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return ColorLoader();
                                } else {
                                  List<QueryDocumentSnapshot<DownTimeReport>>
                                      dtReportsList =
                                      downTimeSnapshot.data!.docs as List<
                                          QueryDocumentSnapshot<
                                              DownTimeReport>>;
                                  int temp_wasted_minutes1 =
                                      DownTimeReport.getWastedMinutesOfCriteria(
                                    dtReportsList,
                                    int.parse(from_month),
                                    int.parse(to_month),
                                    int.parse(from_day),
                                    int.parse(to_day),
                                    int.parse(chosenYear),
                                    MAAMOUL_AREA,
                                    1,
                                    ALL_SHIFTS,
                                  );
                                  int temp_wasted_minutes2 =
                                      DownTimeReport.getWastedMinutesOfCriteria(
                                        dtReportsList,
                                    int.parse(from_month),
                                    int.parse(to_month),
                                    int.parse(from_day),
                                    int.parse(to_day),
                                    int.parse(chosenYear),
                                    MAAMOUL_AREA,
                                    2,
                                    ALL_SHIFTS,
                                  );
                                  int temp_wasted_minutesAll =
                                      DownTimeReport.getWastedMinutesOfCriteria(
                                        dtReportsList,
                                    int.parse(from_month),
                                    int.parse(to_month),
                                    int.parse(from_day),
                                    int.parse(to_day),
                                    int.parse(chosenYear),
                                    MAAMOUL_AREA,
                                    ALL_LINES,
                                    ALL_SHIFTS,
                                  );
                                  List<QueryDocumentSnapshot<OverWeightReport>>
                                      reportsList =
                                      overweightSnapshot.data!.docs as List<
                                          QueryDocumentSnapshot<
                                              OverWeightReport>>;
                                  OverWeightReport overWeight1 =
                                      OverWeightReport
                                          .getFilteredReportOfInterval(
                                    reportsList,
                                    int.parse(from_month),
                                    int.parse(to_month),
                                    int.parse(from_day),
                                    int.parse(to_day),
                                    int.parse(chosenYear),
                                    MAAMOUL_AREA,
                                    1,
                                  );
                                  OverWeightReport overWeight2 =
                                      OverWeightReport
                                          .getFilteredReportOfInterval(
                                    reportsList,
                                    int.parse(from_month),
                                    int.parse(to_month),
                                    int.parse(from_day),
                                    int.parse(to_day),
                                    int.parse(chosenYear),
                                    MAAMOUL_AREA,
                                    2,
                                  );
                                  OverWeightReport overWeightAll =
                                      OverWeightReport
                                          .getFilteredReportOfInterval(
                                    reportsList,
                                    int.parse(from_month),
                                    int.parse(to_month),
                                    int.parse(from_day),
                                    int.parse(to_day),
                                    int.parse(chosenYear),
                                    MAAMOUL_AREA,
                                    ALL_LINES,
                                  );
                                  List<OverWeightReport> overweightTempList =
                                      OverWeightReport.getAllReportsOfInterval(
                                    reportsList,
                                    int.parse(from_month),
                                    int.parse(to_month),
                                    int.parse(from_day),
                                    int.parse(to_day),
                                    int.parse(chosenYear),
                                    MAAMOUL_AREA,
                                  ).values.toList();
                                  return FutureBuilder<QuerySnapshot>(
                                    future: maamoulReportRef.get(),
                                    builder: (BuildContext context,
                                        AsyncSnapshot<QuerySnapshot>
                                            productionSnapshot) {
                                      if (productionSnapshot.hasError) {
                                        return ErrorMessageHeading(
                                            'Something went wrong');
                                      } else if (productionSnapshot
                                              .connectionState ==
                                          ConnectionState.waiting) {
                                        return ColorLoader();
                                      } else {
                                        try {
                                          List<
                                                  QueryDocumentSnapshot<
                                                      MaamoulReport>>
                                              reportsList =
                                              productionSnapshot.data!.docs
                                                  as List<
                                                      QueryDocumentSnapshot<
                                                          MaamoulReport>>;
                                          MiniProductionReport temp_report1 =
                                              MaamoulReport
                                                  .getFilteredReportOfInterval(
                                                reportsList,
                                            int.parse(from_month),
                                            int.parse(to_month),
                                            int.parse(from_day),
                                            int.parse(to_day),
                                            int.parse(chosenYear),
                                            1,
                                            overweightTempList,
                                            dtReportsList,
                                          );
                                          MiniProductionReport temp_report2 =
                                              MaamoulReport
                                                  .getFilteredReportOfInterval(
                                                reportsList,
                                            int.parse(from_month),
                                            int.parse(to_month),
                                            int.parse(from_day),
                                            int.parse(to_day),
                                            int.parse(chosenYear),
                                            2,
                                            overweightTempList,
                                            dtReportsList,
                                          );
                                          MiniProductionReport temp_reportAll =
                                              MaamoulReport
                                                  .getFilteredReportOfInterval(
                                                reportsList,
                                            int.parse(from_month),
                                            int.parse(to_month),
                                            int.parse(from_day),
                                            int.parse(to_day),
                                            int.parse(chosenYear),
                                            ALL_LINES,
                                            overweightTempList,
                                            dtReportsList,
                                          );
                                          return !kIsWeb
                                              ? Padding(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal:
                                                          defaultPadding),
                                                  child: ErrorMessageHeading(
                                                      "This View is Available for Web only"),
                                                )
                                              : IntrinsicHeight(
                                                  child: Row(
                                                    children: [
                                                      Expanded(
                                                        child: Padding(
                                                          padding: const EdgeInsets
                                                                  .symmetric(
                                                              horizontal:
                                                                  minimumPadding),
                                                          child: Column(
                                                            children: [
                                                              SizedBox(
                                                                height:
                                                                    minimumPadding,
                                                              ),
                                                              adminHeading(
                                                                  "Line 1"),
                                                              Center(
                                                                child:
                                                                    ProductionLine(
                                                                  report:
                                                                      temp_report1,
                                                                  overweight:
                                                                      overWeight1
                                                                          .percent,
                                                                  isWebView:
                                                                      true,
                                                                  wastedMinutes:
                                                                      temp_wasted_minutes1,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                      myVerticalDivider(),
                                                      Expanded(
                                                        child: Padding(
                                                          padding: const EdgeInsets
                                                                  .symmetric(
                                                              horizontal:
                                                                  minimumPadding),
                                                          child: Column(
                                                            children: [
                                                              SizedBox(
                                                                height:
                                                                    minimumPadding,
                                                              ),
                                                              adminHeading(
                                                                  "Line 2"),
                                                              Center(
                                                                child:
                                                                    ProductionLine(
                                                                  report:
                                                                      temp_report2,
                                                                  overweight:
                                                                      overWeight2
                                                                          .percent,
                                                                  isWebView:
                                                                      true,
                                                                  wastedMinutes:
                                                                      temp_wasted_minutes2,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                      myVerticalDivider(),
                                                      Expanded(
                                                        child: Padding(
                                                          padding: const EdgeInsets
                                                                  .symmetric(
                                                              horizontal:
                                                                  minimumPadding),
                                                          child: Column(
                                                            children: [
                                                              SizedBox(
                                                                height:
                                                                    minimumPadding,
                                                              ),
                                                              adminHeading(
                                                                  "Total"),
                                                              Center(
                                                                child:
                                                                    ProductionLine(
                                                                  report:
                                                                      temp_reportAll,
                                                                  overweight:
                                                                      overWeightAll
                                                                          .percent,
                                                                  isWebView:
                                                                      true,
                                                                  wastedMinutes:
                                                                      temp_wasted_minutesAll,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                        } catch (e) {
                                          print(e);
                                          return ErrorMessageHeading(
                                              'Something went wrong');
                                        }
                                      }
                                    },
                                  );
                                }
                              });
                        }
                      }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
