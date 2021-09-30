import 'dart:async';
import 'package:cairo_bisco_app/classes/Credentials.dart';
import 'package:cairo_bisco_app/classes/Plans.dart';
import 'package:cairo_bisco_app/classes/SKU.dart';
import 'package:cairo_bisco_app/classes/values/colors.dart';
import 'package:cairo_bisco_app/ui/login_screens/login.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    Timer(
        Duration(seconds: 3),
        () => {
              Credentials.getCredentials(),
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (BuildContext context) => Login()))
            });
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: KelloggColors.white,
      body: SafeArea(
        child: Center(
          child: new Image.asset(
            'images/kws_logo.png',
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
