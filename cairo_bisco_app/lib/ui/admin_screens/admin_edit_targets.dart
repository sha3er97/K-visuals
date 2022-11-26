import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import '/classes/Plans.dart';
import '/classes/utility_funcs/text_utilities.dart';
import '/classes/values/TextStandards.dart';
import '/classes/values/colors.dart';
import '/classes/values/constants.dart';
import '/components/buttons/back_btn.dart';
import '/components/buttons/rounded_btn.dart';

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
      targetAbsence = Plans.targetAbsence.toString(),
      mpsaTarget = Plans.mpsaTarget.toString(),
      universalTargetScrap = Plans.universalTargetScrap.toString(),
      electConsumptionTarget = Plans.electConsumptionTarget.toString(),
      waterConsumptionTarget = Plans.waterConsumptionTarget.toString(),
      gasConsumptionTarget = Plans.gasConsumptionTarget.toString(),
      organicWasteConsumptionTarget =
          Plans.organicWasteConsumptionTarget.toString(),
      universalTargetFilmWaste = Plans.universalTargetFilmWaste.toString();

  bool _targetOverWeightAbove_validate = false,
      _targetOEE_validate = false,
      _monthlyNearMissTarget_validate = false,
      _mediumRisksBoundary_validate = false,
      _highRisksBoundary_validate = false,
      _target_absence_validate = false,
      _mpsaTarget_validate = false,
      _elect_consumption_validate = false,
      _water_consumption_validate = false,
      _gas_consumption_validate = false,
      _organic_waste_consumption_validate = false,
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
          appBar: AppBar(
            backgroundColor: KelloggColors.white.withOpacity(0),
            shadowColor: KelloggColors.white.withOpacity(0),
            leading: MyBackButton(
              color: KelloggColors.darkBlue,
            ),
            title: const Text(
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
                    margin:
                        const EdgeInsets.symmetric(vertical: minimumPadding),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            adminHeading('Target OverWeight :'),
                            const SizedBox(width: minimumPadding),
                            Expanded(
                              child: TextFormField(
                                initialValue:
                                    Plans.targetOverWeightAbove.toString(),
                                style: (const TextStyle(
                                    color: KelloggColors.darkBlue,
                                    fontWeight: FontWeight.w400)),
                                keyboardType:
                                    const TextInputType.numberWithOptions(
                                        decimal: true),
                                cursorColor: Colors.white,
                                obscureText: false,
                                decoration: InputDecoration(
                                  border: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: KelloggColors.darkBlue,
                                        width: textFieldBorderRadius),
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(textFieldRadius)),
                                  ),
                                  errorText: _targetOverWeightAbove_validate
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
                                  targetOverWeightAbove = value;
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: defaultPadding),
                        /////////////////////////////////////////////////////////////////////////
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            adminHeading('OEE% Target :'),
                            const SizedBox(width: minimumPadding),
                            Expanded(
                              child: TextFormField(
                                initialValue: Plans.targetOEE.toString(),
                                style: (const TextStyle(
                                    color: KelloggColors.darkBlue,
                                    fontWeight: FontWeight.w400)),
                                keyboardType:
                                    const TextInputType.numberWithOptions(
                                        decimal: true),
                                cursorColor: Colors.white,
                                obscureText: false,
                                decoration: InputDecoration(
                                  border: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: KelloggColors.darkBlue,
                                        width: textFieldBorderRadius),
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(textFieldRadius)),
                                  ),
                                  errorText: _targetOEE_validate
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
                                  targetOEE = value;
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: defaultPadding),
                        /////////////////////////////////////////////////////////////////////////
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            adminHeading('MPSA% Target :'),
                            const SizedBox(width: minimumPadding),
                            Expanded(
                              child: TextFormField(
                                initialValue: Plans.mpsaTarget.toString(),
                                style: (const TextStyle(
                                    color: KelloggColors.darkBlue,
                                    fontWeight: FontWeight.w400)),
                                keyboardType:
                                    const TextInputType.numberWithOptions(
                                        decimal: true),
                                cursorColor: Colors.white,
                                obscureText: false,
                                decoration: InputDecoration(
                                  border: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: KelloggColors.darkBlue,
                                        width: textFieldBorderRadius),
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(textFieldRadius)),
                                  ),
                                  errorText: _mpsaTarget_validate
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
                                  mpsaTarget = value;
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: defaultPadding),
                        /////////////////////////////////////////////////////////////////////////
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            adminHeading('Monthly Near Miss Target :'),
                            const SizedBox(width: minimumPadding),
                            Expanded(
                              child: TextFormField(
                                initialValue:
                                    Plans.monthlyNearMissTarget.toString(),
                                style: (const TextStyle(
                                    color: KelloggColors.darkBlue,
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
                                        color: KelloggColors.darkBlue,
                                        width: textFieldBorderRadius),
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(textFieldRadius)),
                                  ),
                                  errorText: _monthlyNearMissTarget_validate
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
                                  monthlyNearMissTarget = value;
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: defaultPadding),
                        /////////////////////////////////////////////////////////////////////////
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            adminHeading('Medium Risk Assessment Boundary :'),
                            const SizedBox(width: minimumPadding),
                            Expanded(
                              child: TextFormField(
                                initialValue:
                                    Plans.mediumRisksBoundary.toString(),
                                style: (const TextStyle(
                                    color: KelloggColors.darkBlue,
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
                                        color: KelloggColors.darkBlue,
                                        width: textFieldBorderRadius),
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(textFieldRadius)),
                                  ),
                                  errorText: _mediumRisksBoundary_validate
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
                                  mediumRisksBoundary = value;
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: defaultPadding),
                        /////////////////////////////////////////////////////////////////////////
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            adminHeading('High Risk Assessment Boundary :'),
                            const SizedBox(width: minimumPadding),
                            Expanded(
                              child: TextFormField(
                                initialValue:
                                    Plans.highRisksBoundary.toString(),
                                style: (const TextStyle(
                                    color: KelloggColors.darkBlue,
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
                                        color: KelloggColors.darkBlue,
                                        width: textFieldBorderRadius),
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(textFieldRadius)),
                                  ),
                                  errorText: _highRisksBoundary_validate
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
                                  highRisksBoundary = value;
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: defaultPadding),
                        /////////////////////////////////////////////////////////////////////////
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            adminHeading('Maximum Absence% Target :'),
                            const SizedBox(width: minimumPadding),
                            Expanded(
                              child: TextFormField(
                                initialValue: Plans.targetAbsence.toString(),
                                style: (const TextStyle(
                                    color: KelloggColors.darkBlue,
                                    fontWeight: FontWeight.w400)),
                                keyboardType:
                                    const TextInputType.numberWithOptions(
                                        decimal: true),
                                cursorColor: Colors.white,
                                obscureText: false,
                                decoration: InputDecoration(
                                  border: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: KelloggColors.darkBlue,
                                        width: textFieldBorderRadius),
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(textFieldRadius)),
                                  ),
                                  errorText: _target_absence_validate
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
                                  targetAbsence = value;
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: defaultPadding),
                        /////////////////////////////////////////////////////////////////////////
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            adminHeading('Plant Scrap Target :'),
                            const SizedBox(width: minimumPadding),
                            Expanded(
                              child: TextFormField(
                                initialValue:
                                    Plans.universalTargetScrap.toString(),
                                style: (const TextStyle(
                                    color: KelloggColors.darkBlue,
                                    fontWeight: FontWeight.w400)),
                                keyboardType:
                                    const TextInputType.numberWithOptions(
                                        decimal: true),
                                cursorColor: Colors.white,
                                obscureText: false,
                                decoration: InputDecoration(
                                  border: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: KelloggColors.darkBlue,
                                        width: textFieldBorderRadius),
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(textFieldRadius)),
                                  ),
                                  errorText: _universalTargetScrap_validate
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
                                  universalTargetScrap = value;
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: defaultPadding),
                        /////////////////////////////////////////////////////////////////////////
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            adminHeading('Plant Film Waste Target :'),
                            const SizedBox(width: minimumPadding),
                            Expanded(
                              child: TextFormField(
                                initialValue:
                                    Plans.universalTargetFilmWaste.toString(),
                                style: (const TextStyle(
                                    color: KelloggColors.darkBlue,
                                    fontWeight: FontWeight.w400)),
                                keyboardType:
                                    const TextInputType.numberWithOptions(
                                        decimal: true),
                                cursorColor: Colors.white,
                                obscureText: false,
                                decoration: InputDecoration(
                                  border: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: KelloggColors.darkBlue,
                                        width: textFieldBorderRadius),
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(textFieldRadius)),
                                  ),
                                  errorText: _universalTargetFilmWaste_validate
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
                                  universalTargetFilmWaste = value;
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: defaultPadding),
                        /////////////////////////////////////////////////////////////////////////
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            adminHeading('Electric Consumption Target :'),
                            const SizedBox(width: minimumPadding),
                            Expanded(
                              child: TextFormField(
                                initialValue:
                                    Plans.electConsumptionTarget.toString(),
                                style: (const TextStyle(
                                    color: KelloggColors.darkBlue,
                                    fontWeight: FontWeight.w400)),
                                keyboardType:
                                    const TextInputType.numberWithOptions(
                                        decimal: true),
                                cursorColor: Colors.white,
                                obscureText: false,
                                decoration: InputDecoration(
                                  border: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: KelloggColors.darkBlue,
                                        width: textFieldBorderRadius),
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(textFieldRadius)),
                                  ),
                                  errorText: _elect_consumption_validate
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
                                  electConsumptionTarget = value;
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: defaultPadding),
                        /////////////////////////////////////////////////////////////////////////
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            adminHeading('Water Consumption Target :'),
                            const SizedBox(width: minimumPadding),
                            Expanded(
                              child: TextFormField(
                                initialValue:
                                    Plans.waterConsumptionTarget.toString(),
                                style: (const TextStyle(
                                    color: KelloggColors.darkBlue,
                                    fontWeight: FontWeight.w400)),
                                keyboardType:
                                    const TextInputType.numberWithOptions(
                                        decimal: true),
                                cursorColor: Colors.white,
                                obscureText: false,
                                decoration: InputDecoration(
                                  border: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: KelloggColors.darkBlue,
                                        width: textFieldBorderRadius),
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(textFieldRadius)),
                                  ),
                                  errorText: _water_consumption_validate
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
                                  waterConsumptionTarget = value;
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: defaultPadding),
                        /////////////////////////////////////////////////////////////////////////
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            adminHeading('Gas Consumption Target :'),
                            const SizedBox(width: minimumPadding),
                            Expanded(
                              child: TextFormField(
                                initialValue:
                                    Plans.gasConsumptionTarget.toString(),
                                style: (const TextStyle(
                                    color: KelloggColors.darkBlue,
                                    fontWeight: FontWeight.w400)),
                                keyboardType:
                                    const TextInputType.numberWithOptions(
                                        decimal: true),
                                cursorColor: Colors.white,
                                obscureText: false,
                                decoration: InputDecoration(
                                  border: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: KelloggColors.darkBlue,
                                        width: textFieldBorderRadius),
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(textFieldRadius)),
                                  ),
                                  errorText: _gas_consumption_validate
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
                                  gasConsumptionTarget = value;
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: defaultPadding),
                        /////////////////////////////////////////////////////////////////////////
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            adminHeading('Organic Waste Consumption Target :'),
                            const SizedBox(width: minimumPadding),
                            Expanded(
                              child: TextFormField(
                                initialValue: Plans
                                    .organicWasteConsumptionTarget
                                    .toString(),
                                style: (const TextStyle(
                                    color: KelloggColors.darkBlue,
                                    fontWeight: FontWeight.w400)),
                                keyboardType:
                                    const TextInputType.numberWithOptions(
                                        decimal: true),
                                cursorColor: Colors.white,
                                obscureText: false,
                                decoration: InputDecoration(
                                  border: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: KelloggColors.darkBlue,
                                        width: textFieldBorderRadius),
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(textFieldRadius)),
                                  ),
                                  errorText: _organic_waste_consumption_validate
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
                                  organicWasteConsumptionTarget = value;
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: defaultPadding),
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
                                      emptyField(targetAbsence);
                                  _universalTargetFilmWaste_validate =
                                      emptyField(universalTargetFilmWaste);
                                  _universalTargetScrap_validate =
                                      emptyField(universalTargetScrap);
                                  _water_consumption_validate =
                                      emptyField(waterConsumptionTarget);
                                  _elect_consumption_validate =
                                      emptyField(electConsumptionTarget);
                                  _gas_consumption_validate =
                                      emptyField(gasConsumptionTarget);
                                  _organic_waste_consumption_validate =
                                      emptyField(organicWasteConsumptionTarget);
                                });
                                try {
                                  if (!_highRisksBoundary_validate &&
                                      !_mediumRisksBoundary_validate &&
                                      !_monthlyNearMissTarget_validate &&
                                      !_mpsaTarget_validate &&
                                      !_targetOEE_validate &&
                                      !_targetOverWeightAbove_validate &&
                                      !_universalTargetScrap_validate &&
                                      !_elect_consumption_validate &&
                                      !_water_consumption_validate &&
                                      !_gas_consumption_validate &&
                                      !_organic_waste_consumption_validate &&
                                      !_universalTargetFilmWaste_validate) {
                                    Plans.updateRules(
                                      context,
                                      double.parse(targetOverWeightAbove),
                                      double.parse(targetOEE),
                                      double.parse(mpsaTarget),
                                      int.parse(monthlyNearMissTarget),
                                      int.parse(mediumRisksBoundary),
                                      int.parse(highRisksBoundary),
                                      double.parse(targetAbsence),
                                      double.parse(universalTargetScrap),
                                      double.parse(universalTargetFilmWaste),
                                      double.parse(electConsumptionTarget),
                                      double.parse(waterConsumptionTarget),
                                      double.parse(gasConsumptionTarget),
                                      double.parse(
                                          organicWasteConsumptionTarget),
                                    );
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
