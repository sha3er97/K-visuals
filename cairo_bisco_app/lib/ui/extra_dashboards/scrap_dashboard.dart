import 'package:cairo_bisco_app/classes/CauseCount.dart';
import 'package:cairo_bisco_app/classes/values/TextStandards.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import '../../classes/BiscuitsReport.dart';
import '../../classes/MaamoulReport.dart';
import '../../classes/MiniProductionReport.dart';
import '../../classes/OverWeightReport.dart';
import '../../classes/Plans.dart';
import '../../classes/WaferReport.dart';
import '../../classes/utility_funcs/calculations_utility.dart';
import '../../classes/utility_funcs/date_time_utility.dart';
import '../../classes/values/colors.dart';
import '../../classes/values/constants.dart';
import '../../classes/values/form_values.dart';
import '../../components/buttons/back_btn.dart';
import '../../components/buttons/rounded_btn.dart';
import '../../components/charts/LabeledPieChart.dart';

class ScrapDashboard extends StatefulWidget {
  @override
  _ScrapDashboardState createState() => _ScrapDashboardState();
}

class _ScrapDashboardState extends State<ScrapDashboard> {
  String _selectedYearFrom = years[(int.parse(getYear())) - 2020],
      _selectedMonthFrom = months[(int.parse(getMonth())) - 1],
      _selectedDayFrom = days[(int.parse(getDay())) - 1],
      _selectedYearTo = years[(int.parse(getYear())) - 2020],
      _selectedMonthTo = months[(int.parse(getMonth())) - 1],
      _selectedDayTo = days[(int.parse(getDay())) - 1];
  late int refNum = 3;
  late String sku = correspondingSkus[refNum][0],
      area = prodType[3],
      selectedProdLine = correspondingLines[refNum][0];

  bool showSpinner = false;

  VoidCallback? onAreaChange(val) {
    setState(() {
      area = val;
      refNum = prodType.indexOf(val);
      selectedProdLine = correspondingLines[refNum][0];
      sku = correspondingSkus[refNum][0];
    });
    return null;
  }

  VoidCallback? onLineChange(val) {
    setState(() {
      selectedProdLine = val;
    });
    return null;
  }

  VoidCallback? onSKUChange(val) {
    setState(() {
      sku = val;
    });
    return null;
  }

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

  void calculateInterval() {
    // DateTime dateFrom = DateTime(int.parse(_selectedYearTo),
    //     int.parse(_selectedMonthFrom), int.parse(_selectedDayFrom));
    // DateTime dateAfter = DateTime(int.parse(_selectedYearTo),
    //     int.parse(_selectedMonthTo), int.parse(_selectedDayTo));

    // days_in_interval = dateFrom.difference(dateAfter).inDays.abs();
    validated_day_from = int.parse(_selectedDayFrom);
    validated_day_to = int.parse(_selectedDayTo);
    validated_month_from = int.parse(_selectedMonthFrom);
    validated_month_to = int.parse(_selectedMonthTo);
    validated_year = int.parse(_selectedYearFrom);
  }

  //temp variables
  //DownTimeReport temp_downTime = DownTimeReport.getEmptyReport();
  // List<QueryDocumentSnapshot<DownTimeReport>> downTimeReportReportsList = [];
  MiniProductionReport temp_wafer_report =
          MiniProductionReport.getEmptyReport(),
      temp_maamoul_report = MiniProductionReport.getEmptyReport(),
      temp_biscuits_report = MiniProductionReport.getEmptyReport(),
      all_reports = MiniProductionReport.getEmptyReport();
  List<MiniProductionReport> reportsList = [
    MiniProductionReport.getEmptyReport(),
    MiniProductionReport.getEmptyReport(),
    MiniProductionReport.getEmptyReport(),
    MiniProductionReport.getEmptyReport(),
  ];
  OverWeightReport overweightTempReport = OverWeightReport.getEmptyReport();
  List<List<CauseCount>> allScrapDistribution = [
    [],
    [],
    [],
    [],
  ];

