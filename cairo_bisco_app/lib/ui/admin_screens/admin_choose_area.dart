/*
    this screen will have 3 big buttons
    biscuits
    wafer
    maamoul
 *********************************/
import 'package:cairo_bisco_app/classes/values/colors.dart';
import 'package:cairo_bisco_app/classes/values/constants.dart';
import 'package:cairo_bisco_app/components/buttons/back_btn.dart';
import 'package:flutter/material.dart';

import 'admin_add_sku_form.dart';

class AdminChooseArea extends StatelessWidget {
  AdminChooseArea({
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
          admin: false,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(minimumPadding),
              child: Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(BoxImageBorder),
                  child: ConstrainedBox(
                    constraints: BoxConstraints.tightFor(
                        width: TightBoxWidth, height: LargeBoxHeight),
                    child: ElevatedButton.icon(
                      label: Text('Biscuits\nالبسكويت'),
                      style: ElevatedButton.styleFrom(
                        textStyle: TextStyle(
                            fontSize: largeButtonFont, fontFamily: 'MyFont'),
                        primary: KelloggColors.yellow,
                      ),
                      icon: ClipRRect(
                        borderRadius: BorderRadius.circular(iconImageBorder),
                        child: Container(
                          height: mediumIconSize,
                          width: mediumIconSize,
                          padding: EdgeInsets.all(minimumPadding / 2),
                          child: new Image.asset(
                            'images/colored_biscuit.png',
                          ),
                        ),
                      ),
                      onPressed: () {
                        switch (type) {
                          case ADMIN_ADD_SKU:
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AddSkuForm(
                                  refNum: BISCUIT_AREA,
                                ),
                              ),
                            );
                            break;
                        }
                      },
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(minimumPadding),
              child: Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(BoxImageBorder),
                  child: ConstrainedBox(
                    constraints: BoxConstraints.tightFor(
                        width: TightBoxWidth, height: LargeBoxHeight),
                    child: ElevatedButton.icon(
                      label: Text('Wafer\nالويفر'),
                      style: ElevatedButton.styleFrom(
                        textStyle: TextStyle(
                            fontSize: largeButtonFont, fontFamily: 'MyFont'),
                        primary: KelloggColors.green,
                      ),
                      icon: ClipRRect(
                        borderRadius: BorderRadius.circular(iconImageBorder),
                        child: Container(
                          height: mediumIconSize,
                          width: mediumIconSize,
                          padding: EdgeInsets.all(minimumPadding / 2),
                          child: new Image.asset(
                            'images/colored_wafer.png',
                          ),
                        ),
                      ),
                      onPressed: () {
                        switch (type) {
                          case ADMIN_ADD_SKU:
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AddSkuForm(
                                  refNum: WAFER_AREA,
                                ),
                              ),
                            );
                            break;
                        }
                      },
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(minimumPadding),
              child: Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(BoxImageBorder),
                  child: ConstrainedBox(
                    constraints: BoxConstraints.tightFor(
                        width: TightBoxWidth, height: LargeBoxHeight),
                    child: ElevatedButton.icon(
                      label: Text('Maamoul\nالمعمول'),
                      style: ElevatedButton.styleFrom(
                        textStyle: TextStyle(
                            fontSize: largeButtonFont, fontFamily: 'MyFont'),
                        padding: EdgeInsets.symmetric(
                            horizontal: defaultPadding,
                            vertical: minimumPadding),
                        primary: KelloggColors.cockRed,
                      ),
                      icon: ClipRRect(
                        borderRadius: BorderRadius.circular(iconImageBorder),
                        child: Container(
                          height: mediumIconSize,
                          width: mediumIconSize,
                          padding: EdgeInsets.all(minimumPadding / 2),
                          child: new Image.asset(
                            'images/colored_maamoul.png',
                          ),
                        ),
                      ),
                      onPressed: () {
                        switch (type) {
                          case ADMIN_ADD_SKU:
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AddSkuForm(
                                  refNum: MAAMOUL_AREA,
                                ),
                              ),
                            );
                            break;
                        }
                      },
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
