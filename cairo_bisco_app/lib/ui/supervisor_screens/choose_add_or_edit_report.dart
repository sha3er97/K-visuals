/**********************************
    this screen will have 2 big buttons
    Visuals
    Reports
 *********************************/
import 'package:cairo_bisco_app/classes/values/colors.dart';
import 'package:cairo_bisco_app/components/buttons/back_btn.dart';
import 'package:cairo_bisco_app/components/buttons/gradient_general_btn.dart';
import 'package:cairo_bisco_app/ui/supervisor_screens/supervisor_choose_area.dart';
import 'package:flutter/material.dart';

class ChooseAddOrEditReport extends StatelessWidget {
  ChooseAddOrEditReport({
    Key? key,
    required this.type,
  }) : super(key: key);

  final int type;

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
              title: "Add Report\nاضافة تقرير",
              btn_icon: Icons.add,
              param_onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SupervisorChooseAreaPage(
                      type: type,
                      isEdit: false,
                    ),
                  ),
                );
              },
            ),
            GradientGeneralButton(
              gradientColor1: KelloggColors.successGreen,
              gradientColor2: KelloggColors.grey,
              mainColor: KelloggColors.green.withOpacity(0.5),
              title: "Edit/Delete Report\nتعديل و حذف التقارير",
              btn_icon: Icons.edit,
              param_onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SupervisorChooseAreaPage(
                      type: type,
                      isEdit: true,
                    ),
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
