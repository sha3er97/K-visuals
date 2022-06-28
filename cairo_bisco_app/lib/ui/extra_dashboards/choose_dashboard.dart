import 'package:cairo_bisco_app/classes/values/colors.dart';
import 'package:cairo_bisco_app/components/buttons/back_btn.dart';
import 'package:cairo_bisco_app/components/buttons/gradient_general_btn.dart';
import 'package:cairo_bisco_app/ui/extra_dashboards/downTime_dashboard.dart';
import 'package:cairo_bisco_app/ui/extra_dashboards/scrap_dashboard.dart';
import 'package:flutter/material.dart';

class ChooseDashBoard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KelloggColors.white,
      resizeToAvoidBottomInset: true,
      appBar: new AppBar(
        backgroundColor: KelloggColors.white.withOpacity(0),
        shadowColor: KelloggColors.white.withOpacity(0),
        leading: MyBackButton(
          color: KelloggColors.darkRed,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GradientGeneralButton(
                gradientColor1: KelloggColors.cockRed,
                gradientColor2: KelloggColors.grey,
                mainColor: KelloggColors.darkBlue.withOpacity(0.5),
                title: "DownTime DashBoard",
                btn_icon: Icons.bar_chart,
                param_onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DownTimeDashboard(),
                    ),
                  );
                }),
            GradientGeneralButton(
              gradientColor1: KelloggColors.successGreen,
              gradientColor2: KelloggColors.grey,
              mainColor: KelloggColors.green.withOpacity(0.5),
              title: "Scrap DashBoard",
              btn_icon: Icons.pie_chart,
              param_onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ScrapDashboard(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
