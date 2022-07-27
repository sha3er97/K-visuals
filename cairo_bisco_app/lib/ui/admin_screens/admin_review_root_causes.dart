import 'package:cairo_bisco_app/classes/utility_funcs/text_utilities.dart';
import 'package:cairo_bisco_app/classes/values/TextStandards.dart';
import 'package:cairo_bisco_app/classes/values/colors.dart';
import 'package:cairo_bisco_app/classes/values/constants.dart';
import 'package:cairo_bisco_app/components/alert_dialog.dart';
import 'package:cairo_bisco_app/components/buttons/back_btn.dart';
import 'package:cairo_bisco_app/components/buttons/rounded_btn.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import '../../classes/RootCause.dart';
import '../../classes/values/form_values.dart';
import '../../components/special_components/place_holders.dart';

class AdminReviewRootCauses extends StatefulWidget {
  @override
  _AdminReviewRootCausesState createState() => _AdminReviewRootCausesState();
}

class _AdminReviewRootCausesState extends State<AdminReviewRootCauses> {
  String type = displayDownTimeTypes[0], cause = "";

  bool _valid_cause_validate = false;
  bool showSpinner = false;

  VoidCallback? onTypeChange(val) {
    setState(() {
      type = val;
    });
    return null;
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
              color: KelloggColors.darkBlue,
            ),
            title: Text(
              "Root Causes",
              style: TextStyle(
                  color: KelloggColors.darkBlue,
                  fontWeight: FontWeight.w300,
                  fontSize: largeFontSize),
            ),
          ),
          body: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: defaultPadding),
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: minimumPadding),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        adminHeading('DT Type'),
                        SizedBox(height: minimumPadding),
                        Container(
                          margin:
                              EdgeInsets.symmetric(vertical: minimumPadding),
                          padding: const EdgeInsets.symmetric(
                              horizontal: defaultPadding),
                          child: DropdownButtonFormField<String>(
                            // decoration: InputDecoration(labelText: 'اختر'),
                            value: type,
                            isExpanded: true,
                            items: displayDownTimeTypes.map((String value) {
                              return new DropdownMenuItem<String>(
                                value: value,
                                child: Text(
                                  value,
                                  style:
                                      TextStyle(color: KelloggColors.darkRed),
                                ),
                              );
                            }).toList(),
                            onChanged: onTypeChange,
                          ),
                        ),
                        SizedBox(height: defaultPadding),
                        /////////////////////////////////////////////////////////////
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            adminHeading('Cause description :'),
                            SizedBox(width: minimumPadding),
                            Expanded(
                              child: TextFormField(
                                // initialValue:
                                // Plans.targetOverWeightAbove.toString(),
                                style: (TextStyle(
                                    color: KelloggColors.darkBlue,
                                    fontWeight: FontWeight.w400)),
                                keyboardType: TextInputType.multiline,
                                cursorColor: Colors.white,
                                obscureText: false,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: KelloggColors.darkBlue,
                                        width: textFieldBorderRadius),
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(textFieldRadius)),
                                  ),
                                  errorText: _valid_cause_validate
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
                                  cause = value;
                                },
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: defaultPadding),
                        ///////////////////////////////////////////////////////////////
                        Padding(
                          padding: const EdgeInsets.all(minimumPadding),
                          child: Center(
                            child: RoundedButton(
                              btnText: 'Add New Cause',
                              color: KelloggColors.darkBlue,
                              onPressed: () async {
                                setState(() {
                                  showSpinner = true;
                                  _valid_cause_validate = emptyField(cause);
                                });
                                try {
                                  if (!_valid_cause_validate) {
                                    RootCause.addCause(
                                      context,
                                      downTimeTypes[
                                          displayDownTimeTypes.indexOf(type)],
                                      cause.trim(),
                                    );
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
                        sectionWithDivider('Existing Causes'),
                        /////////////////////////////////////////////////////////////////////////////////
                        ListView.builder(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            physics: ClampingScrollPhysics(),
                            // padding: const EdgeInsets.all(minimumPadding),
                            itemCount: RootCause.allCauses.length,
                            itemBuilder: (BuildContext context, int index) {
                              if (RootCause.reversedCausesMap[
                                              RootCause.allCauses[index]]!
                                          .compareTo(downTimeTypes[
                                              displayDownTimeTypes
                                                  .indexOf(type)]) ==
                                      0 ||
                                  type.compareTo(displayDownTimeTypes[0]) ==
                                      0) {
                                return ListTile(
                                  title: adminHeading(displayDownTimeTypes[
                                          downTimeTypes.indexOf(RootCause
                                              .reversedCausesMap[
                                                  RootCause.allCauses[index]]
                                              .toString())] +
                                      " : " +
                                      RootCause.allCauses[index]),
                                  leading: IconButton(
                                    icon: const Icon(Icons.close),
                                    color: KelloggColors.cockRed,
                                    onPressed: () {
                                      confirmDeleteCauseAlertDialog(
                                          context,
                                          RootCause.reversedCausesMap[
                                                  RootCause.allCauses[index]]
                                              .toString(),
                                          RootCause.allCauses[index]);
                                    },
                                  ),
                                );
                              } else {
                                return EmptyPlaceHolder();
                              }
                            }),
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
