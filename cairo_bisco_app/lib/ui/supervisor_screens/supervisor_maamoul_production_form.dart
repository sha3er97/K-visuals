import 'package:cairo_bisco_app/classes/Credentials.dart';
import 'package:cairo_bisco_app/classes/MaamoulReport.dart';
import 'package:cairo_bisco_app/classes/SKU.dart';
import 'package:cairo_bisco_app/classes/utility_funcs/date_utility.dart';
import 'package:cairo_bisco_app/classes/utility_funcs/other_utility.dart';
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

class MaamoulProductionForm extends StatefulWidget {
  MaamoulProductionForm({
    required this.reportDetails,
    required this.isEdit,
    required this.reportID,
  });

  final dynamic reportDetails;
  final bool isEdit;
  final String reportID;

  @override
  _MaamoulProductionFormState createState() => _MaamoulProductionFormState(
        reportDetails: reportDetails,
        isEdit: isEdit,
        reportID: reportID,
      );
}

class _MaamoulProductionFormState extends State<MaamoulProductionForm> {
  _MaamoulProductionFormState({
    required this.reportDetails,
    required this.isEdit,
    required this.reportID,
  });

  final String reportID;
  final dynamic reportDetails;
  final bool isEdit;

  bool showSpinner = false;
  int refNum = 2; // 2 = maamoul

  late String supName,
      shiftProductionPlan,
      actualSpeed,
      productionInCartons,
      mixerScrap,
      mixerRework,
      stampingScrap,
      stampingRework,
      ovenScrap,
      ovenRework,
      mc1Speed,
      mc2Speed,
      packingScrap,
      packingRework,
      boxesWaste,
      cartonWaste,
      mc1FilmUsed,
      mc2FilmUsed,
      mc1WasteKg,
      mc2WasteKg,
      shiftHours,
      wastedMinutes;

  bool _sup_name_validate = false,
      _shift_plan_validate = false,
      _actualSpeed_validate = false,
      _productionInCartons_validate = false,
      _mixerScrap_validate = false,
      _mixerRework_validate = false,
      _ovenScrap_validate = false,
      _ovenRework_validate = false,
      _stampingScrap_validate = false,
      _stampingRework_validate = false,
      _mc1Speed_validate = false,
      _mc2Speed_validate = false,
      _packingScrap_validate = false,
      _packingRework_validate = false,
      _boxesWaste_validate = false,
      _cartonWaste_validate = false,
      _mc1FilmUsed_validate = false,
      _mc2FilmUsed_validate = false,
      _mc1WasteKg_validate = false,
      _mc2WasteKg_validate = false,
      _shiftHours_validate = false,
      _wastedMinutes_validate = false;

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
    mixerScrap = isEdit ? reportDetails.mixerScrap.toString() : '';
    mixerRework = isEdit ? reportDetails.mixerRework.toString() : '';
    ovenScrap = isEdit ? reportDetails.ovenScrap.toString() : '';
    ovenRework = isEdit ? reportDetails.ovenRework.toString() : '';
    stampingScrap = isEdit ? reportDetails.stampingScrap.toString() : '';
    stampingRework = isEdit ? reportDetails.stampingRework.toString() : '';
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
    shiftHours = isEdit
        ? reportDetails.shiftHours.toString()
        : standardShiftHours.toString();
    wastedMinutes = isEdit ? reportDetails.wastedMinutes.toString() : '';

