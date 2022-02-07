import 'package:cairo_bisco_app/classes/values/colors.dart';
import 'package:cairo_bisco_app/classes/values/constants.dart';
import 'package:cairo_bisco_app/ui/error_success_screens/general_error.dart';
import 'package:cairo_bisco_app/ui/error_success_screens/loading_screen.dart';
import 'package:cairo_bisco_app/ui/homePage.dart';
import 'package:cairo_bisco_app/ui/login_screens/login.dart';
import 'package:cairo_bisco_app/ui/splash.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'classes/Credentials.dart';
import 'classes/Machine.dart';
import 'classes/Plans.dart';
import 'classes/SKU.dart';
import 'components/alert_dialog.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    systemNavigationBarColor: KelloggColors.white, // navigation bar color
    statusBarColor: KelloggColors.grey, // status bar color
  ));
  WidgetsFlutterBinding.ensureInitialized();
  return runApp(MyApp());
}

Future<void> loadRules() async {
  SKU.getAllSku();
  Plans.getPlans();
  Machine.getPackingMachines();
  await Credentials.getCredentials();
  await Credentials.getAdmins();
  await Credentials.getOwners();
}

class MyApp extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: appName,
      theme: ThemeData(
        primarySwatch: Colors.red,
        // primaryColor: KelloggColors.darkRed,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'MyFont',
        scaffoldBackgroundColor: KelloggColors.white,
        // colorScheme: ColorScheme.fromSwatch()
        //     .copyWith(secondary: KelloggColors.darkRed)
      ),
      debugShowCheckedModeBanner: false,
      home: FutureBuilder(
        // Initialize FlutterFire:
        future: _initialization,
        builder: (context, snapshot) {
          // Check for errors
          if (snapshot.hasError) {
            return GeneralErrorScreen();
          }
          // Once complete, show your application
          if (snapshot.connectionState == ConnectionState.done) {
            return FutureBuilder(
              // Initialize FlutterFire:
              future: loadRules(),
              builder: (context, snapshot) {
                // Check for errors
                if (snapshot.hasError) {
                  return GeneralErrorScreen();
                }
                // Once complete, show your application
                if (snapshot.connectionState == ConnectionState.done) {
                  FirebaseAuth.instance.userChanges().listen(
                    (User? user) {
                      if (Credentials.lastVersionCode > versionCode) {
                        //play store has a newer update
                        showForceUpdateAlertDialog(context);
                      } else {
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
                          if (Credentials.isOwner(user.email.toString())) {
                            Credentials.isUserOwner = true;
                          } else {
                            Credentials.isUserOwner = false;
                          }
                          Credentials.userEmail = user.email.toString();
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      HomePage()));
                        }
                      }
                    },
                  );
                  // return SplashScreen();
                }
                // Otherwise, show something whilst waiting for initialization to complete
                return SplashScreen();
              },
            );
            // return SplashScreen();
          }
          // Otherwise, show something whilst waiting for initialization to complete
          return SplashScreen();
        },
      ),
    );
  }
}
