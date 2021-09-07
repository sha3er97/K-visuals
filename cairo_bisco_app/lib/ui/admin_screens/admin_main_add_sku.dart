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

class AdminAddSku extends StatelessWidget {
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
                                label: Text('Biscuits\nالبسكويت'),
                                style: ElevatedButton.styleFrom(
                                  textStyle: TextStyle(
                                      fontSize: largeButtonFont,
                                      fontFamily: 'MyFont'),
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
                                          builder: (context) => AddSkuForm(
                                                refNum: 0,
                                              )));
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
                                      fontFamily: 'MyFont'),
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
                                          builder: (context) => AddSkuForm(
                                                refNum: 1,
                                              )));
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
                                      fontFamily: 'MyFont'),
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
                                          builder: (context) => AddSkuForm(
                                                refNum: 2,
                                              )));
                                },
                              ))))),
            ])));
  }
}
