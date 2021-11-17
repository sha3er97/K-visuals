import 'package:cairo_bisco_app/classes/Credentials.dart';
import 'package:cairo_bisco_app/classes/NRCReport.dart';
import 'package:cairo_bisco_app/classes/utility_funcs/date_utility.dart';
import 'package:cairo_bisco_app/classes/utility_funcs/text_utilities.dart';
import 'package:cairo_bisco_app/classes/values/TextStandards.dart';
import 'package:cairo_bisco_app/classes/values/colors.dart';
import 'package:cairo_bisco_app/classes/values/constants.dart';
import 'package:cairo_bisco_app/classes/values/form_values.dart';
import 'package:cairo_bisco_app/components/buttons/back_btn.dart';
import 'package:cairo_bisco_app/components/buttons/rounded_btn.dart';
import 'package:cairo_bisco_app/components/special_components/place_holders.dart';
import 'package:cairo_bisco_app/ui/error_success_screens/success.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class SupervisorNRCReportForm extends StatefulWidget {
  SupervisorNRCReportForm({
    Key? key,
    required this.refNum,
    required this.reportDetails,
    required this.isEdit,
    required this.reportID,
  }) : super(key: key);
  final int refNum;
  final dynamic reportDetails;
  final bool isEdit;
  final String reportID;

  @override
  _SupervisorNRCReportFormState createState() => _SupervisorNRCReportFormState(
    refNum: refNum,
    reportDetails: reportDetails,
    isEdit: isEdit,
    reportID: reportID,
  );
}

class _SupervisorNRCReportFormState extends State<SupervisorNRCReportForm> {
  _SupervisorNRCReportFormState({
    required this.refNum,
    required this.reportDetails,
    required this.isEdit,
    required this.reportID,
  });

  final String reportID;
  final dynamic reportDetails;
  final int refNum;
  final bool isEdit;

  bool showSpinner = false;
  late String supName, notes_count, notes_details;

  bool _sup_name_validate = false,
      _notes_count_validate = false,
      _notes_details_validate = false;

  //drop down values
  late String selectedShift, selectedYear, selectedMonth, selectedDay;

  VoidCallback? onShiftChange(val) {
    setState(() {
      selectedShift = val;
    });
  }

  VoidCallback? onYearChange(val) {
    setState(() {
      selectedYear = val;
    });
  }

  VoidCallback? onMonthChange(val) {
    setState(() {
      selectedMonth = val;
    });
  }

  VoidCallback? onDayChange(val) {
    setState(() {
      selectedDay = val;
    });
  }

