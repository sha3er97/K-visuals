/*
    this screen will have 3 big buttons
    production
    qfs
    ehs
 *********************************/
import 'package:cairo_bisco_app/components/buttons/log_out_btn.dart';
import 'package:cairo_bisco_app/ui/supervisor_screens/supervisor_production_home.dart';
import 'package:flutter/material.dart';
import 'package:cairo_bisco_app/classes/values/colors.dart';
import 'package:cairo_bisco_app/classes/values/constants.dart';

class SupervisorHomePage extends StatefulWidget {
  @override
  _SupervisorHomeState createState() => _SupervisorHomeState();
}

class _SupervisorHomeState extends State<SupervisorHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: KelloggColors.white,
        resizeToAvoidBottomInset: true,
        appBar: new AppBar(
          backgroundColor: KelloggColors.white.withOpacity(0),
          shadowColor: KelloggColors.white.withOpacity(0),
          leading: LogOutBtn(),
          // leading: MyBackButton(),
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
                        borderRadius: BorderRadius.circular(15.0),
                        //or 15.0
                        child: ConstrainedBox(
                            constraints: BoxConstraints.tightFor(
                                width: 300, height: 200),
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
                                        fontSize: largeFontSize,
                                        fontFamily: 'Poppins'),
                                    primary:
                                        KelloggColors.yellow.withOpacity(0.5),
                                  ),
                                  icon: ClipRRect(
                                    borderRadius:
                                        BorderRadius.circular(10.0), //or 15.0
                                    child: Container(
                                      height: 50.0,
                                      width: 50.0,
                                      padding:
                                          EdgeInsets.all(minimumPadding / 2),
                                      child: new Image.asset(
                                        'images/factory.png',
                                      ),
                                    ),
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                SupervisorHomeProductionPage()));
                                  },
                                ))))),
              ),
              /////////////////second button///////////////////
              Padding(
                padding: const EdgeInsets.all(minimumPadding),
                child: Center(
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(15.0),
                        //or 15.0
                        child: ConstrainedBox(
                            constraints: BoxConstraints.tightFor(
                                width: 300, height: 200),
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
                                        fontSize: largeFontSize,
                                        fontFamily: 'Poppins'),
                                    primary:
                                        KelloggColors.green.withOpacity(0.5),
                                  ),
                                  icon: ClipRRect(
                                    borderRadius:
                                        BorderRadius.circular(10.0), //or 15.0
                                    child: Container(
                                      height: 50.0,
                                      width: 50.0,
                                      padding:
                                          EdgeInsets.all(minimumPadding / 2),
                                      child: new Image.asset(
                                        'images/quality.png',
                                        color: KelloggColors.white,
                                      ),
                                    ),
                                  ),
                                  onPressed: () {
                                    // Navigator.push(
                                    //     context,
                                    //     MaterialPageRoute(
                                    //         builder: (context) => WaferLines())
                                    // );
                                  },
                                ))))),
              ),
              /////////////////third button///////////////////
              Padding(
                padding: const EdgeInsets.all(minimumPadding),
                child: Center(
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(15.0),
                        //or 15.0
                        child: ConstrainedBox(
                            constraints: BoxConstraints.tightFor(
                                width: 300, height: 200),
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
                                        fontSize: largeFontSize,
                                        fontFamily: 'Poppins'),
                                    padding: EdgeInsets.symmetric(
                                        horizontal: defaultPadding,
                                        vertical: minimumPadding),
                                    primary:
                                        KelloggColors.cockRed.withOpacity(0.5),
                                  ),
                                  icon: ClipRRect(
                                    borderRadius:
                                        BorderRadius.circular(10.0), //or 15.0
                                    child: Container(
                                      height: 50.0,
                                      width: 50.0,
                                      padding:
                                          EdgeInsets.all(minimumPadding / 2),
                                      child: new Image.asset(
                                        'images/safety.png',
                                        color: KelloggColors.white,
                                      ),
                                    ),
                                  ),
                                  onPressed: () {
                                    // Navigator.push(
                                    //     context,
                                    //     MaterialPageRoute(
                                    //         builder: (context) =>
                                    //             MaamoulLines())
                                    // );
                                  },
                                ))))),
              ),
            ])));
  }
}
