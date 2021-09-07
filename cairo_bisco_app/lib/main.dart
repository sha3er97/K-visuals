import 'package:cairo_bisco_app/classes/values/colors.dart';
import 'package:cairo_bisco_app/ui/error_success_screens/general_error.dart';
import 'package:cairo_bisco_app/ui/splash.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    systemNavigationBarColor: KelloggColors.white, // navigation bar color
    statusBarColor: KelloggColors.grey, // status bar color
  ));
  WidgetsFlutterBinding.ensureInitialized();
  return runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'K Visuals',
      theme: ThemeData(
        primarySwatch: Colors.red,
        // primaryColor: KelloggColors.darkRed,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'Poppins',
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
            return SplashScreen();
          }
          // Otherwise, show something whilst waiting for initialization to complete
          return GeneralErrorScreen();
        },
      ),
    );
  }
}
