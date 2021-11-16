import 'package:cairo_bisco_app/classes/QfsReport.dart';
import 'package:cairo_bisco_app/classes/utility_funcs/date_utility.dart';
import 'package:cairo_bisco_app/classes/values/TextStandards.dart';
import 'package:cairo_bisco_app/classes/values/colors.dart';
import 'package:cairo_bisco_app/classes/values/constants.dart';
import 'package:cairo_bisco_app/classes/values/form_values.dart';
import 'package:cairo_bisco_app/components/buttons/back_btn.dart';
import 'package:cairo_bisco_app/components/buttons/rounded_btn.dart';
import 'package:cairo_bisco_app/components/qfs_ehs_wigdets/1kpi_good_bad_indicator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class QfsDetailedReport extends StatefulWidget {
  @override
  _QfsDetailedReportState createState() => _QfsDetailedReportState();
}

class _QfsDetailedReportState extends State<QfsDetailedReport> {
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
  }

  VoidCallback? onFromMonthChange(val) {
    setState(() {
      _selectedMonthFrom = val;
    });
  }

  VoidCallback? onFromDayChange(val) {
    setState(() {
      _selectedDayFrom = val;
    });
  }

  VoidCallback? onToYearChange(val) {
    setState(() {
      _selectedYearTo = val;
    });
  }

  VoidCallback? onToMonthChange(val) {
    setState(() {
      _selectedMonthTo = val;
    });
  }

  VoidCallback? onToDayChange(val) {
    setState(() {
      _selectedDayTo = val;
    });
  }

  int days_in_interval = 0;
  int validated_day_from = int.parse(getDay()),
      validated_day_to = int.parse(getDay()),
      validated_month_from = int.parse(getMonth()),
      validated_month_to = int.parse(getMonth()),
      validated_year = int.parse(getYear());

  void calculateInterval() {
    DateTime dateFrom = DateTime(int.parse(_selectedYearTo),
        int.parse(_selectedMonthFrom), int.parse(_selectedDayFrom));
    DateTime dateAfter = DateTime(int.parse(_selectedYearTo),
        int.parse(_selectedMonthTo), int.parse(_selectedDayTo));

    days_in_interval = dateFrom.difference(dateAfter).inDays.abs();
    validated_day_from = int.parse(_selectedDayFrom);
    validated_day_to = int.parse(_selectedDayTo);
    validated_month_from = int.parse(_selectedMonthFrom);
    validated_month_to = int.parse(_selectedMonthTo);
    validated_year = int.parse(_selectedYearFrom);
  }

  //temp variables
  QfsReport temp_qfs = QfsReport.getEmptyReport();
  List<QueryDocumentSnapshot<QfsReport>> reportsList = [];

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
          title: Text('QFS',
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
                            temp_qfs = QfsReport.getFilteredReportOfInterval(
                                reportsList,
                                validated_month_from,
                                validated_month_to,
                                validated_day_from,
                                validated_day_to,
                                validated_year,
                                -1,
                                -1);
                          });
                          // print("debug :: quality incidents = " +
                          //     temp_qfs.quality_incidents.toString());
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
                stream: qualityReportRef.snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return ErrorMessageHeading('Something went wrong');
                  } else if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return ErrorMessageHeading('Loading');
                  } else {
                    try {
                      reportsList = snapshot.data!.docs
                          as List<QueryDocumentSnapshot<QfsReport>>;
                      // print("qfs ::" + reportsList.length.toString());
                      return Column(
                        children: [
                          SizedBox(height: defaultPadding),
                          IntrinsicHeight(
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: minimumPadding),
                                  child: Container(
                                    margin: EdgeInsets.symmetric(
                                        vertical: minimumPadding),
                                    child: KPI1GoodBadIndicator(
                                      circleColor:
                                          temp_qfs.quality_incidents > 0
                                              ? KelloggColors.cockRed
                                              : KelloggColors.green,
                                      title: 'Quality\nIncidents',
                                      circleText:
                                          temp_qfs.quality_incidents.toString(),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: minimumPadding),
                                  child: Container(
                                    margin: EdgeInsets.symmetric(
                                        vertical: minimumPadding),
                                    child: KPI1GoodBadIndicator(
                                      circleColor:
                                          temp_qfs.food_safety_incidents > 0
                                              ? KelloggColors.cockRed
                                              : KelloggColors.green,
                                      title: 'Food Safety\nIncidents',
                                      circleText: temp_qfs.food_safety_incidents
                                          .toString(),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: defaultPadding),
                          IntrinsicHeight(
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: minimumPadding),
                                  child: Container(
                                    margin: EdgeInsets.symmetric(
                                        vertical: minimumPadding),
                                    child: KPI1GoodBadIndicator(
                                      circleColor: temp_qfs.ccp_failure > 0
                                          ? KelloggColors.cockRed
                                          : KelloggColors.green,
                                      title: 'CCP\nFailures',
                                      circleText:
                                          temp_qfs.ccp_failure.toString(),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: minimumPadding),
                                  child: Container(
                                    margin: EdgeInsets.symmetric(
                                        vertical: minimumPadding),
                                    child: KPI1GoodBadIndicator(
                                      circleColor: temp_qfs.pes_index == 3
                                          ? KelloggColors.cockRed
                                          : temp_qfs.pes_index == 2
                                              ? KelloggColors.yellow
                                              : KelloggColors.green,
                                      title: 'PES\n(B&C Defects)',
                                      circleText: Pes[temp_qfs.pes_index],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: defaultPadding),
                          IntrinsicHeight(
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: minimumPadding),
                                  child: Container(
                                    margin: EdgeInsets.symmetric(
                                        vertical: minimumPadding),
                                    child: KPI1GoodBadIndicator(
                                      circleColor:
                                          temp_qfs.consumer_complaints > 0
                                              ? KelloggColors.cockRed
                                              : KelloggColors.green,
                                      title: 'Consumer\nComplaints',
                                      circleText: temp_qfs.consumer_complaints
                                          .toString(),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: minimumPadding),
                                  child: Container(
                                    margin: EdgeInsets.symmetric(
                                        vertical: minimumPadding),
                                    child: KPI1GoodBadIndicator(
                                      circleColor: temp_qfs.g6_index == 2
                                          ? KelloggColors.cockRed
                                          : temp_qfs.g6_index == 1
                                              ? KelloggColors.yellow
                                              : KelloggColors.green,
                                      title: 'G6 Escalation',
                                      circleText: G6[temp_qfs.g6_index],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: defaultPadding),
                        ],
                      );
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
      ),
    );
  }
}
