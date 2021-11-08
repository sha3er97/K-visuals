import 'dart:async';

import 'package:cairo_bisco_app/classes/Credentials.dart';
import 'package:cairo_bisco_app/classes/Plans.dart';
import 'package:cairo_bisco_app/classes/SKU.dart';
import 'package:cairo_bisco_app/classes/values/colors.dart';
import 'package:cairo_bisco_app/classes/values/constants.dart';
import 'package:cairo_bisco_app/ui/homePage.dart';
import 'package:cairo_bisco_app/ui/login_screens/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<SplashScreen> {
  // User? user;

  @override
  void initState() {
    super.initState();
    Plans.getPlans();
    SKU.getAllSku();
    Credentials.getCredentials();
    Credentials.getAdmins();
    // user = FirebaseAuth.instance.currentUser;

    // if (user != null) {
    //   if (Credentials.isAdmin(user!.email.toString())) {
    //     Credentials.isUserAdmin = true;
    //   }
    // }
  }

  @override
  Widget build(BuildContext context) {
    Timer(
        Duration(seconds: splashScreenDuration),
        () => {
              FirebaseAuth.instance.userChanges().listen((User? user) {
                if (user == null) {
                  print('User is currently signed out!');
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => Login()));
                } else {
                  print('User is signed in!');
                  if (Credentials.isAdmin(user.email.toString())) {
                    Credentials.isUserAdmin = true;
                  } else {
                    Credentials.isUserAdmin = false;
                  }
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => HomePage()));
                }
              }),
              // Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //         builder: (BuildContext context) =>
              //             user == null ? Login() : HomePage()))
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
