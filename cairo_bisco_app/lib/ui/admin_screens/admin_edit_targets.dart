import 'package:cairo_bisco_app/classes/Plans.dart';
import 'package:cairo_bisco_app/classes/utility_funcs/text_utilities.dart';
import 'package:cairo_bisco_app/classes/values/TextStandards.dart';
import 'package:cairo_bisco_app/classes/values/colors.dart';
import 'package:cairo_bisco_app/classes/values/constants.dart';
import 'package:cairo_bisco_app/components/buttons/back_btn.dart';
import 'package:cairo_bisco_app/components/buttons/rounded_btn.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class AdminEditTargets extends StatefulWidget {
  @override
  _AdminEditTargetsState createState() => _AdminEditTargetsState();
}

class _AdminEditTargetsState extends State<AdminEditTargets> {
  bool showSpinner = false;
  String targetOverWeightAbove = Plans.targetOverWeightAbove.toString(),
      targetOEE = Plans.targetOEE.toString(),
      monthlyNearMissTarget = Plans.monthlyNearMissTarget.toString(),
      mediumRisksBoundary = Plans.mediumRisksBoundary.toString(),
      highRisksBoundary = Plans.highRisksBoundary.toString(),
      target_absence = Plans.target_absence.toString(),
      mpsaTarget = Plans.mpsaTarget.toString(),
      universalTargetScrap = Plans.universalTargetScrap.toString(),
      universalTargetFilmWaste = Plans.universalTargetFilmWaste.toString();

