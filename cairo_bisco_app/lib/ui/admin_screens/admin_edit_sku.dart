import 'package:cairo_bisco_app/classes/SKU.dart';
import 'package:cairo_bisco_app/classes/utility_funcs/text_utilities.dart';
import 'package:cairo_bisco_app/classes/values/TextStandards.dart';
import 'package:cairo_bisco_app/classes/values/colors.dart';
import 'package:cairo_bisco_app/classes/values/constants.dart';
import 'package:cairo_bisco_app/components/buttons/back_btn.dart';
import 'package:cairo_bisco_app/components/buttons/rounded_btn.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import 'admin_edit_machines_nums_sku.dart';

class AdminEditSku extends StatefulWidget {
  AdminEditSku({
    Key? key,
    required this.refNum,
    required this.skuName,
  }) : super(key: key);
  final int refNum;
  final String skuName;

  @override
  _AdminEditSkuState createState() => _AdminEditSkuState(
        refNum: refNum,
        skuName: skuName,
      );
}

class _AdminEditSkuState extends State<AdminEditSku> {
  _AdminEditSkuState({
    required this.refNum,
    required this.skuName,
  });

  final String skuName;
  final int refNum;

  bool showSpinner = false;

  bool _cartonWeight_validate = false,
      _theoreticalShiftProd1_validate = false,
      _theoreticalShiftProd2_validate = false,
      _theoreticalShiftProd3_validate = false,
      _theoreticalShiftProd4_validate = false,
      _boxesPerCarton_validate = false,
      _targetFilmWaste_validate = false,
      _targetScrap_validate = false,
      _rm_cost_validate = false,
      _pm_cost_validate = false,
      _piece_weight_validate = false;

