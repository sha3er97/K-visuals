import 'package:cairo_bisco_app/classes/MaamoulReport.dart';
import 'package:cairo_bisco_app/classes/SKU.dart';
import 'package:cairo_bisco_app/classes/utility_funcs/date_utility.dart';
import 'package:cairo_bisco_app/classes/utility_funcs/login_utility.dart';
import 'package:cairo_bisco_app/classes/values/TextStandards.dart';
import 'package:cairo_bisco_app/classes/values/colors.dart';
import 'package:cairo_bisco_app/classes/values/constants.dart';
import 'package:cairo_bisco_app/classes/values/form_values.dart';
import 'package:cairo_bisco_app/components/buttons/back_btn.dart';
import 'package:cairo_bisco_app/components/buttons/rounded_btn.dart';
import 'package:cairo_bisco_app/ui/error_success_screens/success.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class MaamoulProductionForm extends StatefulWidget {
  @override
  _MaamoulProductionFormState createState() => _MaamoulProductionFormState();
}

class _MaamoulProductionFormState extends State<MaamoulProductionForm> {
  bool showSpinner = false;
  int refNum = 2; // 2 = maamoul

  String supName = "",
      shiftProductionPlan = '',
      actualSpeed = '',
      productionInCartons = '',
      mixerScrap = '',
      mixerRework = '',
      stampingScrap = '',
      stampingRework = '',
      ovenScrap = '',
      ovenRework = '',
      unPackedProducts = '',
      mc1Speed = '',
      mc2Speed = '',
      packingScrap = '',
      packingRework = '',
      packingRepack = '',
      boxesWaste = '',
      cartonWaste = '',
      mc1FilmUsed = '',
      mc2FilmUsed = '',
      mc1WasteKg = '',
      mc2WasteKg = '';

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
      _unPackedProducts_validate = false,
      _mc1Speed_validate = false,
      _mc2Speed_validate = false,
      _packingScrap_validate = false,
      _packingRework_validate = false,
      _packingRepack_validate = false,
      _boxesWaste_validate = false,
      _cartonWaste_validate = false,
      _mc1FilmUsed_validate = false,
      _mc2FilmUsed_validate = false,
      _mc1WasteKg_validate = false,
      _mc2WasteKg_validate = false;