  bool _targetOverWeightAbove_validate = false,
      _targetOEE_validate = false,
      _monthlyNearMissTarget_validate = false,
      _mediumRisksBoundary_validate = false,
      _highRisksBoundary_validate = false,
      _target_absence_validate = false,
      _mpsaTarget_validate = false,
      _universalTargetScrap_validate = false,
      _universalTargetFilmWaste_validate = false;

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
              admin: true,
            ),
            title: Text(
              "Edit Targets",
              style: TextStyle(
                  color: KelloggColors.darkBlue,
                  fontWeight: FontWeight.w300,
                  fontSize: largeFontSize),
            ),
          ),
          body: SingleChildScrollView(
            child: Column(
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
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            adminHeading('Target OverWeight :'),
                            SizedBox(width: minimumPadding),
                            Expanded(
                              child: TextFormField(
                                initialValue:
                                    Plans.targetOverWeightAbove.toString(),
                                style: (TextStyle(
                                    color: KelloggColors.darkBlue,
                                    fontWeight: FontWeight.w400)),
                                keyboardType: TextInputType.numberWithOptions(
                                    decimal: true),
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
                                  errorText: _targetOverWeightAbove_validate
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
                                  targetOverWeightAbove = value;
                                },
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: defaultPadding),
                        /////////////////////////////////////////////////////////////////////////
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            adminHeading('OEE% Target :'),
                            SizedBox(width: minimumPadding),
                            Expanded(
                              child: TextFormField(
                                initialValue: Plans.targetOEE.toString(),
                                style: (TextStyle(
                                    color: KelloggColors.darkBlue,
                                    fontWeight: FontWeight.w400)),
                                keyboardType: TextInputType.numberWithOptions(
                                    decimal: true),
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
                                  errorText: _targetOEE_validate
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
                                  targetOEE = value;
                                },
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: defaultPadding),
                        /////////////////////////////////////////////////////////////////////////
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            adminHeading('MPSA% Target :'),
                            SizedBox(width: minimumPadding),
                            Expanded(
                              child: TextFormField(
                                initialValue: Plans.mpsaTarget.toString(),
                                style: (TextStyle(
                                    color: KelloggColors.darkBlue,
                                    fontWeight: FontWeight.w400)),
                                keyboardType: TextInputType.numberWithOptions(
                                    decimal: true),
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
                                  errorText: _mpsaTarget_validate
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
                                  mpsaTarget = value;
                                },
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: defaultPadding),
                        /////////////////////////////////////////////////////////////////////////
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            adminHeading('Monthly Near Miss Target :'),
                            SizedBox(width: minimumPadding),
                            Expanded(
                              child: TextFormField(
                                initialValue:
                                    Plans.monthlyNearMissTarget.toString(),
                                style: (TextStyle(
                                    color: KelloggColors.darkBlue,
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
                                        color: KelloggColors.darkBlue,
                                        width: textFieldBorderRadius),
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(textFieldRadius)),
                                  ),
                                  errorText: _monthlyNearMissTarget_validate
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
                                  monthlyNearMissTarget = value;
                                },
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: defaultPadding),
                        /////////////////////////////////////////////////////////////////////////
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            adminHeading('Medium Risk Assessment Boundary :'),
                            SizedBox(width: minimumPadding),
                            Expanded(
                              child: TextFormField(
                                initialValue:
                                    Plans.mediumRisksBoundary.toString(),
                                style: (TextStyle(
                                    color: KelloggColors.darkBlue,
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
                                        color: KelloggColors.darkBlue,
                                        width: textFieldBorderRadius),
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(textFieldRadius)),
                                  ),
                                  errorText: _mediumRisksBoundary_validate
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
                                  mediumRisksBoundary = value;
                                },
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: defaultPadding),
                        /////////////////////////////////////////////////////////////////////////
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            adminHeading('High Risk Assessment Boundary :'),
                            SizedBox(width: minimumPadding),
                            Expanded(
                              child: TextFormField(
                                initialValue:
                                    Plans.highRisksBoundary.toString(),
                                style: (TextStyle(
                                    color: KelloggColors.darkBlue,
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
                                        color: KelloggColors.darkBlue,
                                        width: textFieldBorderRadius),
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(textFieldRadius)),
                                  ),
                                  errorText: _highRisksBoundary_validate
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
                                  highRisksBoundary = value;
                                },
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: defaultPadding),
                        /////////////////////////////////////////////////////////////////////////
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            adminHeading('Maximum Absence% Target :'),
                            SizedBox(width: minimumPadding),
                            Expanded(
                              child: TextFormField(
                                initialValue: Plans.target_absence.toString(),
                                style: (TextStyle(
                                    color: KelloggColors.darkBlue,
                                    fontWeight: FontWeight.w400)),
                                keyboardType: TextInputType.numberWithOptions(
                                    decimal: true),
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
                                  errorText: _target_absence_validate
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
                                  target_absence = value;
                                },
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: defaultPadding),
                        /////////////////////////////////////////////////////////////////////////
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            adminHeading('Plant Scrap Target :'),
                            SizedBox(width: minimumPadding),
                            Expanded(
                              child: TextFormField(
                                initialValue:
                                    Plans.universalTargetScrap.toString(),
                                style: (TextStyle(
                                    color: KelloggColors.darkBlue,
                                    fontWeight: FontWeight.w400)),
                                keyboardType: TextInputType.numberWithOptions(
                                    decimal: true),
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
                                  errorText: _universalTargetScrap_validate
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
                                  universalTargetScrap = value;
                                },
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: defaultPadding),
                        /////////////////////////////////////////////////////////////////////////
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            adminHeading('Plant Film Waste Target :'),
                            SizedBox(width: minimumPadding),
                            Expanded(
                              child: TextFormField(
                                initialValue:
                                    Plans.universalTargetFilmWaste.toString(),
                                style: (TextStyle(
                                    color: KelloggColors.darkBlue,
                                    fontWeight: FontWeight.w400)),
                                keyboardType: TextInputType.numberWithOptions(
                                    decimal: true),
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
                                  errorText: _universalTargetFilmWaste_validate
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
                                  universalTargetFilmWaste = value;
                                },
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: defaultPadding),
                        /////////////////////////////////////////////////////////////////////////
                        Padding(
                          padding: const EdgeInsets.all(minimumPadding),
                          child: Center(
                            child: RoundedButton(
                              btnText: 'Save Changes',
                              color: KelloggColors.darkBlue,
                              onPressed: () async {
                                setState(() {
                                  showSpinner = true;
                                  _highRisksBoundary_validate =
                                      emptyField(highRisksBoundary);
                                  _mediumRisksBoundary_validate =
                                      emptyField(mediumRisksBoundary);
                                  _monthlyNearMissTarget_validate =
                                      emptyField(monthlyNearMissTarget);
                                  _mpsaTarget_validate = emptyField(mpsaTarget);
                                  _targetOEE_validate = emptyField(targetOEE);
                                  _targetOverWeightAbove_validate =
                                      emptyField(targetOverWeightAbove);
                                  _target_absence_validate =
                                      emptyField(target_absence);
                                  _universalTargetFilmWaste_validate =
                                      emptyField(universalTargetFilmWaste);
                                  _universalTargetScrap_validate =
                                      emptyField(universalTargetScrap);
                                });
                                try {
                                  if (!_highRisksBoundary_validate &&
                                      !_mediumRisksBoundary_validate &&
                                      !_monthlyNearMissTarget_validate &&
                                      !_mpsaTarget_validate &&
                                      !_targetOEE_validate &&
                                      !_targetOverWeightAbove_validate &&
                                      !_universalTargetScrap_validate &&
                                      !_universalTargetFilmWaste_validate) {
                                    Plans.updateRules(
                                      context,
                                      double.parse(targetOverWeightAbove),
                                      double.parse(targetOEE),
                                      double.parse(mpsaTarget),
                                      int.parse(monthlyNearMissTarget),
                                      int.parse(mediumRisksBoundary),
                                      int.parse(highRisksBoundary),
                                      double.parse(target_absence),
                                      double.parse(universalTargetScrap),
                                      double.parse(universalTargetFilmWaste),
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
