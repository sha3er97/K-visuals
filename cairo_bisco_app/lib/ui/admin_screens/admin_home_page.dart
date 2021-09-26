import 'package:cairo_bisco_app/classes/values/colors.dart';
import 'package:cairo_bisco_app/components/buttons/admin_btn.dart';
import 'package:cairo_bisco_app/components/buttons/back_btn.dart';
import 'package:flutter/material.dart';

import 'admin_edit_targets.dart';
import 'admin_main_add_sku.dart';
import 'admin_show_all_skus.dart';

class AdminHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KelloggColors.white,
      resizeToAvoidBottomInset: true,
      appBar: new AppBar(
        backgroundColor: KelloggColors.white.withOpacity(0),
        shadowColor: KelloggColors.white.withOpacity(0),
        leading: MyBackButton(
          admin: true,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AdminButton(
                gradientColor1: KelloggColors.cockRed,
                gradientColor2: KelloggColors.grey,
                mainColor: KelloggColors.darkBlue.withOpacity(0.5),
                title: "Add New SKU",
                btn_icon: Icons.add_comment,
                param_onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => AdminAddSku()));
                },
              ),
              AdminButton(
                gradientColor1: KelloggColors.yellow,
                gradientColor2: KelloggColors.grey,
                mainColor: KelloggColors.darkBlue.withOpacity(0.5),
                title: "Edit Existing SKU",
                btn_icon: Icons.edit,
                param_onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => ShowSkus()));
                },
              ),
              AdminButton(
                gradientColor1: KelloggColors.white,
                gradientColor2: KelloggColors.grey,
                mainColor: KelloggColors.darkBlue.withOpacity(0.5),
                btn_icon: Icons.edit_road,
                title: "Edit Targets",
                param_onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AdminEditTargets()));
                },
              ),
            ]),
      ),
    );
  }
}