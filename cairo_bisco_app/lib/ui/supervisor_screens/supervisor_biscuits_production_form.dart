import 'package:cairo_bisco_app/classes/BiscuitsReport.dart';
import 'package:cairo_bisco_app/classes/Credentials.dart';
import 'package:cairo_bisco_app/classes/Machine.dart';
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

class BiscuitsProductionForm extends StatefulWidget {
  BiscuitsProductionForm({
    required this.reportDetails,
    required this.isEdit,
    required this.reportID,
  });

  final BiscuitsReport reportDetails;
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
      productionInCartons,
      extrusionScrap,
      extrusionRework,
      extrusionScrapReason,
      ovenScrap,
      ovenRework,
      ovenScrapReason,
      cutterScrap,
      cutterRework,
      cutterScrapReason,
      conveyorScrap,
      conveyorRework,
      conveyorScrapReason,
      mc1Speed,
      mc2Speed,
      mc3Speed,
      mc4Speed,
      packingScrap,
      packingRework,
      packingScrapReason,
      boxesWaste,
      cartonWaste,
      mc1FilmUsed,
      mc2FilmUsed,
      mc1WasteKg,
      mc2WasteKg,
      shiftHours,
      wastedMinutes,
      //3.0.9 additions
      mc1Type,
      mc2Type,
      mc3Type,
      mc4Type,
      mc3FilmUsed,
      mc4FilmUsed,
      mc3WasteKg,
      mc4WasteKg;

  bool _sup_name_validate = false,
      _shift_plan_validate = false,
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
      _mc3Speed_validate = false,
      _mc4Speed_validate = false,
      _packingScrap_validate = false,
      _packingRework_validate = false,
      _boxesWaste_validate = false,
      _cartonWaste_validate = false,
      _mc1FilmUsed_validate = false,
      _mc2FilmUsed_validate = false,
      _mc3FilmUsed_validate = false,
      _mc4FilmUsed_validate = false,
      _mc1WasteKg_validate = false,
      _mc2WasteKg_validate = false,
      _mc3WasteKg_validate = false,
      _mc4WasteKg_validate = false,
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

  VoidCallback? onMC1Change(val) {
    setState(() {
      mc1Type = val;
    });
  }

  VoidCallback? onMC2Change(val) {
    setState(() {
      mc2Type = val;
    });
  }

  VoidCallback? onMC3Change(val) {
    setState(() {
      mc3Type = val;
    });
  }

