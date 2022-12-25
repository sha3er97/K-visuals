import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import '/classes/BiscuitsReport.dart';
import '/classes/MaamoulReport.dart';
import '/classes/MiniProductionReport.dart';
import '/classes/WaferReport.dart';
import '/classes/values/TextStandards.dart';
import '/components/charts/VerticalBarChart.dart';
import '../../classes/CauseCount.dart';
import '../../classes/NRCReport.dart';
import '../../classes/Plans.dart';
import '../../classes/utility_funcs/date_time_utility.dart';
import '../../classes/utility_funcs/other_excel_utilities.dart';
import '../../classes/values/colors.dart';
import '../../classes/values/constants.dart';
import '../../classes/values/form_values.dart';
import '../../components/alert_dialog.dart';
import '../../components/buttons/back_btn.dart';
import '../../components/buttons/rounded_btn.dart';
import '../error_success_screens/loading_screen.dart';

class NRCDashboard extends StatefulWidget {
  @override
  _NRCDashboardState createState() => _NRCDashboardState();
}

class _NRCDashboardState extends State<NRCDashboard> {
  String _selectedYearFrom = years[(int.parse(getYear())) - 2020],
      _selectedMonthFrom = months[(int.parse(getMonth())) - 1],
      _selectedDayFrom = days[(int.parse(getDay())) - 1],
      _selectedYearTo = years[(int.parse(getYear())) - 2020],
      _selectedMonthTo = months[(int.parse(getMonth())) - 1],
      _selectedDayTo = days[(int.parse(getDay())) - 1];

  // int refNum = 0; //MASS FOOD
  // late String area = areas[refNum];

  bool showSpinner = false;

  // VoidCallback? onAreaChange(val) {
  //   setState(() {
  //     area = val;
  //     refNum = areas.indexOf(val);
  //   });
  //   return null;
  // }

  VoidCallback? onFromYearChange(val) {
    setState(() {
      _selectedYearFrom = val;
    });
    return null;
  }

  VoidCallback? onFromMonthChange(val) {
    setState(() {
      _selectedMonthFrom = val;
    });
    return null;
  }

  VoidCallback? onFromDayChange(val) {
    setState(() {
      _selectedDayFrom = val;
    });
    return null;
  }

  VoidCallback? onToYearChange(val) {
    setState(() {
      _selectedYearTo = val;
    });
    return null;
  }

  VoidCallback? onToMonthChange(val) {
    setState(() {
      _selectedMonthTo = val;
    });
    return null;
  }

  VoidCallback? onToDayChange(val) {
    setState(() {
      _selectedDayTo = val;
    });
    return null;
  }

  int validated_day_from = int.parse(getDay()),
      validated_day_to = int.parse(getDay()),
      validated_month_from = int.parse(getMonth()),
      validated_month_to = int.parse(getMonth()),
      validated_year = int.parse(getYear());

  void calculateInterval() {
    // DateTime dateFrom = DateTime(int.parse(_selectedYearTo),
    //     int.parse(_selectedMonthFrom), int.parse(_selectedDayFrom));
    // DateTime dateAfter = DateTime(int.parse(_selectedYearTo),
    //     int.parse(_selectedMonthTo), int.parse(_selectedDayTo));

    // days_in_interval = dateFrom.difference(dateAfter).inDays.abs();
    validated_day_from = int.parse(_selectedDayFrom);
    validated_day_to = int.parse(_selectedDayTo);
    validated_month_from = int.parse(_selectedMonthFrom);
    validated_month_to = int.parse(_selectedMonthTo);
    validated_year = int.parse(_selectedYearFrom);
  }