  @override
  void initState() {
    super.initState();
    supName = isEdit ? reportDetails.supName : Credentials.getUserName();
    notes_count = isEdit ? reportDetails.notes_count.toString() : '';
    notes_details = isEdit ? reportDetails.notes_details.toString() : '';
    ///////////////////////////////////////////////////////////////////////////////
    selectedShift = shifts[reportDetails.shift_index];
    selectedYear =
        years[(isEdit ? reportDetails.year : (int.parse(getYear()))) - 2020];
    selectedMonth =
        months[(isEdit ? reportDetails.month : (int.parse(getMonth()))) - 1];
    selectedDay =
        days[(isEdit ? reportDetails.day : (int.parse(getDay()))) - 1];
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      child: SafeArea(
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
              prodType[refNum],
              style: TextStyle(
                  color: KelloggColors.darkRed,
                  fontWeight: FontWeight.w300,
                  fontSize: largeFontSize),
            ),
          ),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: defaultPadding),
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: minimumPadding),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        smallerHeading('اسم المسؤول\nSupervisor Name'),
                        SizedBox(height: minimumPadding),
                        TextFormField(
                          initialValue: supName,
                          readOnly: true,
                          style: (TextStyle(
                              color: KelloggColors.darkRed,
                              fontWeight: FontWeight.w400)),
                          keyboardType: TextInputType.name,
                          cursorColor: Colors.white,
                          obscureText: false,
                          decoration: InputDecoration(
                            labelText: uneditableLabelText,
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: KelloggColors.darkRed,
                                  width: textFieldBorderRadius),
                              borderRadius: BorderRadius.all(
                                  Radius.circular(textFieldRadius)),
                            ),
                            errorText: _sup_name_validate
                                ? missingValueErrorText
                                : null,
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: KelloggColors.yellow,
                                  width: textFieldFocusedBorderRadius),
                              borderRadius: BorderRadius.all(
                                  Radius.circular(textFieldRadius)),
                            ),
                          ),
                          onChanged: (value) {
                            supName = value;
                          },
                        ),
                        SizedBox(height: defaultPadding),
                        ///////////////////////////////////////////////////////////////
                        smallerHeading('تاريخ اليوم\nToday Date'),
                        SizedBox(height: minimumPadding),
                        Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: mediumPadding),
                                child: Container(
                                  margin: EdgeInsets.symmetric(vertical: 10),
                                  child: Column(
                                    children: [
                                      DropdownButton<String>(
                                        hint: Text("day"),
                                        value: selectedDay,
                                        isExpanded: true,
                                        items: days.map((String value) {
                                          return new DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(
                                              value,
                                              style: TextStyle(
                                                  color: KelloggColors.darkRed),
                                            ),
                                          );
                                        }).toList(),
                                        onChanged: onDayChange,
                                      ),
                                    ],
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
                                      DropdownButton<String>(
                                        hint: Text("month"),
                                        value: selectedMonth,
                                        isExpanded: true,
                                        items: months.map((String value) {
                                          return new DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(
                                              value,
                                              style: TextStyle(
                                                  color: KelloggColors.darkRed),
                                            ),
                                          );
                                        }).toList(),
                                        onChanged: onMonthChange,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: mediumPadding),
                                child: Container(
                                  margin: EdgeInsets.symmetric(
                                      vertical: minimumPadding),
                                  child: Column(
                                    children: [
                                      DropdownButton<String>(
                                        hint: Text("year"),
                                        value: selectedYear,
                                        isExpanded: true,
                                        items: years.map((String value) {
                                          return new DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(
                                              value,
                                              style: TextStyle(
                                                  color: KelloggColors.darkRed),
                                            ),
                                          );
                                        }).toList(),
                                        onChanged: onYearChange,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: defaultPadding),
                        ///////////////////////////////////////////////////////////////
                        smallerHeading('اختر الوردية\nWork Shift'),
                        SizedBox(height: minimumPadding),
                        Container(
                          margin:
                          EdgeInsets.symmetric(vertical: minimumPadding),
                          padding: const EdgeInsets.symmetric(
                              horizontal: defaultPadding),
                          child: DropdownButtonFormField<String>(
                            value: selectedShift,
                            isExpanded: true,
                            items: shifts.map((String value) {
                              return new DropdownMenuItem<String>(
                                value: value,
                                child: Text(
                                  value,
                                  style:
                                  TextStyle(color: KelloggColors.darkRed),
                                ),
                              );
                            }).toList(),
                            onChanged: onShiftChange,
                          ),
                        ),
                        SizedBox(height: defaultPadding),
                        /////////////////////////////////////////////////////////////////////////////////
                        smallerHeading(
                            'عدد ملاحظات استهلاك سلبي \nNotes Count'),
                        SizedBox(height: minimumPadding),
                        TextFormField(
                          initialValue: notes_count,
                          style: (TextStyle(
                              color: KelloggColors.darkRed,
                              fontWeight: FontWeight.w400)),
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          cursorColor: Colors.white,
                          obscureText: false,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: KelloggColors.darkRed,
                                  width: textFieldBorderRadius),
                              borderRadius: BorderRadius.all(
                                  Radius.circular(textFieldRadius)),
                            ),
                            errorText: _notes_count_validate
                                ? missingValueErrorText
                                : null,
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: KelloggColors.yellow,
                                  width: textFieldFocusedBorderRadius),
                              borderRadius: BorderRadius.all(
                                  Radius.circular(textFieldRadius)),
                            ),
                          ),
                          onChanged: (value) {
                            notes_count = value;
                          },
                        ),
                        SizedBox(height: defaultPadding),
                        ///////////////////////////////////////////////////////////////
                        smallerHeading(
                            'ملاحظات الاستهلاك السلبي \nNotes Details'),
                        SizedBox(height: minimumPadding),
                        TextFormField(
                          initialValue: notes_details,
                          style: (TextStyle(
                              color: KelloggColors.darkRed,
                              fontWeight: FontWeight.w400)),
                          keyboardType: TextInputType.multiline,
                          cursorColor: Colors.white,
                          obscureText: false,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: KelloggColors.darkRed,
                                  width: textFieldBorderRadius),
                              borderRadius: BorderRadius.all(
                                  Radius.circular(textFieldRadius)),
                            ),
                            errorText: _notes_details_validate
                                ? conditionalMissingValueErrorText
                                : null,
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: KelloggColors.yellow,
                                  width: textFieldFocusedBorderRadius),
                              borderRadius: BorderRadius.all(
                                  Radius.circular(textFieldRadius)),
                            ),
                          ),
                          onChanged: (value) {
                            notes_details = value;
                          },
                        ),
                        SizedBox(height: defaultPadding),
                        ///////////////////////////////////////////////////////////////
                        isEdit
                            ? EmptyPlaceHolder()
                            : Padding(
                          padding: const EdgeInsets.all(minimumPadding),
                          child: Center(
                            child: RoundedButton(
                              btnText: 'تسليم التقرير',
                              color: KelloggColors.darkRed,
                              onPressed: () async {
                                setState(() {
                                  showSpinner = true;
                                        _notes_count_validate =
                                            emptyField(notes_count);
                                        if (!_notes_count_validate)
                                          _notes_details_validate =
                                              conditionalEmptyField(
                                                  int.parse(notes_count),
                                                  notes_details);
                                        _sup_name_validate =
                                            emptyField(supName);
                                      });
                                try {
                                  if (!_notes_count_validate &&
                                            !_notes_details_validate &&
                                            !_sup_name_validate) {
                                          NRCReport.addReport(
                                              supName,
                                              int.parse(notes_count),
                                              notes_details,
                                              shifts.indexOf(selectedShift),
                                              refNum,
                                              int.parse(selectedYear),
                                              int.parse(selectedMonth),
                                              int.parse(selectedDay));
                                          Navigator.push(
                                              context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                SuccessScreen()));
                                  } else {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                      content: Text(submissionErrorText),
                                    ));
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
                        //////////////////////////////////////////////////////////////////
                        !isEdit
                            ? EmptyPlaceHolder()
                            : Padding(
                          padding: const EdgeInsets.all(minimumPadding),
                          child: Center(
                            child: RoundedButton(
                              btnText: 'Edit Report',
                              color: KelloggColors.darkBlue,
                              onPressed: () {
                                setState(() {
                                  showSpinner = true;

                                        _notes_count_validate =
                                            emptyField(notes_count);
                                        if (!_notes_count_validate)
                                          _notes_details_validate =
                                              conditionalEmptyField(
                                                  int.parse(notes_count),
                                                  notes_details);
                                        _sup_name_validate =
                                            emptyField(supName);
                                      });
                                try {
                                  if (!_notes_count_validate &&
                                            !_notes_details_validate &&
                                            !_sup_name_validate) {
                                          NRCReport.editReport(
                                              context,
                                              reportID,
                                              supName,
                                              int.parse(notes_count),
                                              notes_details,
                                              shifts.indexOf(selectedShift),
                                              refNum,
                                              int.parse(selectedYear),
                                              int.parse(selectedMonth),
                                              int.parse(selectedDay));
                                  } else {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                      content: Text(submissionErrorText),
                                    ));
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
                        //////////////////////////////////////////////////////////////////
                        !isEdit
                            ? EmptyPlaceHolder()
                            : Padding(
                          padding: const EdgeInsets.all(minimumPadding),
                          child: Center(
                            child: RoundedButton(
                              btnText: 'Delete Report',
                              color: KelloggColors.cockRed,
                              onPressed: () {
                                setState(() {
                                  showSpinner = true;
                                });
                                try {
                                  NRCReport.deleteReport(
                                    context,
                                    reportID,
                                    int.parse(selectedYear),
                                  );
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
                        //////////////////////////////////////////////////////////////////
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
