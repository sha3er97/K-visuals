import 'dart:collection';

import 'package:cairo_bisco_app/classes/DownTimeSummary.dart';
import 'package:cairo_bisco_app/classes/ReportTitle.dart';
import 'package:cairo_bisco_app/classes/utility_funcs/date_utility.dart';
import 'package:cairo_bisco_app/classes/values/colors.dart';
import 'package:cairo_bisco_app/classes/values/constants.dart';
import 'package:cairo_bisco_app/components/buttons/back_btn.dart';
import 'package:cairo_bisco_app/components/buttons/rounded_btn.dart';
import 'package:cairo_bisco_app/components/list_items/report_item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import '../../classes/DownTimeReport.dart';
import '../../classes/values/TextStandards.dart';
import '../../components/alert_dialog.dart';

class ApproveReports extends StatefulWidget {
  @override
  _ApproveReportsState createState() => _ApproveReportsState();
}

class _ApproveReportsState extends State<ApproveReports> {
  bool showSpinner = false;

  //temp variables
  List<DownTimeSummary> reportsTitlesList = [];

  @override
  Widget build(BuildContext context) {
    final downTimeReportRef = FirebaseFirestore.instance
        .collection(factory_name)
        .doc('downtime_reports')
        .collection(getYear().toString())
        .withConverter<DownTimeReport>(
          fromFirestore: (snapshot, _) =>
              DownTimeReport.fromJson(snapshot.data()!),
          toFirestore: (report, _) => report.toJson(),
        );
    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      child: Scaffold(
        backgroundColor: KelloggColors.white,
        resizeToAvoidBottomInset: true,
        appBar: new AppBar(
          backgroundColor: KelloggColors.white.withOpacity(0),
          shadowColor: KelloggColors.white.withOpacity(0),
          leading: MyBackButton(
            admin: false,
          ),
          title: Text(
            "Approve Reports",
            style: TextStyle(
                color: KelloggColors.darkRed,
                fontWeight: FontWeight.w300,
                fontSize: largeFontSize),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(minimumPadding),
                child: Center(
                  child: RoundedButton(
                      btnText: 'Refresh Reports',
                      color: KelloggColors.darkRed,
                      onPressed: () {
                        downTimeReportRef.get().then((QuerySnapshot snapshot) {
                          setState(() {
                            List<QueryDocumentSnapshot<DownTimeReport>>
                                downTimeSnapshotReportsList = snapshot.docs
                                    as List<
                                        QueryDocumentSnapshot<DownTimeReport>>;
                            HashMap<String, DownTimeReport>
                                downTimeReportsList =
                                DownTimeReport.getPendingReports(
                              downTimeSnapshotReportsList,
                            );
                            reportsTitlesList = DownTimeSummary.makeList(
                                context, downTimeReportsList);
                          });
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text("Report refreshed"),
                          ));
                        });
                      }),
                ),
              ),
              ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  physics: ClampingScrollPhysics(),
                  padding: const EdgeInsets.all(minimumPadding),
                  itemCount: reportsTitlesList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      title: aboveMediumHeading(reportsTitlesList[index].date +
                          "\n By : " +
                          reportsTitlesList[index].supName +
                          "\n Tech. : " +
                          reportsTitlesList[index].technicianName +
                          '\n' +
                          reportsTitlesList[index].type +
                          '\n' +
                          reportsTitlesList[index].root_cause +
                          "\nFrom : " +
                          reportsTitlesList[index].from_time +
                          "\nTo : " +
                          reportsTitlesList[index].to_time +
                          "\nTotal Time : " +
                          reportsTitlesList[index].wastedMinutes +
                          " Mins." +
                          "\n--------------------------------------\n"),
                      leading: IconButton(
                        tooltip: "Approve",
                        icon: const Icon(
                          Icons.mode_edit,
                        ),
                        color: KelloggColors.green,
                        onPressed: () {
                          confirmApproveReport(
                              context, reportsTitlesList[index].reportID);
                        },
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.close),
                        color: KelloggColors.cockRed,
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text("Feature not available yet"),
                          ));
                          //todo :: delete report
                          // confirmDeleteMachineDetailAlertDialog(
                          //     context,
                          //     refNum,
                          //     skuName,
                          //     SKU.skuMachineDetails[skuName]![index]
                          //         .id);
                        },
                      ),
                    );
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