  //drop down values
  String selectedShift = shifts[0];
  String selectedYear = years[(int.parse(getYear())) - 2020];
  String selectedMonth = months[(int.parse(getMonth())) - 1];
  String selectedDay = days[(int.parse(getDay())) - 1];
  String selectedProdLine = prod_lines4[0];
  String sku = SKU.maamoulSKU[0];

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
                        smallerHeading('اسم المشرف المسؤول\nSupervisor Name'),
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
                                _sup_name_validate ? 'هذه الخانة ضرورية' : null,
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
                        smallerHeading('تاريخ اليوم\nToday Date'),
                        SizedBox(height: minimumPadding),
                        Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12.0),
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
                                    horizontal: 12.0),
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
                                    horizontal: 12.0),
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
                            'خطة انتاج الوردية\nShift Production Plan'),
                        SizedBox(height: minimumPadding),
                        TextField(
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
                            shiftProductionPlan = value;
                          },
                        ),
                        SizedBox(height: defaultPadding),
                        ///////////////////////////////////////////////////////////////
                        smallerHeading('السرعة الفعلية\nActual Speed'),
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
                            errorText: _actualSpeed_validate
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
                            actualSpeed = value;
                          },
                        ),
                        SizedBox(height: defaultPadding),
                        ///////////////////////////////////////////////////////////////
                        smallerHeading('الانتاج الفعلي بالكراتين\nProduction'),
                        SizedBox(height: minimumPadding),
                        TextField(
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
                            productionInCartons = value;
                          },
                        ),
                        SizedBox(height: defaultPadding),
                        ///////////////////////////////////////////////////////////////
                        sectionWithDivider('التخليط Mixer'),
                        /////////////////////////////////////////////////////////////////////////////////
                        smallerHeading('اعادة تشغيل\nRework'),
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
                            errorText: _mixerRework_validate
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
                            mixerRework = value;
                          },
                        ),
                        SizedBox(height: defaultPadding),
                        //////////////////////////////////////////////////////////////////
                        smallerHeading('الهالك\nScrap'),
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
                            errorText: _mixerScrap_validate
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
                            mixerScrap = value;
                          },
                        ),
                        SizedBox(height: defaultPadding),
                        //////////////////////////////////////////////////////////////////
                        sectionWithDivider('التشكيل Stamping'),
                        /////////////////////////////////////////////////////////////////////////////////
                        smallerHeading('اعادة تشغيل\nRework'),
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
                            errorText: _stampingRework_validate
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
                            stampingRework = value;
                          },
                        ),
                        SizedBox(height: defaultPadding),
                        //////////////////////////////////////////////////////////////////
                        smallerHeading('الهالك\nScrap'),
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
                            errorText: _stampingScrap_validate
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
                            stampingScrap = value;
                          },
                        ),
                        SizedBox(height: defaultPadding),
                        //////////////////////////////////////////////////////////////////
                        sectionWithDivider('الفرن Oven'),
                        /////////////////////////////////////////////////////////////////////////////////
                        smallerHeading('اعادة تشغيل\nRework'),
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
                            errorText: _ovenRework_validate
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
                            ovenRework = value;
                          },
                        ),
                        SizedBox(height: defaultPadding),
                        //////////////////////////////////////////////////////////////////
                        smallerHeading('الهالك\nScrap'),
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
                            errorText: _ovenScrap_validate
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
                            ovenScrap = value;
                          },
                        ),
                        SizedBox(height: defaultPadding),
                        //////////////////////////////////////////////////////////////////
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            myDivider(),
                            Text(
                              'الانتاج الغير معبأ',
                              style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: largeFontSize,
                                  color: KelloggColors.darkBlue),
                            ),
                            Text(
                              'Unpacked Products',
                              style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: largeFontSize,
                                  color: KelloggColors.darkBlue),
                            ),
                            SizedBox(height: defaultPadding),
                          ],
                        ),
                        //////////////////////////////////////////////////////////////////
                        smallerHeading('الوزن بالكجم\nWeight in Kg'),
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
                            errorText: _unPackedProducts_validate
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
                            unPackedProducts = value;
                          },
                        ),
                        SizedBox(height: defaultPadding),
                        //////////////////////////////////////////////////////////////////
                        sectionWithDivider('التعبئة Packaging'),
                        //////////////////////////////////////////////////////////////////
                        smallerHeading('السرعة الفعلية mc1'),
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
                            errorText:
                                _mc1Speed_validate ? 'هذه الخانة ضرورية' : null,
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
                            errorText:
                                _mc2Speed_validate ? 'هذه الخانة ضرورية' : null,
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
                        smallerHeading('اعادة التشغيل\nRework'),
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
                            errorText: _packingRework_validate
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
                            packingRework = value;
                          },
                        ),
                        SizedBox(height: defaultPadding),
                        ///////////////////////////////////////////////////////////////////////////
                        smallerHeading('اعادة التغليف\nRepack'),
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
                            errorText: _packingRepack_validate
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
                            packingRepack = value;
                          },
                        ),
                        SizedBox(height: defaultPadding),
                        ///////////////////////////////////////////////////////////////////////////
                        smallerHeading('هالك معمول\nScrap'),
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
                            errorText: _packingScrap_validate
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
                            packingScrap = value;
                          },
                        ),
                        SizedBox(height: defaultPadding),
                        ///////////////////////////////////////////////////////////////////////////
                        smallerHeading('هالك علب\nBoxes Waste'),
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
                            errorText: _boxesWaste_validate
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
                            boxesWaste = value;
                          },
                        ),
                        SizedBox(height: defaultPadding),
                        ///////////////////////////////////////////////////////////////////////////
                        smallerHeading('هالك كرتون\nCarton Waste'),
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
                            errorText: _cartonWaste_validate
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
                            cartonWaste = value;
                          },
                        ),
                        SizedBox(height: defaultPadding),
                        //////////////////////////////////////////////////////////////////
                        sectionWithDivider('هالك الموبينات Film Waste'),
                        ///////////////////////////////////////////////////////////////////////////
                        smallerHeading('الهالك بالكجم mc1'),
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
                            errorText: _mc1WasteKg_validate
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
                            mc1WasteKg = value;
                          },
                        ),
                        SizedBox(height: defaultPadding),
                        ///////////////////////////////////////////////////////////////////////////
                        smallerHeading('اجمالي الفيلم المستخدم mc1'),
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
                            errorText: _mc1FilmUsed_validate
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
                            mc1FilmUsed = value;
                          },
                        ),
                        SizedBox(height: defaultPadding),
                        ///////////////////////////////////////////////////////////////////////////
                        smallerHeading('الهالك بالكجم mc2'),
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
                            errorText: _mc2WasteKg_validate
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
                            mc2WasteKg = value;
                          },
                        ),
                        SizedBox(height: defaultPadding),
                        ///////////////////////////////////////////////////////////////////////////
                        smallerHeading('اجمالي الفيلم المستخدم mc2'),
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
                            errorText: _mc2FilmUsed_validate
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
                            mc2FilmUsed = value;
                          },
                        ),
                        SizedBox(height: defaultPadding),
                        //////////////////////////////////button//////////////////////////
                        Padding(
                          padding: const EdgeInsets.all(minimumPadding),
                          child: Center(
                            child: RoundedButton(
                              btnText: 'تسليم التقرير',
                              color: KelloggColors.darkRed,
                              onPressed: () async {
                                setState(() {
                                  showSpinner = true;
                                  _sup_name_validate = emptyField(supName);
                                  _shift_plan_validate =
                                      emptyField(shiftProductionPlan);
                                  _actualSpeed_validate =
                                      emptyField(actualSpeed);
                                  _productionInCartons_validate =
                                      emptyField(productionInCartons);
                                  _mixerScrap_validate = emptyField(mixerScrap);
                                  _mixerRework_validate =
                                      emptyField(mixerRework);
                                  _ovenScrap_validate = emptyField(ovenScrap);
                                  _ovenRework_validate = emptyField(ovenRework);
                                  _stampingScrap_validate =
                                      emptyField(stampingScrap);
                                  _stampingRework_validate =
                                      emptyField(stampingRework);
                                  _unPackedProducts_validate =
                                      emptyField(unPackedProducts);
                                  _mc1Speed_validate = emptyField(mc1Speed);
                                  _mc2Speed_validate = emptyField(mc2Speed);
                                  _packingScrap_validate =
                                      emptyField(packingScrap);
                                  _packingRework_validate =
                                      emptyField(packingRework);
                                  _packingRepack_validate =
                                      emptyField(packingRepack);
                                  _boxesWaste_validate = emptyField(boxesWaste);
                                  _cartonWaste_validate =
                                      emptyField(cartonWaste);
                                  _mc1FilmUsed_validate =
                                      emptyField(mc1FilmUsed);
                                  _mc2FilmUsed_validate =
                                      emptyField(mc2FilmUsed);
                                  _mc1WasteKg_validate = emptyField(mc1WasteKg);
                                  _mc2WasteKg_validate = emptyField(mc2WasteKg);
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
                                      !_unPackedProducts_validate &&
                                      !_mc1Speed_validate &&
                                      !_mc2Speed_validate &&
                                      !_packingScrap_validate &&
                                      !_packingRework_validate &&
                                      !_packingRepack_validate &&
                                      !_boxesWaste_validate &&
                                      !_cartonWaste_validate &&
                                      !_mc1FilmUsed_validate &&
                                      !_mc2FilmUsed_validate &&
                                      !_mc1WasteKg_validate &&
                                      !_mc2WasteKg_validate) {
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
                                        double.parse(unPackedProducts),
                                        double.parse(mc1Speed),
                                        double.parse(mc2Speed),
                                        double.parse(packingScrap),
                                        double.parse(packingRework),
                                        double.parse(packingRepack),
                                        double.parse(boxesWaste),
                                        double.parse(cartonWaste),
                                        double.parse(mc1FilmUsed),
                                        double.parse(mc2FilmUsed),
                                        double.parse(mc1WasteKg),
                                        double.parse(mc2WasteKg),
                                        int.parse(shiftProductionPlan),
                                        int.parse(productionInCartons),
                                        prod_lines4.indexOf(selectedProdLine) +
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