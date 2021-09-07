/*
this screen will contain
1- navigation drawer (today production details/production in interval/QFS/EHS)
2 - Big title and today date
3 - today's numbers of the whole plant : production
4- qfs brief
5- ehs brief
 *********************************/
import 'package:cairo_bisco_app/classes/values/Rules.dart';
import 'package:cairo_bisco_app/classes/values/TextStandards.dart';
import 'package:cairo_bisco_app/classes/values/colors.dart';
import 'package:cairo_bisco_app/classes/values/constants.dart';
import 'package:cairo_bisco_app/classes/values/form_values.dart';
import 'package:cairo_bisco_app/components/production_widgets/chart.dart';
import 'package:cairo_bisco_app/components/production_widgets/production_info_card.dart';
import 'package:cairo_bisco_app/components/qfs_ehs_wigdets/6kpis_good_bad_indicator.dart';
import 'package:cairo_bisco_app/components/special_components/side_menu.dart';
import 'package:cairo_bisco_app/components/utility_funcs/date_utility.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class HomePage extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  bool showSpinner = false;
  double biscuits = 10.0,
      wafer = 5.1,
      maamoul = 3.6,
      totalTonnage = 25; //TODO :: take actual numbers

  int biscuitsCartons = 10,
      waferCartons = 5,
      maamoulCartons = 3,
      totalCartons = 25; //TODO :: take actual numbers

  int quality_incidents = 3,
      food_safety_incidents = 0,
      ccp_failure = 0,
      consumer_complaints = 0;
  String pes = Pes[1], g6_escalaction = G6[2]; //TODO :: take actual numbers

  int firstAid_incidents = 0,
      lostTime_incidents = 0,
      recordable_incidents = 0,
      nearMiss = 0,
      risk_assessment = 6;
  String s7_tours = S7[1]; //TODO :: take actual numbers

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: SafeArea(
            child: Scaffold(
                backgroundColor: KelloggColors.white,
                key: _scaffoldKey,
                drawer: SideMenu(),
                appBar: new AppBar(
                  backgroundColor: KelloggColors.white.withOpacity(0),
                  shadowColor: KelloggColors.white.withOpacity(0),
                  leading: new IconButton(
                    icon: new Icon(
                      Icons.menu,
                      color: KelloggColors.darkRed,
                    ),
                    onPressed: () => _scaffoldKey.currentState!.openDrawer(),
                  ),
                ),
                resizeToAvoidBottomInset: true,
                body: SingleChildScrollView(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                      Center(
                        child: subHeading('Plant overview'),
                      ),
                      Center(child: smallerHeading(todayDateText())),
                      SizedBox(height: defaultPadding),
                      sectionTitle('Production'),
                      Chart(
                          biscuits: biscuits,
                          wafer: wafer,
                          maamoul: maamoul,
                          totalProduction: biscuits + maamoul + wafer,
                          totalTonnage: totalTonnage),
                      ProductionInfoCard(
                        image: "colored_biscuit",
                        title: "Biscuits",
                        background: KelloggColors.yellow,
                        amountInKgs: "$biscuits K",
                        numOfCartons: biscuitsCartons,
                      ),
                      ProductionInfoCard(
                        image: "colored_wafer",
                        title: "Wafer",
                        background: KelloggColors.green,
                        amountInKgs: "$wafer K",
                        numOfCartons: waferCartons,
                      ),
                      ProductionInfoCard(
                        image: "colored_maamoul",
                        title: "Maamoul",
                        background: KelloggColors.cockRed,
                        amountInKgs: "$maamoul K",
                        numOfCartons: maamoulCartons,
                      ),
                      ProductionInfoCard(
                        image: "recycle",
                        title: "Scrap and rework",
                        background: KelloggColors.white,
                        amountInKgs: (totalTonnage - biscuits - maamoul - wafer)
                                .toStringAsFixed(1) +
                            " K",
                        numOfCartons: totalCartons -
                            biscuitsCartons -
                            maamoulCartons -
                            waferCartons,
                      ),
                      sectionTitle('QFS'),
                      KPI6GoodBadIndicator(
                        color1: quality_incidents > 0
                            ? KelloggColors.cockRed
                            : KelloggColors.green,
                        title1: 'Quality\nIncidents',
                        color2: food_safety_incidents > 0
                            ? KelloggColors.cockRed
                            : KelloggColors.green,
                        title2: 'Food Safety\nIncidents',
                        color3: ccp_failure > 0
                            ? KelloggColors.cockRed
                            : KelloggColors.green,
                        title3: 'CCP\nFailures',
                        color4: pes.compareTo(Pes[2]) == 0
                            ? KelloggColors.cockRed
                            : pes.compareTo(Pes[1]) == 0
                                ? KelloggColors.yellow
                                : KelloggColors.green,
                        title4: 'PES\n(B&C Defects)',
                        color5: consumer_complaints > 0
                            ? KelloggColors.cockRed
                            : KelloggColors.green,
                        title5: 'Consumer\nComplaints',
                        color6: g6_escalaction.compareTo(G6[2]) == 0
                            ? KelloggColors.cockRed
                            : pes.compareTo(G6[1]) == 0
                                ? KelloggColors.yellow
                                : KelloggColors.green,
                        title6: 'G6 Escalation',
                      ),
                      sectionTitle('EHS'),
                      KPI6GoodBadIndicator(
                        color1: firstAid_incidents > 0
                            ? KelloggColors.cockRed
                            : KelloggColors.green,
                        title1: 'First Aid\nIncidents',
                        color2: lostTime_incidents > 0
                            ? KelloggColors.cockRed
                            : KelloggColors.green,
                        title2: 'Lost Time\nIncidents',
                        color3: recordable_incidents > 0
                            ? KelloggColors.cockRed
                            : KelloggColors.green,
                        title3: 'Recordable\nIncidents',
                        color4: nearMiss == 0
                            ? KelloggColors.cockRed
                            : KelloggColors.green,
                        title4: 'Near Miss',
                        color5: risk_assessment > Plans.highRisksBoundary
                            ? KelloggColors.cockRed
                            : risk_assessment > Plans.mediumRisksBoundary
                                ? KelloggColors.yellow
                                : KelloggColors.green,
                        title5: 'pre-shift\nRisk\nAssessment',
                        color6: s7_tours.compareTo(S7[1]) == 0
                            ? KelloggColors.cockRed
                            : KelloggColors.green,
                        title6: 'S7 Tours',
                      ),
                    ])))));
  }
}