    ///////////////////////////////////////////////////////////////////////////////
    selectedShift = shifts[reportDetails.shift_index];
    selectedYear =
        years[(isEdit ? reportDetails.year : (int.parse(getYear()))) - 2020];
    selectedMonth =
        months[(isEdit ? reportDetails.month : (int.parse(getMonth()))) - 1];
    selectedDay =
        days[(isEdit ? reportDetails.day : (int.parse(getDay()))) - 1];
    selectedProdLine = prod_lines4[reportDetails.line_index - 1];
    sku = isEdit ? reportDetails.skuName : SKU.maamoulSKU[0];
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
              "Maamoul",
              style: TextStyle(
                  color: KelloggColors.cockRed,
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
                        smallerHeading('اسم المسؤول\nResponsible Name'),
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
                            // decoration: InputDecoration(labelText: 'اختر'),
                            // hint: Text(
                            //   "اختر",
                            //   style: TextStyle(
                            //       fontWeight: FontWeight.w300,
                            //       fontSize: 13,
                            //       color: KelloggColors.darkRed),
                            // ),
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
                        smallerHeading('عدد ساعات الوردية\nShift Hours'),
                        SizedBox(height: minimumPadding),
                        TextFormField(
                          initialValue: shiftHours,
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
                            errorText: _shiftHours_validate
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
                            shiftHours = value;
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
                            items: prod_lines2.map((String value) {
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
                        smallerHeading('نوع منتج المعمول\nMaamoul SKU'),
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
                            items: SKU.maamoulSKU.map((String value) {
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
                            'اجمالي توقفات الخط بالدقيقة\nTotal line stops in Minutes'),
                        SizedBox(height: minimumPadding),
                        TextFormField(
                          initialValue: wastedMinutes,
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
                            errorText: _wastedMinutes_validate
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
                            wastedMinutes = value;
                          },
                        ),
                        SizedBox(height: defaultPadding),
                        ///////////////////////////////////////////////////////////////
                        smallerHeading(
                            'السرعة الفعلية لابطا ماكينة (التشكيل)\nActual Speed for bottle neck'),
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
                        smallerHeading('الانتاج الفعلي بالكراتين\nProduction'),
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
                        sectionWithDivider('التخليط Mixer'),
                        /////////////////////////////////////////////////////////////////////////////////
                        smallerHeading('اعادة تشغيل\nRework'),
                        SizedBox(height: minimumPadding),
                        TextFormField(
                          initialValue: mixerRework,
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
                            errorText: _mixerRework_validate
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
                            mixerRework = value;
                          },
                        ),
                        SizedBox(height: defaultPadding),
                        //////////////////////////////////////////////////////////////////
                        smallerHeading('الهالك\nScrap'),
                        SizedBox(height: minimumPadding),
                        TextFormField(
                          initialValue: mixerScrap,
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
                            errorText: _mixerScrap_validate
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
                            mixerScrap = value;
                          },
                        ),
                        SizedBox(height: defaultPadding),
                        //////////////////////////////////////////////////////////////////
                        sectionWithDivider('التشكيل Stamping'),
                        /////////////////////////////////////////////////////////////////////////////////
                        smallerHeading('اعادة تشغيل\nRework'),
                        SizedBox(height: minimumPadding),
                        TextFormField(
                          initialValue: stampingRework,
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
                            errorText: _stampingRework_validate
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
                            stampingRework = value;
                          },
                        ),
                        SizedBox(height: defaultPadding),
                        //////////////////////////////////////////////////////////////////
                        smallerHeading('الهالك\nScrap'),
                        SizedBox(height: minimumPadding),
                        TextFormField(
                          initialValue: stampingScrap,
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
                            errorText: _stampingScrap_validate
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
                            stampingScrap = value;
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
                        sectionWithDivider('التعبئة Packaging'),
                        //////////////////////////////////////////////////////////////////
                        smallerHeading('السرعة الفعلية mc1'),
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
                        smallerHeading('السرعة الفعلية mc2'),
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
                            'اعادة تشغيل معمول منطقة التغليف\nPacking Rework'),
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
                            'هالك معمول منطقة التغليف\nPacking Scrap'),
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
                        smallerHeading('الهالك بالكجم mc1'),
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
                        smallerHeading('اجمالي الفيلم المستخدم mc1'),
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
                        smallerHeading('الهالك بالكجم mc2'),
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
                        smallerHeading('اجمالي الفيلم المستخدم mc2'),
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
                                        _mixerScrap_validate =
                                            emptyField(mixerScrap);
                                        _mixerRework_validate =
                                            emptyField(mixerRework);
                                        _ovenScrap_validate =
                                            emptyField(ovenScrap);
                                        _ovenRework_validate =
                                            emptyField(ovenRework);
                                        _stampingScrap_validate =
                                            emptyField(stampingScrap);
                                        _stampingRework_validate =
                                            emptyField(stampingRework);
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
                                        _shiftHours_validate =
                                            emptyField(shiftHours);
                                        _wastedMinutes_validate =
                                            emptyField(wastedMinutes);
                                      });
                                      try {
                                        if (!_sup_name_validate &&
                                            !_shift_plan_validate &&
                                            !_actualSpeed_validate &&
                                            !_productionInCartons_validate &&
                                            !_mixerScrap_validate &&
                                            !_mixerRework_validate &&
                                            !_ovenScrap_validate &&
                                            !_ovenRework_validate &&
                                            !_stampingScrap_validate &&
                                            !_stampingRework_validate &&
                                            !_mc1Speed_validate &&
                                            !_mc2Speed_validate &&
                                            !_packingScrap_validate &&
                                            !_packingRework_validate &&
                                            !_boxesWaste_validate &&
                                            !_cartonWaste_validate &&
                                            !_mc1FilmUsed_validate &&
                                            !_mc2FilmUsed_validate &&
                                            !_mc1WasteKg_validate &&
                                            !_mc2WasteKg_validate &&
                                            !_shiftHours_validate &&
                                            !_wastedMinutes_validate) {
                                          MaamoulReport.addReport(
                                            supName,
                                            sku,
                                            double.parse(actualSpeed),
                                            double.parse(ovenScrap),
                                            double.parse(ovenRework),
                                            double.parse(mixerScrap),
                                            double.parse(mixerRework),
                                            double.parse(stampingScrap),
                                            double.parse(stampingRework),
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
                                            prod_lines4
                                                    .indexOf(selectedProdLine) +
                                                1,
                                            shifts.indexOf(selectedShift),
                                            refNum,
                                            int.parse(selectedYear),
                                            int.parse(selectedMonth),
                                            int.parse(selectedDay),
                                            double.parse(shiftHours),
                                            double.parse(wastedMinutes),
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
                        //////////////////////////////////////////////
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
                                        _mixerScrap_validate =
                                            emptyField(mixerScrap);
                                        _mixerRework_validate =
                                            emptyField(mixerRework);
                                        _ovenScrap_validate =
                                            emptyField(ovenScrap);
                                        _ovenRework_validate =
                                            emptyField(ovenRework);
                                        _stampingScrap_validate =
                                            emptyField(stampingScrap);
                                        _stampingRework_validate =
                                            emptyField(stampingRework);
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
                                        _shiftHours_validate =
                                            emptyField(shiftHours);
                                        _wastedMinutes_validate =
                                            emptyField(wastedMinutes);
                                      });
                                      try {
                                        if (!_sup_name_validate &&
                                            !_shift_plan_validate &&
                                            !_actualSpeed_validate &&
                                            !_productionInCartons_validate &&
                                            !_mixerScrap_validate &&
                                            !_mixerRework_validate &&
                                            !_ovenScrap_validate &&
                                            !_ovenRework_validate &&
                                            !_stampingScrap_validate &&
                                            !_stampingRework_validate &&
                                            !_mc1Speed_validate &&
                                            !_mc2Speed_validate &&
                                            !_packingScrap_validate &&
                                            !_packingRework_validate &&
                                            !_boxesWaste_validate &&
                                            !_cartonWaste_validate &&
                                            !_mc1FilmUsed_validate &&
                                            !_mc2FilmUsed_validate &&
                                            !_mc1WasteKg_validate &&
                                            !_shiftHours_validate &&
                                            !_wastedMinutes_validate) {
                                          if (canEditThisReport(
                                            supName,
                                            int.parse(selectedDay),
                                            int.parse(selectedMonth),
                                            int.parse(selectedYear),
                                          )) {
                                            MaamoulReport.editReport(
                                              context,
                                              reportID,
                                              supName,
                                              sku,
                                              double.parse(actualSpeed),
                                              double.parse(ovenScrap),
                                              double.parse(ovenRework),
                                              double.parse(mixerScrap),
                                              double.parse(mixerRework),
                                              double.parse(stampingScrap),
                                              double.parse(stampingRework),
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
                                              int.parse(selectedDay),
                                              double.parse(shiftHours),
                                              double.parse(wastedMinutes),
                                            );
                                          } else {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(SnackBar(
                                              content:
                                                  Text(unauthorizedEditMsg),
                                            ));
                                          }
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
                                        if (canEditThisReport(
                                            supName,
                                            int.parse(selectedDay),
                                            int.parse(selectedMonth),
                                            int.parse(selectedYear))) {
                                          MaamoulReport.deleteReport(
                                            context,
                                            reportID,
                                            int.parse(selectedYear),
                                          );
                                        } else {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
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
