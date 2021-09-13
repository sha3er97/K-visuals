import 'package:cairo_bisco_app/classes/SKU.dart';
import 'package:cairo_bisco_app/classes/values/TextStandards.dart';
import 'package:cairo_bisco_app/classes/values/colors.dart';
import 'package:cairo_bisco_app/classes/values/constants.dart';
import 'package:cairo_bisco_app/components/buttons/back_btn.dart';
import 'package:cairo_bisco_app/components/buttons/rounded_btn.dart';
import 'package:cairo_bisco_app/components/utility_funcs/login_utility.dart';
import 'package:cairo_bisco_app/ui/error_success_screens/success.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class AddSkuForm extends StatefulWidget {
  AddSkuForm({
    Key? key,
    required this.refNum,
  }) : super(key: key);
  final int refNum;

  @override
  _AddSkuFormState createState() => _AddSkuFormState(refNum: refNum);
}

class _AddSkuFormState extends State<AddSkuForm> {
  _AddSkuFormState({
    required this.refNum,
  });

  final int refNum;

  bool showSpinner = false;
  String skuName = "",
      cartonWeight = "",
      theoreticalShiftProd = "",
      targetScrap = "",
      targetFilmWaste = "";
  bool _skuName_validate = false,
      _cartonWeight_validate = false,
      _theoreticalShiftProd_validate = false,
      _targetFilmWaste_validate = false,
      _targetScrap_validate = false;

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
            leading: MyBackButton(),
            title: Text(
              prodType[refNum],
              style: TextStyle(
                  color: KelloggColors.yellow,
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
                        TextField(
                          style: (TextStyle(
                              color: KelloggColors.darkRed,
                              fontWeight: FontWeight.w400)),
                          keyboardType: TextInputType.name,
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
                            errorText:
                                _skuName_validate ? 'هذه الخانة ضرورية' : null,
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: KelloggColors.yellow,
                                  width: textFieldFocusedBorderRadius),
                              borderRadius: BorderRadius.all(
                                  Radius.circular(textFieldRadius)),
                            ),
                          ),
                          onChanged: (value) {
                            skuName = value;
                          },
                        ),
                        SizedBox(height: defaultPadding),
                        /////////////////////////////////////////////////////////////////////////
                        smallerHeading('وزن الكرتونة بالكجم\nCarton Weight'),
                        SizedBox(height: minimumPadding),
                        TextField(
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
                                ? 'هذه الخانة ضرورية'
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
                            'الانتاج المثالي في الوردية\nTheoretical Production Per Shift'),
                        SizedBox(height: minimumPadding),
                        TextField(
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
                            errorText: _theoreticalShiftProd_validate
                                ? 'هذه الخانة ضرورية'
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
                            theoreticalShiftProd = value;
                          },
                        ),
                        SizedBox(height: defaultPadding),
                        /////////////////////////////////////////////////////////////////////////
                        smallerHeading('مستهدف الهالك للمنتج\nTarget Scrap'),
                        SizedBox(height: minimumPadding),
                        TextField(
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
                                ? 'هذه الخانة ضرورية'
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
                        TextField(
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
                                ? 'هذه الخانة ضرورية'
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
                        //////////////////////////////////////////////////////////////////
                        Padding(
                          padding: const EdgeInsets.all(minimumPadding),
                          child: Center(
                            child: RoundedButton(
                              btnText: 'Add Sku',
                              color: KelloggColors.darkRed,
                              onPressed: () async {
                                setState(() {
                                  showSpinner = true;
                                  _skuName_validate = emptyField(skuName);
                                  _targetFilmWaste_validate =
                                      emptyField(targetFilmWaste);
                                  _cartonWeight_validate =
                                      emptyField(cartonWeight);
                                  _targetScrap_validate =
                                      emptyField(targetScrap);
                                  _theoreticalShiftProd_validate =
                                      emptyField(theoreticalShiftProd);
                                });
                                try {
                                  if (!_skuName_validate &&
                                      !_targetFilmWaste_validate &&
                                      !_cartonWeight_validate &&
                                      !_targetScrap_validate &&
                                      !_theoreticalShiftProd_validate) {
                                    SKU.addSKU(
                                      refNum,
                                      skuName,
                                      double.parse(cartonWeight),
                                      double.parse(theoreticalShiftProd),
                                      double.parse(targetScrap),
                                      double.parse(targetFilmWaste),
                                    );
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
