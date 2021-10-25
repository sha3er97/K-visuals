/**********************************
    this screen will have 2 big buttons
    Visuals
    Reports
 *********************************/
import 'package:cairo_bisco_app/classes/BiscuitsReport.dart';
import 'package:cairo_bisco_app/classes/MaamoulReport.dart';
import 'package:cairo_bisco_app/classes/WaferReport.dart';
import 'package:cairo_bisco_app/classes/utility_funcs/excel_utilities.dart';
import 'package:cairo_bisco_app/classes/values/colors.dart';
import 'package:cairo_bisco_app/classes/values/constants.dart';
import 'package:cairo_bisco_app/components/alert_dialog.dart';
import 'package:cairo_bisco_app/components/buttons/back_btn.dart';
import 'package:cairo_bisco_app/components/buttons/gradient_general_btn.dart';
import 'package:cairo_bisco_app/ui/production_screens/biscuits_lines.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChooseVisualsOrExcel extends StatelessWidget {
  ChooseVisualsOrExcel({
    Key? key,
    required this.from_day,
    required this.to_day,
    required this.from_month,
    required this.to_month,
    required this.chosenYear,
    required this.refNum,
  }) : super(key: key);
  final String from_day, to_day, from_month, to_month, chosenYear;
  final int refNum;

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
    final waferReportRef = FirebaseFirestore.instance
        .collection(factory_name)
        .doc('wafer_reports')
        .collection(chosenYear)
        .withConverter<WaferReport>(
          fromFirestore: (snapshot, _) =>
              WaferReport.fromJson(snapshot.data()!),
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
    final productionRefs = [
      biscuitsReportRef,
      waferReportRef,
      maamoulReportRef
    ];
    return Scaffold(
      backgroundColor: KelloggColors.white,
      resizeToAvoidBottomInset: true,
      appBar: new AppBar(
        backgroundColor: KelloggColors.white.withOpacity(0),
        shadowColor: KelloggColors.white.withOpacity(0),
        leading: MyBackButton(
          admin: false,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GradientGeneralButton(
              gradientColor1: KelloggColors.cockRed,
              gradientColor2: KelloggColors.grey,
              mainColor: KelloggColors.darkBlue.withOpacity(0.5),
              title: "Visuals",
              btn_icon: Icons.bar_chart,
              param_onPressed: () {
                switch (refNum) {
                  case BISCUIT_AREA:
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => BiscuitLines(
                                from_day: from_day,
                                to_day: to_day,
                                from_month: from_month,
                                to_month: to_month,
                                chosenYear: chosenYear)));
                    break;
                  case WAFER_AREA:
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => BiscuitLines(
                                from_day: from_day,
                                to_day: to_day,
                                from_month: from_month,
                                to_month: to_month,
                                chosenYear: chosenYear)));
                    break;
                  case MAAMOUL_AREA:
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => BiscuitLines(
                                from_day: from_day,
                                to_day: to_day,
                                from_month: from_month,
                                to_month: to_month,
                                chosenYear: chosenYear)));
                    break;
                }
              },
            ),
            GradientGeneralButton(
              gradientColor1: KelloggColors.successGreen,
              gradientColor2: KelloggColors.grey,
              mainColor: KelloggColors.green.withOpacity(0.5),
              title: "Excel Report",
              btn_icon: Icons.file_download,
              param_onPressed: () async {
                try {
                  ExcelUtilities util = ExcelUtilities(refNum: refNum);
                  util.insertHeaders();
                  productionRefs[refNum]
                      .get()
                      .then((QuerySnapshot productionSnapshot) {
                    switch (refNum) {
                      case BISCUIT_AREA:
                        List<QueryDocumentSnapshot<BiscuitsReport>>
                            reportslist = productionSnapshot.docs
                                as List<QueryDocumentSnapshot<BiscuitsReport>>;
                        List<BiscuitsReport> tempList =
                            BiscuitsReport.getAllReportsOfInterval(
                          reportslist,
                          int.parse(from_month),
                          int.parse(to_month),
                          int.parse(from_day),
                          int.parse(to_day),
                          int.parse(chosenYear),
                        );
                        util.insertBiscuitReportRows(tempList);
                        break;
                      case WAFER_AREA:
                        List<QueryDocumentSnapshot<WaferReport>> reportslist =
                            productionSnapshot.docs
                                as List<QueryDocumentSnapshot<WaferReport>>;
                        List<WaferReport> tempList =
                            WaferReport.getAllReportsOfInterval(
                          reportslist,
                          int.parse(from_month),
                          int.parse(to_month),
                          int.parse(from_day),
                          int.parse(to_day),
                          int.parse(chosenYear),
                        );
                        util.insertWaferReportRows(tempList);
                        break;
                      case MAAMOUL_AREA:
                        List<QueryDocumentSnapshot<MaamoulReport>> reportslist =
                            productionSnapshot.docs
                                as List<QueryDocumentSnapshot<MaamoulReport>>;
                        List<MaamoulReport> tempList =
                            MaamoulReport.getAllReportsOfInterval(
                          reportslist,
                          int.parse(from_month),
                          int.parse(to_month),
                          int.parse(from_day),
                          int.parse(to_day),
                          int.parse(chosenYear),
                        );
                        util.insertMaamoulReportRows(tempList);
                        break;
                    }
                    util.saveFile(
                        context, from_day, to_day, from_month, to_month);
                  });
                } catch (e) {
                  showExcelAlertDialog(context, false, "");
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
