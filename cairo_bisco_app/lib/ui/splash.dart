import 'package:cairo_bisco_app/classes/values/colors.dart';
import 'package:flutter/material.dart';

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
    // FirebaseAuth.instance.userChanges().listen(
    //   (User? user) {
    //     if (Credentials.lastVersionCode > versionCode) {
    //       //play store has a newer update
    //       showForceUpdateAlertDialog(context);
    //     } else {
    //       Timer(
    //         Duration(seconds: splashScreenDuration),
    //         () => {
    //           if (user == null)
    //             {
    //               print('User is currently signed out!'),
    //               Navigator.push(
    //                   context,
    //                   MaterialPageRoute(
    //                       builder: (BuildContext context) => Login())),
    //             }
    //           else
    //             {
    //               print('User is signed in!'),
    //               if (Credentials.isAdmin(user.email.toString()))
    //                 {
    //                   Credentials.isUserAdmin = true,
    //                 }
    //               else
    //                 {
    //                   Credentials.isUserAdmin = false,
    //                 },
    //               if (Credentials.isOwner(user.email.toString()))
    //                 {
    //                   Credentials.isUserOwner = true,
    //                 }
    //               else
    //                 {
    //                   Credentials.isUserOwner = false,
    //                 },
    //               Credentials.userEmail = user.email.toString(),
    //               Navigator.push(
    //                   context,
    //                   MaterialPageRoute(
    //                       builder: (BuildContext context) => HomePage())),
    //             }
    //         },
    //       );
    //     }
    //   },
    // );

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
