import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import '/classes/Credentials.dart';
import '/classes/NRCReport.dart';
import '/classes/utility_funcs/date_time_utility.dart';
import '/classes/utility_funcs/other_utility.dart';
import '/classes/utility_funcs/text_utilities.dart';
import '/classes/values/TextStandards.dart';
import '/classes/values/colors.dart';
import '/classes/values/constants.dart';
import '/classes/values/form_values.dart';
import '/components/buttons/back_btn.dart';
import '/components/buttons/rounded_btn.dart';
import '/components/special_components/place_holders.dart';
import '/ui/error_success_screens/success.dart';

class SupervisorNRCReportForm extends StatefulWidget {
  const SupervisorNRCReportForm({
    Key? key,
    required this.refNum,
    required this.reportDetails,
    required this.isEdit,
    required this.reportID,
  }) : super(key: key);
  final int refNum;
  final NRCReport reportDetails;
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
  final bool isEdit;
  final int refNum;
  final NRCReport reportDetails;

  bool showSpinner = false;
  late String supName, area, type, reading;

  bool _sup_name_validate = false, _reading_validate = false;

  //drop down values
  late String selectedArea,
      selectedYear,
      selectedMonth,
      selectedDay,
      selectedType;

  VoidCallback? onAreaChange(val) {
    setState(() {
      area = val;
    });
    return null;
  }

  VoidCallback? onTypeChange(val) {
    setState(() {
      type = val;
      area = gaugesPerType[gaugesTypes.indexOf(type)][0];
    });
    return null;
  }

  VoidCallback? onYearChange(val) {
    setState(() {
      selectedYear = val;
    });
    return null;
  }

  VoidCallback? onMonthChange(val) {
    setState(() {
      selectedMonth = val;
    });
    return null;
  }

  VoidCallback? onDayChange(val) {
    setState(() {
      selectedDay = val;
    });
    return null;
  }

