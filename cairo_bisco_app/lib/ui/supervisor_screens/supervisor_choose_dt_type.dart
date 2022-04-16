import 'package:cairo_bisco_app/ui/supervisor_screens/supervisor_downtime_report.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../classes/values/TextStandards.dart';
import '../../classes/values/colors.dart';
import '../../classes/values/constants.dart';
import '../../classes/values/form_values.dart';
import '../../components/buttons/back_btn.dart';
import '../../components/buttons/rounded_btn.dart';

class SupervisorChooseDtType extends StatefulWidget {
  SupervisorChooseDtType({
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
  _SupervisorChooseDtTypeState createState() => _SupervisorChooseDtTypeState(
        refNum: refNum,
        reportDetails: reportDetails,
        isEdit: isEdit,
        reportID: reportID,
      );
}

class _SupervisorChooseDtTypeState extends State<SupervisorChooseDtType> {
  _SupervisorChooseDtTypeState({
    required this.refNum,
    required this.reportDetails,
    required this.isEdit,
    required this.reportID,
  });

  final int refNum;
  final dynamic reportDetails;
  final bool isEdit;
  final String reportID;
  late String dtType;

  final _formKey = GlobalKey<FormState>();

  VoidCallback? onDtTypeChange(val) {
    if (isEdit) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Report type can't be edited after submission"),
      ));
    }
    setState(() {
      dtType = val;
    });
    return null;
  }

  @override
  void initState() {
    super.initState();
    dtType = isEdit ? reportDetails.causeType : downTimeTypes[0];
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
        title: Text(
          prodType[refNum],
          style: TextStyle(
              color: KelloggColors.darkRed,
              fontWeight: FontWeight.w300,
              fontSize: largeFontSize),
        ),
      ),
      body: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.always,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: minimumPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      smallerHeading('اختر سبب العطل\nDown Time Type'),
                      SizedBox(height: minimumPadding),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: minimumPadding),
                        padding: const EdgeInsets.symmetric(
                            horizontal: defaultPadding),
                        child: DropdownButtonFormField<String>(
                          // decoration: InputDecoration(labelText: 'اختر'),
                          value: dtType,
                          isExpanded: true,
                          validator: (value) =>
                              value == downTimeTypes[0] || value == null
                                  ? missingValueErrorText
                                  : null,
                          items: downTimeTypes.map((String value) {
                            return new DropdownMenuItem<String>(
                              value: value,
                              child: Text(
                                value,
                                style: TextStyle(color: KelloggColors.darkRed),
                              ),
                            );
                          }).toList(),
                          onChanged: onDtTypeChange,
                        ),
                      ),
                      SizedBox(height: defaultPadding),
                      /////////////////////////////////////////////////////////////////////////////
                      Padding(
                        padding: const EdgeInsets.all(minimumPadding),
                        child: Center(
                          child: RoundedButton(
                            btnText: 'Next',
                            color: KelloggColors.darkRed,
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                //form is valid, proceed further
                                _formKey.currentState!
                                    .save(); //save once fields are valid, onSaved method invoked for every form fields
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            SupervisorDownTimeReportForm(
                                              refNum: refNum,
                                              reportDetails: reportDetails,
                                              reportID: reportID,
                                              dtType: isEdit
                                                  ? reportDetails.causeType
                                                  : dtType,
                                              isEdit: isEdit,
                                            )));
                              } else {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  content: Text(dropDownSelectionErrorText),
                                ));
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
    );
  }
}
