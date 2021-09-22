import 'package:cairo_bisco_app/classes/BiscuitsReport.dart';
import 'package:cairo_bisco_app/classes/MiniProductionReport.dart';
import 'package:cairo_bisco_app/classes/Plans.dart';
import 'package:cairo_bisco_app/classes/values/TextStandards.dart';
import 'package:cairo_bisco_app/classes/values/colors.dart';
import 'package:cairo_bisco_app/classes/values/constants.dart';
import 'package:cairo_bisco_app/components/production_widgets/scroll_production_line.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class BiscuitLines extends StatefulWidget {
  BiscuitLines({
    Key? key,
    required this.from_day,
    required this.to_day,
    required this.from_month,
    required this.to_month,
    required this.chosenYear,
  }) : super(key: key);
  final String from_day, to_day, from_month, to_month, chosenYear;

  @override
  _BiscuitLinesState createState() => _BiscuitLinesState(
        from_day: from_day,
        to_day: to_day,
        from_month: from_month,
        to_month: to_month,
        chosenYear: chosenYear,
      );
}

class _BiscuitLinesState extends State<BiscuitLines> {
  _BiscuitLinesState({
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
    return ModalProgressHUD(
      inAsyncCall: false,
      child: DefaultTabController(
        // The number of tabs / content sections to display.
        length: 5,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: KelloggColors.yellow,
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
                  text: "Line 3",
                ),
                Tab(
                  // icon: Icon(Icons.directions_car),
                  text: "Line 4",
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
                    StreamBuilder<QuerySnapshot>(
                      stream: biscuitsReportRef.snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasError) {
                          return ErrorMessageHeading('Something went wrong');
                        } else if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return ErrorMessageHeading("Loading");
                        } else {
                          try {
                            List<QueryDocumentSnapshot<BiscuitsReport>>
                                reportsList = snapshot.data!.docs as List<
                                    QueryDocumentSnapshot<BiscuitsReport>>;
                            MiniProductionReport temp_report =
                                BiscuitsReport.getFilteredReportOfInterval(
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
                              oee: (temp_report.productionInKg.toDouble() /
                                      temp_report.theoreticalAverage) *
                                  100,
                              scrap: temp_report.scrap *
                                  100 /
                                  (temp_report.scrap +
                                      temp_report.rework +
                                      temp_report.productionInKg),
                              money: temp_report.scrap * Plans.scrapKgCost,
                              overweight: 0.5,
                              //TODO :: integrate overweight cycle
                              filmWaste: (temp_report.totalFilmWasted /
                                      temp_report.totalFilmUsed) *
                                  100,
                              targetProd: temp_report.shiftProductionPlan,
                              productName: temp_report.skuName,
                            ));
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
              SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    StreamBuilder<QuerySnapshot>(
                      stream: biscuitsReportRef.snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasError) {
                          return ErrorMessageHeading('Something went wrong');
                        } else if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return ErrorMessageHeading("Loading");
                        } else {
                          try {
                            List<QueryDocumentSnapshot<BiscuitsReport>>
                                reportsList = snapshot.data!.docs as List<
                                    QueryDocumentSnapshot<BiscuitsReport>>;
                            MiniProductionReport temp_report =
                                BiscuitsReport.getFilteredReportOfInterval(
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
                              oee: (temp_report.productionInKg.toDouble() /
                                      temp_report.theoreticalAverage) *
                                  100,
                              scrap: temp_report.scrap *
                                  100 /
                                  (temp_report.scrap +
                                      temp_report.rework +
                                      temp_report.productionInKg),
                              money: temp_report.scrap * Plans.scrapKgCost,
                              overweight: 0.5,
                              //TODO :: integrate overweight cycle
                              filmWaste: (temp_report.totalFilmWasted /
                                      temp_report.totalFilmUsed) *
                                  100,
                              targetProd: temp_report.shiftProductionPlan,
                              productName: temp_report.skuName,
                            ));
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
              SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    StreamBuilder<QuerySnapshot>(
                      stream: biscuitsReportRef.snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasError) {
                          return ErrorMessageHeading('Something went wrong');
                        } else if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return ErrorMessageHeading("Loading");
                        } else {
                          try {
                            List<QueryDocumentSnapshot<BiscuitsReport>>
                                reportsList = snapshot.data!.docs as List<
                                    QueryDocumentSnapshot<BiscuitsReport>>;
                            MiniProductionReport temp_report =
                                BiscuitsReport.getFilteredReportOfInterval(
                              reportsList,
                              int.parse(from_month),
                              int.parse(to_month),
                              int.parse(from_day),
                              int.parse(to_day),
                              int.parse(chosenYear),
                              3,
                            );
                            return Center(
                                child: ProductionLine(
                              cartons: temp_report.productionInCartons,
                              oee: (temp_report.productionInKg.toDouble() /
                                      temp_report.theoreticalAverage) *
                                  100,
                              scrap: temp_report.scrap *
                                  100 /
                                  (temp_report.scrap +
                                      temp_report.rework +
                                      temp_report.productionInKg),
                              money: temp_report.scrap * Plans.scrapKgCost,
                              overweight: 0.5,
                              //TODO :: integrate overweight cycle
                              filmWaste: (temp_report.totalFilmWasted /
                                      temp_report.totalFilmUsed) *
                                  100,
                              targetProd: temp_report.shiftProductionPlan,
                              productName: temp_report.skuName,
                            ));
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
              SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    StreamBuilder<QuerySnapshot>(
                      stream: biscuitsReportRef.snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasError) {
                          return ErrorMessageHeading('Something went wrong');
                        } else if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return ErrorMessageHeading("Loading");
                        } else {
                          try {
                            List<QueryDocumentSnapshot<BiscuitsReport>>
                                reportsList = snapshot.data!.docs as List<
                                    QueryDocumentSnapshot<BiscuitsReport>>;
                            MiniProductionReport temp_report =
                                BiscuitsReport.getFilteredReportOfInterval(
                                  reportsList,
                              int.parse(from_month),
                              int.parse(to_month),
                              int.parse(from_day),
                              int.parse(to_day),
                              int.parse(chosenYear),
                              4,
                            );
                            return Center(
                                child: ProductionLine(
                              cartons: temp_report.productionInCartons,
                              oee: (temp_report.productionInKg.toDouble() /
                                      temp_report.theoreticalAverage) *
                                  100,
                              scrap: temp_report.scrap *
                                  100 /
                                  (temp_report.scrap +
                                      temp_report.rework +
                                      temp_report.productionInKg),
                              money: temp_report.scrap * Plans.scrapKgCost,
                              overweight: 0.5,
                              //TODO :: integrate overweight cycle
                              filmWaste: (temp_report.totalFilmWasted /
                                      temp_report.totalFilmUsed) *
                                  100,
                              targetProd: temp_report.shiftProductionPlan,
                              productName: temp_report.skuName,
                            ));
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
              SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    StreamBuilder<QuerySnapshot>(
                      stream: biscuitsReportRef.snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasError) {
                          return ErrorMessageHeading('Something went wrong');
                        } else if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return ErrorMessageHeading("Loading");
                        } else {
                          try {
                            List<QueryDocumentSnapshot<BiscuitsReport>>
                                reportsList = snapshot.data!.docs as List<
                                    QueryDocumentSnapshot<BiscuitsReport>>;
                            MiniProductionReport temp_report =
                                BiscuitsReport.getFilteredReportOfInterval(
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
                              oee: (temp_report.productionInKg.toDouble() /
                                      temp_report.theoreticalAverage) *
                                  100,
                              scrap: temp_report.scrap *
                                  100 /
                                  (temp_report.scrap +
                                      temp_report.rework +
                                      temp_report.productionInKg),
                              money: temp_report.scrap * Plans.scrapKgCost,
                              overweight: 0.5,
                              //TODO :: integrate overweight cycle
                              filmWaste: (temp_report.totalFilmWasted /
                                      temp_report.totalFilmUsed) *
                                  100,
                              targetProd: temp_report.shiftProductionPlan,
                              productName: temp_report.skuName,
                            ));
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
            ],
          ),
        ),
      ),
    );
  }
}
