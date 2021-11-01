import 'package:cairo_bisco_app/classes/Credentials.dart';
import 'package:cairo_bisco_app/classes/values/colors.dart';
import 'package:cairo_bisco_app/classes/values/constants.dart';
import 'package:cairo_bisco_app/ui/production_screens/home_production.dart';
import 'package:cairo_bisco_app/ui/production_screens/home_production_interval.dart';
import 'package:cairo_bisco_app/ui/qfs_ehs_screens/ehs_detailed_report.dart';
import 'package:cairo_bisco_app/ui/qfs_ehs_screens/qfs_detailed_report.dart';
import 'package:cairo_bisco_app/ui/supervisor_screens/supervisor_home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isAdmin = Credentials.isUserAdmin;
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            child: Image.asset("images/logo.png"),
          ),
          isAdmin
              ? DrawerListTile(
                  title: "  Today's production details",
                  image: "factory",
                  press: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => HomeProductionPage()));
                  },
                )
              : SizedBox(height: 0),
          isAdmin
              ? DrawerListTile(
                  title: "  Production in interval",
                  image: "calendar",
                  press: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                HomeProductionIntervalPage()));
                  },
                )
              : SizedBox(height: 0),
          isAdmin
              ? DrawerListTile(
                  title: "  QFS",
                  image: "quality",
                  press: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => QfsDetailedReport()));
                  },
                )
              : SizedBox(height: 0),
          isAdmin
              ? DrawerListTile(
                  title: "  EHS",
                  image: "safety",
                  press: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => EhsDetailedReport()));
                  },
                )
              : SizedBox(height: 0),
          DrawerListTile(
            title: isAdmin ? "  Add/Edit Report" : "  Add Report",
            image: "report",
            press: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SupervisorHomePage()));
            },
          ),
          DrawerListTile(
            title: "  Log Out",
            image: "exit",
            press: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pop(context);
              Navigator.pop(context);
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
      horizontalTitleGap: 0.0,
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(iconImageBorder), //or 15.0
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
