import 'package:cairo_bisco_app/classes/BiscuitsReport.dart';
import 'package:cairo_bisco_app/classes/Credentials.dart';
import 'package:cairo_bisco_app/classes/SKU.dart';
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

class BiscuitsProductionForm extends StatefulWidget {
  BiscuitsProductionForm({
    required this.reportDetails,
    required this.isEdit,
    required this.reportID,
  });

  final dynamic reportDetails;
  final bool isEdit;
  final String reportID;

  @override
  _BiscuitsProductionFormState createState() => _BiscuitsProductionFormState(
        reportDetails: reportDetails,
        isEdit: isEdit,
        reportID: reportID,
      );
}

class _BiscuitsProductionFormState extends State<BiscuitsProductionForm> {
  _BiscuitsProductionFormState({
    required this.reportDetails,
    required this.isEdit,
    required this.reportID,
  });

  final String reportID;
  final bool isEdit;
  final dynamic reportDetails;

  bool showSpinner = false;
  int refNum = 0; // 0 = biscuits

  late String supName,
      shiftProductionPlan,
      actualSpeed,
      productionInCartons,
      extrusionScrap,
      extrusionRework,
      ovenScrap,
      ovenRework,
      cutterScrap,
      cutterRework,
      conveyorScrap,
      conveyorRework,
      mc1Speed,
      mc2Speed,
      packingScrap,
      packingRework,
      boxesWaste,
      cartonWaste,
      mc1FilmUsed,
      mc2FilmUsed,
      mc1WasteKg,
      mc2WasteKg;

  bool _sup_name_validate = false,
      _shift_plan_validate = false,
      _actualSpeed_validate = false,
      _productionInCartons_validate = false,
      _extrusionScrap_validate = false,
      _extrusionRework_validate = false,
      _ovenScrap_validate = false,
      _ovenRework_validate = false,
      _cutterScrap_validate = false,
      _cutterRework_validate = false,
      _conveyorScrap_validate = false,
      _conveyorRework_validate = false,
      _mc1Speed_validate = false,
      _mc2Speed_validate = false,
      _packingScrap_validate = false,
      _packingRework_validate = false,
      _boxesWaste_validate = false,
      _cartonWaste_validate = false,
      _mc1FilmUsed_validate = false,
      _mc2FilmUsed_validate = false,
      _mc1WasteKg_validate = false,
      _mc2WasteKg_validate = false;

  //drop down values
  late String selectedShift,
      selectedYear,
      selectedMonth,
      selectedDay,
      selectedProdLine,
      sku;

  VoidCallback? onSKUChange(val) {
    setState(() {
      sku = val;
    });
  }

  VoidCallback? onLineChange(val) {
    setState(() {
      selectedProdLine = val;
      print("changed line :" + selectedProdLine.toString());
    });
  }

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
    shiftProductionPlan =
        isEdit ? reportDetails.shiftProductionPlan.toString() : '';
    actualSpeed = isEdit ? reportDetails.actualSpeed.toString() : '';
    productionInCartons =
        isEdit ? reportDetails.productionInCartons.toString() : '';
    extrusionScrap = isEdit ? reportDetails.extrusionScrap.toString() : '';
    extrusionRework = isEdit ? reportDetails.extrusionRework.toString() : '';
    ovenScrap = isEdit ? reportDetails.ovenScrap.toString() : '';
    ovenRework = isEdit ? reportDetails.ovenRework.toString() : '';
    cutterScrap = isEdit ? reportDetails.cutterScrap.toString() : '';
    cutterRework = isEdit ? reportDetails.cutterRework.toString() : '';
    conveyorScrap = isEdit ? reportDetails.conveyorScrap.toString() : '';
    conveyorRework = isEdit ? reportDetails.conveyorRework.toString() : '';
    mc1Speed = isEdit ? reportDetails.mc1Speed.toString() : '';
    mc2Speed = isEdit ? reportDetails.mc2Speed.toString() : '';
    packingScrap = isEdit ? reportDetails.packingScrap.toString() : '';
    packingRework = isEdit ? reportDetails.packingRework.toString() : '';
    boxesWaste = isEdit ? reportDetails.boxesWaste.toString() : '';
    cartonWaste = isEdit ? reportDetails.cartonWaste.toString() : '';
    mc1FilmUsed = isEdit ? reportDetails.mc1FilmUsed.toString() : '';
    mc2FilmUsed = isEdit ? reportDetails.mc2FilmUsed.toString() : '';
    mc1WasteKg = isEdit ? reportDetails.mc1WasteKg.toString() : '';
    mc2WasteKg = isEdit ? reportDetails.mc2WasteKg.toString() : '';
    ///////////////////////////////////////////////////////////////////////////////
    selectedShift = shifts[reportDetails.shift_index];
    selectedYear =
        years[(isEdit ? reportDetails.year : (int.parse(getYear()))) - 2020];
    selectedMonth =
        months[(isEdit ? reportDetails.month : (int.parse(getMonth()))) - 1];
    selectedDay =
        days[(isEdit ? reportDetails.day : (int.parse(getDay()))) - 1];
    selectedProdLine = prod_lines4[reportDetails.line_index - 1];

