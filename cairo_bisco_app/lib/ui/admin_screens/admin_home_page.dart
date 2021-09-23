import 'package:cairo_bisco_app/classes/values/colors.dart';
import 'package:cairo_bisco_app/components/buttons/admin_btn.dart';
import 'package:cairo_bisco_app/components/buttons/back_btn.dart';
import 'package:flutter/material.dart';

import 'admin_main_add_sku.dart';

class AdminHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Color gradientColor1 = type.compareTo(prodType[0]) == 0
    //     ? KelloggColors.orange
    //     : type.compareTo(prodType[1]) == 0
    //         ? KelloggColors.cockRed
    //         : KelloggColors.grey;
    // Color gradientColor2 = type.compareTo(prodType[0]) == 0
    //     ? KelloggColors.yellow
    //     : type.compareTo(prodType[1]) == 0
    //         ? KelloggColors.grey
    //         : KelloggColors.cockRed;
    // Color mainColor = type.compareTo(prodType[0]) == 0
    //     ? KelloggColors.yellow.withOpacity(0.5)
    //     : type.compareTo(prodType[1]) == 0
    //         ? KelloggColors.green.withOpacity(0.5)
    //         : KelloggColors.cockRed.withOpacity(0.5);
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
                  //TODO :: list exiting skus with option to be edited
                  // Navigator.push(context,
                  //     MaterialPageRoute(builder: (context) => AdminAddSku()));
                },
              ),
              AdminButton(
                gradientColor1: KelloggColors.white,
                gradientColor2: KelloggColors.grey,
                mainColor: KelloggColors.darkBlue.withOpacity(0.5),
                btn_icon: Icons.edit_road,
                title: "Edit Targets",
                param_onPressed: () {
                  //TODO :: list targets with existing values and slider to edit
                  // Navigator.push(context,
                  //     MaterialPageRoute(builder: (context) => AdminAddSku()));
                },
              ),
            ]),
      ),
    );
  }
}
