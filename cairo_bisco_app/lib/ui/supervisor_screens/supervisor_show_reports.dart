import 'dart:collection';

import 'package:cairo_bisco_app/classes/BiscuitsReport.dart';
import 'package:cairo_bisco_app/classes/DownTimeReportTitle.dart';
import 'package:cairo_bisco_app/classes/EhsReport.dart';
import 'package:cairo_bisco_app/classes/MaamoulReport.dart';
import 'package:cairo_bisco_app/classes/NRCReport.dart';
import 'package:cairo_bisco_app/classes/OverWeightReport.dart';
import 'package:cairo_bisco_app/classes/PeopleReport.dart';
import 'package:cairo_bisco_app/classes/QfsReport.dart';
import 'package:cairo_bisco_app/classes/ReportTitle.dart';
import 'package:cairo_bisco_app/classes/WaferReport.dart';
import 'package:cairo_bisco_app/classes/utility_funcs/date_time_utility.dart';
import 'package:cairo_bisco_app/classes/utility_funcs/other_utility.dart';
import 'package:cairo_bisco_app/classes/values/colors.dart';
import 'package:cairo_bisco_app/classes/values/constants.dart';
import 'package:cairo_bisco_app/components/buttons/back_btn.dart';
import 'package:cairo_bisco_app/components/buttons/rounded_btn.dart';
import 'package:cairo_bisco_app/components/list_items/report_item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import '../../classes/DownTimeReport.dart';
import '../../classes/values/form_values.dart';

class SupervisorShowAllReports extends StatefulWidget {
  SupervisorShowAllReports({
    Key? key,
    required this.type,
    required this.refNum,
  }) : super(key: key);
  final int type;
  final int refNum;

  @override
  _SupervisorShowAllReportsState createState() =>
      _SupervisorShowAllReportsState(
        type: type,
        refNum: refNum,
      );
}

class _SupervisorShowAllReportsState extends State<SupervisorShowAllReports> {
  _SupervisorShowAllReportsState({
    required this.type,
    required this.refNum,
  });

  final int type;
  final int refNum;

  String _selectedYearFrom = years[(int.parse(getYear())) - 2020];
  String _selectedMonthFrom = months[(int.parse(getMonth())) - 1];
  String _selectedDayFrom = days[(int.parse(getDay())) - 1];
  String _selectedYearTo = years[(int.parse(getYear())) - 2020];
  String _selectedMonthTo = months[(int.parse(getMonth())) - 1];
  String _selectedDayTo = days[(int.parse(getDay())) - 1];

  bool showSpinner = false;

  VoidCallback? onFromYearChange(val) {
    setState(() {
      _selectedYearFrom = val;
    });
    return null;
  }

  VoidCallback? onFromMonthChange(val) {
    setState(() {
      _selectedMonthFrom = val;
    });
    return null;
  }

  VoidCallback? onFromDayChange(val) {
    setState(() {
      _selectedDayFrom = val;
    });
    return null;
  }

  VoidCallback? onToYearChange(val) {
    setState(() {
      _selectedYearTo = val;
    });
    return null;
  }

  VoidCallback? onToMonthChange(val) {
    setState(() {
      _selectedMonthTo = val;
    });
    return null;
  }

  VoidCallback? onToDayChange(val) {
    setState(() {
      _selectedDayTo = val;
    });
    return null;
  }

  int validated_day_from = int.parse(getDay()),
      validated_day_to = int.parse(getDay()),
      validated_month_from = int.parse(getMonth()),
      validated_month_to = int.parse(getMonth()),
      validated_year = int.parse(getYear());

  //temp variables
  List<ReportTitle> reportsTitlesList = [];
  List<DownTimeReportTitle> dtReportsTitlesList = [];

