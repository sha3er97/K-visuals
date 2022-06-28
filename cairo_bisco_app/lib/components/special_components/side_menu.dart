import 'package:cairo_bisco_app/classes/Credentials.dart';
import 'package:cairo_bisco_app/classes/values/colors.dart';
import 'package:cairo_bisco_app/classes/values/constants.dart';
import 'package:cairo_bisco_app/components/special_components/place_holders.dart';
import 'package:cairo_bisco_app/ui/admin_screens/admin_home_page.dart';
import 'package:cairo_bisco_app/ui/login_screens/login.dart';
import 'package:cairo_bisco_app/ui/production_screens/home_production.dart';
import 'package:cairo_bisco_app/ui/production_screens/home_production_interval.dart';
import 'package:cairo_bisco_app/ui/qfs_ehs_screens/ehs_detailed_report.dart';
import 'package:cairo_bisco_app/ui/qfs_ehs_screens/qfs_detailed_report.dart';
import 'package:cairo_bisco_app/ui/supervisor_screens/supervisor_home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../ui/down_time_screens/dt_approve_reports.dart';
import '../../ui/extra_dashboards/choose_dashboard.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isAdmin = Credentials.isUserAdmin;
    bool isOwner = Credentials.isUserOwner;
    bool isKws = Credentials.isUserKws;
    return Drawer(
      backgroundColor: KelloggColors.white,
      child: ListView(
        children: [
          // DrawerHeader(
          //   child: Image.asset("images/logo.png"),
          // ),
          DrawerHeader(
            child: Image.asset("images/small factory.jpg"),
          ),
          SizedBox(
            height: minimumPadding,
          ),
          Center(
            child: Text(
              'Version : ' + versionNum,
              style: TextStyle(color: KelloggColors.grey),
            ),
          ),
          SizedBox(
            height: minimumPadding,
          ),
          Center(
            child: Text(
              "Name : " + Credentials.getUserName(),
              style: TextStyle(color: KelloggColors.darkBlue),
            ),
          ),
          SizedBox(
            height: minimumPadding,
          ),
          isAdmin
              ? DrawerListTile(
                  title: "Today's production details",
                  image: "factory",
                  press: () {
                    // WidgetsBinding.instance!.addPostFrameCallback((_) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HomeProductionPage(),
                      ),
                    );
                    // });
                  },
                )
              : EmptyPlaceHolder(),
          isAdmin
              ? DrawerListTile(
                  title: "Production in interval",
                  image: "calendar",
                  press: () {
                    // WidgetsBinding.instance!.addPostFrameCallback((_) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HomeProductionIntervalPage(),
                      ),
                    );
                    // });
                  },
                )
              : EmptyPlaceHolder(),
          isAdmin
              ? DrawerListTile(
                  title: "QFS",
                  image: "quality",
                  press: () {
                    // WidgetsBinding.instance!.addPostFrameCallback((_) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => QfsDetailedReport(),
                      ),
                    );
                    // });
                  },
                )
              : EmptyPlaceHolder(),
          isAdmin
              ? DrawerListTile(
                  title: "EHS",
                  image: "safety",
                  press: () {
                    // WidgetsBinding.instance!.addPostFrameCallback((_) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EhsDetailedReport(),
                      ),
                    );
                    // });
                  },
                )
              : EmptyPlaceHolder(),
          isAdmin
              ? DrawerListTile(
                  title: isOwner ? "Add/Edit Report" : "Add Report",
                  image: "report",
                  press: () {
                    // WidgetsBinding.instance!.addPostFrameCallback((_) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SupervisorHomePage(),
                      ),
                    );
                    // });
                  },
                )
              : EmptyPlaceHolder(),
          isAdmin
              ? DrawerListTile(
                  title: "Approve Pending Reports",
                  image: "downtime",
                  press: () {
                    // WidgetsBinding.instance!.addPostFrameCallback((_) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ApproveReports(),
                      ),
                    );
                    // });
                  },
                )
              : EmptyPlaceHolder(),
          isAdmin
              ? DrawerListTile(
                  title: "More Dashboards",
                  image: "pie_chart",
                  press: () {
                    // WidgetsBinding.instance!.addPostFrameCallback((_) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChooseDashBoard(),
                      ),
                    );
                    // });
                  },
                )
              : EmptyPlaceHolder(),
          isKws && isAdmin
              ? DrawerListTile(
                  title: "KWS View",
                  image: "vip",
                  press: () {
                    // WidgetsBinding.instance!.addPostFrameCallback((_) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            // builder: (context) => SuccessScreen()
                            builder: (context) => AdminHomePage()));
                    // });
                  },
                )
              : EmptyPlaceHolder(),
          DrawerListTile(
            title: "Log Out",
            image: "exit",
            press: () async {
              await FirebaseAuth.instance.signOut();
              WidgetsBinding.instance!.addPostFrameCallback((_) {
                Navigator.pop(context);
                // Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Login(),
                  ),
                );
              });
            },
          ),
        ],
      ),
    );
  }
}

class DrawerListTile extends StatelessWidget {
  const DrawerListTile({
    Key? key,
    // For selecting those three line once press "Command+D"
    required this.title,
    required this.image,
    required this.press,
  }) : super(key: key);

  final String title, image;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: press,
      horizontalTitleGap: minimumPadding,
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(iconImageBorder),
        child: Container(
          height: regularIconSize,
          width: regularIconSize,
          padding: EdgeInsets.all(minimumPadding / 2),
          color: KelloggColors.white,
          child: new Image.asset(
            'images/$image.png',
          ),
        ),
      ),
      title: Text(
        title,
        style: TextStyle(color: KelloggColors.darkRed),
      ),
    );
  }
}