  //temp variables
  //DownTimeReport temp_downTime = DownTimeReport.getEmptyReport();
  MiniProductionReport totalProd = MiniProductionReport.getEmptyReport();
  List<QueryDocumentSnapshot<NRCReport>> nrcReportsList = [];
  List<QueryDocumentSnapshot<BiscuitsReport>> biscuitsReportsList = [];
  List<QueryDocumentSnapshot<WaferReport>> waferReportsList = [];
  List<QueryDocumentSnapshot<MaamoulReport>> maamoulReportsList = [];
  List<CauseCount> tempElectricityNrcList = [];
  List<CauseCount> tempGasNrcList = [];
  List<CauseCount> tempWaterNrcList = [];
  List<CauseCount> tempOrganicWasteNrcList = [];
  num totalConsumptionElect = 0, totalProductionElect = 0;
  num totalConsumptionGas = 0, totalProductionGas = 0;
  num totalConsumptionWater = 0, totalProductionWater = 0;
  num totalConsumptionOrganic = 0, totalProductionOrganic = 0;

  @override
  Widget build(BuildContext context) {
    final nrcReportRef = FirebaseFirestore.instance
        .collection(factory_name)
        .doc('nrc_reports')
        .collection(validated_year.toString())
        .withConverter<NRCReport>(
          fromFirestore: (snapshot, _) => NRCReport.fromJson(snapshot.data()!),
          toFirestore: (report, _) => report.toJson(),
        );
    final biscuitsReportRef = FirebaseFirestore.instance
        .collection(factory_name)
        .doc('biscuits_reports')
        .collection(validated_year.toString())
        .withConverter<BiscuitsReport>(
          fromFirestore: (snapshot, _) =>
              BiscuitsReport.fromJson(snapshot.data()!),
          toFirestore: (report, _) => report.toJson(),
        );
    final maamoulReportRef = FirebaseFirestore.instance
        .collection(factory_name)
        .doc('maamoul_reports')
        .collection(validated_year.toString())
        .withConverter<MaamoulReport>(
          fromFirestore: (snapshot, _) =>
              MaamoulReport.fromJson(snapshot.data()!),
          toFirestore: (report, _) => report.toJson(),
        );
    final waferReportRef = FirebaseFirestore.instance
        .collection(factory_name)
        .doc('wafer_reports')
        .collection(validated_year.toString())
        .withConverter<WaferReport>(
          fromFirestore: (snapshot, _) =>
              WaferReport.fromJson(snapshot.data()!),
          toFirestore: (report, _) => report.toJson(),
        );
    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      child: Scaffold(
        backgroundColor: KelloggColors.white,
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          backgroundColor: KelloggColors.white.withOpacity(0),
          shadowColor: KelloggColors.white.withOpacity(0),
          leading: MyBackButton(
            color: KelloggColors.darkRed,
          ),
          title: const Text('NRC DashBoard',
              style: TextStyle(
                color: KelloggColors.darkRed,
                fontWeight: FontWeight.w600,
              )),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: defaultPadding),
                    child: Container(
                      margin:
                          const EdgeInsets.symmetric(vertical: minimumPadding),
                      child: const Text(
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
                      padding:
                          const EdgeInsets.symmetric(horizontal: mediumPadding),
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                            vertical: minimumPadding),
                        child: Column(
                          children: [
                            DropdownButton<String>(
                              hint: const Text("day"),
                              value: _selectedDayFrom,
                              isExpanded: true,
                              items: days.map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(
                                    value,
                                    style: const TextStyle(
                                        color: KelloggColors.darkRed),
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
                      padding:
                          const EdgeInsets.symmetric(horizontal: mediumPadding),
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                            vertical: minimumPadding),
                        child: Column(
                          children: [
                            DropdownButton<String>(
                              hint: const Text("month"),
                              value: _selectedMonthFrom,
                              isExpanded: true,
                              items: months.map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(
                                    value,
                                    style: const TextStyle(
                                        color: KelloggColors.darkRed),
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
                      padding:
                          const EdgeInsets.symmetric(horizontal: mediumPadding),
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                            vertical: minimumPadding),
                        child: Column(
                          children: [
                            DropdownButton<String>(
                              hint: const Text("year"),
                              value: _selectedYearFrom,
                              isExpanded: true,
                              items: years.map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(
                                    value,
                                    style: const TextStyle(
                                        color: KelloggColors.darkRed),
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
                    padding:
                        const EdgeInsets.symmetric(horizontal: defaultPadding),
                    child: Container(
                      margin:
                          const EdgeInsets.symmetric(vertical: minimumPadding),
                      child: const Text(
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
                      padding:
                          const EdgeInsets.symmetric(horizontal: mediumPadding),
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                            vertical: minimumPadding),
                        child: Column(
                          children: [
                            DropdownButton<String>(
                              hint: const Text("day"),
                              value: _selectedDayTo,
                              isExpanded: true,
                              items: days.map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(
                                    value,
                                    style: const TextStyle(
                                        color: KelloggColors.darkRed),
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
                      padding:
                          const EdgeInsets.symmetric(horizontal: mediumPadding),
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                            vertical: minimumPadding),
                        child: Column(
                          children: [
                            DropdownButton<String>(
                              hint: const Text("month"),
                              value: _selectedMonthTo,
                              isExpanded: true,
                              items: months.map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(
                                    value,
                                    style: const TextStyle(
                                        color: KelloggColors.darkRed),
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
                      padding:
                          const EdgeInsets.symmetric(horizontal: mediumPadding),
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                            vertical: minimumPadding),
                        child: Column(
                          children: [
                            DropdownButton<String>(
                              hint: const Text("year"),
                              value: _selectedYearTo,
                              isExpanded: true,
                              items: years.map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(
                                    value,
                                    style: const TextStyle(
                                        color: KelloggColors.darkRed),
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
              // Row(
              //   children: [
              //     Padding(
              //       padding:
              //           const EdgeInsets.symmetric(horizontal: mediumPadding),
              //       child: Container(
              //         margin:
              //             const EdgeInsets.symmetric(vertical: minimumPadding),
              //         child: const Text(
              //           "Area : ",
              //           style: TextStyle(
              //             color: KelloggColors.darkRed,
              //             fontSize: aboveMediumFontSize,
              //             fontWeight: FontWeight.w500,
              //           ),
              //         ),
              //       ),
              //     ),
              //     Expanded(
              //       child: Padding(
              //         padding:
              //             const EdgeInsets.symmetric(horizontal: mediumPadding),
              //         child: Container(
              //           margin: const EdgeInsets.symmetric(
              //               vertical: minimumPadding),
              //           child: Column(
              //             children: [
              //               DropdownButtonFormField<String>(
              //                 // decoration: InputDecoration(labelText: 'اختر'),
              //                 value: area,
              //                 isExpanded: true,
              //                 items: areas.map((String value) {
              //                   return DropdownMenuItem<String>(
              //                     value: value,
              //                     child: Text(
              //                       value,
              //                       style: const TextStyle(
              //                           color: KelloggColors.darkRed),
              //                     ),
              //                   );
              //                 }).toList(),
              //                 onChanged: onAreaChange,
              //               ),
              //             ],
              //           ),
              //         ),
              //       ),
              //     ),
              //   ],
              // ),
              const SizedBox(height: defaultPadding),
              Padding(
                padding: const EdgeInsets.all(minimumPadding),
                child: Center(
                  child: RoundedButton(
                    btnText: 'Refresh Report',
                    color: KelloggColors.darkRed,
                    onPressed: () {
                      if (int.parse(_selectedYearTo) !=
                          int.parse(_selectedYearFrom)) {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text(
                              "Error : invalid interval (reports of same year only are allowed)"),
                        ));
                      } else {
                        DateTime dateFrom = DateTime(
                            int.parse(_selectedYearTo),
                            int.parse(_selectedMonthFrom),
                            int.parse(_selectedDayFrom));
                        DateTime dateAfter = DateTime(
                            int.parse(_selectedYearTo),
                            int.parse(_selectedMonthTo),
                            int.parse(_selectedDayTo));
                        if (dateFrom.isBefore(dateAfter) ||
                            dateFrom.isAtSameMomentAs(dateAfter)) {
                          calculateInterval();

                          setState(() {
                            tempElectricityNrcList =
                                NRCReport.getIntervalReadings(
                              nrcReportsList,
                              getPreviousMonth(validated_month_from),
                              validated_month_to,
                              validated_day_from,
                              validated_day_to,
                              validated_year,
                              gaugesTypes[0], //electricity
                            );
                            tempElectricityNrcList = NRCReport.getConsumptions(
                              tempElectricityNrcList,
                              validated_month_from,
                              validated_day_from,
                              validated_year,
                            );
                            for (CauseCount elect in tempElectricityNrcList) {
                              totalConsumptionElect += elect.count;
                              int tempMonth =
                                  int.parse(elect.causeName.split("/")[1]);
                              int tempDay =
                                  int.parse(elect.causeName.split("/")[0]);
                              MiniProductionReport tempBiscuitReport =
                                  BiscuitsReport.getProductionOfInterval(
                                biscuitsReportsList,
                                tempMonth,
                                tempMonth,
                                tempDay,
                                tempDay,
                                validated_year,
                              );

                              MiniProductionReport tempWaferReport =
                                  WaferReport.getProductionOfInterval(
                                waferReportsList,
                                tempMonth,
                                tempMonth,
                                tempDay,
                                tempDay,
                                validated_year,
                              );
                              MiniProductionReport tempMaamoulReport =
                                  MaamoulReport.getProductionOfInterval(
                                maamoulReportsList,
                                tempMonth,
                                tempMonth,
                                tempDay,
                                tempDay,
                                validated_year,
                              );

                              totalProd = MiniProductionReport.mergeReports([
                                tempBiscuitReport,
                                tempWaferReport,
                                tempMaamoulReport
                              ]);
                              totalProductionElect += totalProd.productionInKg;
                              elect.count /=
                                  max(1, totalProd.productionInKg / 1000);
                            }
                            ////////////////////////////////////////////////////////////////////////////
                            tempWaterNrcList = NRCReport.getIntervalReadings(
                              nrcReportsList,
                              getPreviousMonth(validated_month_from),
                              validated_month_to,
                              validated_day_from,
                              validated_day_to,
                              validated_year,
                              gaugesTypes[1], //water
                            );
                            tempWaterNrcList = NRCReport.getConsumptions(
                              tempWaterNrcList,
                              validated_month_from,
                              validated_day_from,
                              validated_year,
                            );
                            for (CauseCount water in tempWaterNrcList) {
                              totalConsumptionWater += water.count;
                              int tempMonth =
                                  int.parse(water.causeName.split("/")[1]);
                              int tempDay =
                                  int.parse(water.causeName.split("/")[0]);
                              MiniProductionReport tempBiscuitReport =
                                  BiscuitsReport.getProductionOfInterval(
                                biscuitsReportsList,
                                tempMonth,
                                tempMonth,
                                tempDay,
                                tempDay,
                                validated_year,
                              );

                              MiniProductionReport tempWaferReport =
                                  WaferReport.getProductionOfInterval(
                                waferReportsList,
                                tempMonth,
                                tempMonth,
                                tempDay,
                                tempDay,
                                validated_year,
                              );
                              MiniProductionReport tempMaamoulReport =
                                  MaamoulReport.getProductionOfInterval(
                                maamoulReportsList,
                                tempMonth,
                                tempMonth,
                                tempDay,
                                tempDay,
                                validated_year,
                              );

                              totalProd = MiniProductionReport.mergeReports([
                                tempBiscuitReport,
                                tempWaferReport,
                                tempMaamoulReport
                              ]);
                              totalProductionWater += totalProd.productionInKg;
                              water.count /=
                                  max(1, totalProd.productionInKg / 1000);
                            }
                            ////////////////////////////////////////////////////////////////////////
                            tempGasNrcList = NRCReport.getIntervalReadings(
                              nrcReportsList,
                              getPreviousMonth(validated_month_from),
                              validated_month_to,
                              validated_day_from,
                              validated_day_to,
                              validated_year,
                              gaugesTypes[2], //gas
                            );
                            tempGasNrcList = NRCReport.getConsumptions(
                              tempGasNrcList,
                              validated_month_from,
                              validated_day_from,
                              validated_year,
                            );
                            for (CauseCount gas in tempGasNrcList) {
                              totalConsumptionGas += gas.count;
                              int tempMonth =
                                  int.parse(gas.causeName.split("/")[1]);
                              int tempDay =
                                  int.parse(gas.causeName.split("/")[0]);
                              MiniProductionReport tempBiscuitReport =
                                  BiscuitsReport.getProductionOfInterval(
                                biscuitsReportsList,
                                tempMonth,
                                tempMonth,
                                tempDay,
                                tempDay,
                                validated_year,
                              );

                              MiniProductionReport tempWaferReport =
                                  WaferReport.getProductionOfInterval(
                                waferReportsList,
                                tempMonth,
                                tempMonth,
                                tempDay,
                                tempDay,
                                validated_year,
                              );
                              MiniProductionReport tempMaamoulReport =
                                  MaamoulReport.getProductionOfInterval(
                                maamoulReportsList,
                                tempMonth,
                                tempMonth,
                                tempDay,
                                tempDay,
                                validated_year,
                              );

                              totalProd = MiniProductionReport.mergeReports([
                                tempBiscuitReport,
                                tempWaferReport,
                                tempMaamoulReport
                              ]);
                              totalProductionGas += totalProd.productionInKg;
                              gas.count /=
                                  max(1, totalProd.productionInKg / 1000);
                            }
                            ///////////////////////////////////////////////////////////////////////////////

                            tempOrganicWasteNrcList =
                                NRCReport.getIntervalReadings(
                              nrcReportsList,
                              getPreviousMonth(validated_month_from),
                              validated_month_to,
                              validated_day_from,
                              validated_day_to,
                              validated_year,
                              gaugesTypes[3], //organic waste
                            );
                            // tempOrganicWasteNrcList = NRCReport.getConsumptions(
                            //   tempOrganicWasteNrcList,
                            //   validated_month_from,
                            //   validated_day_from,
                            //   validated_year,
                            // );
                            for (CauseCount oWaste in tempOrganicWasteNrcList) {
                              totalConsumptionOrganic += oWaste.count;
                              int tempMonth =
                                  int.parse(oWaste.causeName.split("/")[1]);
                              int tempDay =
                                  int.parse(oWaste.causeName.split("/")[0]);
                              MiniProductionReport tempBiscuitReport =
                                  BiscuitsReport.getProductionOfInterval(
                                biscuitsReportsList,
                                tempMonth,
                                tempMonth,
                                tempDay,
                                tempDay,
                                validated_year,
                              );

                              MiniProductionReport tempWaferReport =
                                  WaferReport.getProductionOfInterval(
                                waferReportsList,
                                tempMonth,
                                tempMonth,
                                tempDay,
                                tempDay,
                                validated_year,
                              );
                              MiniProductionReport tempMaamoulReport =
                                  MaamoulReport.getProductionOfInterval(
                                maamoulReportsList,
                                tempMonth,
                                tempMonth,
                                tempDay,
                                tempDay,
                                validated_year,
                              );

                              totalProd = MiniProductionReport.mergeReports([
                                tempBiscuitReport,
                                tempWaferReport,
                                tempMaamoulReport
                              ]);
                              totalProductionOrganic +=
                                  totalProd.productionInKg;
                              oWaste.count /=
                                  max(1, totalProd.productionInKg / 1000);
                            }
                          });
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content: Text("Report refreshed"),
                          ));
                          showSpinner = false;
                        } else {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content: Text(
                                "Error : invalid interval (from date must be <= to date)"),
                          ));
                        }
                      }
                    },
                  ),
                ),
              ),
              //dashboard parts
              FutureBuilder<QuerySnapshot>(
                  future: biscuitsReportRef.get(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> biscuitsSnapshot) {
                    if (biscuitsSnapshot.hasError) {
                      return ErrorMessageHeading('Something went wrong');
                    } else if (biscuitsSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return ColorLoader();
                    } else {
                      return FutureBuilder<QuerySnapshot>(
                          future: waferReportRef.get(),
                          builder: (BuildContext context,
                              AsyncSnapshot<QuerySnapshot> waferSnapshot) {
                            if (waferSnapshot.hasError) {
                              return ErrorMessageHeading(
                                  'Something went wrong');
                            } else if (waferSnapshot.connectionState ==
                                ConnectionState.waiting) {
                              return ColorLoader();
                            } else {
                              return FutureBuilder<QuerySnapshot>(
                                  future: maamoulReportRef.get(),
                                  builder: (BuildContext context,
                                      AsyncSnapshot<QuerySnapshot>
                                          maamoulSnapshot) {
                                    if (maamoulSnapshot.hasError) {
                                      return ErrorMessageHeading(
                                          'Something went wrong');
                                    } else if (maamoulSnapshot
                                            .connectionState ==
                                        ConnectionState.waiting) {
                                      return ColorLoader();
                                    } else {
                                      return FutureBuilder<QuerySnapshot>(
                                          future: nrcReportRef.get(),
                                          builder: (BuildContext context,
                                              AsyncSnapshot<QuerySnapshot>
                                                  nrcSnapshot) {
                                            if (nrcSnapshot.hasError) {
                                              return ErrorMessageHeading(
                                                  'Something went wrong');
                                            } else if (nrcSnapshot
                                                    .connectionState ==
                                                ConnectionState.waiting) {
                                              return ColorLoader();
                                            } else {
                                              try {
                                                biscuitsReportsList =
                                                    biscuitsSnapshot.data!.docs
                                                        as List<
                                                            QueryDocumentSnapshot<
                                                                BiscuitsReport>>;

                                                waferReportsList = waferSnapshot
                                                        .data!.docs
                                                    as List<
                                                        QueryDocumentSnapshot<
                                                            WaferReport>>;

                                                maamoulReportsList =
                                                    maamoulSnapshot.data!.docs
                                                        as List<
                                                            QueryDocumentSnapshot<
                                                                MaamoulReport>>;
                                                nrcReportsList = nrcSnapshot
                                                        .data!.docs
                                                    as List<
                                                        QueryDocumentSnapshot<
                                                            NRCReport>>;
                                                return SingleChildScrollView(
                                                  child: Column(
                                                    children: [
                                                      Container(
                                                        height:
                                                            defaultChartHeight,
                                                        padding:
                                                            const EdgeInsets
                                                                    .all(
                                                                defaultPadding),
                                                        child: Card(
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .all(
                                                                    minimumPadding),
                                                            child: Column(
                                                              children: [
                                                                subHeading(
                                                                    gaugesTypes[
                                                                        0]),
                                                                Expanded(
                                                                  child: VerticalBarChart
                                                                      .withRealData(
                                                                    tempElectricityNrcList,
                                                                    totalConsumptionElect /
                                                                        max(1,
                                                                            totalProductionElect),
                                                                    Plans
                                                                        .electConsumptionTarget,
                                                                    measureUnits[
                                                                        0],
                                                                    // gaugesTypes[0],
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      /////////////////////////////////////////////////////////////////////////
                                                      const SizedBox(
                                                          height:
                                                              defaultPadding),
                                                      Container(
                                                        height:
                                                            defaultChartHeight,
                                                        padding:
                                                            const EdgeInsets
                                                                    .all(
                                                                defaultPadding),
                                                        child: Card(
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .all(
                                                                    minimumPadding),
                                                            child: Column(
                                                              children: [
                                                                subHeading(
                                                                    gaugesTypes[
                                                                        1]),
                                                                Expanded(
                                                                  child: VerticalBarChart
                                                                      .withRealData(
                                                                    tempWaterNrcList,
                                                                    totalConsumptionWater /
                                                                        max(1,
                                                                            totalProductionWater),
                                                                    Plans
                                                                        .waterConsumptionTarget,
                                                                    measureUnits[
                                                                        1],
                                                                    // gaugesTypes[1],
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      /////////////////////////////////////////////////////////////////////
                                                      const SizedBox(
                                                          height:
                                                              defaultPadding),
                                                      Container(
                                                        height:
                                                            defaultChartHeight,
                                                        padding:
                                                            const EdgeInsets
                                                                    .all(
                                                                defaultPadding),
                                                        child: Card(
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .all(
                                                                    minimumPadding),
                                                            child: Column(
                                                              children: [
                                                                subHeading(
                                                                    gaugesTypes[
                                                                        2]),
                                                                Expanded(
                                                                  child: VerticalBarChart
                                                                      .withRealData(
                                                                    tempGasNrcList,
                                                                    totalConsumptionGas /
                                                                        max(1,
                                                                            totalProductionGas),
                                                                    Plans
                                                                        .gasConsumptionTarget,
                                                                    measureUnits[
                                                                        2],
                                                                    // gaugesTypes[1],
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      //////////////////////////////////////////////////////////////////////////
                                                      const SizedBox(
                                                          height:
                                                              defaultPadding),
                                                      Container(
                                                        height:
                                                            defaultChartHeight,
                                                        padding:
                                                            const EdgeInsets
                                                                    .all(
                                                                defaultPadding),
                                                        child: Card(
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .all(
                                                                    minimumPadding),
                                                            child: Column(
                                                              children: [
                                                                subHeading(
                                                                    gaugesTypes[
                                                                        3]),
                                                                Expanded(
                                                                  child: VerticalBarChart
                                                                      .withRealData(
                                                                    tempOrganicWasteNrcList,
                                                                    totalConsumptionOrganic /
                                                                        max(1,
                                                                            totalProductionOrganic),
                                                                    Plans
                                                                        .organicWasteConsumptionTarget,
                                                                    measureUnits[
                                                                        3],
                                                                    // gaugesTypes[1],
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              } catch (e) {
                                                print(e);
                                                return ErrorMessageHeading(
                                                    'Something went wrong');
                                              }
                                            }
                                          });
                                    }
                                  });
                            }
                          });
                    }
                  }),
              /////////////////////////////////////////////////////////////////////////////////////////
              const SizedBox(height: defaultPadding),
              Padding(
                padding: const EdgeInsets.all(minimumPadding),
                child: Center(
                  child: RoundedButton(
                      btnText: 'Export Detailed Report',
                      color: KelloggColors.green,
                      onPressed: () {
                        if (int.parse(_selectedYearTo) !=
                            int.parse(_selectedYearFrom)) {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content: Text(
                                "Error : invalid interval (reports of same year only are allowed)"),
                          ));
                        } else {
                          DateTime dateFrom = DateTime(
                              int.parse(_selectedYearTo),
                              int.parse(_selectedMonthFrom),
                              int.parse(_selectedDayFrom));
                          DateTime dateAfter = DateTime(
                              int.parse(_selectedYearTo),
                              int.parse(_selectedMonthTo),
                              int.parse(_selectedDayTo));
                          if (dateFrom.isBefore(dateAfter) ||
                              dateFrom.isAtSameMomentAs(dateAfter)) {
                            calculateInterval();
                            OtherExcelUtilities util =
                                OtherExcelUtilities(refNum: NRC_REPORT);
                            util.insertHeaders();
                            nrcReportRef
                                .get()
                                .then((QuerySnapshot nrcSnapshot) {
                              try {
                                List<QueryDocumentSnapshot<NRCReport>>
                                    nrcReportsList = nrcSnapshot.docs as List<
                                        QueryDocumentSnapshot<NRCReport>>;
                                List<NRCReport> allReports =
                                    NRCReport.getAllReportsOfInterval(
                                  nrcReportsList,
                                  validated_month_from,
                                  validated_month_to,
                                  validated_day_from,
                                  validated_day_to,
                                  validated_year,
                                  TOTAL_PLANT,
                                  //ALL_LINES,
                                ).values.toList();

                                util.insertNrcReportRows(allReports);

                                util.saveExcelFile(
                                    context,
                                    validated_day_from.toString(),
                                    validated_day_to.toString(),
                                    validated_month_from.toString(),
                                    validated_month_to.toString());
                              } catch (e) {
                                showExcelAlertDialog(context, false, "");
                              }
                            });
                          }
                        }
                      }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
