import 'package:cairo_bisco_app/classes/Credentials.dart';
import 'package:cairo_bisco_app/classes/Machine.dart';
import 'package:cairo_bisco_app/classes/utility_funcs/text_utilities.dart';
import 'package:cairo_bisco_app/classes/values/TextStandards.dart';
import 'package:cairo_bisco_app/classes/values/colors.dart';
import 'package:cairo_bisco_app/classes/values/constants.dart';
import 'package:cairo_bisco_app/components/alert_dialog.dart';
import 'package:cairo_bisco_app/components/buttons/back_btn.dart';
import 'package:cairo_bisco_app/components/buttons/rounded_btn.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import '../../classes/SKU.dart';
import '../../classes/values/form_values.dart';

class AdminEditMachinesNumsSku extends StatefulWidget {
  AdminEditMachinesNumsSku({
    Key? key,
    required this.refNum,
    required this.skuName,
  }) : super(key: key);
  final int refNum;
  final String skuName;

  @override
  _AdminEditMachinesNumsSkuState createState() =>
      _AdminEditMachinesNumsSkuState(
        refNum: refNum,
        skuName: skuName,
      );
}

class _AdminEditMachinesNumsSkuState extends State<AdminEditMachinesNumsSku> {
  _AdminEditMachinesNumsSkuState({
    required this.refNum,
    required this.skuName,
  });

  final int refNum;
  final String skuName;

  bool _valid_num_validate = false;
  bool showSpinner = false;

  String theoNum = "",
      machineName = Machine.packingMachinesList[0],
      selectedProdLine = prod_lines4[0];

  VoidCallback? onLineChange(val) {
    setState(() {
      selectedProdLine = val;
    });
    return null;
  }

  VoidCallback? onMachineNameChange(val) {
    setState(() {
      machineName = val;
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
              admin: true,
            ),
            title: Text(
              "Packing Machines Numbers",
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
                        adminHeading('Packing Machine Type'),
                        SizedBox(height: minimumPadding),
                        Container(
                          margin:
                              EdgeInsets.symmetric(vertical: minimumPadding),
                          padding: const EdgeInsets.symmetric(
                              horizontal: defaultPadding),
                          child: DropdownButtonFormField<String>(
                            // decoration: InputDecoration(labelText: 'اختر'),
                            value: machineName,
                            isExpanded: true,
                            items:
                                Machine.packingMachinesList.map((String value) {
                              return new DropdownMenuItem<String>(
                                value: value,
                                child: Text(
                                  value,
                                  style:
                                      TextStyle(color: KelloggColors.darkRed),
                                ),
                              );
                            }).toList(),
                            onChanged: onMachineNameChange,
                          ),
                        ),
                        SizedBox(height: defaultPadding),
                        ///////////////////////////////////////////////////////////////
                        adminHeading('Production Line'),
                        SizedBox(height: minimumPadding),
                        Container(
                          margin:
                              EdgeInsets.symmetric(vertical: minimumPadding),
                          padding: const EdgeInsets.symmetric(
                              horizontal: defaultPadding),
                          child: DropdownButtonFormField<String>(
                            // decoration: InputDecoration(labelText: 'اختر'),
                            value: selectedProdLine,
                            isExpanded: true,
                            items: prod_lines4.map((String value) {
                              return new DropdownMenuItem<String>(
                                value: value,
                                child: Text(
                                  value,
                                  style:
                                      TextStyle(color: KelloggColors.darkRed),
                                ),
                              );
                            }).toList(),
                            onChanged: onLineChange,
                          ),
                        ),
                        SizedBox(height: defaultPadding),
                        /////////////////////////////////////////////////////////////
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            adminHeading('Pcs/Min :'),
                            SizedBox(width: minimumPadding),
                            Expanded(
                              child: TextFormField(
                                // initialValue:
                                // Plans.targetOverWeightAbove.toString(),
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
                                  errorText: _valid_num_validate
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
                                  theoNum = value;
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
                              btnText: 'Add Entry',
                              color: KelloggColors.darkBlue,
                              onPressed: () async {
                                setState(() {
                                  showSpinner = true;
                                  _valid_num_validate = emptyField(theoNum);
                                });
                                try {
                                  if (!_valid_num_validate) {
                                    SKU.addMachineDetail(
                                      context,
                                      refNum,
                                      skuName,
                                      machineName,
                                      int.parse(theoNum.trim()),
                                      prod_lines4.indexOf(selectedProdLine) + 1,
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
                        sectionWithDivider('Existing Entries'),
                        /////////////////////////////////////////////////////////////////////////////////
                        ListView.builder(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            physics: ClampingScrollPhysics(),
                            // padding: const EdgeInsets.all(minimumPadding),
                            itemCount: SKU.skuMachineDetails[skuName]!.length,
                            itemBuilder: (BuildContext context, int index) {
                              return ListTile(
                                title: adminHeading(SKU
                                        .skuMachineDetails[skuName]![index]
                                        .name +
                                    " : " +
                                    SKU.skuMachineDetails[skuName]![index]
                                        .pcsPerMin
                                        .toString()),
                                trailing: smallerHeading("L" +
                                    SKU.skuMachineDetails[skuName]![index]
                                        .line_index
                                        .toString()),
                                leading: IconButton(
                                  icon: const Icon(Icons.close),
                                  color: KelloggColors.cockRed,
                                  onPressed: () {
                                    confirmDeleteMachineDetailAlertDialog(
                                        context,
                                        refNum,
                                        skuName,
                                        SKU.skuMachineDetails[skuName]![index]
                                            .id);
                                  },
                                ),
                              );
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
