import 'package:cairo_bisco_app/classes/BiscuitsReport.dart';
import 'package:cairo_bisco_app/classes/MaamoulReport.dart';
import 'package:cairo_bisco_app/classes/MiniProductionReport.dart';
import 'package:cairo_bisco_app/classes/OverWeightReport.dart';
import 'package:cairo_bisco_app/classes/WaferReport.dart';
import 'package:cairo_bisco_app/classes/values/TextStandards.dart';
import 'package:cairo_bisco_app/classes/values/colors.dart';
import 'package:cairo_bisco_app/classes/values/constants.dart';
import 'package:cairo_bisco_app/components/production_widgets/scroll_production_line.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TotalPlantLine extends StatefulWidget {
  TotalPlantLine({
    Key? key,
    required this.from_day,
    required this.to_day,
    required this.from_month,
    required this.to_month,
    required this.chosenYear,
  }) : super(key: key);
  final String from_day, to_day, from_month, to_month, chosenYear;

  @override
  _TotalPlantLineState createState() => _TotalPlantLineState(
        from_day: from_day,
        to_day: to_day,
        from_month: from_month,
        to_month: to_month,
        chosenYear: chosenYear,
      );
}

class _TotalPlantLineState extends State<TotalPlantLine> {
  _TotalPlantLineState({
    required this.from_day,
    required this.to_day,
    required this.from_month,
    required this.to_month,
    required this.chosenYear,
  });

  final String from_day, to_day, from_month, to_month, chosenYear;

  @override
  Widget build(BuildContext context) {
    final biscuitsReportRef = FirebaseFirestore.instance
        .collection(factory_name)
        .doc('biscuits_reports')
        .collection(chosenYear)
        .withConverter<BiscuitsReport>(
          fromFirestore: (snapshot, _) =>
              BiscuitsReport.fromJson(snapshot.data()!),
          toFirestore: (report, _) => report.toJson(),
        );
    final maamoulReportRef = FirebaseFirestore.instance
        .collection(factory_name)
        .doc('maamoul_reports')
        .collection(chosenYear)
        .withConverter<MaamoulReport>(
          fromFirestore: (snapshot, _) =>
              MaamoulReport.fromJson(snapshot.data()!),
          toFirestore: (report, _) => report.toJson(),
        );
    final waferReportRef = FirebaseFirestore.instance
        .collection(factory_name)
        .doc('wafer_reports')
        .collection(chosenYear)
        .withConverter<WaferReport>(
          fromFirestore: (snapshot, _) =>
              WaferReport.fromJson(snapshot.data()!),
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
    return DefaultTabController(
      // The number of tabs / content sections to display.
      length: 1,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: KelloggColors.darkBlue,
          bottom: TabBar(
            tabs: [
              Tab(
                icon: Icon(
                  Icons.dashboard_customize_rounded,
                ),
                text: "Total Plant",
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
                                  return ErrorMessageHeading(
                                      'Something went wrong');
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
                                        } else if (maamoulSnapshot
                                                .connectionState ==
                                            ConnectionState.waiting) {
                                          return ErrorMessageHeading("Loading");
                                        } else {
                                          return FutureBuilder<QuerySnapshot>(
                                              future: overWeightReportRef.get(),
                                              builder: (BuildContext context,
                                                  AsyncSnapshot<QuerySnapshot>
                                                      overweightSnapshot) {
                                                if (overweightSnapshot
                                                    .hasError) {
                                                  return ErrorMessageHeading(
                                                      'Something went wrong');
                                                } else if (overweightSnapshot
                                                        .connectionState ==
                                                    ConnectionState.waiting) {
                                                  return ErrorMessageHeading(
                                                      "Loading");
                                                } else {
                                                  List<
                                                          QueryDocumentSnapshot<
                                                              OverWeightReport>>
                                                      overReportsList =
                                                      overweightSnapshot
                                                              .data!.docs
                                                          as List<
                                                              QueryDocumentSnapshot<
                                                                  OverWeightReport>>;
                                                  OverWeightReport
                                                      temp_overweight_report =
                                                      OverWeightReport
                                                          .getFilteredReportOfInterval(
                                                    overReportsList,
                                                    int.parse(from_month),
                                                    int.parse(to_month),
                                                    int.parse(from_day),
                                                    int.parse(to_day),
                                                    int.parse(chosenYear),
                                                    TOTAL_PLANT,
                                                    -1,
                                                  );
                                                  List<
                                                          QueryDocumentSnapshot<
                                                              BiscuitsReport>>
                                                      biscuitsReportsList =
                                                      biscuitsSnapshot
                                                              .data!.docs
                                                          as List<
                                                              QueryDocumentSnapshot<
                                                                  BiscuitsReport>>;
                                                  MiniProductionReport
                                                      temp_biscuit_report =
                                                      BiscuitsReport
                                                          .getFilteredReportOfInterval(
                                                    biscuitsReportsList,
                                                    int.parse(from_month),
                                                    int.parse(to_month),
                                                    int.parse(from_day),
                                                    int.parse(to_day),
                                                    int.parse(chosenYear),
                                                    -1,
                                                  );
                                                  List<
                                                          QueryDocumentSnapshot<
                                                              WaferReport>>
                                                      waferReportsList =
                                                      waferSnapshot.data!.docs
                                                          as List<
                                                              QueryDocumentSnapshot<
                                                                  WaferReport>>;
                                                  MiniProductionReport
                                                      temp_wafer_report =
                                                      WaferReport
                                                          .getFilteredReportOfInterval(
                                                    waferReportsList,
                                                    int.parse(from_month),
                                                    int.parse(to_month),
                                                    int.parse(from_day),
                                                    int.parse(to_day),
                                                    int.parse(chosenYear),
                                                    -1,
                                                  );
                                                  List<
                                                          QueryDocumentSnapshot<
                                                              MaamoulReport>>
                                                      maamoulReportsList =
                                                      maamoulSnapshot.data!.docs
                                                          as List<
                                                              QueryDocumentSnapshot<
                                                                  MaamoulReport>>;
                                                  MiniProductionReport
                                                      temp_maamoul_report =
                                                      MaamoulReport
                                                          .getFilteredReportOfInterval(
                                                    maamoulReportsList,
                                                    int.parse(from_month),
                                                    int.parse(to_month),
                                                    int.parse(from_day),
                                                    int.parse(to_day),
                                                    int.parse(chosenYear),
                                                    -1,
                                                  );
                                                  return Center(
                                                    child: ProductionLine(
                                                      report:
                                                          MiniProductionReport
                                                              .mergeReports([
                                                        temp_biscuit_report,
                                                        temp_wafer_report,
                                                        temp_maamoul_report
                                                      ]),
                                                      overweight:
                                                          temp_overweight_report
                                                              .percent,
                                                    ),
                                                  );
                                                }
                                              });
                                        }
                                      });
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
