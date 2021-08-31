import 'package:cairo_bisco_app/components/buttons/back_btn.dart';
import 'package:cairo_bisco_app/components/buttons/rounded_btn.dart';
import 'package:cairo_bisco_app/components/qfs_ehs_wigdets/1kpi_good_bad_indicator.dart';
import 'package:cairo_bisco_app/components/values/colors.dart';
import 'package:cairo_bisco_app/components/values/constants.dart';
import 'package:cairo_bisco_app/components/utility_funcs/date_utility.dart';
import 'package:cairo_bisco_app/components/values/form_values.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class QfsReport extends StatefulWidget {
  @override
  _QfsReportState createState() => _QfsReportState();
}

class _QfsReportState extends State<QfsReport> {
  String _selectedYearFrom = years[(int.parse(getYear())) - 2020];
  String _selectedMonthFrom = months[(int.parse(getMonth())) - 1];
  String _selectedDayFrom = days[(int.parse(getDay())) - 1];
  String _selectedYearTo = years[(int.parse(getYear())) - 2020];
  String _selectedMonthTo = months[(int.parse(getMonth())) - 1];
  String _selectedDayTo = days[(int.parse(getDay())) - 1];

  bool showSpinner = false;
  int quality_incidents = 3,
      food_safety_incidents = 0,
      ccp_failure = 0,
      consumer_complaints = 0;
  String pes = Pes[1], g6_escalaction = G6[2];

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
          title: Text('QFS',
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
                        // final user = await _auth.signInWithEmailAndPassword(
                        //     email: email, password: password);

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
                          circleColor: quality_incidents > 0
                              ? KelloggColors.cockRed
                              : KelloggColors.green,
                          title: 'Quality\nIncidents',
                          circleText: quality_incidents.toString(),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: minimumPadding),
                      child: Container(
                        margin: EdgeInsets.symmetric(vertical: minimumPadding),
                        child: KPI1GoodBadIndicator(
                          circleColor: food_safety_incidents > 0
                              ? KelloggColors.cockRed
                              : KelloggColors.green,
                          title: 'Food Safety\nIncidents',
                          circleText: food_safety_incidents.toString(),
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
                          circleColor: ccp_failure > 0
                              ? KelloggColors.cockRed
                              : KelloggColors.green,
                          title: 'CCP\nFailures',
                          circleText: ccp_failure.toString(),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: minimumPadding),
                      child: Container(
                        margin: EdgeInsets.symmetric(vertical: minimumPadding),
                        child: KPI1GoodBadIndicator(
                          circleColor: pes.compareTo(Pes[2]) == 0
                              ? KelloggColors.cockRed
                              : pes.compareTo(Pes[1]) == 0
                                  ? KelloggColors.yellow
                                  : KelloggColors.green,
                          title: 'PES\n(B&C Defects)',
                          circleText: pes,
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
                          circleColor: consumer_complaints > 0
                              ? KelloggColors.cockRed
                              : KelloggColors.green,
                          title: 'Consumer\nComplaints',
                          circleText: consumer_complaints.toString(),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: minimumPadding),
                      child: Container(
                        margin: EdgeInsets.symmetric(vertical: minimumPadding),
                        child: KPI1GoodBadIndicator(
                          circleColor: g6_escalaction.compareTo(G6[2]) == 0
                              ? KelloggColors.cockRed
                              : g6_escalaction.compareTo(G6[1]) == 0
                                  ? KelloggColors.yellow
                                  : KelloggColors.green,
                          title: 'G6 Escalation',
                          circleText: g6_escalaction,
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
