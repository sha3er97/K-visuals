/*
    this screen will have 3 big buttons
    biscuits
    wafer
    maamoul
 *********************************/
import 'package:cairo_bisco_app/components/buttons/back_btn.dart';
import 'package:cairo_bisco_app/components/values/colors.dart';
import 'package:cairo_bisco_app/components/values/constants.dart';
import 'package:cairo_bisco_app/ui/production_screens/biscuits_lines.dart';
import 'package:cairo_bisco_app/ui/production_screens/maamoul_lines.dart';
import 'package:cairo_bisco_app/ui/production_screens/wafer_lines.dart';
import 'package:flutter/material.dart';

class HomeProductionPage extends StatefulWidget {
  @override
  _HomeProductionState createState() => _HomeProductionState();
}

class _HomeProductionState extends State<HomeProductionPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: KelloggColors.white,
        resizeToAvoidBottomInset: true,
        appBar: new AppBar(
          backgroundColor: KelloggColors.white.withOpacity(0),
          shadowColor: KelloggColors.white.withOpacity(0),
          leading: MyBackButton(),
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
                          borderRadius: BorderRadius.circular(15.0),
                          //or 15.0
                          child: ConstrainedBox(
                              constraints: BoxConstraints.tightFor(
                                  width: 300, height: 200),
                              child: ElevatedButton.icon(
                                label: Text('Biscuits'),
                                style: ElevatedButton.styleFrom(
                                  textStyle: TextStyle(
                                      fontSize: largeButtonFont,
                                      fontFamily: 'Poppins'),
                                  primary: KelloggColors.yellow,
                                ),
                                icon: ClipRRect(
                                  borderRadius:
                                      BorderRadius.circular(10.0), //or 15.0
                                  child: Container(
                                    height: 50.0,
                                    width: 50.0,
                                    padding: EdgeInsets.all(minimumPadding / 2),
                                    child: new Image.asset(
                                      'images/colored_biscuit.png',
                                    ),
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              BiscuitLines()));
                                },
                              ))))),
              Padding(
                  padding: const EdgeInsets.all(minimumPadding),
                  child: Center(
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(15.0),
                          //or 15.0
                          child: ConstrainedBox(
                              constraints: BoxConstraints.tightFor(
                                  width: 300, height: 200),
                              child: ElevatedButton.icon(
                                label: Text('Wafer'),
                                style: ElevatedButton.styleFrom(
                                  textStyle: TextStyle(
                                      fontSize: largeButtonFont,
                                      fontFamily: 'Poppins'),
                                  primary: KelloggColors.green,
                                ),
                                icon: ClipRRect(
                                  borderRadius:
                                      BorderRadius.circular(10.0), //or 15.0
                                  child: Container(
                                    height: 50.0,
                                    width: 50.0,
                                    padding: EdgeInsets.all(minimumPadding / 2),
                                    child: new Image.asset(
                                      'images/colored_wafer.png',
                                    ),
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => WaferLines()));
                                },
                              ))))),
              Padding(
                  padding: const EdgeInsets.all(minimumPadding),
                  child: Center(
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(15.0),
                          //or 15.0
                          child: ConstrainedBox(
                              constraints: BoxConstraints.tightFor(
                                  width: 300, height: 200),
                              child: ElevatedButton.icon(
                                label: Text('Maamoul'),
                                style: ElevatedButton.styleFrom(
                                  textStyle: TextStyle(
                                      fontSize: largeButtonFont,
                                      fontFamily: 'Poppins'),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: defaultPadding,
                                      vertical: minimumPadding),
                                  primary: KelloggColors.cockRed,
                                ),
                                icon: ClipRRect(
                                  borderRadius:
                                      BorderRadius.circular(10.0), //or 15.0
                                  child: Container(
                                    height: 50.0,
                                    width: 50.0,
                                    padding: EdgeInsets.all(minimumPadding / 2),
                                    child: new Image.asset(
                                      'images/colored_maamoul.png',
                                    ),
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              MaamoulLines()));
                                },
                              ))))),
            ])));
  }
}
