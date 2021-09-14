/*
this screen will contain
1- navigation drawer (today production details/production in interval/QFS/EHS)
2 - Big title and today date
3 - today's numbers of the whole plant : production
4- qfs brief
5- ehs brief
 *********************************/
import 'package:cairo_bisco_app/classes/EhsReport.dart';
import 'package:cairo_bisco_app/classes/Plans.dart';
import 'package:cairo_bisco_app/classes/QfsReport.dart';
import 'package:cairo_bisco_app/classes/values/TextStandards.dart';
import 'package:cairo_bisco_app/classes/values/colors.dart';
import 'package:cairo_bisco_app/classes/values/constants.dart';
import 'package:cairo_bisco_app/components/production_widgets/chart.dart';
import 'package:cairo_bisco_app/components/production_widgets/production_info_card.dart';
import 'package:cairo_bisco_app/components/qfs_ehs_wigdets/6kpis_good_bad_indicator.dart';
import 'package:cairo_bisco_app/components/special_components/side_menu.dart';
import 'package:cairo_bisco_app/components/utility_funcs/date_utility.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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

  @override
  Widget build(BuildContext context) {
    int days_in_interval = 1; //screen shows 1 day only
    final qualityReportRef = FirebaseFirestore.instance
        .collection(factory_name)
        .doc('quality_reports')
        .collection(getYear())
        .withConverter<QfsReport>(
          fromFirestore: (snapshot, _) => QfsReport.fromJson(snapshot.data()!),
          toFirestore: (report, _) => report.toJson(),
        );
    final ehsReportRef = FirebaseFirestore.instance
        .collection(factory_name)
        .doc('ehs_reports')
        .collection(getYear())
        .withConverter<EhsReport>(
          fromFirestore: (snapshot, _) => EhsReport.fromJson(snapshot.data()!),
          toFirestore: (report, _) => report.toJson(),
        );
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
                StreamBuilder<QuerySnapshot>(
                  stream: qualityReportRef.snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return ErrorMessageHeading('Something went wrong');
                    } else if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return ErrorMessageHeading('Loading');
                    } else {
                      try {
                        List<QueryDocumentSnapshot<QfsReport>> reportsList =
                            snapshot.data!.docs
                                as List<QueryDocumentSnapshot<QfsReport>>;
                        // print("qfs ::" + reportsList.length.toString());
                        QfsReport temp_qfs =
                            QfsReport.getFilteredReportOfInterval(
                                reportsList,
                                int.parse(getMonth()),
                                int.parse(getMonth()),
                                int.parse(getDay()),
                                int.parse(getDay()),
                                -1,
                                -1);
                        return KPI6GoodBadIndicator(
                          color1: temp_qfs.quality_incidents > 0
                              ? KelloggColors.cockRed
                              : KelloggColors.green,
                          title1: 'Quality\nIncidents',
                          color2: temp_qfs.food_safety_incidents > 0
                              ? KelloggColors.cockRed
                              : KelloggColors.green,
                          title2: 'Food Safety\nIncidents',
                          color3: temp_qfs.ccp_failure > 0
                              ? KelloggColors.cockRed
                              : KelloggColors.green,
                          title3: 'CCP\nFailures',
                          color4: temp_qfs.pes_index == 2
                              ? KelloggColors.cockRed
                              : temp_qfs.pes_index == 1
                                  ? KelloggColors.yellow
                                  : KelloggColors.green,
                          title4: 'PES\n(B&C Defects)',
                          color5: temp_qfs.consumer_complaints > 0
                              ? KelloggColors.cockRed
                              : KelloggColors.green,
                          title5: 'Consumer\nComplaints',
                          color6: temp_qfs.g6_index == 2
                              ? KelloggColors.cockRed
                              : temp_qfs.g6_index == 1
                                  ? KelloggColors.yellow
                                  : KelloggColors.green,
                          title6: 'G6 Escalation',
                        );
                      } catch (e) {
                        print(e);
                        return ErrorMessageHeading('Something went wrong');
                      }
                    }
                  },
                ),
                sectionTitle('EHS'),
                StreamBuilder<QuerySnapshot>(
                  stream: ehsReportRef.snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return ErrorMessageHeading('Something went wrong');
                    } else if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return ErrorMessageHeading("Loading");
                    } else {
                      try {
                        List<QueryDocumentSnapshot<EhsReport>> reportsList =
                            snapshot.data!.docs
                                as List<QueryDocumentSnapshot<EhsReport>>;
                        // print("ehs ::" + reportsList.length.toString());
                        EhsReport temp_ehs =
                            EhsReport.getFilteredReportOfInterval(
                                reportsList,
                                int.parse(getMonth()),
                                int.parse(getMonth()),
                                int.parse(getDay()),
                                int.parse(getDay()),
                                -1,
                                -1);
                        return KPI6GoodBadIndicator(
                          color1: temp_ehs.firstAid_incidents > 0
                              ? KelloggColors.cockRed
                              : KelloggColors.green,
                          title1: 'First Aid\nIncidents',
                          color2: temp_ehs.lostTime_incidents > 0
                              ? KelloggColors.cockRed
                              : KelloggColors.green,
                          title2: 'Lost Time\nIncidents',
                          color3: temp_ehs.recordable_incidents > 0
                              ? KelloggColors.cockRed
                              : KelloggColors.green,
                          title3: 'Recordable\nIncidents',
                          color4: temp_ehs.nearMiss <
                                  (Plans.monthlyNearMissTarget / monthDays) *
                                      days_in_interval
                              ? KelloggColors.cockRed
                              : KelloggColors.green,
                          title4: 'Near Miss',
                          color5:
                              temp_ehs.risk_assessment > Plans.highRisksBoundary
                                  ? KelloggColors.cockRed
                                  : temp_ehs.risk_assessment >
                                          Plans.mediumRisksBoundary
                                      ? KelloggColors.yellow
                                      : KelloggColors.green,
                          title5: 'pre-shift\nRisk\nAssessment',
                          color6: temp_ehs.s7_index == 1
                              ? KelloggColors.cockRed
                              : KelloggColors.green,
                          title6: 'S7 Tours',
                        );
                      } catch (e) {
                        print(e);
                        return ErrorMessageHeading('Something went wrong');
                      }
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
