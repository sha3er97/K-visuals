/*
    this screen will have 6 big buttons
    production
    qfs
    ehs
    overweight
    people
    NRC
 *********************************/
import 'package:cairo_bisco_app/classes/values/colors.dart';
import 'package:cairo_bisco_app/classes/values/constants.dart';
import 'package:cairo_bisco_app/components/buttons/back_btn.dart';
import 'package:flutter/material.dart';

import 'choose_add_or_edit_report.dart';

class SupervisorHomePage extends StatelessWidget {
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
            /////////////////first button///////////////////
            Padding(
              padding: const EdgeInsets.all(minimumPadding),
              child: Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(BoxImageBorder),
                  child: ConstrainedBox(
                    constraints: BoxConstraints.tightFor(
                        width: TightBoxWidth, height: LargeBoxHeight),
                    child: Container(
                      decoration: const BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment(0.99, 0.0),
                          // 10% of the width, so there are ten blinds.
                          colors: const <Color>[
                            KelloggColors.orange,
                            KelloggColors.yellow
                          ],
                          // red to yellow
                          tileMode: TileMode
                              .repeated, // repeats the gradient over the canvas
                        ),
                      ),
                      child: ElevatedButton.icon(
                        label: Text(
                          'Production Report\nتقرير الانتاج',
                          overflow: TextOverflow.ellipsis,
                        ),
                        style: ElevatedButton.styleFrom(
                          textStyle: TextStyle(
                              fontSize: largeFontSize, fontFamily: 'MyFont'),
                          primary: KelloggColors.yellow.withOpacity(0.5),
                        ),
                        icon: ClipRRect(
                          borderRadius: BorderRadius.circular(iconImageBorder),
                          child: Container(
                            height: mediumIconSize,
                            width: mediumIconSize,
                            padding: EdgeInsets.all(minimumPadding / 2),
                            child: new Image.asset(
                              'images/factory.png',
                            ),
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ChooseAddOrEditReport(
                                      type: PRODUCTION_REPORT)));
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
            /////////////////second button///////////////////
            Padding(
              padding: const EdgeInsets.all(minimumPadding),
              child: Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(BoxImageBorder),
                  child: ConstrainedBox(
                    constraints: BoxConstraints.tightFor(
                        width: TightBoxWidth, height: LargeBoxHeight),
                    child: Container(
                      decoration: const BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment(0.99, 0.0),
                          // 10% of the width, so there are ten blinds.
                          colors: const <Color>[
                            KelloggColors.cockRed,
                            KelloggColors.grey
                          ],
                          // red to yellow
                          tileMode: TileMode
                              .repeated, // repeats the gradient over the canvas
                        ),
                      ),
                      child: ElevatedButton.icon(
                        label: Text(
                          'QFS Report\nتقرير الجودة',
                          overflow: TextOverflow.ellipsis,
                        ),
                        style: ElevatedButton.styleFrom(
                          textStyle: TextStyle(
                              fontSize: largeFontSize, fontFamily: 'MyFont'),
                          primary: KelloggColors.green.withOpacity(0.5),
                        ),
                        icon: ClipRRect(
                          borderRadius: BorderRadius.circular(iconImageBorder),
                          child: Container(
                            height: mediumIconSize,
                            width: mediumIconSize,
                            padding: EdgeInsets.all(minimumPadding / 2),
                            child: new Image.asset(
                              'images/quality.png',
                              color: KelloggColors.white,
                            ),
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      ChooseAddOrEditReport(type: QFS_REPORT)));
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
            /////////////////third button///////////////////
            Padding(
              padding: const EdgeInsets.all(minimumPadding),
              child: Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(BoxImageBorder),
                  child: ConstrainedBox(
                    constraints: BoxConstraints.tightFor(
                        width: TightBoxWidth, height: LargeBoxHeight),
                    child: Container(
                      decoration: const BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment(0.99, 0.0),
                          // 10% of the width, so there are ten blinds.
                          colors: const <Color>[
                            KelloggColors.grey,
                            KelloggColors.cockRed
                          ],
                          // red to yellow
                          tileMode: TileMode
                              .repeated, // repeats the gradient over the canvas
                        ),
                      ),
                      child: ElevatedButton.icon(
                        label: Text(
                          'EHS Report\nتقرير سلامة الافراد',
                        ),
                        style: ElevatedButton.styleFrom(
                          textStyle: TextStyle(
                              fontSize: largeFontSize, fontFamily: 'MyFont'),
                          padding: EdgeInsets.symmetric(
                              horizontal: defaultPadding,
                              vertical: minimumPadding),
                          primary: KelloggColors.cockRed.withOpacity(0.5),
                        ),
                        icon: ClipRRect(
                          borderRadius: BorderRadius.circular(iconImageBorder),
                          child: Container(
                            height: mediumIconSize,
                            width: mediumIconSize,
                            padding: EdgeInsets.all(minimumPadding / 2),
                            child: new Image.asset(
                              'images/safety.png',
                              color: KelloggColors.white,
                            ),
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      ChooseAddOrEditReport(type: EHS_REPORT)));
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
            /////////////////fourth button///////////////////
            Padding(
              padding: const EdgeInsets.all(minimumPadding),
              child: Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(BoxImageBorder),
                  child: ConstrainedBox(
                    constraints: BoxConstraints.tightFor(
                        width: TightBoxWidth, height: LargeBoxHeight),
                    child: Container(
                      decoration: const BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment(0.99, 0.0),
                          // 10% of the width, so there are ten blinds.
                          colors: const <Color>[
                            KelloggColors.grey,
                            KelloggColors.darkBlue
                          ],
                          // red to yellow
                          tileMode: TileMode
                              .repeated, // repeats the gradient over the canvas
                        ),
                      ),
                      child: ElevatedButton.icon(
                        label: Text(
                          'OverWeight Report\n تقرير فرق الوزن',
                        ),
                        style: ElevatedButton.styleFrom(
                          textStyle: TextStyle(
                              fontSize: largeFontSize, fontFamily: 'MyFont'),
                          padding: EdgeInsets.symmetric(
                              horizontal: defaultPadding,
                              vertical: minimumPadding),
                          primary: KelloggColors.cockRed.withOpacity(0.5),
                        ),
                        icon: ClipRRect(
                          borderRadius: BorderRadius.circular(iconImageBorder),
                          child: Container(
                            height: mediumIconSize,
                            width: mediumIconSize,
                            padding: EdgeInsets.all(minimumPadding / 2),
                            child: new Image.asset(
                              'images/overweight.png',
                              color: KelloggColors.white,
                            ),
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ChooseAddOrEditReport(
                                      type: OVERWEIGHT_REPORT)));
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
            /////////////////fifth button///////////////////
            Padding(
              padding: const EdgeInsets.all(minimumPadding),
              child: Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(BoxImageBorder),
                  child: ConstrainedBox(
                    constraints: BoxConstraints.tightFor(
                        width: TightBoxWidth, height: LargeBoxHeight),
                    child: Container(
                      decoration: const BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment(0.99, 0.0),
                          // 10% of the width, so there are ten blinds.
                          colors: const <Color>[
                            KelloggColors.grey,
                            KelloggColors.orange
                          ],
                          // red to yellow
                          tileMode: TileMode
                              .repeated, // repeats the gradient over the canvas
                        ),
                      ),
                      child: ElevatedButton.icon(
                        label: Text(
                          'People Report\n تقرير الاشخاص',
                        ),
                        style: ElevatedButton.styleFrom(
                          textStyle: TextStyle(
                              fontSize: largeFontSize, fontFamily: 'MyFont'),
                          padding: EdgeInsets.symmetric(
                              horizontal: defaultPadding,
                              vertical: minimumPadding),
                          primary: KelloggColors.yellow.withOpacity(0.5),
                        ),
                        icon: ClipRRect(
                          borderRadius: BorderRadius.circular(iconImageBorder),
                          child: Container(
                            height: mediumIconSize,
                            width: mediumIconSize,
                            padding: EdgeInsets.all(minimumPadding / 2),
                            child: new Image.asset(
                              'images/people.png',
                              color: KelloggColors.white,
                            ),
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ChooseAddOrEditReport(
                                      type: PEOPLE_REPORT)));
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
            /////////////////sixth button///////////////////
            Padding(
              padding: const EdgeInsets.all(minimumPadding),
              child: Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(BoxImageBorder),
                  child: ConstrainedBox(
                    constraints: BoxConstraints.tightFor(
                        width: TightBoxWidth, height: LargeBoxHeight),
                    child: Container(
                      decoration: const BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment(0.99, 0.0),
                          // 10% of the width, so there are ten blinds.
                          colors: const <Color>[
                            KelloggColors.grey,
                            KelloggColors.white
                          ],
                          // red to yellow
                          tileMode: TileMode
                              .repeated, // repeats the gradient over the canvas
                        ),
                      ),
                      child: ElevatedButton.icon(
                        label: Text(
                          'NRC Report\n تقرير الموارد الطبيعية',
                        ),
                        style: ElevatedButton.styleFrom(
                          textStyle: TextStyle(
                              fontSize: largeFontSize, fontFamily: 'MyFont'),
                          padding: EdgeInsets.symmetric(
                              horizontal: defaultPadding,
                              vertical: minimumPadding),
                          primary: KelloggColors.darkBlue.withOpacity(0.5),
                        ),
                        icon: ClipRRect(
                          borderRadius: BorderRadius.circular(iconImageBorder),
                          child: Container(
                            height: mediumIconSize,
                            width: mediumIconSize,
                            padding: EdgeInsets.all(minimumPadding / 2),
                            child: new Image.asset(
                              'images/nrc.png',
                              color: KelloggColors.white,
                            ),
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      ChooseAddOrEditReport(type: NRC_REPORT)));
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
            /////////////////////////////////////////////////////////////////////
          ],
        ),
      ),
    );
  }
}
