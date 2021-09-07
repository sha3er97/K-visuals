/*
    this screen will have 3 big buttons
    biscuits
    wafer
    maamoul
 *********************************/
import 'package:cairo_bisco_app/components/buttons/log_out_btn.dart';
import 'package:cairo_bisco_app/classes/values/colors.dart';
import 'package:cairo_bisco_app/classes/values/constants.dart';
import 'package:flutter/material.dart';

import 'package:cairo_bisco_app/ui/floor_screens/floor_choose_line.dart';

class FloorChooseArea extends StatefulWidget {
  @override
  _FloorChooseAreaState createState() => _FloorChooseAreaState();
}

class _FloorChooseAreaState extends State<FloorChooseArea> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: KelloggColors.white,
        resizeToAvoidBottomInset: true,
        appBar: new AppBar(
          backgroundColor: KelloggColors.white.withOpacity(0),
          shadowColor: KelloggColors.white.withOpacity(0),
          leading: LogOutBtn(),
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
                                label: Text('Biscuits\nالبسكويت'),
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
                                          builder: (context) => FloorChooseLine(
                                              type: prodType[0])));
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
                                label: Text('Wafer\nالويفر'),
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
                                          builder: (context) => FloorChooseLine(
                                              type: prodType[1])));
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
                                label: Text('Maamoul\nالمعمول'),
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
                                          builder: (context) => FloorChooseLine(
                                              type: prodType[2])));
                                },
                              ))))),
            ])));
  }
}
