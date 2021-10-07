import 'package:cairo_bisco_app/classes/MaamoulReport.dart';
import 'package:cairo_bisco_app/classes/MiniProductionReport.dart';
import 'package:cairo_bisco_app/classes/OverWeightReport.dart';
import 'package:cairo_bisco_app/classes/Plans.dart';
import 'package:cairo_bisco_app/classes/values/TextStandards.dart';
import 'package:cairo_bisco_app/classes/values/colors.dart';
import 'package:cairo_bisco_app/classes/values/constants.dart';
import 'package:cairo_bisco_app/components/production_widgets/scroll_production_line.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

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
    return ModalProgressHUD(
      inAsyncCall: false,
      child: DefaultTabController(
        // The number of tabs / content sections to display.
        length: 3,
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
                            return ErrorMessageHeading("Loading");
                          } else {
                            List<QueryDocumentSnapshot<OverWeightReport>>
                                reportsList =
                                overweightSnapshot.data!.docs as List<
                                    QueryDocumentSnapshot<OverWeightReport>>;
                            OverWeightReport temp_overweight_report =
                                OverWeightReport.getFilteredReportOfInterval(
                              reportsList,
                              int.parse(from_month),
                              int.parse(to_month),
                              int.parse(from_day),
                              int.parse(to_day),
                              int.parse(chosenYear),
                              MAAMOUL_AREA,
                              1,
                            );
                            return FutureBuilder<QuerySnapshot>(
                              future: maamoulReportRef.get(),
                              builder: (BuildContext context,
                                  AsyncSnapshot<QuerySnapshot>
                                      productionSnapshot) {
                                if (productionSnapshot.hasError) {
                                  return ErrorMessageHeading(
                                      'Something went wrong');
                                } else if (productionSnapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return ErrorMessageHeading("Loading");
                                } else {
                                  try {
                                    List<QueryDocumentSnapshot<MaamoulReport>>
                                        reportsList =
                                        productionSnapshot.data!.docs as List<
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
                                    );
                                    return Center(
                                        child: ProductionLine(
                                      cartons: temp_report.productionInCartons,
                                      oee: (temp_report.productionInKg
                                                  .toDouble() /
                                              temp_report.theoreticalAverage) *
                                          100,
                                      scrap: temp_report.scrap *
                                          100 /
                                          (temp_report.scrap +
                                              temp_report.rework +
                                              temp_report.productionInKg),
                                      money:
                                          temp_report.scrap * Plans.scrapKgCost,
                                      overweight:
                                          temp_overweight_report.percent,
                                      filmWaste: (temp_report.totalFilmWasted /
                                              temp_report.totalFilmUsed) *
                                          100,
                                      targetProd:
                                          temp_report.shiftProductionPlan,
                                      productName: temp_report.skuName,
                                    ));
                                  } catch (e) {
                                    print(e);
                                    return ErrorMessageHeading(
                                        'Something went wrong');
                                  }
                                }
                              },
                            );
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
                            return ErrorMessageHeading("Loading");
                          } else {
                            List<QueryDocumentSnapshot<OverWeightReport>>
                                reportsList =
                                overweightSnapshot.data!.docs as List<
                                    QueryDocumentSnapshot<OverWeightReport>>;
                            OverWeightReport temp_overweight_report =
                                OverWeightReport.getFilteredReportOfInterval(
                              reportsList,
                              int.parse(from_month),
                              int.parse(to_month),
                              int.parse(from_day),
                              int.parse(to_day),
                              int.parse(chosenYear),
                              MAAMOUL_AREA,
                              2,
                            );
                            return FutureBuilder<QuerySnapshot>(
                              future: maamoulReportRef.get(),
                              builder: (BuildContext context,
                                  AsyncSnapshot<QuerySnapshot>
                                      productionSnapshot) {
                                if (productionSnapshot.hasError) {
                                  return ErrorMessageHeading(
                                      'Something went wrong');
                                } else if (productionSnapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return ErrorMessageHeading("Loading");
                                } else {
                                  try {
                                    List<QueryDocumentSnapshot<MaamoulReport>>
                                        reportsList =
                                        productionSnapshot.data!.docs as List<
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
                                    );
                                    return Center(
                                        child: ProductionLine(
                                      cartons: temp_report.productionInCartons,
                                      oee: (temp_report.productionInKg
                                                  .toDouble() /
                                              temp_report.theoreticalAverage) *
                                          100,
                                      scrap: temp_report.scrap *
                                          100 /
                                          (temp_report.scrap +
                                              temp_report.rework +
                                              temp_report.productionInKg),
                                      money:
                                          temp_report.scrap * Plans.scrapKgCost,
                                      overweight:
                                          temp_overweight_report.percent,
                                      filmWaste: (temp_report.totalFilmWasted /
                                              temp_report.totalFilmUsed) *
                                          100,
                                      targetProd:
                                          temp_report.shiftProductionPlan,
                                      productName: temp_report.skuName,
                                    ));
                                  } catch (e) {
                                    print(e);
                                    return ErrorMessageHeading(
                                        'Something went wrong');
                                  }
                                }
                              },
                            );
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
                            return ErrorMessageHeading("Loading");
                          } else {
                            List<QueryDocumentSnapshot<OverWeightReport>>
                                reportsList =
                                overweightSnapshot.data!.docs as List<
                                    QueryDocumentSnapshot<OverWeightReport>>;
                            OverWeightReport temp_overweight_report =
                                OverWeightReport.getFilteredReportOfInterval(
                              reportsList,
                              int.parse(from_month),
                              int.parse(to_month),
                              int.parse(from_day),
                              int.parse(to_day),
                              int.parse(chosenYear),
                              MAAMOUL_AREA,
                              -1,
                            );
                            return FutureBuilder<QuerySnapshot>(
                              future: maamoulReportRef.get(),
                              builder: (BuildContext context,
                                  AsyncSnapshot<QuerySnapshot>
                                      productionSnapshot) {
                                if (productionSnapshot.hasError) {
                                  return ErrorMessageHeading(
                                      'Something went wrong');
                                } else if (productionSnapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return ErrorMessageHeading("Loading");
                                } else {
                                  try {
                                    List<QueryDocumentSnapshot<MaamoulReport>>
                                        reportsList =
                                        productionSnapshot.data!.docs as List<
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
                                      -1,
                                    );
                                    return Center(
                                        child: ProductionLine(
                                      cartons: temp_report.productionInCartons,
                                      oee: (temp_report.productionInKg
                                                  .toDouble() /
                                              temp_report.theoreticalAverage) *
                                          100,
                                      scrap: temp_report.scrap *
                                          100 /
                                          (temp_report.scrap +
                                              temp_report.rework +
                                              temp_report.productionInKg),
                                      money:
                                          temp_report.scrap * Plans.scrapKgCost,
                                      overweight:
                                          temp_overweight_report.percent,
                                      filmWaste: (temp_report.totalFilmWasted /
                                              temp_report.totalFilmUsed) *
                                          100,
                                      targetProd:
                                          temp_report.shiftProductionPlan,
                                      productName: temp_report.skuName,
                                    ));
                                  } catch (e) {
                                    print(e);
                                    return ErrorMessageHeading(
                                        'Something went wrong');
                                  }
                                }
                              },
                            );
                          }
                        }),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