  @override
  Widget build(BuildContext context) {
    final qualityReportRef = FirebaseFirestore.instance
        .collection(factory_name)
        .doc('quality_reports')
        .collection(validated_year.toString())
        .withConverter<QfsReport>(
          fromFirestore: (snapshot, _) => QfsReport.fromJson(snapshot.data()!),
          toFirestore: (report, _) => report.toJson(),
        );
    final ehsReportRef = FirebaseFirestore.instance
        .collection(factory_name)
        .doc('ehs_reports')
        .collection(validated_year.toString())
        .withConverter<EhsReport>(
          fromFirestore: (snapshot, _) => EhsReport.fromJson(snapshot.data()!),
          toFirestore: (report, _) => report.toJson(),
        );
    final biscuitsReportRef = FirebaseFirestore.instance
        .collection(factory_name)
        .doc('biscuits_reports')
        .collection(validated_year.toString())
        .withConverter<BiscuitsReport>(
          fromFirestore: (snapshot, _) =>
              BiscuitsReport.fromJson(snapshot.data()!),
          toFirestore: (report, _) => report.toJson(),
        );
    final waferReportRef = FirebaseFirestore.instance
        .collection(factory_name)
        .doc('wafer_reports')
        .collection(validated_year.toString())
        .withConverter<WaferReport>(
          fromFirestore: (snapshot, _) =>
              WaferReport.fromJson(snapshot.data()!),
          toFirestore: (report, _) => report.toJson(),
        );
    final maamoulReportRef = FirebaseFirestore.instance
        .collection(factory_name)
        .doc('maamoul_reports')
        .collection(validated_year.toString())
        .withConverter<MaamoulReport>(
          fromFirestore: (snapshot, _) =>
              MaamoulReport.fromJson(snapshot.data()!),
          toFirestore: (report, _) => report.toJson(),
        );
    final nrcReportRef = FirebaseFirestore.instance
        .collection(factory_name)
        .doc('nrc_reports')
        .collection(validated_year.toString())
        .withConverter<NRCReport>(
          fromFirestore: (snapshot, _) => NRCReport.fromJson(snapshot.data()!),
          toFirestore: (report, _) => report.toJson(),
        );
    final peopleReportRef = FirebaseFirestore.instance
        .collection(factory_name)
        .doc('people_reports')
        .collection(validated_year.toString())
        .withConverter<PeopleReport>(
          fromFirestore: (snapshot, _) =>
              PeopleReport.fromJson(snapshot.data()!),
          toFirestore: (report, _) => report.toJson(),
        );
    final overWeightReportRef = FirebaseFirestore.instance
        .collection(factory_name)
        .doc('overWeight_reports')
        .collection(validated_year.toString())
        .withConverter<OverWeightReport>(
          fromFirestore: (snapshot, _) =>
              OverWeightReport.fromJson(snapshot.data()!),
          toFirestore: (report, _) => report.toJson(),
        );
    final downTimeReportRef = FirebaseFirestore.instance
        .collection(factory_name)
        .doc('downtime_reports')
        .collection(validated_year.toString())
        .withConverter<DownTimeReport>(
          fromFirestore: (snapshot, _) =>
              DownTimeReport.fromJson(snapshot.data()!),
          toFirestore: (report, _) => report.toJson(),
        );
    final allRefs = [
      biscuitsReportRef,
      waferReportRef,
      maamoulReportRef,
      qualityReportRef,
      ehsReportRef,
      downTimeReportRef,
      peopleReportRef,
      nrcReportRef,
      overWeightReportRef,
    ];
    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      child: Scaffold(
        backgroundColor: KelloggColors.white,
        resizeToAvoidBottomInset: true,
        appBar: new AppBar(
          backgroundColor: KelloggColors.white.withOpacity(0),
          shadowColor: KelloggColors.white.withOpacity(0),
          leading: MyBackButton(
            color: KelloggColors.darkRed,
          ),
          title: Text(
            "Edit Reports",
            style: TextStyle(
                color: KelloggColors.darkRed,
                fontWeight: FontWeight.w300,
                fontSize: largeFontSize),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: mediumPadding),
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: minimumPadding),
                      child: Text(
                        "From : ",
                        style: TextStyle(
                          color: KelloggColors.darkRed,
                          fontSize: aboveMediumFontSize,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding:
                          const EdgeInsets.symmetric(horizontal: mediumPadding),
                      child: Container(
                        margin: EdgeInsets.symmetric(vertical: minimumPadding),
                        child: Column(
                          children: [
                            DropdownButton<String>(
                              hint: Text("day"),
                              value: _selectedDayFrom,
                              isExpanded: true,
                              items: days.map((String value) {
                                return new DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(
                                    value,
                                    style:
                                        TextStyle(color: KelloggColors.darkRed),
                                  ),
                                );
                              }).toList(),
                              onChanged: onFromDayChange,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding:
                          const EdgeInsets.symmetric(horizontal: mediumPadding),
                      child: Container(
                        margin: EdgeInsets.symmetric(vertical: minimumPadding),
                        child: Column(
                          children: [
                            DropdownButton<String>(
                              hint: Text("month"),
                              value: _selectedMonthFrom,
                              isExpanded: true,
                              items: months.map((String value) {
                                return new DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(
                                    value,
                                    style:
                                        TextStyle(color: KelloggColors.darkRed),
                                  ),
                                );
                              }).toList(),
                              onChanged: onFromMonthChange,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding:
                          const EdgeInsets.symmetric(horizontal: mediumPadding),
                      child: Container(
                        margin: EdgeInsets.symmetric(vertical: minimumPadding),
                        child: Column(
                          children: [
                            DropdownButton<String>(
                              hint: Text("year"),
                              value: _selectedYearFrom,
                              isExpanded: true,
                              items: years.map((String value) {
                                return new DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(
                                    value,
                                    style:
                                        TextStyle(color: KelloggColors.darkRed),
                                  ),
                                );
                              }).toList(),
                              onChanged: onFromYearChange,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: mediumPadding),
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: minimumPadding),
                      child: Text(
                        "To :     ",
                        style: TextStyle(
                          color: KelloggColors.darkRed,
                          fontSize: aboveMediumFontSize,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding:
                          const EdgeInsets.symmetric(horizontal: mediumPadding),
                      child: Container(
                        margin: EdgeInsets.symmetric(vertical: minimumPadding),
                        child: Column(
                          children: [
                            DropdownButton<String>(
                              hint: Text("day"),
                              value: _selectedDayTo,
                              isExpanded: true,
                              items: days.map((String value) {
                                return new DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(
                                    value,
                                    style:
                                        TextStyle(color: KelloggColors.darkRed),
                                  ),
                                );
                              }).toList(),
                              onChanged: onToDayChange,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding:
                          const EdgeInsets.symmetric(horizontal: mediumPadding),
                      child: Container(
                        margin: EdgeInsets.symmetric(vertical: minimumPadding),
                        child: Column(
                          children: [
                            DropdownButton<String>(
                              hint: Text("month"),
                              value: _selectedMonthTo,
                              isExpanded: true,
                              items: months.map((String value) {
                                return new DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(
                                    value,
                                    style:
                                        TextStyle(color: KelloggColors.darkRed),
                                  ),
                                );
                              }).toList(),
                              onChanged: onToMonthChange,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding:
                          const EdgeInsets.symmetric(horizontal: mediumPadding),
                      child: Container(
                        margin: EdgeInsets.symmetric(vertical: minimumPadding),
                        child: Column(
                          children: [
                            DropdownButton<String>(
                              hint: Text("year"),
                              value: _selectedYearTo,
                              isExpanded: true,
                              items: years.map((String value) {
                                return new DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(
                                    value,
                                    style:
                                        TextStyle(color: KelloggColors.darkRed),
                                  ),
                                );
                              }).toList(),
                              onChanged: onToYearChange,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(minimumPadding),
                child: Center(
                  child: RoundedButton(
                    btnText: 'Refresh Report',
                    color: KelloggColors.darkRed,
                    onPressed: () {
                      if (int.parse(_selectedYearTo) !=
                          int.parse(_selectedYearFrom))
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(
                              "Error : invalid interval (reports of same year only are allowed)"),
                        ));
                      else {
                        DateTime dateFrom = DateTime(
                            int.parse(_selectedYearTo),
                            int.parse(_selectedMonthFrom),
                            int.parse(_selectedDayFrom));
                        DateTime dateAfter = DateTime(
                            int.parse(_selectedYearTo),
                            int.parse(_selectedMonthTo),
                            int.parse(_selectedDayTo));
                        if (dateFrom.isBefore(dateAfter) ||
                            dateFrom.isAtSameMomentAs(dateAfter)) {
                          validated_day_from = int.parse(_selectedDayFrom);
                          validated_day_to = int.parse(_selectedDayTo);
                          validated_month_from = int.parse(_selectedMonthFrom);
                          validated_month_to = int.parse(_selectedMonthTo);
                          validated_year = int.parse(_selectedYearFrom);
                          print("type =" + type.toString());
                          allRefs[getRefIdx(type, refNum)]
                              .get()
                              .then((QuerySnapshot snapshot) {
                            setState(() {
                              switch (type) {
                                case PRODUCTION_REPORT:
                                  switch (refNum) {
                                    case BISCUIT_AREA:
                                      List<
                                              QueryDocumentSnapshot<
                                                  BiscuitsReport>>
                                          prodSnapshotReportsList =
                                          snapshot.docs as List<
                                              QueryDocumentSnapshot<
                                                  BiscuitsReport>>;
                                      HashMap<String, dynamic> ProdReportsList =
                                          BiscuitsReport
                                              .getAllReportsOfInterval(
                                        prodSnapshotReportsList,
                                        validated_month_from,
                                        validated_month_to,
                                        validated_day_from,
                                        validated_day_to,
                                        validated_year,
                                      );
                                      reportsTitlesList =
                                          ReportTitle.fullReportToTitleList(
                                              ProdReportsList);
                                      break;
                                    case WAFER_AREA:
                                      List<QueryDocumentSnapshot<WaferReport>>
                                          prodSnapshotReportsList =
                                          snapshot.docs as List<
                                              QueryDocumentSnapshot<
                                                  WaferReport>>;
                                      HashMap<String, dynamic> ProdReportsList =
                                          WaferReport.getAllReportsOfInterval(
                                        prodSnapshotReportsList,
                                        validated_month_from,
                                        validated_month_to,
                                        validated_day_from,
                                        validated_day_to,
                                        validated_year,
                                      );
                                      reportsTitlesList =
                                          ReportTitle.fullReportToTitleList(
                                              ProdReportsList);
                                      break;
                                    case MAAMOUL_AREA:
                                      List<QueryDocumentSnapshot<MaamoulReport>>
                                          prodSnapshotReportsList =
                                          snapshot.docs as List<
                                              QueryDocumentSnapshot<
                                                  MaamoulReport>>;
                                      HashMap<String, dynamic> ProdReportsList =
                                          MaamoulReport.getAllReportsOfInterval(
                                        prodSnapshotReportsList,
                                        validated_month_from,
                                        validated_month_to,
                                        validated_day_from,
                                        validated_day_to,
                                        validated_year,
                                      );
                                      reportsTitlesList =
                                          ReportTitle.fullReportToTitleList(
                                              ProdReportsList);
                                      break;
                                  }
                                  break;
                                case QFS_REPORT:
                                  List<QueryDocumentSnapshot<QfsReport>>
                                      qfsSnapshotReportsList = snapshot.docs
                                          as List<
                                              QueryDocumentSnapshot<QfsReport>>;
                                  HashMap<String, dynamic> QfsReportsList =
                                      QfsReport.getAllReportsOfInterval(
                                    qfsSnapshotReportsList,
                                    validated_month_from,
                                    validated_month_to,
                                    validated_day_from,
                                    validated_day_to,
                                    validated_year,
                                    refNum,
                                  );
                                  reportsTitlesList =
                                      ReportTitle.fullReportToTitleList(
                                          QfsReportsList);
                                  break;
                                case EHS_REPORT:
                                  List<QueryDocumentSnapshot<EhsReport>>
                                      ehsSnapshotReportsList = snapshot.docs
                                          as List<
                                              QueryDocumentSnapshot<EhsReport>>;
                                  HashMap<String, dynamic> ehsReportsList =
                                      EhsReport.getAllReportsOfInterval(
                                    ehsSnapshotReportsList,
                                    validated_month_from,
                                    validated_month_to,
                                    validated_day_from,
                                    validated_day_to,
                                    validated_year,
                                    refNum,
                                  );
                                  reportsTitlesList =
                                      ReportTitle.fullReportToTitleList(
                                          ehsReportsList);
                                  break;
                                case OVERWEIGHT_REPORT:
                                  List<QueryDocumentSnapshot<OverWeightReport>>
                                      overWeightSnapshotReportsList =
                                      snapshot.docs as List<
                                          QueryDocumentSnapshot<
                                              OverWeightReport>>;
                                  HashMap<String, dynamic>
                                      overweightReportsList =
                                      OverWeightReport.getAllReportsOfInterval(
                                    overWeightSnapshotReportsList,
                                    validated_month_from,
                                    validated_month_to,
                                    validated_day_from,
                                    validated_day_to,
                                    validated_year,
                                    refNum,
                                  );
                                  reportsTitlesList =
                                      ReportTitle.missingShiftReportToTitleList(
                                          overweightReportsList);
                                  break;
                                case PEOPLE_REPORT:
                                  List<QueryDocumentSnapshot<PeopleReport>>
                                      peopleSnapshotReportsList =
                                      snapshot.docs as List<
                                          QueryDocumentSnapshot<PeopleReport>>;
                                  HashMap<String, dynamic> peopleReportsList =
                                      PeopleReport.getAllReportsOfInterval(
                                    peopleSnapshotReportsList,
                                    validated_month_from,
                                    validated_month_to,
                                    validated_day_from,
                                    validated_day_to,
                                    validated_year,
                                    refNum,
                                  );
                                  reportsTitlesList =
                                      ReportTitle.missingLineReportToTitleList(
                                          peopleReportsList);
                                  break;
                                case NRC_REPORT:
                                  List<QueryDocumentSnapshot<NRCReport>>
                                      nrcSnapshotReportsList = snapshot.docs
                                          as List<
                                              QueryDocumentSnapshot<NRCReport>>;
                                  HashMap<String, dynamic> nrcReportsList =
                                      NRCReport.getAllReportsOfInterval(
                                    nrcSnapshotReportsList,
                                    validated_month_from,
                                    validated_month_to,
                                    validated_day_from,
                                    validated_day_to,
                                    validated_year,
                                    refNum,
                                  );
                                  reportsTitlesList =
                                      ReportTitle.missingLineReportToTitleList(
                                          nrcReportsList);
                                  break;
                                case DOWNTIME_REPORT:
                                  List<QueryDocumentSnapshot<DownTimeReport>>
                                      downTimeSnapshotReportsList =
                                      snapshot.docs as List<
                                          QueryDocumentSnapshot<
                                              DownTimeReport>>;
                                  HashMap<String, DownTimeReport>
                                      downTimeReportsList =
                                      DownTimeReport.getAllReportsOfInterval(
                                    downTimeSnapshotReportsList,
                                    validated_month_from,
                                    validated_month_to,
                                    validated_day_from,
                                    validated_day_to,
                                    validated_year,
                                    refNum,
                                  );
                                  dtReportsTitlesList = DownTimeReportTitle
                                      .downTimeReportToTitleList(
                                          downTimeReportsList);
                                  break;
                              }
                            });
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text("Report refreshed"),
                            ));
                          });
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(
                                "Error : invalid interval (from date must be <= to date)"),
                          ));
                        }
                      }
                    },
                  ),
                ),
              ),
              ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  physics: ClampingScrollPhysics(),
                  padding: const EdgeInsets.all(minimumPadding),
                  itemCount: type == DOWNTIME_REPORT
                      ? dtReportsTitlesList.length
                      : reportsTitlesList.length,
                  itemBuilder: (BuildContext context, int index) {
                    switch (type) {
                      case DOWNTIME_REPORT:
                        return ReportItem(
                          line: dtReportsTitlesList[index].line,
                          shift: dtReportsTitlesList[index].shift,
                          date: dtReportsTitlesList[index].date,
                          supName: dtReportsTitlesList[index].supName,
                          reportDetails:
                              dtReportsTitlesList[index].reportDetails,
                          reportID: dtReportsTitlesList[index].reportID,
                          refNum: refNum,
                          type: type,
                          rootCause: dtReportsTitlesList[index].rootCause,
                        );
                      default:
                        return ReportItem(
                          line: reportsTitlesList[index].line,
                          shift: reportsTitlesList[index].shift,
                          date: reportsTitlesList[index].date,
                          supName: reportsTitlesList[index].supName,
                          reportDetails: reportsTitlesList[index].reportDetails,
                          reportID: reportsTitlesList[index].reportID,
                          refNum: refNum,
                          type: type,
                          rootCause: "",
                        );
                    }
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