  @override
  Widget build(BuildContext context) {
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
    final overWeightReportRef = FirebaseFirestore.instance
        .collection(factory_name)
        .doc('overWeight_reports')
        .collection(validated_year.toString())
        .withConverter<OverWeightReport>(
          fromFirestore: (snapshot, _) =>
              OverWeightReport.fromJson(snapshot.data()!),
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
          title: Text('Scrap DashBoard',
              style: TextStyle(
                color: KelloggColors.darkRed,
                fontWeight: FontWeight.w600,
              )),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: defaultPadding),
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: minimumPadding),
                      child: Text(
                        "From : ",
                        style: TextStyle(
                            color: KelloggColors.darkRed,
                            fontSize: aboveMediumFontSize,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 1.2),
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
                        const EdgeInsets.symmetric(horizontal: defaultPadding),
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: minimumPadding),
                      child: Text(
                        "To :     ",
                        style: TextStyle(
                            color: KelloggColors.darkRed,
                            fontSize: aboveMediumFontSize,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 1.2),
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
              Row(
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: mediumPadding),
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: minimumPadding),
                      child: Text(
                        "Area : ",
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
                            DropdownButtonFormField<String>(
                              // decoration: InputDecoration(labelText: 'اختر'),
                              value: area,
                              isExpanded: true,
                              items: prodType.map((String value) {
                                return new DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(
                                    value,
                                    style:
                                        TextStyle(color: KelloggColors.darkRed),
                                  ),
                                );
                              }).toList(),
                              onChanged: onAreaChange,
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
                        "Line : ",
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
                            DropdownButtonFormField<String>(
                              // decoration: InputDecoration(labelText: 'اختر'),
                              value: selectedProdLine,
                              isExpanded: true,
                              items: correspondingLines[refNum]
                                  .map((String value) {
                                return new DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(
                                    value,
                                    style:
                                        TextStyle(color: KelloggColors.darkRed),
                                  ),
                                );
                              }).toList(),
                              onChanged: onLineChange,
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
                        "SKU : ",
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
                            DropdownButtonFormField<String>(
                              // decoration: InputDecoration(labelText: 'اختر'),
                              value: sku,
                              isExpanded: true,
                              items:
                                  correspondingSkus[refNum].map((String value) {
                                return new DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(
                                    value,
                                    style:
                                        TextStyle(color: KelloggColors.darkRed),
                                  ),
                                );
                              }).toList(),
                              onChanged: onSKUChange,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: defaultPadding),
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
                          calculateInterval();