  VoidCallback? onMC4Change(val) {
    setState(() {
      mc4Type = val;
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

    packingScrap = isEdit ? reportDetails.packingScrap.toString() : '';
    packingRework = isEdit ? reportDetails.packingRework.toString() : '';
    boxesWaste = isEdit ? reportDetails.boxesWaste.toString() : '';
    cartonWaste = isEdit ? reportDetails.cartonWaste.toString() : '';
    mc1FilmUsed = isEdit ? reportDetails.mc1FilmUsed.toString() : '0';
    mc2FilmUsed = isEdit ? reportDetails.mc2FilmUsed.toString() : '0';
    mc1WasteKg = isEdit ? reportDetails.mc1WasteKg.toString() : '0';
    mc2WasteKg = isEdit ? reportDetails.mc2WasteKg.toString() : '0';
    shiftHours = isEdit
        ? reportDetails.shiftHours.toString()
        : standardShiftHours.toString();
    wastedMinutes = isEdit ? reportDetails.wastedMinutes.toString() : '';
    //3.0.8 additions
    conveyorScrapReason =
        isEdit ? reportDetails.conveyorScrapReason.toString() : '';
    cutterScrapReason =
        isEdit ? reportDetails.cutterScrapReason.toString() : '';
    extrusionScrapReason =
        isEdit ? reportDetails.extrusionScrapReason.toString() : '';
    ovenScrapReason = isEdit ? reportDetails.ovenScrapReason.toString() : '';
    packingScrapReason =
        isEdit ? reportDetails.packingScrapReason.toString() : '';
    //3.0.9 additions
    mc1Speed = isEdit ? reportDetails.mc1Speed.toString() : '0';
    mc2Speed = isEdit ? reportDetails.mc2Speed.toString() : '0';
    mc3Speed = isEdit ? reportDetails.mc3Speed.toString() : '0';
    mc4Speed = isEdit ? reportDetails.mc4Speed.toString() : '0';
    mc3FilmUsed = isEdit ? reportDetails.mc3FilmUsed.toString() : '0';
    mc4FilmUsed = isEdit ? reportDetails.mc4FilmUsed.toString() : '0';
    mc3WasteKg = isEdit ? reportDetails.mc3WasteKg.toString() : '0';
    mc4WasteKg = isEdit ? reportDetails.mc4WasteKg.toString() : '0';
    ///////////////////////////////////////////////////////////////////////////////
    selectedShift = shifts[reportDetails.shift_index];
    selectedYear =
        years[(isEdit ? reportDetails.year : (int.parse(getYear()))) - 2020];
    selectedMonth =
        months[(isEdit ? reportDetails.month : (int.parse(getMonth()))) - 1];
    selectedDay =
        days[(isEdit ? reportDetails.day : (int.parse(getDay()))) - 1];
    selectedProdLine = prod_lines4[reportDetails.line_index - 1];

    sku = isEdit
        ? reportDetails.skuName
        : SKU.allSkus[refNum][0]; //SKU.biscuitSKU[0];
    //3.0.9 additions
    mc1Type = isEdit ? reportDetails.mc1Type : Machine.packingMachinesList[0];
    mc2Type = isEdit ? reportDetails.mc2Type : Machine.packingMachinesList[0];
    mc3Type = isEdit ? reportDetails.mc3Type : Machine.packingMachinesList[0];
    mc4Type = isEdit ? reportDetails.mc4Type : Machine.packingMachinesList[0];
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
                            items: SKU.allSkus[refNum].map((String value) {
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
                        smallerHeading('سبب الهالك \nScrap Reason'),
                        SizedBox(height: minimumPadding),
                        TextFormField(
                          initialValue: extrusionScrapReason,
                          style: (TextStyle(
                              color: KelloggColors.darkRed,
                              fontWeight: FontWeight.w400)),
                          keyboardType: TextInputType.multiline,
                          cursorColor: Colors.white,
                          decoration: InputDecoration(
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
                          onChanged: (value) {
                            extrusionScrapReason = value;
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
                        smallerHeading('سبب الهالك \nScrap Reason'),
                        SizedBox(height: minimumPadding),
                        TextFormField(
                          initialValue: ovenScrapReason,
                          style: (TextStyle(
                              color: KelloggColors.darkRed,
                              fontWeight: FontWeight.w400)),
                          keyboardType: TextInputType.multiline,
                          cursorColor: Colors.white,
                          decoration: InputDecoration(
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
                          onChanged: (value) {
                            ovenScrapReason = value;
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
                        smallerHeading('سبب الهالك \nScrap Reason'),
                        SizedBox(height: minimumPadding),
                        TextFormField(
                          initialValue: cutterScrapReason,
                          style: (TextStyle(
                              color: KelloggColors.darkRed,
                              fontWeight: FontWeight.w400)),
                          keyboardType: TextInputType.multiline,
                          cursorColor: Colors.white,
                          decoration: InputDecoration(
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
                          onChanged: (value) {
                            cutterScrapReason = value;
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
                        smallerHeading('سبب الهالك \nScrap Reason'),
                        SizedBox(height: minimumPadding),
                        TextFormField(
                          initialValue: conveyorScrapReason,
                          style: (TextStyle(
                              color: KelloggColors.darkRed,
                              fontWeight: FontWeight.w400)),
                          keyboardType: TextInputType.multiline,
                          cursorColor: Colors.white,
                          decoration: InputDecoration(
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
                          onChanged: (value) {
                            conveyorScrapReason = value;
                          },
                        ),
                        SizedBox(height: defaultPadding),
                        //////////////////////////////////////////////////////////////////
                        sectionWithDivider('التعبئة Packaging'),
                        //////////////////////////////////////////////////////////////////
                        smallerHeading(
                            'نوع مكنة التغليف 1\nPacking Machine 1 Type'),
                        SizedBox(height: minimumPadding),
                        Container(
                          margin:
                              EdgeInsets.symmetric(vertical: minimumPadding),
                          padding: const EdgeInsets.symmetric(
                              horizontal: defaultPadding),
                          child: DropdownButtonFormField<String>(
                            // decoration: InputDecoration(labelText: 'اختر'),
                            value: mc1Type,
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
                            onChanged: onMC1Change,
                          ),
                        ),
                        SizedBox(height: defaultPadding),
                        /////////////////////////////////////////////////////////////////////////////
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
                        smallerHeading(
                            'نوع مكنة التغليف 2\nPacking Machine 2 Type'),
                        SizedBox(height: minimumPadding),
                        Container(
                          margin:
                              EdgeInsets.symmetric(vertical: minimumPadding),
                          padding: const EdgeInsets.symmetric(
                              horizontal: defaultPadding),
                          child: DropdownButtonFormField<String>(
                            // decoration: InputDecoration(labelText: 'اختر'),
                            value: mc2Type,
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
                            onChanged: onMC2Change,
                          ),
                        ),
                        SizedBox(height: defaultPadding),
                        /////////////////////////////////////////////////////////////////////////////
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
                            'نوع مكنة التغليف 3\nPacking Machine 3 Type'),
                        SizedBox(height: minimumPadding),
                        Container(
                          margin:
                              EdgeInsets.symmetric(vertical: minimumPadding),
                          padding: const EdgeInsets.symmetric(
                              horizontal: defaultPadding),
                          child: DropdownButtonFormField<String>(
                            // decoration: InputDecoration(labelText: 'اختر'),
                            value: mc3Type,
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
                            onChanged: onMC3Change,
                          ),
                        ),
                        SizedBox(height: defaultPadding),
                        /////////////////////////////////////////////////////////////////////////////
                        smallerHeading('السرعة الفعلية MC3'),
                        SizedBox(height: minimumPadding),
                        TextFormField(
                          initialValue: mc3Speed,
                          style: (TextStyle(
                              color: KelloggColors.darkRed,
                              fontWeight: FontWeight.w400)),
                          keyboardType:
                              TextInputType.numberWithOptions(decimal: true),
                          cursorColor: Colors.white,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: KelloggColors.darkRed,
                                  width: textFieldBorderRadius),
                              borderRadius: BorderRadius.all(
                                  Radius.circular(textFieldRadius)),
                            ),
                            errorText: _mc3Speed_validate
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
                            mc3Speed = value;
                          },
                        ),
                        SizedBox(height: defaultPadding),
                        ///////////////////////////////////////////////////////////////////////////
                        smallerHeading(
                            'نوع مكنة التغليف 4\nPacking Machine 4 Type'),
                        SizedBox(height: minimumPadding),
                        Container(
                          margin:
                              EdgeInsets.symmetric(vertical: minimumPadding),
                          padding: const EdgeInsets.symmetric(
                              horizontal: defaultPadding),
                          child: DropdownButtonFormField<String>(
                            // decoration: InputDecoration(labelText: 'اختر'),
                            value: mc4Type,
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
                            onChanged: onMC4Change,
                          ),
                        ),
                        SizedBox(height: defaultPadding),
                        /////////////////////////////////////////////////////////////////////////////
                        smallerHeading('السرعة الفعلية MC4'),
                        SizedBox(height: minimumPadding),
                        TextFormField(
                          initialValue: mc4Speed,
                          style: (TextStyle(
                              color: KelloggColors.darkRed,
                              fontWeight: FontWeight.w400)),
                          keyboardType:
                              TextInputType.numberWithOptions(decimal: true),
                          cursorColor: Colors.white,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: KelloggColors.darkRed,
                                  width: textFieldBorderRadius),
                              borderRadius: BorderRadius.all(
                                  Radius.circular(textFieldRadius)),
                            ),
                            errorText: _mc4Speed_validate
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
                            mc4Speed = value;
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
                        smallerHeading('سبب الهالك \nScrap Reason'),
                        SizedBox(height: minimumPadding),
                        TextFormField(
                          initialValue: packingScrapReason,
                          style: (TextStyle(
                              color: KelloggColors.darkRed,
                              fontWeight: FontWeight.w400)),
                          keyboardType: TextInputType.multiline,
                          cursorColor: Colors.white,
                          decoration: InputDecoration(
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
                          onChanged: (value) {
                            packingScrapReason = value;
                          },
                        ),
                        SizedBox(height: defaultPadding),
                        //////////////////////////////////////////////////////////////////
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
                        smallerHeading('الهالك بالكجم MC3'),
                        SizedBox(height: minimumPadding),
                        TextFormField(
                          initialValue: mc3WasteKg,
                          style: (TextStyle(
                              color: KelloggColors.darkRed,
                              fontWeight: FontWeight.w400)),
                          keyboardType:
                              TextInputType.numberWithOptions(decimal: true),
                          cursorColor: Colors.white,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: KelloggColors.darkRed,
                                  width: textFieldBorderRadius),
                              borderRadius: BorderRadius.all(
                                  Radius.circular(textFieldRadius)),
                            ),
                            errorText: _mc3WasteKg_validate
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
                            mc3WasteKg = value;
                          },
                        ),
                        SizedBox(height: defaultPadding),
                        ///////////////////////////////////////////////////////////////////////////
                        smallerHeading('اجمالي الفيلم المستخدم MC3'),
                        SizedBox(height: minimumPadding),
                        TextFormField(
                          initialValue: mc3FilmUsed,
                          style: (TextStyle(
                              color: KelloggColors.darkRed,
                              fontWeight: FontWeight.w400)),
                          keyboardType:
                              TextInputType.numberWithOptions(decimal: true),
                          cursorColor: Colors.white,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: KelloggColors.darkRed,
                                  width: textFieldBorderRadius),
                              borderRadius: BorderRadius.all(
                                  Radius.circular(textFieldRadius)),
                            ),
                            errorText: _mc3FilmUsed_validate
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
                            mc3FilmUsed = value;
                          },
                        ),
                        SizedBox(height: defaultPadding),
                        ///////////////////////////////////////////////////////////////////////////
                        smallerHeading('الهالك بالكجم MC4'),
                        SizedBox(height: minimumPadding),
                        TextFormField(
                          initialValue: mc4WasteKg,
                          style: (TextStyle(
                              color: KelloggColors.darkRed,
                              fontWeight: FontWeight.w400)),
                          keyboardType:
                              TextInputType.numberWithOptions(decimal: true),
                          cursorColor: Colors.white,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: KelloggColors.darkRed,
                                  width: textFieldBorderRadius),
                              borderRadius: BorderRadius.all(
                                  Radius.circular(textFieldRadius)),
                            ),
                            errorText: _mc4WasteKg_validate
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
                            mc4WasteKg = value;
                          },
                        ),
                        SizedBox(height: defaultPadding),
                        ///////////////////////////////////////////////////////////////////////////
                        smallerHeading('اجمالي الفيلم المستخدم MC4'),
                        SizedBox(height: minimumPadding),
                        TextFormField(
                          initialValue: mc4FilmUsed,
                          style: (TextStyle(
                              color: KelloggColors.darkRed,
                              fontWeight: FontWeight.w400)),
                          keyboardType:
                              TextInputType.numberWithOptions(decimal: true),
                          cursorColor: Colors.white,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: KelloggColors.darkRed,
                                  width: textFieldBorderRadius),
                              borderRadius: BorderRadius.all(
                                  Radius.circular(textFieldRadius)),
                            ),
                            errorText: _mc4FilmUsed_validate
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
                            mc4FilmUsed = value;
                          },
                        ),
                        SizedBox(height: defaultPadding),
                        ///////////////////////////////////////////////////////////////////////////

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
                                        _shiftHours_validate =
                                            emptyField(shiftHours);
                                        _wastedMinutes_validate =
                                            emptyField(wastedMinutes);
                                        //3.0.9 additions
                                        _mc3Speed_validate =
                                            emptyField(mc3Speed);
                                        _mc4Speed_validate =
                                            emptyField(mc4Speed);
                                        _mc3FilmUsed_validate =
                                            emptyField(mc3FilmUsed);
                                        _mc4FilmUsed_validate =
                                            emptyField(mc4FilmUsed);
                                        _mc3WasteKg_validate =
                                            emptyField(mc3WasteKg);
                                        _mc4WasteKg_validate =
                                            emptyField(mc4WasteKg);
                                      });
                                      try {
                                        if (!_sup_name_validate &&
                                            !_shift_plan_validate &&
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
                                            !_mc2WasteKg_validate &&
                                            !_shiftHours_validate &&
                                            !_wastedMinutes_validate &&
                                            //3.0.9 additions
                                            !_mc3Speed_validate &&
                                            !_mc4Speed_validate &&
                                            !_mc3FilmUsed_validate &&
                                            !_mc4FilmUsed_validate &&
                                            !_mc3WasteKg_validate &&
                                            !_mc4WasteKg_validate) {
                                          BiscuitsReport.addReport(
                                            supName,
                                            sku,
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
                                            double.parse(mc3FilmUsed),
                                            double.parse(mc4FilmUsed),
                                            double.parse(mc1WasteKg),
                                            double.parse(mc2WasteKg),
                                            double.parse(mc3WasteKg),
                                            double.parse(mc4WasteKg),
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
                                            //3.0.8 additions
                                            extrusionScrapReason,
                                            ovenScrapReason,
                                            conveyorScrapReason,
                                            cutterScrapReason,
                                            packingScrapReason,
                                            //3.0.9 additions
                                            double.parse(mc3Speed),
                                            double.parse(mc4Speed),
                                            mc1Type,
                                            mc2Type,
                                            mc3Type,
                                            mc4Type,
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
                                        _shiftHours_validate =
                                            emptyField(shiftHours);
                                        _wastedMinutes_validate =
                                            emptyField(wastedMinutes);
                                        //3.0.9 additions
                                        _mc3Speed_validate =
                                            emptyField(mc3Speed);
                                        _mc4Speed_validate =
                                            emptyField(mc4Speed);
                                        _mc3FilmUsed_validate =
                                            emptyField(mc3FilmUsed);
                                        _mc4FilmUsed_validate =
                                            emptyField(mc4FilmUsed);
                                        _mc3WasteKg_validate =
                                            emptyField(mc3WasteKg);
                                        _mc4WasteKg_validate =
                                            emptyField(mc4WasteKg);
                                      });
                                      try {
                                        if (!_sup_name_validate &&
                                            !_shift_plan_validate &&
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
                                            !_mc2WasteKg_validate &&
                                            !_shiftHours_validate &&
                                            !_wastedMinutes_validate &&
                                            //3.0.9 additions
                                            !_mc3Speed_validate &&
                                            !_mc4Speed_validate &&
                                            !_mc3FilmUsed_validate &&
                                            !_mc4FilmUsed_validate &&
                                            !_mc3WasteKg_validate &&
                                            !_mc4WasteKg_validate) {
                                          if (canEditThisReport(
                                            supName,
                                            int.parse(selectedDay),
                                            int.parse(selectedMonth),
                                            int.parse(selectedYear),
                                          )) {
                                            BiscuitsReport.editReport(
                                              context,
                                              reportID,
                                              supName,
                                              sku,
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
                                              double.parse(mc3FilmUsed),
                                              double.parse(mc2FilmUsed),
                                              double.parse(mc1WasteKg),
                                              double.parse(mc2WasteKg),
                                              double.parse(mc3WasteKg),
                                              double.parse(mc4WasteKg),
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
                                              //3.0.8 additions
                                              extrusionScrapReason,
                                              ovenScrapReason,
                                              conveyorScrapReason,
                                              cutterScrapReason,
                                              packingScrapReason,
                                              //3.0.9 additions
                                              double.parse(mc3Speed),
                                              double.parse(mc4Speed),
                                              mc1Type,
                                              mc2Type,
                                              mc3Type,
                                              mc4Type,
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
                                          BiscuitsReport.deleteReport(
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
