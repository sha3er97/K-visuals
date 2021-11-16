import 'package:cairo_bisco_app/classes/values/colors.dart';
import 'package:cairo_bisco_app/components/buttons/gradient_general_btn.dart';
import 'package:cairo_bisco_app/components/buttons/log_out_btn.dart';
import 'package:cairo_bisco_app/ui/admin_screens/admin_edit_targets.dart';
import 'package:cairo_bisco_app/ui/admin_screens/admin_main_add_sku.dart';
import 'package:cairo_bisco_app/ui/admin_screens/admin_show_all_skus.dart';
import 'package:flutter/material.dart';

import 'admin_review_admin_emails.dart';
import 'admin_review_owner_emails.dart';

class AdminHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KelloggColors.white,
      resizeToAvoidBottomInset: true,
      appBar: new AppBar(
        backgroundColor: KelloggColors.white.withOpacity(0),
        shadowColor: KelloggColors.white.withOpacity(0),
        leading: LogOutBtn(
          admin: true,
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
                title: "Add New SKU",
                btn_icon: Icons.add_comment,
                param_onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AdminAddSku(),
                    ),
                  );
                },
              ),
              GradientGeneralButton(
                gradientColor1: KelloggColors.yellow,
                gradientColor2: KelloggColors.grey,
                mainColor: KelloggColors.darkBlue.withOpacity(0.5),
                title: "Edit Existing SKU",
                btn_icon: Icons.edit,
                param_onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ShowSkus(),
                    ),
                  );
                },
              ),
              GradientGeneralButton(
                gradientColor1: KelloggColors.white,
                gradientColor2: KelloggColors.grey,
                mainColor: KelloggColors.darkBlue.withOpacity(0.5),
                btn_icon: Icons.edit_road,
                title: "Edit Targets",
                param_onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AdminEditTargets(),
                    ),
                  );
                },
              ),
              GradientGeneralButton(
                gradientColor1: KelloggColors.green,
                gradientColor2: KelloggColors.grey,
                mainColor: KelloggColors.darkBlue.withOpacity(0.5),
                btn_icon: Icons.verified_user,
                title: "Edit Authorized People",
                param_onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ReviewAdminEmails(),
                    ),
                  );
                },
              ),
              GradientGeneralButton(
                gradientColor1: KelloggColors.successGreen,
                gradientColor2: KelloggColors.grey,
                mainColor: KelloggColors.darkBlue.withOpacity(0.5),
                btn_icon: Icons.verified,
                title: "Edit Owners",
                param_onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ReviewOwnerEmails(),
                    ),
                  );
                },
              ),
            ]),
      ),
    );
  }
}
