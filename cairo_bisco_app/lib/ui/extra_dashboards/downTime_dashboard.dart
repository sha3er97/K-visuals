import 'dart:math';

import 'package:cairo_bisco_app/classes/CauseCount.dart';
import 'package:cairo_bisco_app/classes/DownTimeReport.dart';
import 'package:cairo_bisco_app/classes/utility_funcs/date_time_utility.dart';
import 'package:cairo_bisco_app/classes/values/TextStandards.dart';
import 'package:cairo_bisco_app/classes/values/colors.dart';
import 'package:cairo_bisco_app/classes/values/constants.dart';
import 'package:cairo_bisco_app/classes/values/form_values.dart';
import 'package:cairo_bisco_app/components/buttons/back_btn.dart';
import 'package:cairo_bisco_app/components/buttons/rounded_btn.dart';
import 'package:cairo_bisco_app/ui/error_success_screens/loading_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import '../../classes/Machine.dart';
import '../../classes/utility_funcs/other_excel_utilities.dart';
import '../../classes/utility_funcs/text_utilities.dart';
import '../../components/alert_dialog.dart';
import '../../components/charts/HorizontalBarChart.dart';
import '../../components/charts/LabeledPieChart.dart';

class DownTimeDashboard extends StatefulWidget {
  @override
  _DownTimeDashboardState createState() => _DownTimeDashboardState();
}

class _DownTimeDashboardState extends State<DownTimeDashboard> {
  String _selectedYearFrom = years[(int.parse(getYear())) - 2020],
      _selectedMonthFrom = months[(int.parse(getMonth())) - 1],
      _selectedDayFrom = days[(int.parse(getDay())) - 1],
      _selectedYearTo = years[(int.parse(getYear())) - 2020],
      _selectedMonthTo = months[(int.parse(getMonth())) - 1],
      _selectedDayTo = days[(int.parse(getDay())) - 1],
      chartLimit = causesDisplayDefaultLimit.toString();
  late int refNum = 3;

  late String isPlanned = plannedTypes[0],
      isStopped = y_nDesc[0],
      wfCategory = wfCategories[0],
      machine = allMachines[refNum][0],
      area = prodType[3],
      selectedProdLine = correspondingLines[refNum][0];

  bool showSpinner = false;
  bool _chartLimitValidate = false;

  VoidCallback? onAreaChange(val) {
    setState(() {
      area = val;
      refNum = prodType.indexOf(val);
      selectedProdLine = correspondingLines[refNum][0];
      machine = allMachines[refNum][0];
    });
    return null;
  }

  VoidCallback? onLineChange(val) {
    setState(() {
      selectedProdLine = val;
    });
    return null;
  }

  VoidCallback? onPlannedChange(val) {
    setState(() {
      isPlanned = val;
    });
    return null;
  }

  VoidCallback? onStoppedChange(val) {
    setState(() {
      isStopped = val;
    });
    return null;
  }

  VoidCallback? onWfCategoryChange(val) {
    setState(() {
      wfCategory = val;
    });
    return null;
  }

