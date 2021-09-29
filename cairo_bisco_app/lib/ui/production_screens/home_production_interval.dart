import 'package:cairo_bisco_app/classes/utility_funcs/date_utility.dart';
import 'package:cairo_bisco_app/classes/values/colors.dart';
import 'package:cairo_bisco_app/classes/values/constants.dart';
import 'package:cairo_bisco_app/components/buttons/back_btn.dart';
import 'package:cairo_bisco_app/ui/production_screens/biscuits_lines.dart';
import 'package:cairo_bisco_app/ui/production_screens/maamoul_lines.dart';
import 'package:cairo_bisco_app/ui/production_screens/wafer_lines.dart';
import 'package:flutter/material.dart';

class HomeProductionIntervalPage extends StatefulWidget {
  @override
  _HomeProductionIntervalState createState() => _HomeProductionIntervalState();
}

class _HomeProductionIntervalState extends State<HomeProductionIntervalPage> {
  String _selectedYearFrom = years[(int.parse(getYear())) - 2020];
  String _selectedMonthFrom = months[(int.parse(getMonth())) - 1];
  String _selectedDayFrom = days[(int.parse(getDay())) - 1];
  String _selectedYearTo = years[(int.parse(getYear())) - 2020];
  String _selectedMonthTo = months[(int.parse(getMonth())) - 1];
  String _selectedDayTo = days[(int.parse(getDay())) - 1];

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
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(BoxImageBorder),
                  child: ConstrainedBox(
                    constraints: BoxConstraints.tightFor(
                        width: TightBoxWidth, height: LargeBoxHeight),
                    child: ElevatedButton.icon(
                      label: Text('Biscuits'),
                      style: ElevatedButton.styleFrom(
                        textStyle: TextStyle(
                            fontSize: largeButtonFont, fontFamily: 'MyFont'),
                        primary: KelloggColors.yellow,
                      ),
                      icon: ClipRRect(
                        borderRadius: BorderRadius.circular(iconImageBorder),
                        child: Container(
                          height: mediumIconSize,
                          width: mediumIconSize,
                          padding: EdgeInsets.all(minimumPadding / 2),
                          child: new Image.asset(
                            'images/colored_biscuit.png',
                          ),
                        ),
                      ),
                      onPressed: () {
                        if (int.parse(_selectedYearTo) !=
                            int.parse(_selectedYearFrom))
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  "Error : invalid interval (reports of same year only are allowed)"),
                            ),
                          );
                        else {
                          DateTime dateFrom = DateTime(
                            int.parse(_selectedYearTo),
                            int.parse(_selectedMonthFrom),
                            int.parse(_selectedDayFrom),
                          );
                          DateTime dateAfter = DateTime(
                            int.parse(_selectedYearTo),
                            int.parse(_selectedMonthTo),
                            int.parse(_selectedDayTo),
                          );
                          if (dateFrom.isBefore(dateAfter) ||
                              dateFrom.isAtSameMomentAs(dateAfter)) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => BiscuitLines(
                                        from_month: _selectedMonthFrom,
                                        to_month: _selectedMonthTo,
                                        chosenYear: _selectedYearFrom,
                                        from_day: _selectedDayFrom,
                                        to_day: _selectedDayTo,
                                      )),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                    "Error : invalid interval (from date must be <= to date)"),
                              ),
                            );
                          }
                        }
                      },
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(minimumPadding),
              child: Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(BoxImageBorder),
                  child: ConstrainedBox(
                    constraints: BoxConstraints.tightFor(
                        width: TightBoxWidth, height: LargeBoxHeight),
                    child: ElevatedButton.icon(
                      label: Text('Wafer'),
                      style: ElevatedButton.styleFrom(
                        textStyle: TextStyle(
                            fontSize: largeButtonFont, fontFamily: 'MyFont'),
                        primary: KelloggColors.green,
                      ),
                      icon: ClipRRect(
                        borderRadius: BorderRadius.circular(iconImageBorder),
                        child: Container(
                          height: mediumIconSize,
                          width: mediumIconSize,
                          padding: EdgeInsets.all(minimumPadding / 2),
                          child: new Image.asset(
                            'images/colored_wafer.png',
                          ),
                        ),
                      ),
                      onPressed: () {
                        if (int.parse(_selectedYearTo) !=
                            int.parse(_selectedYearFrom))
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  "Error : invalid interval (reports of same year only are allowed)"),
                            ),
                          );
                        else {
                          DateTime dateFrom = DateTime(
                            int.parse(_selectedYearTo),
                            int.parse(_selectedMonthFrom),
                            int.parse(_selectedDayFrom),
                          );
                          DateTime dateAfter = DateTime(
                            int.parse(_selectedYearTo),
                            int.parse(_selectedMonthTo),
                            int.parse(_selectedDayTo),
                          );
                          if (dateFrom.isBefore(dateAfter) ||
                              dateFrom.isAtSameMomentAs(dateAfter)) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => WaferLines(
                                        from_month: _selectedMonthFrom,
                                        to_month: _selectedMonthTo,
                                        chosenYear: _selectedYearFrom,
                                        from_day: _selectedDayFrom,
                                        to_day: _selectedDayTo,
                                      )),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                    "Error : invalid interval (from date must be <= to date)"),
                              ),
                            );
                          }
                        }
                      },
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(minimumPadding),
              child: Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(BoxImageBorder),
                  child: ConstrainedBox(
                    constraints: BoxConstraints.tightFor(
                        width: TightBoxWidth, height: LargeBoxHeight),
                    child: ElevatedButton.icon(
                      label: Text('Maamoul'),
                      style: ElevatedButton.styleFrom(
                        textStyle: TextStyle(
                            fontSize: largeButtonFont, fontFamily: 'MyFont'),
                        padding: EdgeInsets.symmetric(
                            horizontal: defaultPadding,
                            vertical: minimumPadding),
                        primary: KelloggColors.cockRed,
                      ),
                      icon: ClipRRect(
                        borderRadius: BorderRadius.circular(iconImageBorder),
                        child: Container(
                          height: mediumIconSize,
                          width: mediumIconSize,
                          padding: EdgeInsets.all(minimumPadding / 2),
                          child: new Image.asset(
                            'images/colored_maamoul.png',
                          ),
                        ),
                      ),
                      onPressed: () {
                        if (int.parse(_selectedYearTo) !=
                            int.parse(_selectedYearFrom))
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  "Error : invalid interval (reports of same year only are allowed)"),
                            ),
                          );
                        else {
                          DateTime dateFrom = DateTime(
                            int.parse(_selectedYearTo),
                            int.parse(_selectedMonthFrom),
                            int.parse(_selectedDayFrom),
                          );
                          DateTime dateAfter = DateTime(
                            int.parse(_selectedYearTo),
                            int.parse(_selectedMonthTo),
                            int.parse(_selectedDayTo),
                          );
                          if (dateFrom.isBefore(dateAfter) ||
                              dateFrom.isAtSameMomentAs(dateAfter)) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MaamoulLines(
                                  from_month: _selectedMonthFrom,
                                  to_month: _selectedMonthTo,
                                  chosenYear: _selectedYearFrom,
                                  from_day: _selectedDayFrom,
                                  to_day: _selectedDayTo,
                                ),
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                    "Error : invalid interval (from date must be <= to date)"),
                              ),
                            );
                          }
                        }
                      },
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