    sku = isEdit ? reportDetails.skuName : SKU.biscuitSKU[0];
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
              "Biscuits",
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
                        /////////////////////////////////////////////////////////////
                        smallerHeading('تاريخ اليوم\nToday Date'),
                        SizedBox(height: minimumPadding),
                        Row(
                          children: [
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
                        smallerHeading('اختر الخط\nProduction Line'),
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
                        smallerHeading('نوع منتج البسكويت\nBiscuit SKU'),
                        SizedBox(height: minimumPadding),
                        Container(
                          margin:
                              EdgeInsets.symmetric(vertical: minimumPadding),
                          padding: const EdgeInsets.symmetric(
                              horizontal: defaultPadding),
                          child: DropdownButtonFormField<String>(
                            // decoration: InputDecoration(labelText: 'اختر'),
                            value: sku,
                            isExpanded: true,
                            items: SKU.biscuitSKU.map((String value) {
                              return new DropdownMenuItem<String>(
                                value: value,
                                child: Text(
                                  value,
                                  style:
                                      TextStyle(color: KelloggColors.darkRed),
                                ),
                              );
                            }).toList(),
                            onChanged: onSKUChange,
                          ),
                        ),
                        SizedBox(height: defaultPadding),
                        /////////////////////////////////////////////////////////////////////////////
                        sectionWithDivider('الانتاج Production'),
                        /////////////////////////////////////////////////////////////////////////////////
                        smallerHeading(
                            'خطة انتاج الوردية بالكراتين\nShift Production Plan'),
                        SizedBox(height: minimumPadding),
                        TextFormField(
                          initialValue: shiftProductionPlan,
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
                            errorText: _shift_plan_validate
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
                            shiftProductionPlan = value;
                          },
                        ),
                        SizedBox(height: defaultPadding),
                        ///////////////////////////////////////////////////////////////
                        smallerHeading(
                            'السرعة الفعلية لابطا ماكينة (السكينة)\nActual Speed of bottle neck'),
                        SizedBox(height: minimumPadding),
                        TextFormField(
                          initialValue: actualSpeed,
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
                            errorText: _actualSpeed_validate
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
                            actualSpeed = value;
                          },
                        ),
                        SizedBox(height: defaultPadding),
                        ///////////////////////////////////////////////////////////////
                        smallerHeading(
                            'الانتاج الفعلي بالكراتين\nProduction in Cartons'),
                        SizedBox(height: minimumPadding),
                        TextFormField(
                          initialValue: productionInCartons,
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
                            errorText: _productionInCartons_validate
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
                            productionInCartons = value;
                          },
                        ),
                        SizedBox(height: defaultPadding),
                        ///////////////////////////////////////////////////////////////
                        sectionWithDivider('التشكيل Extrusion'),
                        /////////////////////////////////////////////////////////////////////////////////
                        smallerHeading('اعادة تشغيل\nRework'),
                        SizedBox(height: minimumPadding),
                        TextFormField(
                          initialValue: extrusionRework,
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
                            errorText: _extrusionRework_validate
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
                            extrusionRework = value;
                          },
                        ),
                        SizedBox(height: defaultPadding),
                        //////////////////////////////////////////////////////////////////
                        smallerHeading('الهالك\nScrap'),
                        SizedBox(height: minimumPadding),
                        TextFormField(
                          initialValue: extrusionScrap,
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
                            errorText: _extrusionScrap_validate
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
                            extrusionScrap = value;
                          },
                        ),
                        SizedBox(height: defaultPadding),
                        //////////////////////////////////////////////////////////////////
                        sectionWithDivider('الفرن Oven'),
                        /////////////////////////////////////////////////////////////////////////////////
                        smallerHeading('اعادة تشغيل\nRework'),
                        SizedBox(height: minimumPadding),
                        TextFormField(
                          initialValue: ovenRework,
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
                            errorText: _ovenRework_validate
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
                            ovenRework = value;
                          },
                        ),
                        SizedBox(height: defaultPadding),
                        //////////////////////////////////////////////////////////////////
                        smallerHeading('الهالك\nScrap'),
                        SizedBox(height: minimumPadding),
                        TextFormField(
                          initialValue: ovenScrap,
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
                            errorText: _ovenScrap_validate
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
                            ovenScrap = value;
                          },
                        ),
                        SizedBox(height: defaultPadding),
                        //////////////////////////////////////////////////////////////////
                        sectionWithDivider('السكينة Cutter'),
                        /////////////////////////////////////////////////////////////////////////////////
                        smallerHeading('اعادة تشغيل\nRework'),
                        SizedBox(height: minimumPadding),
                        TextFormField(
                          initialValue: cutterRework,
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
                            errorText: _cutterRework_validate
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
                            cutterRework = value;
                          },
                        ),
                        SizedBox(height: defaultPadding),
                        //////////////////////////////////////////////////////////////////
                        smallerHeading('الهالك\nScrap'),
                        SizedBox(height: minimumPadding),
                        TextFormField(
                          initialValue: cutterScrap,
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
                            errorText: _cutterScrap_validate
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
                            cutterScrap = value;
                          },
                        ),
                        SizedBox(height: defaultPadding),
                        //////////////////////////////////////////////////////////////////
                        sectionWithDivider('السير Conveyor'),
                        /////////////////////////////////////////////////////////////////////////////////
                        smallerHeading('اعادة تشغيل\nRework'),
                        SizedBox(height: minimumPadding),
                        TextFormField(
                          initialValue: conveyorRework,
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
                            errorText: _conveyorRework_validate
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
                            conveyorRework = value;
                          },
                        ),
                        SizedBox(height: defaultPadding),
                        //////////////////////////////////////////////////////////////////
                        smallerHeading('الهالك\nScrap'),
                        SizedBox(height: minimumPadding),
                        TextFormField(
                          initialValue: conveyorScrap,
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
                            errorText: _conveyorScrap_validate
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
                            conveyorScrap = value;
                          },
                        ),
                        SizedBox(height: defaultPadding),
                        //////////////////////////////////////////////////////////////////
                        sectionWithDivider('التعبئة Packaging'),
                        //////////////////////////////////////////////////////////////////
                        smallerHeading('السرعة الفعلية MC1'),
                        SizedBox(height: minimumPadding),
                        TextFormField(
                          initialValue: mc1Speed,
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
                            errorText: _mc1Speed_validate
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
                            mc1Speed = value;
                          },
                        ),
                        SizedBox(height: defaultPadding),
                        ///////////////////////////////////////////////////////////////////////////
                        smallerHeading('السرعة الفعلية MC2'),
                        SizedBox(height: minimumPadding),
                        TextFormField(
                          initialValue: mc2Speed,
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
                            errorText: _mc2Speed_validate
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
                            mc2Speed = value;
                          },
                        ),
                        SizedBox(height: defaultPadding),
                        ///////////////////////////////////////////////////////////////////////////
                        smallerHeading(
                            'اعادة تشغيل بسكويت منطقة التغليف\nPacking Rework'),
                        SizedBox(height: minimumPadding),
                        TextFormField(
                          initialValue: packingRework,
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
                            errorText: _packingRework_validate
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
                            packingRework = value;
                          },
                        ),
                        SizedBox(height: defaultPadding),
                        ///////////////////////////////////////////////////////////////////////////
                        smallerHeading(
                            'هالك بسكويت منطقة التغليف\nPacking Scrap'),
                        SizedBox(height: minimumPadding),
                        TextFormField(
                          initialValue: packingScrap,
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
                            errorText: _packingScrap_validate
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
                            packingScrap = value;
                          },
                        ),
                        SizedBox(height: defaultPadding),
                        ///////////////////////////////////////////////////////////////////////////
                        smallerHeading('هالك علب\nBoxes Waste'),
                        SizedBox(height: minimumPadding),
                        TextFormField(
                          initialValue: boxesWaste,
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
                            errorText: _boxesWaste_validate
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
                            boxesWaste = value;
                          },
                        ),
                        SizedBox(height: defaultPadding),
                        ///////////////////////////////////////////////////////////////////////////
                        smallerHeading('هالك كرتون\nCarton Waste'),
                        SizedBox(height: minimumPadding),
                        TextFormField(
                          initialValue: cartonWaste,
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
                            errorText: _cartonWaste_validate
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
                            cartonWaste = value;
                          },
                        ),
                        SizedBox(height: defaultPadding),
                        //////////////////////////////////////////////////////////////////
                        sectionWithDivider('هالك الموبينات Film Waste'),
                        ///////////////////////////////////////////////////////////////////////////
                        smallerHeading('الهالك بالكجم MC1'),
                        SizedBox(height: minimumPadding),
                        TextFormField(
                          initialValue: mc1WasteKg,
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
                            errorText: _mc1WasteKg_validate
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
                            mc1WasteKg = value;
                          },
                        ),
                        SizedBox(height: defaultPadding),
                        ///////////////////////////////////////////////////////////////////////////
                        smallerHeading('اجمالي الفيلم المستخدم MC1'),
                        SizedBox(height: minimumPadding),
                        TextFormField(
                          initialValue: mc1FilmUsed,
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
                            errorText: _mc1FilmUsed_validate
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
                            mc1FilmUsed = value;
                          },
                        ),
                        SizedBox(height: defaultPadding),
                        ///////////////////////////////////////////////////////////////////////////
                        smallerHeading('الهالك بالكجم MC2'),
                        SizedBox(height: minimumPadding),
                        TextFormField(
                          initialValue: mc2WasteKg,
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
                            errorText: _mc2WasteKg_validate
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
                            mc2WasteKg = value;
                          },
                        ),
                        SizedBox(height: defaultPadding),
                        ///////////////////////////////////////////////////////////////////////////
                        smallerHeading('اجمالي الفيلم المستخدم MC2'),
                        SizedBox(height: minimumPadding),
                        TextFormField(
                          initialValue: mc2FilmUsed,
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
                            errorText: _mc2FilmUsed_validate
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
                            mc2FilmUsed = value;
                          },
                        ),
                        SizedBox(height: defaultPadding),
                        //////////////////////////////////button//////////////////////////
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
                                        _sup_name_validate =
                                            emptyField(supName);
                                        _shift_plan_validate =
                                            emptyField(shiftProductionPlan);
                                        _actualSpeed_validate =
                                            emptyField(actualSpeed);
                                        _productionInCartons_validate =
                                            emptyField(productionInCartons);
                                        _extrusionScrap_validate =
                                            emptyField(extrusionScrap);
                                        _extrusionRework_validate =
                                            emptyField(extrusionRework);
                                        _ovenScrap_validate =
                                            emptyField(ovenScrap);
                                        _ovenRework_validate =
                                            emptyField(ovenRework);
                                        _cutterScrap_validate =
                                            emptyField(cutterScrap);
                                        _cutterRework_validate =
                                            emptyField(cutterRework);
                                        _conveyorScrap_validate =
                                            emptyField(conveyorScrap);
                                        _conveyorRework_validate =
                                            emptyField(conveyorRework);
                                        _mc1Speed_validate =
                                            emptyField(mc1Speed);
                                        _mc2Speed_validate =
                                            emptyField(mc2Speed);
                                        _packingScrap_validate =
                                            emptyField(packingScrap);
                                        _packingRework_validate =
                                            emptyField(packingRework);
                                        _boxesWaste_validate =
                                            emptyField(boxesWaste);
                                        _cartonWaste_validate =
                                            emptyField(cartonWaste);
                                        _mc1FilmUsed_validate =
                                            emptyField(mc1FilmUsed);
                                        _mc2FilmUsed_validate =
                                            emptyField(mc2FilmUsed);
                                        _mc1WasteKg_validate =
                                            emptyField(mc1WasteKg);
                                        _mc2WasteKg_validate =
                                            emptyField(mc2WasteKg);
                                      });
                                      try {
                                        if (!_sup_name_validate &&
                                            !_shift_plan_validate &&
                                            !_actualSpeed_validate &&
                                            !_productionInCartons_validate &&
                                            !_extrusionScrap_validate &&
                                            !_extrusionRework_validate &&
                                            !_ovenScrap_validate &&
                                            !_ovenRework_validate &&
                                            !_cutterScrap_validate &&
                                            !_cutterRework_validate &&
                                            !_conveyorScrap_validate &&
                                            !_conveyorRework_validate &&
                                            !_mc1Speed_validate &&
                                            !_mc2Speed_validate &&
                                            !_packingScrap_validate &&
                                            !_packingRework_validate &&
                                            !_boxesWaste_validate &&
                                            !_cartonWaste_validate &&
                                            !_mc1FilmUsed_validate &&
                                            !_mc2FilmUsed_validate &&
                                            !_mc1WasteKg_validate &&
                                            !_mc2WasteKg_validate) {
                                          BiscuitsReport.addReport(
                                              supName,
                                              sku,
                                              double.parse(actualSpeed),
                                              double.parse(extrusionScrap),
                                              double.parse(extrusionRework),
                                              double.parse(ovenScrap),
                                              double.parse(ovenRework),
                                              double.parse(cutterScrap),
                                              double.parse(cutterRework),
                                              double.parse(conveyorScrap),
                                              double.parse(conveyorRework),
                                              double.parse(mc1Speed),
                                              double.parse(mc2Speed),
                                              double.parse(packingScrap),
                                              double.parse(packingRework),
                                              double.parse(boxesWaste),
                                              double.parse(cartonWaste),
                                              double.parse(mc1FilmUsed),
                                              double.parse(mc2FilmUsed),
                                              double.parse(mc1WasteKg),
                                              double.parse(mc2WasteKg),
                                              int.parse(shiftProductionPlan),
                                              int.parse(productionInCartons),
                                              prod_lines4.indexOf(
                                                      selectedProdLine) +
                                                  1,
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

                                        _sup_name_validate =
                                            emptyField(supName);
                                        _shift_plan_validate =
                                            emptyField(shiftProductionPlan);
                                        _actualSpeed_validate =
                                            emptyField(actualSpeed);
                                        _productionInCartons_validate =
                                            emptyField(productionInCartons);
                                        _extrusionScrap_validate =
                                            emptyField(extrusionScrap);
                                        _extrusionRework_validate =
                                            emptyField(extrusionRework);
                                        _ovenScrap_validate =
                                            emptyField(ovenScrap);
                                        _ovenRework_validate =
                                            emptyField(ovenRework);
                                        _cutterScrap_validate =
                                            emptyField(cutterScrap);
                                        _cutterRework_validate =
                                            emptyField(cutterRework);
                                        _conveyorScrap_validate =
                                            emptyField(conveyorScrap);
                                        _conveyorRework_validate =
                                            emptyField(conveyorRework);
                                        _mc1Speed_validate =
                                            emptyField(mc1Speed);
                                        _mc2Speed_validate =
                                            emptyField(mc2Speed);
                                        _packingScrap_validate =
                                            emptyField(packingScrap);
                                        _packingRework_validate =
                                            emptyField(packingRework);
                                        _boxesWaste_validate =
                                            emptyField(boxesWaste);
                                        _cartonWaste_validate =
                                            emptyField(cartonWaste);
                                        _mc1FilmUsed_validate =
                                            emptyField(mc1FilmUsed);
                                        _mc2FilmUsed_validate =
                                            emptyField(mc2FilmUsed);
                                        _mc1WasteKg_validate =
                                            emptyField(mc1WasteKg);
                                        _mc2WasteKg_validate =
                                            emptyField(mc2WasteKg);
                                      });
                                      try {
                                        if (!_sup_name_validate &&
                                            !_shift_plan_validate &&
                                            !_actualSpeed_validate &&
                                            !_productionInCartons_validate &&
                                            !_extrusionScrap_validate &&
                                            !_extrusionRework_validate &&
                                            !_ovenScrap_validate &&
                                            !_ovenRework_validate &&
                                            !_cutterScrap_validate &&
                                            !_cutterRework_validate &&
                                            !_conveyorScrap_validate &&
                                            !_conveyorRework_validate &&
                                            !_mc1Speed_validate &&
                                            !_mc2Speed_validate &&
                                            !_packingScrap_validate &&
                                            !_packingRework_validate &&
                                            !_boxesWaste_validate &&
                                            !_cartonWaste_validate &&
                                            !_mc1FilmUsed_validate &&
                                            !_mc2FilmUsed_validate &&
                                            !_mc1WasteKg_validate &&
                                            !_mc2WasteKg_validate) {
                                          BiscuitsReport.editReport(
                                              context,
                                              reportID,
                                              supName,
                                              sku,
                                              double.parse(actualSpeed),
                                              double.parse(extrusionScrap),
                                              double.parse(extrusionRework),
                                              double.parse(ovenScrap),
                                              double.parse(ovenRework),
                                              double.parse(cutterScrap),
                                              double.parse(cutterRework),
                                              double.parse(conveyorScrap),
                                              double.parse(conveyorRework),
                                              double.parse(mc1Speed),
                                              double.parse(mc2Speed),
                                              double.parse(packingScrap),
                                              double.parse(packingRework),
                                              double.parse(boxesWaste),
                                              double.parse(cartonWaste),
                                              double.parse(mc1FilmUsed),
                                              double.parse(mc2FilmUsed),
                                              double.parse(mc1WasteKg),
                                              double.parse(mc2WasteKg),
                                              int.parse(shiftProductionPlan),
                                              int.parse(productionInCartons),
                                              prod_lines4.indexOf(
                                                      selectedProdLine) +
                                                  1,
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
                            : SizedBox(height: minimumPadding),
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
                                        BiscuitsReport.deleteReport(
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