  @override
  Widget build(BuildContext context) {
    String cartonWeight = SKU.skuDetails[skuName]!.cartonWeight.toString(),
        theoreticalShiftProd1 =
            SKU.skuDetails[skuName]!.theoreticalShiftProd1.toString(),
        theoreticalShiftProd2 =
            SKU.skuDetails[skuName]!.theoreticalShiftProd2.toString(),
        theoreticalShiftProd3 =
            SKU.skuDetails[skuName]!.theoreticalShiftProd3.toString(),
        theoreticalShiftProd4 =
            SKU.skuDetails[skuName]!.theoreticalShiftProd4.toString(),
        boxesPerCarton = SKU.skuDetails[skuName]!.boxesPerCarton.toString(),
        targetScrap = SKU.skuDetails[skuName]!.targetScrap.toString(),
        targetFilmWaste = SKU.skuDetails[skuName]!.targetFilmWaste.toString(),
        pm_cost = SKU.skuDetails[skuName]!.pm_cost.toString(),
        rm_cost = SKU.skuDetails[skuName]!.rm_cost.toString(),
        piece_weight = SKU.skuDetails[skuName]!.pieceWeight.toString();
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
                        smallerHeading('SKU Name'),
                        SizedBox(height: minimumPadding),
                        TextFormField(
                          initialValue: skuName,
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
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: KelloggColors.yellow,
                                  width: textFieldFocusedBorderRadius),
                              borderRadius: BorderRadius.all(
                                  Radius.circular(textFieldRadius)),
                            ),
                          ),
                        ),
                        SizedBox(height: defaultPadding),
                        /////////////////////////////////////////////////////////////////////////
                        smallerHeading('وزن الكرتونة بالكجم\nCarton Weight'),
                        SizedBox(height: minimumPadding),
                        TextFormField(
                          initialValue: cartonWeight,
                          style: (TextStyle(
                              color: KelloggColors.darkRed,
                              fontWeight: FontWeight.w400)),
                          keyboardType:
                              TextInputType.numberWithOptions(decimal: true),
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
                            errorText: _cartonWeight_validate
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
                            cartonWeight = value;
                          },
                        ),
                        SizedBox(height: defaultPadding),
                        //////////////////////////////////////////////////////////////////
                        smallerHeading(
                            'عدد العلب في الكرتونة\nBoxes Per Carton'),
                        SizedBox(height: minimumPadding),
                        TextFormField(
                          initialValue: boxesPerCarton,
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
                            errorText: _boxesPerCarton_validate
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
                            boxesPerCarton = value;
                          },
                        ),
                        SizedBox(height: defaultPadding),
                        //////////////////////////////////////////////////////////////////
                        smallerHeading(
                            'الانتاج المثالي في الوردية خط 1\nTheoretical Production Per Shift L1'),
                        SizedBox(height: minimumPadding),
                        TextFormField(
                          initialValue: theoreticalShiftProd1,
                          style: (TextStyle(
                              color: KelloggColors.darkRed,
                              fontWeight: FontWeight.w400)),
                          keyboardType:
                              TextInputType.numberWithOptions(decimal: true),
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
                            errorText: _theoreticalShiftProd1_validate
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
                            theoreticalShiftProd1 = value;
                          },
                        ),
                        SizedBox(height: defaultPadding),
                        /////////////////////////////////////////////////////////////////////////
                        smallerHeading(
                            'الانتاج المثالي في الوردية خط 2\nTheoretical Production Per Shift L2'),
                        SizedBox(height: minimumPadding),
                        TextFormField(
                          initialValue: theoreticalShiftProd2,
                          style: (TextStyle(
                              color: KelloggColors.darkRed,
                              fontWeight: FontWeight.w400)),
                          keyboardType:
                              TextInputType.numberWithOptions(decimal: true),
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
                            errorText: _theoreticalShiftProd2_validate
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
                            theoreticalShiftProd2 = value;
                          },
                        ),
                        SizedBox(height: defaultPadding),
                        /////////////////////////////////////////////////////////////////////////
                        smallerHeading(
                            'الانتاج المثالي في الوردية خط 3\nTheoretical Production Per Shift L3'),
                        SizedBox(height: minimumPadding),
                        TextFormField(
                          initialValue: theoreticalShiftProd3,
                          style: (TextStyle(
                              color: KelloggColors.darkRed,
                              fontWeight: FontWeight.w400)),
                          keyboardType:
                              TextInputType.numberWithOptions(decimal: true),
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
                            errorText: _theoreticalShiftProd3_validate
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
                            theoreticalShiftProd3 = value;
                          },
                        ),
                        SizedBox(height: defaultPadding),
                        /////////////////////////////////////////////////////////////////////////
                        smallerHeading(
                            'الانتاج المثالي في الوردية خط 4\nTheoretical Production Per Shift L4'),
                        SizedBox(height: minimumPadding),
                        TextFormField(
                          initialValue: theoreticalShiftProd4,
                          style: (TextStyle(
                              color: KelloggColors.darkRed,
                              fontWeight: FontWeight.w400)),
                          keyboardType:
                              TextInputType.numberWithOptions(decimal: true),
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
                            errorText: _theoreticalShiftProd4_validate
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
                            theoreticalShiftProd4 = value;
                          },
                        ),
                        SizedBox(height: defaultPadding),
                        /////////////////////////////////////////////////////////////////////////
                        smallerHeading('مستهدف الهالك للمنتج\nTarget Scrap'),
                        SizedBox(height: minimumPadding),
                        TextFormField(
                          initialValue: targetScrap,
                          style: (TextStyle(
                              color: KelloggColors.darkRed,
                              fontWeight: FontWeight.w400)),
                          keyboardType:
                              TextInputType.numberWithOptions(decimal: true),
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
                            errorText: _targetScrap_validate
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
                            targetScrap = value;
                          },
                        ),
                        SizedBox(height: defaultPadding),
                        /////////////////////////////////////////////////////////////////////////
                        smallerHeading(
                            'مستهدف هالك التغليف للمنتج\nTarget Film Waste'),
                        SizedBox(height: minimumPadding),
                        TextFormField(
                          initialValue: targetFilmWaste,
                          style: (TextStyle(
                              color: KelloggColors.darkRed,
                              fontWeight: FontWeight.w400)),
                          keyboardType:
                              TextInputType.numberWithOptions(decimal: true),
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
                            errorText: _targetFilmWaste_validate
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
                            targetFilmWaste = value;
                          },
                        ),
                        SizedBox(height: defaultPadding),
                        /////////////////////////////////////////////////////////////////////////
                        smallerHeading('تكلفة هالك المنتج\nRM Cost'),
                        SizedBox(height: minimumPadding),
                        TextFormField(
                          initialValue: rm_cost,
                          style: (TextStyle(
                              color: KelloggColors.darkRed,
                              fontWeight: FontWeight.w400)),
                          keyboardType:
                              TextInputType.numberWithOptions(decimal: true),
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
                            errorText: _rm_cost_validate
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
                            rm_cost = value;
                          },
                        ),
                        SizedBox(height: defaultPadding),
                        /////////////////////////////////////////////////////////////////////////
                        smallerHeading('تكلفة هالك الفيلم للمنتج\nPM Cost'),
                        SizedBox(height: minimumPadding),
                        TextFormField(
                          initialValue: pm_cost,
                          style: (TextStyle(
                              color: KelloggColors.darkRed,
                              fontWeight: FontWeight.w400)),
                          keyboardType:
                              TextInputType.numberWithOptions(decimal: true),
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
                            errorText: _pm_cost_validate
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
                            pm_cost = value;
                          },
                        ),
                        SizedBox(height: defaultPadding),
                        /////////////////////////////////////////////////////////////////////////
                        smallerHeading('وزن القطعة\nPiece Weight'),
                        SizedBox(height: minimumPadding),
                        TextFormField(
                          initialValue: piece_weight,
                          style: (TextStyle(
                              color: KelloggColors.darkRed,
                              fontWeight: FontWeight.w400)),
                          keyboardType:
                              TextInputType.numberWithOptions(decimal: true),
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
                            errorText: _piece_weight_validate
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
                            piece_weight = value;
                          },
                        ),
                        SizedBox(height: defaultPadding),

                        //////////////////////////////////////////////////////////////////
                        Padding(
                          padding: const EdgeInsets.all(minimumPadding),
                          child: Center(
                            child: RoundedButton(
                                btnText: 'Edit Machines Numbers',
                                color: KelloggColors.green,
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              AdminEditMachinesNumsSku(
                                                refNum: refNum,
                                                skuName: skuName,
                                              )));
                                }),
                          ),
                        ),
                        //////////////////////////////////////////////////////////////////
                        Padding(
                          padding: const EdgeInsets.all(minimumPadding),
                          child: Center(
                            child: RoundedButton(
                              btnText: 'Edit Sku',
                              color: KelloggColors.darkBlue,
                              onPressed: () {
                                setState(() {
                                  showSpinner = true;
                                  _targetFilmWaste_validate =
                                      emptyField(targetFilmWaste);
                                  _cartonWeight_validate =
                                      emptyField(cartonWeight);
                                  _targetScrap_validate =
                                      emptyField(targetScrap);
                                  _theoreticalShiftProd1_validate =
                                      emptyField(theoreticalShiftProd1);
                                  _theoreticalShiftProd2_validate =
                                      emptyField(theoreticalShiftProd2);
                                  _theoreticalShiftProd3_validate =
                                      emptyField(theoreticalShiftProd3);
                                  _theoreticalShiftProd4_validate =
                                      emptyField(theoreticalShiftProd4);
                                  _boxesPerCarton_validate =
                                      emptyField(boxesPerCarton);
                                  _rm_cost_validate = emptyField(rm_cost);
                                  _pm_cost_validate = emptyField(pm_cost);
                                  _piece_weight_validate =
                                      emptyField(piece_weight);
                                });
                                try {
                                  if (!_targetFilmWaste_validate &&
                                      !_cartonWeight_validate &&
                                      !_targetScrap_validate &&
                                      !_boxesPerCarton_validate &&
                                      !_theoreticalShiftProd1_validate &&
                                      !_theoreticalShiftProd2_validate &&
                                      !_theoreticalShiftProd3_validate &&
                                      !_theoreticalShiftProd4_validate &&
                                      !_rm_cost_validate &&
                                      !_pm_cost_validate &&
                                      !_piece_weight_validate) {
                                    SKU.editSKU(
                                      context,
                                      refNum,
                                      skuName,
                                      double.parse(cartonWeight),
                                      double.parse(theoreticalShiftProd1),
                                      double.parse(theoreticalShiftProd2),
                                      double.parse(theoreticalShiftProd3),
                                      double.parse(theoreticalShiftProd4),
                                      double.parse(targetScrap),
                                      double.parse(targetFilmWaste),
                                      int.parse(boxesPerCarton),
                                      double.parse(rm_cost),
                                      double.parse(pm_cost),
                                      double.parse(piece_weight),
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
                        SizedBox(height: minimumPadding),
                        Padding(
                          padding: const EdgeInsets.all(minimumPadding),
                          child: Center(
                            child: RoundedButton(
                              btnText: 'Delete Sku',
                              color: KelloggColors.cockRed,
                              onPressed: () {
                                setState(() {
                                  showSpinner = true;
                                });
                                try {
                                  SKU.deleteSku(
                                    context,
                                    refNum,
                                    skuName,
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
