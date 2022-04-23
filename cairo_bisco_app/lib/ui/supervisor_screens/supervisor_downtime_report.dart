import 'package:cairo_bisco_app/classes/DownTimeReport.dart';
import 'package:cairo_bisco_app/classes/RootCause.dart';
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
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:dropdown_search/dropdown_search.dart';

class SupervisorDownTimeReportForm extends StatefulWidget {
  SupervisorDownTimeReportForm({
    Key? key,
    required this.refNum,
    required this.reportDetails,
    required this.isEdit,
    required this.reportID,
    required this.dtType,
  }) : super(key: key);
  final int refNum;
  final dynamic reportDetails;
  final bool isEdit;
  final String reportID;
  final String dtType;

  @override
  _SupervisorDownTimeReportFormState createState() =>
      _SupervisorDownTimeReportFormState(
        refNum: refNum,
        reportDetails: reportDetails,
        isEdit: isEdit,
        reportID: reportID,
        dtType: dtType,
      );
}

class _SupervisorDownTimeReportFormState
    extends State<SupervisorDownTimeReportForm> {
  _SupervisorDownTimeReportFormState({
    required this.refNum,
    required this.reportDetails,
    required this.isEdit,
    required this.reportID,
    required this.dtType,
  });

  final String reportID;
  final DownTimeReport reportDetails;
  final int refNum;
  final bool isEdit;
  final String dtType;

  late String supName, rootCauseDesc, technicianName;
  late TimeOfDay fromTime, toTime;

  //drop down values
  late String selectedShift,
      selectedYearFrom,
      selectedMonthFrom,
      selectedDayFrom,
      selectedYearTo,
      selectedMonthTo,
      selectedDayTo,
      isPlanned,
      isStopped,
      wfCategory,
      machine,
      //responsible,
      selectedProdLine,
      rootCauseDrop,
      sku;
  bool _sup_name_validate = false, _technicianName_validate = false;
  bool showSpinner = false;
  final _formKey = GlobalKey<FormState>();

  VoidCallback? onCauseChange(val) {
    setState(() {
      rootCauseDrop = val;
    });
    return null;
  }

  VoidCallback? onPlannedChange(val) {
    setState(() {
      isPlanned = val;
    });
    return null;
  }

  VoidCallback? onStoppedChange(val) {
    setState(() {
      isStopped = val;
    });
    return null;
  }

  VoidCallback? onWfCategoryChange(val) {
    setState(() {
      wfCategory = val;
    });
    return null;
  }

  VoidCallback? onMachineChange(val) {
    setState(() {
      machine = val;
    });
    return null;
  }

  // VoidCallback? onResponsibleChange(val) {
  //   setState(() {
  //     responsible = val;
  //   });
  //   return null;
  // }

  VoidCallback? onSKUChange(val) {
    setState(() {
      sku = val;
    });
    return null;
  }

  VoidCallback? onLineChange(val) {
    setState(() {
      selectedProdLine = val;
    });
    return null;
  }

  VoidCallback? onShiftChange(val) {
    setState(() {
      selectedShift = val;
    });
    return null;
  }

  VoidCallback? onFromYearChange(val) {
    setState(() {
      selectedYearFrom = val;
    });
    return null;
  }

  VoidCallback? onFromMonthChange(val) {
    setState(() {
      selectedMonthFrom = val;
    });
    return null;
  }

  VoidCallback? onFromDayChange(val) {
    setState(() {
      selectedDayFrom = val;
    });
    return null;
  }

  VoidCallback? onToYearChange(val) {
    setState(() {
      selectedYearTo = val;
    });
    return null;
  }

  VoidCallback? onToMonthChange(val) {
    setState(() {
      selectedMonthTo = val;
    });
    return null;
  }

  VoidCallback? onToDayChange(val) {
    setState(() {
      selectedDayTo = val;
    });
    return null;
  }

  @override
  void initState() {
    super.initState();
    supName = isEdit ? reportDetails.supName : Credentials.getUserName();
    rootCauseDesc = isEdit ? reportDetails.rootCauseDesc.toString() : '';
    fromTime = isEdit
        ? TimeOfDay(
            hour: reportDetails.hour_from, minute: reportDetails.minute_from)
        : TimeOfDay.now();
    toTime = isEdit
        ? TimeOfDay(
            hour: reportDetails.hour_to, minute: reportDetails.minute_to)
        : TimeOfDay.now();
    technicianName = isEdit ? reportDetails.technicianName.toString() : '';
    ///////////////////////////////////////////////////////////////////////////////
    selectedShift = shifts[reportDetails.shift_index];
    selectedYearFrom = years[
        (isEdit ? reportDetails.yearFrom : (int.parse(getYear()))) - 2020];
    selectedYearTo =
        years[(isEdit ? reportDetails.yearTo : (int.parse(getYear()))) - 2020];
    selectedMonthFrom = months[
        (isEdit ? reportDetails.monthFrom : (int.parse(getMonth()))) - 1];
    selectedMonthTo =
        months[(isEdit ? reportDetails.monthTo : (int.parse(getMonth()))) - 1];
    selectedDayFrom =
        days[(isEdit ? reportDetails.dayFrom : (int.parse(getDay()))) - 1];
    selectedDayTo =
        days[(isEdit ? reportDetails.dayTo : (int.parse(getDay()))) - 1];
    selectedProdLine = prod_lines4[reportDetails.line_index - 1];
    sku = isEdit ? reportDetails.skuName : SKU.allSkus[refNum][0];
    isPlanned = isEdit ? reportDetails.isPlanned : plannedTypes[0];
    isStopped = y_nDesc[reportDetails.isStopped_index];
    wfCategory = isEdit ? reportDetails.wfCategory : wfCategories[0];
    machine = isEdit ? reportDetails.machine : allMachines[refNum][0];
    //responsible = isEdit ? reportDetails.responsible : authorities[0];
    rootCauseDrop =
        isEdit ? reportDetails.rootCauseDrop : RootCause.causesMap[dtType]![0];
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
              prodType[refNum],
              style: TextStyle(
                  color: KelloggColors.darkRed,
                  fontWeight: FontWeight.w300,
                  fontSize: largeFontSize),
            ),
          ),
          body: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.always,
            child: SingleChildScrollView(
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
                          reportDetails.isApproved == YES
                              ? NormalMessageHeading("Approved Report by : " +
                                  reportDetails.approved_by)
                              : reportDetails.isRejected == YES
                                  ? ErrorMessageHeading(
                                      "Rejected Report by : " +
                                          reportDetails.rejected_by +
                                          "Because :\n" +
                                          reportDetails.rejectComment)
                                  : EmptyPlaceHolder(),
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
                          smallerHeading('تاريخ العطل\nToday Date'),
                          SizedBox(height: minimumPadding),
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: mediumPadding),
                                child: Container(
                                  margin: EdgeInsets.symmetric(
                                      vertical: minimumPadding),
                                  child: Text(
                                    "From : ",
                                    style: TextStyle(
                                        color: KelloggColors.darkRed,
                                        fontSize: aboveMediumFontSize,
                                        fontWeight: FontWeight.w500,
                                        letterSpacing: 1.2),
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
                                          hint: Text("day"),
                                          value: selectedDayFrom,
                                          isExpanded: true,
                                          items: days.map((String value) {
                                            return new DropdownMenuItem<String>(
                                              value: value,
                                              child: Text(
                                                value,
                                                style: TextStyle(
                                                    color:
                                                        KelloggColors.darkRed),
                                              ),
                                            );
                                          }).toList(),
                                          onChanged: onFromDayChange,
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
                                          value: selectedMonthFrom,
                                          isExpanded: true,
                                          items: months.map((String value) {
                                            return new DropdownMenuItem<String>(
                                              value: value,
                                              child: Text(
                                                value,
                                                style: TextStyle(
                                                    color:
                                                        KelloggColors.darkRed),
                                              ),
                                            );
                                          }).toList(),
                                          onChanged: onFromMonthChange,
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
                                          value: selectedYearFrom,
                                          isExpanded: true,
                                          items: years.map((String value) {
                                            return new DropdownMenuItem<String>(
                                              value: value,
                                              child: Text(
                                                value,
                                                style: TextStyle(
                                                    color:
                                                        KelloggColors.darkRed),
                                              ),
                                            );
                                          }).toList(),
                                          onChanged: onFromYearChange,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: mediumPadding),
                                child: Container(
                                  margin: EdgeInsets.symmetric(
                                      vertical: minimumPadding),
                                  child: Text(
                                    "To :     ",
                                    style: TextStyle(
                                        color: KelloggColors.darkRed,
                                        fontSize: aboveMediumFontSize,
                                        fontWeight: FontWeight.w500,
                                        letterSpacing: 1.2),
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
                                          hint: Text("day"),
                                          value: selectedDayTo,
                                          isExpanded: true,
                                          items: days.map((String value) {
                                            return new DropdownMenuItem<String>(
                                              value: value,
                                              child: Text(
                                                value,
                                                style: TextStyle(
                                                    color:
                                                        KelloggColors.darkRed),
                                              ),
                                            );
                                          }).toList(),
                                          onChanged: onToDayChange,
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
                                          value: selectedMonthTo,
                                          isExpanded: true,
                                          items: months.map((String value) {
                                            return new DropdownMenuItem<String>(
                                              value: value,
                                              child: Text(
                                                value,
                                                style: TextStyle(
                                                    color:
                                                        KelloggColors.darkRed),
                                              ),
                                            );
                                          }).toList(),
                                          onChanged: onToMonthChange,
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
                                          value: selectedYearTo,
                                          isExpanded: true,
                                          items: years.map((String value) {
                                            return new DropdownMenuItem<String>(
                                              value: value,
                                              child: Text(
                                                value,
                                                style: TextStyle(
                                                    color:
                                                        KelloggColors.darkRed),
                                              ),
                                            );
                                          }).toList(),
                                          onChanged: onToYearChange,
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
                          /////////////////////////////////////////////////////////////////////////////////
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
                          smallerHeading('اختر نوع المنتج SKU'),
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
                          smallerHeading('اختر الماكينة Machine'),
                          SizedBox(height: minimumPadding),
                          Container(
                            margin:
                                EdgeInsets.symmetric(vertical: minimumPadding),
                            padding: const EdgeInsets.symmetric(
                                horizontal: defaultPadding),
                            child: DropdownButtonFormField<String>(
                              // decoration: InputDecoration(labelText: 'اختر'),
                              value: machine,
                              isExpanded: true,
                              validator: (value) =>
                                  value == allMachines[refNum][0]
                                      ? missingValueErrorText
                                      : null,
                              items: allMachines[refNum]
                                  .followedBy(Machine.packingMachinesList)
                                  .map((String value) {
                                return new DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(
                                    value,
                                    style:
                                        TextStyle(color: KelloggColors.darkRed),
                                  ),
                                );
                              }).toList(),
                              onChanged: onMachineChange,
                            ),
                          ),
                          SizedBox(height: defaultPadding),
                          /////////////////////////////////////////////////////////////////////////////
                          smallerHeading(
                              'هل العطل مخطط/غير مخطط\nPlanned/Unplanned'),
                          SizedBox(height: minimumPadding),
                          Container(
                            margin:
                                EdgeInsets.symmetric(vertical: minimumPadding),
                            padding: const EdgeInsets.symmetric(
                                horizontal: defaultPadding),
                            child: DropdownButtonFormField<String>(
                              // decoration: InputDecoration(labelText: 'اختر'),
                              value: isPlanned,
                              isExpanded: true,
                              validator: (value) => value == plannedTypes[0]
                                  ? missingValueErrorText
                                  : null,
                              items: plannedTypes.map((String value) {
                                return new DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(
                                    value,
                                    style:
                                        TextStyle(color: KelloggColors.darkRed),
                                  ),
                                );
                              }).toList(),
                              onChanged: onPlannedChange,
                            ),
                          ),
                          SizedBox(height: defaultPadding),
                          /////////////////////////////////////////////////////////////////////////////
                          // smallerHeading('القسم المسؤول\nResponsible'),
                          // SizedBox(height: minimumPadding),
                          // Container(
                          //   margin:
                          //       EdgeInsets.symmetric(vertical: minimumPadding),
                          //   padding: const EdgeInsets.symmetric(
                          //       horizontal: defaultPadding),
                          //   child: DropdownButtonFormField<String>(
                          //     // decoration: InputDecoration(labelText: 'اختر'),
                          //     value: responsible,
                          //     isExpanded: true,
                          //     items: authorities.map((String value) {
                          //       return new DropdownMenuItem<String>(
                          //         value: value,
                          //         child: Text(
                          //           value,
                          //           style:
                          //               TextStyle(color: KelloggColors.darkRed),
                          //         ),
                          //       );
                          //     }).toList(),
                          //     onChanged: onResponsibleChange,
                          //   ),
                          // ),
                          // SizedBox(height: defaultPadding),
                          /////////////////////////////////////////////////////////////////////////////
                          smallerHeading('اختر تفاصيل سبب العطل\nRoot Cause'),
                          SizedBox(height: minimumPadding),
                          Container(
                            margin:
                                EdgeInsets.symmetric(vertical: minimumPadding),
                            padding: const EdgeInsets.symmetric(
                                horizontal: defaultPadding),
                            child: DropdownSearch<String>(
                              mode: Mode.DIALOG,
                              showSearchBox: true,
                              selectedItem: rootCauseDrop,
                              dropdownSearchDecoration: InputDecoration(
                                prefixIcon: new Icon(
                                  Icons.search,
                                  color: KelloggColors.darkRed,
                                ),
                                // labelText: "اختر السبب التفصيلي",
                                // labelStyle:
                                //     TextStyle(color: KelloggColors.darkRed),
                              ),
                              popupItemBuilder:
                                  (context, selected, bool dummy) {
                                Widget item(String i) => Container(
                                      margin: EdgeInsets.symmetric(
                                          horizontal: minimumPadding,
                                          vertical: minimumPadding),
                                      child: Text(
                                        i,
                                        style: TextStyle(
                                            color: KelloggColors.darkRed),
                                      ),
                                    );
                                return item(selected);
                              },
                              dropdownBuilder: (context, selected) {
                                Widget item(String i) => Text(
                                      i,
                                      style: TextStyle(
                                          color: KelloggColors.darkRed),
                                    );
                                return item(selected!);
                              },
                              items: RootCause.causesMap[dtType],
                              // popupItemDisabled: (String s) => s.startsWith('I'),
                              onChanged: onCauseChange,
                            ),
                          ),
                          // Container(
                          //   margin:
                          //       EdgeInsets.symmetric(vertical: minimumPadding),
                          //   padding: const EdgeInsets.symmetric(
                          //       horizontal: defaultPadding),
                          //   child: DropdownButtonFormField<String>(
                          //     // decoration: InputDecoration(labelText: 'اختر'),
                          //     value: rootCauseDrop,
                          //     isExpanded: true,
                          //     items: RootCause.causesMap[dtType]!
                          //         .map((String value) {
                          //       return new DropdownMenuItem<String>(
                          //         value: value,
                          //         child: Text(
                          //           value,
                          //           style:
                          //               TextStyle(color: KelloggColors.darkRed),
                          //         ),
                          //       );
                          //     }).toList(),
                          //     onChanged: onCauseChange,
                          //   ),
                          // ),
                          SizedBox(height: defaultPadding),
                          /////////////////////////////////////////////////////////////////////////////
                          smallerHeading(
                              'تفاصيل اضافية عن العطل \nMore Details'),
                          SizedBox(height: minimumPadding),
                          TextFormField(
                            initialValue: rootCauseDesc,
                            style: (TextStyle(
                                color: KelloggColors.darkRed,
                                fontWeight: FontWeight.w400)),
                            keyboardType: TextInputType.multiline,
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
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: KelloggColors.yellow,
                                    width: textFieldFocusedBorderRadius),
                                borderRadius: BorderRadius.all(
                                    Radius.circular(textFieldRadius)),
                              ),
                            ),
                            onChanged: (value) {
                              rootCauseDesc = value;
                            },
                          ),
                          SizedBox(height: defaultPadding),
                          ///////////////////////////////////////////////////////////////
                          smallerHeading('اختر تصنيف العطل\nWF Category'),
                          SizedBox(height: minimumPadding),
                          Container(
                            margin:
                                EdgeInsets.symmetric(vertical: minimumPadding),
                            padding: const EdgeInsets.symmetric(
                                horizontal: defaultPadding),
                            child: DropdownButtonFormField<String>(
                              // decoration: InputDecoration(labelText: 'اختر'),
                              value: wfCategory,
                              isExpanded: true,
                              validator: (value) => value == wfCategories[0]
                                  ? missingValueErrorText
                                  : null,
                              items: wfCategories.map((String value) {
                                return new DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(
                                    value,
                                    style:
                                        TextStyle(color: KelloggColors.darkRed),
                                  ),
                                );
                              }).toList(),
                              onChanged: onWfCategoryChange,
                            ),
                          ),
                          SizedBox(height: defaultPadding),
                          /////////////////////////////////////////////////////////////////////////////
                          smallerHeading(
                              'توقيت و مدة العطل\nDown Time Duration'),
                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          //   children: [
                          Padding(
                            padding: const EdgeInsets.all(minimumPadding),
                            child: Center(
                              child: RoundedButton(
                                onPressed: () async {
                                  final TimeOfDay? timeOfDay =
                                      await showTimePicker(
                                    context: context,
                                    initialTime: fromTime,
                                    initialEntryMode: TimePickerEntryMode.dial,
                                  );
                                  if (timeOfDay != null &&
                                      timeOfDay != fromTime) {
                                    setState(() {
                                      fromTime = timeOfDay;
                                    });
                                  }
                                  //_selectTime(context);
                                },
                                btnText: "From ${fromTime.format(context)}",
                                color: KelloggColors.darkBlue,
                              ),
                            ),
                          ),
                          // SizedBox(
                          //   width: defaultPadding,
                          // ),
                          //smallerHeading("${fromTime.hour}:${fromTime.minute}"),
                          /////////////////////////////////////////////////////////////////////////////
                          Padding(
                            padding: const EdgeInsets.all(minimumPadding),
                            child: Center(
                              child: RoundedButton(
                                onPressed: () async {
                                  final TimeOfDay? timeOfDay =
                                      await showTimePicker(
                                    context: context,
                                    initialTime: toTime,
                                    initialEntryMode: TimePickerEntryMode.dial,
                                  );
                                  if (timeOfDay != null &&
                                      timeOfDay != toTime) {
                                    setState(() {
                                      toTime = timeOfDay;
                                    });
                                  }
                                  //_selectTime(context);
                                },
                                btnText: "To ${toTime.format(context)}",
                                color: KelloggColors.darkBlue,
                              ),
                            ),
                          ),
                          //smallerHeading("${toTime.hour}:${toTime.minute}"),
                          //   ],
                          // ),
                          /////////////////////////////////////////////////////////////////////////////
                          smallerHeading(
                              'هل يخرج اى منتج نهائى من اى ماكينة تغليف اثناء العطل؟\nIs there final product'),
                          SizedBox(height: minimumPadding),
                          Container(
                            margin:
                                EdgeInsets.symmetric(vertical: minimumPadding),
                            padding: const EdgeInsets.symmetric(
                                horizontal: defaultPadding),
                            child: DropdownButtonFormField<String>(
                              // decoration: InputDecoration(labelText: 'اختر'),
                              value: isStopped,
                              isExpanded: true,
                              validator: (value) => value == y_nDesc[0]
                                  ? missingValueErrorText
                                  : null,
                              items: y_nDesc.map((String value) {
                                return new DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(
                                    value,
                                    style:
                                        TextStyle(color: KelloggColors.darkRed),
                                  ),
                                );
                              }).toList(),
                              onChanged: onStoppedChange,
                            ),
                          ),
                          SizedBox(height: defaultPadding),
                          /////////////////////////////////////////////////////////////////////////////
                          smallerHeading(
                              'اسم الفني او المسؤول عن حل المشكلة\nTechnician Name'),
                          SizedBox(height: minimumPadding),
                          TextFormField(
                            initialValue: technicianName,
                            style: (TextStyle(
                                color: KelloggColors.darkRed,
                                fontWeight: FontWeight.w400)),
                            keyboardType: TextInputType.name,
                            cursorColor: Colors.white,
                            obscureText: false,
                            decoration: InputDecoration(
                              errorText: _technicianName_validate
                                  ? missingValueErrorText
                                  : null,
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
                              technicianName = value;
                            },
                          ),
                          SizedBox(height: defaultPadding),
                          //////////////////////////////////////////////////////////////////////////
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
                                          _technicianName_validate =
                                              emptyField(technicianName);
                                        });
                                        try {
                                          if (_formKey.currentState!
                                              .validate()) {
                                            //form is valid, proceed further
                                            _formKey.currentState!.save();
                                            if (!_sup_name_validate &&
                                                !_technicianName_validate) {
                                              DownTimeReport.addReport(
                                                supName,
                                                sku,
                                                machine,
                                                downTimeAuthoritiesMap[dtType]
                                                    .toString(),
                                                //responsible,
                                                rootCauseDrop,
                                                rootCauseDesc,
                                                wfCategory,
                                                dtType,
                                                shifts.indexOf(selectedShift),
                                                refNum,
                                                int.parse(selectedYearFrom),
                                                int.parse(selectedMonthFrom),
                                                int.parse(selectedDayFrom),
                                                int.parse(selectedYearTo),
                                                int.parse(selectedMonthTo),
                                                int.parse(selectedDayTo),
                                                prod_lines4.indexOf(
                                                        selectedProdLine) +
                                                    1,
                                                isPlanned,
                                                fromTime.hour,
                                                toTime.hour,
                                                fromTime.minute,
                                                toTime.minute,
                                                y_nDesc.indexOf(isStopped),
                                                technicianName,
                                              );
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          SuccessScreen()));
                                            } else {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(SnackBar(
                                                content:
                                                    Text(submissionErrorText),
                                              ));
                                            }
                                          } else {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(SnackBar(
                                              content: Text(
                                                  dropDownSelectionErrorText),
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
                                      btnText:
                                          reportDetails.isApproved == YES &&
                                                  !Credentials.isUserKws
                                              ? "Edit Disabled"
                                              : 'Edit Report',
                                      color: reportDetails.isApproved == YES &&
                                              !Credentials.isUserKws
                                          ? KelloggColors.grey
                                          : KelloggColors.darkBlue,
                                      onPressed: () {
                                        if (reportDetails.isApproved == NO &&
                                            !Credentials.isUserKws) {
                                          setState(() {
                                            showSpinner = true;
                                            _sup_name_validate =
                                                emptyField(supName);
                                            _technicianName_validate =
                                                emptyField(technicianName);
                                          });
                                          try {
                                            if (_formKey.currentState!
                                                .validate()) {
                                              //form is valid, proceed further
                                              _formKey.currentState!.save();
                                              if (!_sup_name_validate &&
                                                  !_technicianName_validate) {
                                                if (canEditThisReport(
                                                    supName,
                                                    int.parse(selectedDayFrom),
                                                    int.parse(
                                                        selectedMonthFrom),
                                                    int.parse(
                                                        selectedYearFrom))) {
                                                  DownTimeReport.editReport(
                                                    context,
                                                    reportID,
                                                    supName,
                                                    sku,
                                                    machine,
                                                    downTimeAuthoritiesMap[
                                                            dtType]
                                                        .toString(),
                                                    //responsible,
                                                    rootCauseDrop,
                                                    rootCauseDesc,
                                                    wfCategory,
                                                    dtType,
                                                    shifts
                                                        .indexOf(selectedShift),
                                                    refNum,
                                                    int.parse(selectedYearFrom),
                                                    int.parse(
                                                        selectedMonthFrom),
                                                    int.parse(selectedDayFrom),
                                                    int.parse(selectedYearTo),
                                                    int.parse(selectedMonthTo),
                                                    int.parse(selectedDayTo),
                                                    prod_lines4.indexOf(
                                                            selectedProdLine) +
                                                        1,
                                                    isPlanned,
                                                    fromTime.hour,
                                                    toTime.hour,
                                                    fromTime.minute,
                                                    toTime.minute,
                                                    y_nDesc.indexOf(isStopped),
                                                    technicianName,
                                                  );
                                                } else {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(SnackBar(
                                                    content: Text(
                                                        unauthorizedEditMsg),
                                                  ));
                                                }
                                              } else {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(SnackBar(
                                                  content:
                                                      Text(submissionErrorText),
                                                ));
                                              }
                                            } else {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(SnackBar(
                                                content: Text(
                                                    dropDownSelectionErrorText),
                                              ));
                                            }
                                            setState(() {
                                              showSpinner = false;
                                            });
                                          } catch (e) {
                                            print(e);
                                          }
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
                                      btnText: 'Delete Report',
                                      color: KelloggColors.cockRed,
                                      onPressed: () {
                                        setState(() {
                                          showSpinner = true;
                                        });
                                        try {
                                          if (canEditThisReport(
                                              supName,
                                              int.parse(selectedDayFrom),
                                              int.parse(selectedMonthFrom),
                                              int.parse(selectedYearFrom))) {
                                            DownTimeReport.deleteReport(
                                              context,
                                              reportID,
                                              int.parse(selectedYearFrom),
                                            );
                                          } else {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(SnackBar(
                                              content:
                                                  Text(unauthorizedEditMsg),
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
      ),
    );
  }
}