                          overWeightReportRef
                              .get()
                              .then((QuerySnapshot overweightSnapshot) {
                            List<QueryDocumentSnapshot<OverWeightReport>>
                                overWeightReportsList =
                                overweightSnapshot.docs as List<
                                    QueryDocumentSnapshot<OverWeightReport>>;
                            overweightTempReport =
                                OverWeightReport.getScrapDashboardSummary(
                              overWeightReportsList,
                              validated_month_from,
                              validated_month_to,
                              validated_day_from,
                              validated_day_to,
                              validated_year,
                              refNum,
                              correspondingLines[refNum]
                                  .indexOf(selectedProdLine),
                              sku,
                            );
                            biscuitsReportRef
                                .get()
                                .then((QuerySnapshot biscuitsSnapshot) {
                              waferReportRef
                                  .get()
                                  .then((QuerySnapshot waferSnapshot) {
                                maamoulReportRef
                                    .get()
                                    .then((QuerySnapshot maamoulSnapshot) {
                                  setState(() {
                                    showSpinner = true;
                                    List<QueryDocumentSnapshot<BiscuitsReport>>
                                        biscuitsReportsList =
                                        biscuitsSnapshot.docs as List<
                                            QueryDocumentSnapshot<
                                                BiscuitsReport>>;

                                    List<QueryDocumentSnapshot<WaferReport>>
                                        waferReportsList =
                                        waferSnapshot.docs as List<
                                            QueryDocumentSnapshot<WaferReport>>;

                                    List<QueryDocumentSnapshot<MaamoulReport>>
                                        maamoulReportsList =
                                        maamoulSnapshot.docs as List<
                                            QueryDocumentSnapshot<
                                                MaamoulReport>>;

                                    temp_biscuits_report =
                                        BiscuitsReport.getScrapDashboardSummary(
                                      biscuitsReportsList,
                                      validated_month_from,
                                      validated_month_to,
                                      validated_day_from,
                                      validated_day_to,
                                      validated_year,
                                      correspondingLines[refNum]
                                          .indexOf(selectedProdLine),
                                      sku,
                                    );
                                    allScrapDistribution[BISCUIT_AREA] =
                                        BiscuitsReport.getScrapDistribution(
                                      biscuitsReportsList,
                                      validated_month_from,
                                      validated_month_to,
                                      validated_day_from,
                                      validated_day_to,
                                      validated_year,
                                      correspondingLines[refNum]
                                          .indexOf(selectedProdLine),
                                      sku,
                                    );

                                    temp_wafer_report =
                                        WaferReport.getScrapDashboardSummary(
                                      waferReportsList,
                                      validated_month_from,
                                      validated_month_to,
                                      validated_day_from,
                                      validated_day_to,
                                      validated_year,
                                      correspondingLines[refNum]
                                          .indexOf(selectedProdLine),
                                      sku,
                                    );
                                    allScrapDistribution[WAFER_AREA] =
                                        WaferReport.getScrapDistribution(
                                      waferReportsList,
                                      validated_month_from,
                                      validated_month_to,
                                      validated_day_from,
                                      validated_day_to,
                                      validated_year,
                                      correspondingLines[refNum]
                                          .indexOf(selectedProdLine),
                                      sku,
                                    );
                                    temp_maamoul_report =
                                        MaamoulReport.getScrapDashboardSummary(
                                      maamoulReportsList,
                                      validated_month_from,
                                      validated_month_to,
                                      validated_day_from,
                                      validated_day_to,
                                      validated_year,
                                      correspondingLines[refNum]
                                          .indexOf(selectedProdLine),
                                      sku,
                                    );
                                    allScrapDistribution[MAAMOUL_AREA] =
                                        MaamoulReport.getScrapDistribution(
                                      maamoulReportsList,
                                      validated_month_from,
                                      validated_month_to,
                                      validated_day_from,
                                      validated_day_to,
                                      validated_year,
                                      correspondingLines[refNum]
                                          .indexOf(selectedProdLine),
                                      sku,
                                    );
                                    all_reports =
                                        MiniProductionReport.mergeReports([
                                      temp_biscuits_report,
                                      temp_wafer_report,
                                      temp_maamoul_report
                                    ]);
                                    allScrapDistribution[3] =
                                        CauseCount.mergeCauseCounts([
                                      allScrapDistribution[BISCUIT_AREA],
                                      allScrapDistribution[WAFER_AREA],
                                      allScrapDistribution[MAAMOUL_AREA]
                                    ]);
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                      content: Text("Report refreshed"),
                                    ));
                                    reportsList = [
                                      temp_biscuits_report,
                                      temp_wafer_report,
                                      temp_maamoul_report,
                                      all_reports,
                                    ];
                                    showSpinner = false;
                                  });
                                });
                              });
                            });
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
              //dashboard parts
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Center(
                        child: Text('Scrap',
                            style: TextStyle(
                                fontSize: aboveMediumFontSize,
                                fontWeight: FontWeight.bold,
                                color: KelloggColors.darkRed)),
                      ),
                      SizedBox(height: minimumPadding),
                      Center(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(BoxImageBorder),
                          child: ConstrainedBox(
                            constraints:
                                BoxConstraints.tightFor(height: kpiBoxHeight),
                            child: ElevatedButton.icon(
                              label: Text("Wt. " +
                                  reportsList[refNum].scrap.toString() +
                                  " Kg."),
                              style: ElevatedButton.styleFrom(
                                textStyle: TextStyle(
                                    fontSize: largeButtonFont,
                                    fontFamily: 'MyFont'),
                                primary: reportsList[refNum].scrap >
                                        Plans.universalTargetScrap
                                    ? KelloggColors.cockRed
                                    : KelloggColors.green,
                              ),
                              icon: ClipRRect(
                                borderRadius:
                                    BorderRadius.circular(iconImageBorder),
                                child: Container(
                                  height: mediumIconSize,
                                  width: mediumIconSize,
                                  padding: EdgeInsets.all(minimumPadding / 2),
                                  child: new Image.asset(
                                    'images/' +
                                        (reportsList[refNum].scrap >
                                                Plans.universalTargetScrap
                                            ? "down"
                                            : "up") +
                                        '.png',
                                  ),
                                ),
                              ),
                              onPressed: () {},
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: minimumPadding),
                      Center(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(BoxImageBorder),
                          child: ConstrainedBox(
                            constraints:
                                BoxConstraints.tightFor(height: kpiBoxHeight),
                            child: ElevatedButton(
                              child: Text("Percentage : " +
                                  calculateScrapPercentFromMiniReport(
                                          reportsList[refNum],
                                          overweightTempReport.percent)
                                      .toStringAsFixed(2) +
                                  " %"),
                              style: ElevatedButton.styleFrom(
                                textStyle: TextStyle(
                                    fontSize: largeButtonFont,
                                    fontFamily: 'MyFont'),
                                primary: reportsList[refNum].rework >
                                        Plans.universalTargetScrap
                                    ? KelloggColors.cockRed
                                    : KelloggColors.green,
                              ),
                              onPressed: () {},
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: defaultPadding),
                  myVerticalDivider(KelloggColors.darkRed),
                  SizedBox(width: defaultPadding),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Center(
                        child: Text('Rework',
                            style: TextStyle(
                                fontSize: aboveMediumFontSize,
                                fontWeight: FontWeight.bold,
                                color: KelloggColors.darkRed)),
                      ),
                      SizedBox(height: minimumPadding),
                      Center(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(BoxImageBorder),
                          child: ConstrainedBox(
                            constraints:
                                BoxConstraints.tightFor(height: kpiBoxHeight),
                            child: ElevatedButton.icon(
                              label: Text("Wt. " +
                                  reportsList[refNum].rework.toString() +
                                  " Kg."),
                              style: ElevatedButton.styleFrom(
                                textStyle: TextStyle(
                                    fontSize: largeButtonFont,
                                    fontFamily: 'MyFont'),
                                primary: reportsList[refNum].rework >
                                        Plans.universalTargetScrap
                                    ? KelloggColors.cockRed
                                    : KelloggColors.green,
                              ),
                              icon: ClipRRect(
                                borderRadius:
                                    BorderRadius.circular(iconImageBorder),
                                child: Container(
                                  height: mediumIconSize,
                                  width: mediumIconSize,
                                  padding: EdgeInsets.all(minimumPadding / 2),
                                  child: new Image.asset(
                                    'images/' +
                                        (reportsList[refNum].rework >
                                                Plans.universalTargetScrap
                                            ? "down"
                                            : "up") +
                                        '.png',
                                  ),
                                ),
                              ),
                              onPressed: () {},
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: minimumPadding),
                      Center(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(BoxImageBorder),
                          child: ConstrainedBox(
                            constraints:
                                BoxConstraints.tightFor(height: kpiBoxHeight),
                            child: ElevatedButton(
                              child: Text("Percentage : " +
                                  calculateReworkPercentFromMiniReport(
                                          reportsList[refNum],
                                          overweightTempReport.percent)
                                      .toStringAsFixed(2) +
                                  " %"),
                              style: ElevatedButton.styleFrom(
                                textStyle: TextStyle(
                                    fontSize: largeButtonFont,
                                    fontFamily: 'MyFont'),
                                primary: reportsList[refNum].rework >
                                        Plans.universalTargetScrap
                                    ? KelloggColors.cockRed
                                    : KelloggColors.green,
                              ),
                              onPressed: () {},
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: defaultPadding),
                  myVerticalDivider(KelloggColors.darkRed),
                  SizedBox(width: defaultPadding),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Center(
                        child: Text('OverWeight',
                            style: TextStyle(
                                fontSize: aboveMediumFontSize,
                                fontWeight: FontWeight.bold,
                                color: KelloggColors.darkRed)),
                      ),
                      SizedBox(height: defaultPadding),
                      Center(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(BoxImageBorder),
                          child: ConstrainedBox(
                            constraints:
                                BoxConstraints.tightFor(height: kpiBoxHeight),
                            child: ElevatedButton.icon(
                              label: Text("Wt. " +
                                  calculateOverweightKgFromMiniReport(
                                          reportsList[refNum],
                                          overweightTempReport.percent)
                                      .toString() +
                                  " Kg."),
                              style: ElevatedButton.styleFrom(
                                textStyle: TextStyle(
                                    fontSize: largeButtonFont,
                                    fontFamily: 'MyFont'),
                                primary: BadOverweightDriver(
                                        overweightTempReport.percent)
                                    ? KelloggColors.cockRed
                                    : KelloggColors.green,
                              ),
                              icon: ClipRRect(
                                borderRadius:
                                    BorderRadius.circular(iconImageBorder),
                                child: Container(
                                  height: mediumIconSize,
                                  width: mediumIconSize,
                                  padding: EdgeInsets.all(minimumPadding / 2),
                                  child: new Image.asset(
                                    'images/' +
                                        (BadOverweightDriver(
                                                overweightTempReport.percent)
                                            ? "down"
                                            : "up") +
                                        '.png',
                                  ),
                                ),
                              ),
                              onPressed: () {},
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: minimumPadding),
                      Center(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(BoxImageBorder),
                          child: ConstrainedBox(
                            constraints:
                                BoxConstraints.tightFor(height: kpiBoxHeight),
                            child: ElevatedButton(
                              child: Text("Percentage : " +
                                  overweightTempReport.percent
                                      .toStringAsFixed(2) +
                                  " %"),
                              style: ElevatedButton.styleFrom(
                                textStyle: TextStyle(
                                    fontSize: largeButtonFont,
                                    fontFamily: 'MyFont'),
                                primary: BadOverweightDriver(
                                        overweightTempReport.percent)
                                    ? KelloggColors.cockRed
                                    : KelloggColors.green,
                              ),
                              onPressed: () {},
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: defaultPadding),
              Container(
                height: largeChartHeight,
                width: largeChartWidth,
                child: Card(
                  child: Column(
                    children: [
                      aboveMediumHeading("Scrap Distribution"),
                      SizedBox(
                        height: minimumPadding,
                      ),
                      Expanded(
                        child: PieOutsideLabelChart.withTenShades(
                            allScrapDistribution[refNum]),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(height: defaultPadding),
            ],
          ),
        ),
      ),
    );
  }
}
