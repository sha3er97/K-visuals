import 'package:cairo_bisco_app/classes/Plans.dart';
import 'package:cairo_bisco_app/classes/values/colors.dart';
import 'package:cairo_bisco_app/classes/values/constants.dart';
import 'package:cairo_bisco_app/classes/values/form_values.dart';
import 'package:cairo_bisco_app/components/buttons/back_btn.dart';
import 'package:cairo_bisco_app/components/buttons/rounded_btn.dart';
import 'package:cairo_bisco_app/components/qfs_ehs_wigdets/1kpi_good_bad_indicator.dart';
import 'package:cairo_bisco_app/components/utility_funcs/date_utility.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class EhsReport extends StatefulWidget {
  @override
  _EhsReportState createState() => _EhsReportState();
}

class _EhsReportState extends State<EhsReport> {
  String _selectedYearFrom = years[(int.parse(getYear())) - 2020];
  String _selectedMonthFrom = months[(int.parse(getMonth())) - 1];
  String _selectedDayFrom = days[(int.parse(getDay())) - 1];
  String _selectedYearTo = years[(int.parse(getYear())) - 2020];
  String _selectedMonthTo = months[(int.parse(getMonth())) - 1];
  String _selectedDayTo = days[(int.parse(getDay())) - 1];

  bool showSpinner = false;
  int firstAid_incidents = 0,
      lostTime_incidents = 0,
      recordable_incidents = 0,
      nearMiss = 0,
      risk_assessment = 6;
  String s7_tours = S7[1];

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

  void calculateInterval() {
    // assume dates are validated (yearTo>yearFrom)
    int modified_to_month = int.parse(_selectedMonthTo) +
        (int.parse(_selectedYearTo) - int.parse(_selectedYearFrom)) * 12;
    // modified_to_month is now > from_month for sure
    int modified_to_day = int.parse(_selectedDayTo) +
        (modified_to_month - int.parse(_selectedMonthFrom)) * 12;
    // modified_to_day is now > from_day for sure
    days_in_interval = modified_to_day - int.parse(_selectedDayFrom);
  }

  bool validateInterval() {
    if (int.parse(_selectedYearTo) < int.parse(_selectedYearFrom))
      return false;
    else if ((int.parse(_selectedYearTo) == int.parse(_selectedYearFrom)) &&
        (int.parse(_selectedMonthTo) < int.parse(_selectedMonthFrom)))
      return false;
    else if ((int.parse(_selectedYearTo) == int.parse(_selectedYearFrom)) &&
        (int.parse(_selectedMonthTo) == int.parse(_selectedMonthFrom)) &&
        (int.parse(_selectedDayTo) < int.parse(_selectedYearFrom)))
      return false;
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      child: Scaffold(
        backgroundColor: KelloggColors.white,
        resizeToAvoidBottomInset: true,
        appBar: new AppBar(
          backgroundColor: KelloggColors.white.withOpacity(0),
          shadowColor: KelloggColors.white.withOpacity(0),
          leading: MyBackButton(),
          title: Text('EHS',
              style: TextStyle(
                  color: KelloggColors.darkRed, fontWeight: FontWeight.w600)),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 10),
                      child: Text(
                        "From : ",
                        style: TextStyle(
                            color: KelloggColors.darkRed,
                            fontSize: 16.0,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 1.2),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: Container(
                        margin: EdgeInsets.symmetric(vertical: 10),
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
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: Container(
                        margin: EdgeInsets.symmetric(vertical: 10),
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
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: Container(
                        margin: EdgeInsets.symmetric(vertical: 10),
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
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 10),
                      child: Text(
                        "To :     ",
                        style: TextStyle(
                            color: KelloggColors.darkRed,
                            fontSize: 16.0,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 1.2),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: Container(
                        margin: EdgeInsets.symmetric(vertical: 10),
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
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: Container(
                        margin: EdgeInsets.symmetric(vertical: 10),
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
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: Container(
                        margin: EdgeInsets.symmetric(vertical: 10),
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
                    onPressed: () async {
                      // Add login code
                      setState(() {
                        showSpinner = true;
                      });
                      try {
                        //TODO :: validate interval
                        if (validateInterval()) {
                          calculateInterval();
                          // TODO :: capture reports in the interval "inclusive"
                        }
                        setState(() {
                          showSpinner = false;
                        });
                      } catch (e) {
                        print(e);
                      }
                    },
                  ),
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
                        margin: EdgeInsets.symmetric(vertical: minimumPadding),
                        child: KPI1GoodBadIndicator(
                          circleColor: firstAid_incidents > 0
                              ? KelloggColors.cockRed
                              : KelloggColors.green,
                          title: 'First Aid\nIncidents',
                          circleText: firstAid_incidents.toString(),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: minimumPadding),
                      child: Container(
                        margin: EdgeInsets.symmetric(vertical: minimumPadding),
                        child: KPI1GoodBadIndicator(
                          circleColor: lostTime_incidents > 0
                              ? KelloggColors.cockRed
                              : KelloggColors.green,
                          title: 'Lost Time\nIncidents',
                          circleText: lostTime_incidents.toString(),
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
                        margin: EdgeInsets.symmetric(vertical: minimumPadding),
                        child: KPI1GoodBadIndicator(
                          circleColor: recordable_incidents > 0
                              ? KelloggColors.cockRed
                              : KelloggColors.green,
                          title: 'Recordable\nIncidents',
                          circleText: recordable_incidents.toString(),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: minimumPadding),
                      child: Container(
                        margin: EdgeInsets.symmetric(vertical: minimumPadding),
                        child: KPI1GoodBadIndicator(
                          circleColor: nearMiss <
                                  (Plans.monthlyNearMissTarget / monthDays) *
                                      days_in_interval
                              ? KelloggColors.cockRed
                              : KelloggColors.green,
                          title: 'Near Miss',
                          circleText: nearMiss.toString(),
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
                        margin: EdgeInsets.symmetric(vertical: minimumPadding),
                        child: KPI1GoodBadIndicator(
                          circleColor: risk_assessment > Plans.highRisksBoundary
                              ? KelloggColors.cockRed
                              : risk_assessment > Plans.mediumRisksBoundary
                                  ? KelloggColors.yellow
                                  : KelloggColors.green,
                          title: 'Pre-Shift\nRisk Assessment',
                          circleText: risk_assessment.toString(),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: minimumPadding),
                      child: Container(
                        margin: EdgeInsets.symmetric(vertical: minimumPadding),
                        child: KPI1GoodBadIndicator(
                          circleColor: s7_tours.compareTo(S7[1]) == 0
                              ? KelloggColors.cockRed
                              : KelloggColors.green,
                          title: 'S7 Tours',
                          circleText: s7_tours,
                        ),
                      ),
                    ),
                  ],
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