  VoidCallback? onMachineChange(val) {
    setState(() {
      machine = val;
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

  // int days_in_interval = 0;
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
  List<CauseCount> tempCausesList = [];
  List<CauseCount> tempYNList = [];
  List<CauseCount> tempLineDistributionList = [];
  List<QueryDocumentSnapshot<DownTimeReport>> downTimeReportReportsList = [];

  @override
  Widget build(BuildContext context) {
    final downTimeReportRef = FirebaseFirestore.instance
        .collection(factory_name)
        .doc('downtime_reports')
        .collection(validated_year.toString())
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
          title: Text('Down Time DashBoard',
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
                        "Machine : ",
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
                              value: machine,
                              isExpanded: true,
                              items: allMachines[refNum]
                                  .followedBy(Machine.packingMachinesList)
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
                              onChanged: onMachineChange,
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
                        "is Scheduled ? : ",
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
                              value: isPlanned,
                              isExpanded: true,
                              items: plannedTypes.map((String value) {
                                return new DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(
                                    value,
                                    style:
                                        TextStyle(color: KelloggColors.darkRed),
                                  ),
                                );
                              }).toList(),
                              onChanged: onPlannedChange,
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
                        "WF Category : ",
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
                              value: wfCategory,
                              isExpanded: true,
                              items: wfCategories.map((String value) {
                                return new DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(
                                    value,
                                    style:
                                        TextStyle(color: KelloggColors.darkRed),
                                  ),
                                );
                              }).toList(),
                              onChanged: onWfCategoryChange,
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
                        "is Stopped ? : ",
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
                              value: isStopped,
                              isExpanded: true,
                              items: y_nDesc.map((String value) {
                                return new DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(
                                    value,
                                    style:
                                        TextStyle(color: KelloggColors.darkRed),
                                  ),
                                );
                              }).toList(),
                              onChanged: onStoppedChange,
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
                          setState(() {
                            _chartLimitValidate = emptyField(chartLimit) &&
                                int.parse(chartLimit) > 0;
                            if (_chartLimitValidate)
                              chartLimit = causesDisplayDefaultLimit.toString();

                            tempCausesList =
                                DownTimeReport.getCausesCountsOfInterval(
                                    downTimeReportReportsList,
                                    validated_month_from,
                                    validated_month_to,
                                    validated_day_from,
                                    validated_day_to,
                                    validated_year,
                                    refNum,
                                    isPlanned,
                                    machine,
                                    wfCategory,
                                    y_nDesc.indexOf(isStopped),
                                    correspondingLines[refNum]
                                        .indexOf(selectedProdLine));
                            tempYNList =
                                DownTimeReport.getYNClassificationOfInterval(
                                    downTimeReportReportsList,
                                    validated_month_from,
                                    validated_month_to,
                                    validated_day_from,
                                    validated_day_to,
                                    validated_year,
                                    refNum,
                                    isPlanned,
                                    machine,
                                    wfCategory,
                                    y_nDesc.indexOf(isStopped),
                                    correspondingLines[refNum]
                                        .indexOf(selectedProdLine));

                            tempLineDistributionList =
                                DownTimeReport.getLineDistributionOfInterval(
                                    downTimeReportReportsList,
                                    validated_month_from,
                                    validated_month_to,
                                    validated_day_from,
                                    validated_day_to,
                                    validated_year,
                                    refNum,
                                    isPlanned,
                                    machine,
                                    wfCategory,
                                    y_nDesc.indexOf(isStopped),
                                    correspondingLines[refNum]
                                        .indexOf(selectedProdLine));
                          });
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text("Report refreshed"),
                          ));
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
              StreamBuilder<QuerySnapshot>(
                  stream: downTimeReportRef.snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> downTimeSnapshot) {
                    if (downTimeSnapshot.hasError) {
                      return ErrorMessageHeading('Something went wrong');
                    } else if (downTimeSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return ColorLoader();
                    } else {
                      try {
                        downTimeReportReportsList = downTimeSnapshot.data!.docs
                            as List<QueryDocumentSnapshot<DownTimeReport>>;
                        return SingleChildScrollView(
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: defaultPadding),
                                    child: Container(
                                      margin: EdgeInsets.symmetric(
                                          vertical: minimumPadding),
                                      child: Text(
                                        "Chart Limit Of Causes",
                                        style: TextStyle(
                                          color: KelloggColors.darkRed,
                                          fontSize: mediumFontSize,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: mediumPadding),
                                      child: Container(
                                        margin: EdgeInsets.symmetric(
                                            vertical: minimumPadding),
                                        child: Column(
                                          children: [
                                            TextFormField(
                                              initialValue: chartLimit,
                                              style: TextStyle(
                                                  color: KelloggColors.darkRed,
                                                  fontWeight: FontWeight.w400),
                                              keyboardType:
                                                  TextInputType.number,
                                              inputFormatters: <
                                                  TextInputFormatter>[
                                                FilteringTextInputFormatter
                                                    .digitsOnly
                                              ],
                                              cursorColor: Colors.white,
                                              obscureText: false,
                                              decoration: InputDecoration(
                                                border: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color:
                                                          KelloggColors.darkRed,
                                                      width:
                                                          textFieldBorderRadius),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(
                                                              textFieldRadius)),
                                                ),
                                                errorText: _chartLimitValidate
                                                    ? missingValueErrorText
                                                    : null,
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color:
                                                          KelloggColors.yellow,
                                                      width:
                                                          textFieldFocusedBorderRadius),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(
                                                              textFieldRadius)),
                                                ),
                                              ),
                                              onChanged: (value) {
                                                chartLimit = value;
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                height: 50.0 *
                                        min(tempCausesList.length,
                                            int.parse(chartLimit)) +
                                    125,
                                padding: EdgeInsets.all(defaultPadding),
                                child: Card(
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.all(minimumPadding),
                                    child: Column(
                                      children: [
                                        subHeading("Top Root Causes"),
                                        Expanded(
                                          child: HorizontalBarChart
                                              .withTop10Causes(
                                            tempCausesList,
                                            int.parse(chartLimit),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                        height: defaultChartHeight,
                                        width: defaultChartWidth,
                                        padding: EdgeInsets.all(defaultPadding),
                                        child: Card(
                                          child: Padding(
                                            padding: const EdgeInsets.all(
                                                minimumPadding),
                                            child: Column(
                                              children: [
                                                aboveMediumHeading(
                                                    "Down Time Line Distribution"),
                                                SizedBox(
                                                  height: defaultPadding,
                                                ),
                                                Expanded(
                                                  child: PieOutsideLabelChart
                                                      .withFiveShades(
                                                          tempLineDistributionList),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Container(
                                        height: defaultChartHeight,
                                        width: defaultChartWidth,
                                        padding: EdgeInsets.all(defaultPadding),
                                        child: Card(
                                          child: Padding(
                                            padding: const EdgeInsets.all(
                                                minimumPadding),
                                            child: Column(
                                              children: [
                                                aboveMediumHeading(
                                                    "Did the line stop ?"),
                                                SizedBox(
                                                  height: minimumPadding,
                                                ),
                                                Expanded(
                                                  child: PieOutsideLabelChart
                                                      .withYNClassificationData(
                                                          tempYNList),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(height: defaultPadding),
                              Padding(
                                padding: const EdgeInsets.all(minimumPadding),
                                child: Center(
                                  child: RoundedButton(
                                      btnText: 'Export Detailed Report',
                                      color: KelloggColors.green,
                                      onPressed: () {
                                        if (int.parse(_selectedYearTo) !=
                                            int.parse(_selectedYearFrom))
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
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
                                              dateFrom.isAtSameMomentAs(
                                                  dateAfter)) {
                                            calculateInterval();
                                            OtherExcelUtilities util =
                                                OtherExcelUtilities(
                                                    refNum: DOWNTIME_REPORT);
                                            util.insertHeaders();
                                            downTimeReportRef.get().then(
                                                (QuerySnapshot dtSnapshot) {
                                              try {
                                                List<
                                                        QueryDocumentSnapshot<
                                                            DownTimeReport>>
                                                    dtReportsList =
                                                    dtSnapshot.docs as List<
                                                        QueryDocumentSnapshot<
                                                            DownTimeReport>>;
                                                List<DownTimeReport>
                                                    allReports = DownTimeReport
                                                        .getAllReportsOfInterval(
                                                  dtReportsList,
                                                  validated_month_from,
                                                  validated_month_to,
                                                  validated_day_from,
                                                  validated_day_to,
                                                  validated_year,
                                                  TOTAL_PLANT,
                                                  //ALL_LINES,
                                                ).values.toList();

                                                util.insertDtReportRows(
                                                    context, allReports);

                                                util.saveExcelFile(
                                                    context,
                                                    validated_day_from
                                                        .toString(),
                                                    validated_day_to.toString(),
                                                    validated_month_from
                                                        .toString(),
                                                    validated_month_to
                                                        .toString());
                                              } catch (e) {
                                                showExcelAlertDialog(
                                                    context, false, "");
                                              }
                                            });
                                          }
                                        }
                                      }),
                                ),
                              ),
                            ],
                          ),
                        );
                      } catch (e) {
                        print(e);
                        return ErrorMessageHeading('Something went wrong');
                      }
                    }
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
