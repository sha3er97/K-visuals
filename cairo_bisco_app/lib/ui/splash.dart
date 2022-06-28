import 'package:cairo_bisco_app/classes/values/TextStandards.dart';
import 'package:cairo_bisco_app/classes/values/colors.dart';
import 'package:cairo_bisco_app/classes/values/constants.dart';
import 'package:flutter/material.dart';

import 'error_success_screens/loading_screen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: KelloggColors.white,
      // body: SafeArea(
      //   child: Center(
      //     child: new Image.asset(
      //       'images/kws_logo.png',
      //       fit: BoxFit.cover,
      //     ),
      //   ),
      // ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          subHeading('Welcome'),
          SizedBox(height: defaultPadding),
          ColorLoader(),
        ],
      ),
    );
  }
}
