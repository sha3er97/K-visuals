import 'package:cairo_bisco_app/classes/MiniProductionReport.dart';
import 'package:cairo_bisco_app/classes/Plans.dart';
import 'package:cairo_bisco_app/classes/WaferReport.dart';
import 'package:cairo_bisco_app/classes/utility_funcs/date_utility.dart';
import 'package:cairo_bisco_app/classes/values/TextStandards.dart';
import 'package:cairo_bisco_app/classes/values/colors.dart';
import 'package:cairo_bisco_app/classes/values/constants.dart';
import 'package:cairo_bisco_app/components/production_widgets/scroll_production_line.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class WaferLines extends StatefulWidget {
  @override
  _WaferLinesState createState() => _WaferLinesState();
}

class _WaferLinesState extends State<WaferLines> {
  final waferReportRef = FirebaseFirestore.instance
      .collection(factory_name)
      .doc('wafer_reports')
      .collection(getYear())
      .withConverter<WaferReport>(
        fromFirestore: (snapshot, _) => WaferReport.fromJson(snapshot.data()!),
        toFirestore: (report, _) => report.toJson(),
      );

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: false,
      child: DefaultTabController(
        // The number of tabs / content sections to display.
        length: 5,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: KelloggColors.green,
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
                      stream: waferReportRef.snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasError) {
                          return ErrorMessageHeading('Something went wrong');
                        } else if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return ErrorMessageHeading("Loading");
                        } else {
                          try {
                            List<QueryDocumentSnapshot<WaferReport>>
                                reportsList = snapshot.data!.docs
                                    as List<QueryDocumentSnapshot<WaferReport>>;
                            MiniProductionReport temp_report =
                                WaferReport.getFilteredReportOfInterval(
                              reportsList,
                              int.parse(getMonth()),
                              int.parse(getMonth()),
                              int.parse(getDay()),
                              int.parse(getDay()),
                              int.parse(getYear()),
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
                      stream: waferReportRef.snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasError) {
                          return ErrorMessageHeading('Something went wrong');
                        } else if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return ErrorMessageHeading("Loading");
                        } else {
                          try {
                            List<QueryDocumentSnapshot<WaferReport>>
                                reportsList = snapshot.data!.docs
                                    as List<QueryDocumentSnapshot<WaferReport>>;
                            MiniProductionReport temp_report =
                                WaferReport.getFilteredReportOfInterval(
                              reportsList,
                              int.parse(getMonth()),
                              int.parse(getMonth()),
                              int.parse(getDay()),
                              int.parse(getDay()),
                              int.parse(getYear()),
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
                      stream: waferReportRef.snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasError) {
                          return ErrorMessageHeading('Something went wrong');
                        } else if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return ErrorMessageHeading("Loading");
                        } else {
                          try {
                            List<QueryDocumentSnapshot<WaferReport>>
                                reportsList = snapshot.data!.docs
                                    as List<QueryDocumentSnapshot<WaferReport>>;
                            MiniProductionReport temp_report =
                                WaferReport.getFilteredReportOfInterval(
                              reportsList,
                              int.parse(getMonth()),
                              int.parse(getMonth()),
                              int.parse(getDay()),
                              int.parse(getDay()),
                              int.parse(getYear()),
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
                      stream: waferReportRef.snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasError) {
                          return ErrorMessageHeading('Something went wrong');
                        } else if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return ErrorMessageHeading("Loading");
                        } else {
                          try {
                            List<QueryDocumentSnapshot<WaferReport>>
                                reportsList = snapshot.data!.docs
                                    as List<QueryDocumentSnapshot<WaferReport>>;
                            MiniProductionReport temp_report =
                                WaferReport.getFilteredReportOfInterval(
                              reportsList,
                              int.parse(getMonth()),
                              int.parse(getMonth()),
                              int.parse(getDay()),
                              int.parse(getDay()),
                              int.parse(getYear()),
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
                      stream: waferReportRef.snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasError) {
                          return ErrorMessageHeading('Something went wrong');
                        } else if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return ErrorMessageHeading("Loading");
                        } else {
                          try {
                            List<QueryDocumentSnapshot<WaferReport>>
                                reportsList = snapshot.data!.docs
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