  @override
  void initState() {
    super.initState();
    supName = isEdit ? reportDetails.supName : Credentials.getUserName();
    reading = isEdit ? reportDetails.reading.toString() : '';
    ///////////////////////////////////////////////////////////////////////////////
    selectedYear =
        years[(isEdit ? reportDetails.year : (int.parse(getYear()))) - 2020];
    selectedMonth =
        months[(isEdit ? reportDetails.month : (int.parse(getMonth()))) - 1];
    selectedDay =
        days[(isEdit ? reportDetails.day : (int.parse(getDay()))) - 1];
    type = isEdit ? reportDetails.type : gaugesTypes[0];
    area = isEdit
        ? reportDetails.area
        : gaugesPerType[gaugesTypes.indexOf(type)][0];
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: KelloggColors.white,
          resizeToAvoidBottomInset: true,
          appBar: AppBar(
            backgroundColor: KelloggColors.white.withOpacity(0),
            shadowColor: KelloggColors.white.withOpacity(0),
            leading: MyBackButton(
              color: KelloggColors.darkRed,
            ),
            title: const Text(
              'NRC Report',
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
                    margin:
                        const EdgeInsets.symmetric(vertical: minimumPadding),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        smallerHeading('اسم المسؤول\nResponsible Name'),
                        const SizedBox(height: minimumPadding),
                        TextFormField(
                          initialValue: supName,
                          readOnly: true,
                          style: (const TextStyle(
                              color: KelloggColors.darkRed,
                              fontWeight: FontWeight.w400)),
                          keyboardType: TextInputType.name,
                          cursorColor: Colors.white,
                          obscureText: false,
                          decoration: InputDecoration(
                            labelText: uneditableLabelText,
                            border: const OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: KelloggColors.darkRed,
                                  width: textFieldBorderRadius),
                              borderRadius: BorderRadius.all(
                                  Radius.circular(textFieldRadius)),
                            ),
                            errorText: _sup_name_validate
                                ? missingValueErrorText
                                : null,
                            focusedBorder: const OutlineInputBorder(
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
                        const SizedBox(height: defaultPadding),
                        ///////////////////////////////////////////////////////////////
                        smallerHeading('تاريخ اليوم\nToday Date'),
                        const SizedBox(height: minimumPadding),
                        Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: mediumPadding),
                                child: Container(
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  child: Column(
                                    children: [
                                      DropdownButton<String>(
                                        hint: const Text("day"),
                                        value: selectedDay,
                                        isExpanded: true,
                                        items: days.map((String value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(
                                              value,
                                              style: const TextStyle(
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
                                  margin: const EdgeInsets.symmetric(
                                      vertical: minimumPadding),
                                  child: Column(
                                    children: [
                                      DropdownButton<String>(
                                        hint: const Text("month"),
                                        value: selectedMonth,
                                        isExpanded: true,
                                        items: months.map((String value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(
                                              value,
                                              style: const TextStyle(
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
                                  margin: const EdgeInsets.symmetric(
                                      vertical: minimumPadding),
                                  child: Column(
                                    children: [
                                      DropdownButton<String>(
                                        hint: const Text("year"),
                                        value: selectedYear,
                                        isExpanded: true,
                                        items: years.map((String value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(
                                              value,
                                              style: const TextStyle(
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
                        const SizedBox(height: defaultPadding),
                        ///////////////////////////////////////////////////////////////
                        smallerHeading('نوع العداد Type'),
                        const SizedBox(height: minimumPadding),
                        Container(
                          margin: const EdgeInsets.symmetric(
                              vertical: minimumPadding),
                          padding: const EdgeInsets.symmetric(
                              horizontal: defaultPadding),
                          child: DropdownButtonFormField<String>(
                            value: type,
                            isExpanded: true,
                            items: gaugesTypes.map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(
                                  value,
                                  style: const TextStyle(
                                      color: KelloggColors.darkRed),
                                ),
                              );
                            }).toList(),
                            onChanged: onTypeChange,
                          ),
                        ),
                        const SizedBox(height: defaultPadding),
                        ///////////////////////////////////////////////////////////////
                        smallerHeading('المنطقة Area'),
                        const SizedBox(height: minimumPadding),
                        Container(
                          margin: const EdgeInsets.symmetric(
                              vertical: minimumPadding),
                          padding: const EdgeInsets.symmetric(
                              horizontal: defaultPadding),
                          child: DropdownButtonFormField<String>(
                            value: area,
                            isExpanded: true,
                            items: gaugesPerType[gaugesTypes.indexOf(type)]
                                .map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(
                                  value,
                                  style: const TextStyle(
                                      color: KelloggColors.darkRed),
                                ),
                              );
                            }).toList(),
                            onChanged: onAreaChange,
                          ),
                        ),
                        const SizedBox(height: defaultPadding),
                        ///////////////////////////////////////////////////////////////
                        smallerHeading('قراءة العداد \nReading'),
                        const SizedBox(height: minimumPadding),
                        TextFormField(
                          initialValue: reading,
                          style: (const TextStyle(
                              color: KelloggColors.darkRed,
                              fontWeight: FontWeight.w400)),
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          cursorColor: Colors.white,
                          obscureText: false,
                          decoration: InputDecoration(
                            border: const OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: KelloggColors.darkRed,
                                  width: textFieldBorderRadius),
                              borderRadius: BorderRadius.all(
                                  Radius.circular(textFieldRadius)),
                            ),
                            errorText: _reading_validate
                                ? missingValueErrorText
                                : null,
                            focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: KelloggColors.yellow,
                                  width: textFieldFocusedBorderRadius),
                              borderRadius: BorderRadius.all(
                                  Radius.circular(textFieldRadius)),
                            ),
                          ),
                          onChanged: (value) {
                            reading = value;
                          },
                        ),
                        const SizedBox(height: defaultPadding),
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
                                        _reading_validate = emptyField(reading);
                                        _sup_name_validate =
                                            emptyField(supName);
                                      });
                                      try {
                                        if (!_sup_name_validate &&
                                            !_reading_validate) {
                                          NRCReport.addReport(
                                              supName,
                                              area,
                                              type,
                                              int.parse(reading),
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
                                              .showSnackBar(const SnackBar(
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
                                        _reading_validate = emptyField(reading);
                                        _sup_name_validate =
                                            emptyField(supName);
                                      });
                                      try {
                                        if (!_sup_name_validate &&
                                            !_reading_validate) {
                                          if (canEditThisReport(
                                              supName,
                                              int.parse(selectedDay),
                                              int.parse(selectedMonth),
                                              int.parse(selectedYear))) {
                                            NRCReport.editReport(
                                                context,
                                                reportID,
                                                supName,
                                                area,
                                                type,
                                                int.parse(reading),
                                                refNum,
                                                int.parse(selectedYear),
                                                int.parse(selectedMonth),
                                                int.parse(selectedDay));
                                          } else {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(const SnackBar(
                                              content:
                                                  Text(unauthorizedEditMsg),
                                            ));
                                          }
                                        } else {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(const SnackBar(
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
                                        if (canEditThisReport(
                                            supName,
                                            int.parse(selectedDay),
                                            int.parse(selectedMonth),
                                            int.parse(selectedYear))) {
                                          NRCReport.deleteReport(
                                            context,
                                            reportID,
                                            int.parse(selectedYear),
                                          );
                                        } else {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(const SnackBar(
                                            content: Text(unauthorizedEditMsg),
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
