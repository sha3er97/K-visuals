import 'package:cairo_bisco_app/classes/Credentials.dart';
import 'package:cairo_bisco_app/classes/utility_funcs/login_utility.dart';
import 'package:cairo_bisco_app/classes/utility_funcs/text_utilities.dart';
import 'package:cairo_bisco_app/classes/values/colors.dart';
import 'package:cairo_bisco_app/classes/values/constants.dart';
import 'package:cairo_bisco_app/components/buttons/rounded_btn.dart';
import 'package:cairo_bisco_app/ui/floor_screens/floor_choose_area.dart';
import 'package:cairo_bisco_app/ui/homePage.dart';
import 'package:cairo_bisco_app/ui/login_screens/create_account.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import '../../components/special_components/wave_widget.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool showSpinner = false;

  final _auth = FirebaseAuth.instance;
  String email = "";
  String password = "";
  bool _email_validate = false;
  bool _password_validate = false;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final bool keyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;
    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      child: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          backgroundColor: KelloggColors.white,
          body: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Center(
                //   child: SizedBox(
                //     width: TightBoxWidth,
                //     height: logoHeight,
                //     child: new Image.asset(
                //       'images/logo.png',
                //       height: logoHeight,
                //       fit: BoxFit.scaleDown,
                //     ),
                //     // child: SvgPicture.asset('images/login.svg')
                //   ),
                // ),
                // Padding(
                //   padding: const EdgeInsets.fromLTRB(20, 15, 20, 8),
                //   child: subHeading('Login'),
                // ),
                Stack(
                  children: <Widget>[
                    Container(
                      height: size.height - 400,
                      color: KelloggColors.darkRed,
                    ),
                    AnimatedPositioned(
                      duration: Duration(milliseconds: 500),
                      curve: Curves.easeOutQuad,
                      top: keyboardOpen ? -size.height / 3.7 : 0.0,
                      child: WaveWidget(
                        size: size,
                        yOffset: size.height / 3.0,
                        color: KelloggColors.white,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 100.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            'Login',
                            style: TextStyle(
                              color: KelloggColors.white,
                              fontSize: titleFontSize,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: defaultPadding),
                  child: Text(
                    'Please sign in to continue.',
                    style: TextStyle(
                        color: KelloggColors.grey,
                        fontWeight: FontWeight.w400,
                        fontSize: mediumFontSize),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: defaultPadding),
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: minimumPadding),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'E-mail',
                          style: TextStyle(
                              fontWeight: FontWeight.w300,
                              fontSize: mediumFontSize,
                              color: KelloggColors.darkRed),
                        ),
                        SizedBox(
                          height: minimumPadding,
                        ),
                        TextField(
                          style: (TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w400)),
                          keyboardType: TextInputType.emailAddress,
                          cursorColor: Colors.white,
                          obscureText: false,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            errorText: _email_validate
                                ? 'Email Can\'t Be Empty'
                                : null,
                            fillColor: KelloggColors.darkRed,
                            filled: true,
                            prefixIcon: Image.asset('images/email.png'),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: KelloggColors.yellow,
                                  width: borderWidth),
                              borderRadius: BorderRadius.all(
                                  Radius.circular(defaultPadding)),
                            ),
                          ),
                          onChanged: (value) {
                            email = value;
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(
                      vertical: minimumPadding, horizontal: defaultPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Password',
                        style: TextStyle(
                            fontWeight: FontWeight.w300,
                            fontSize: mediumFontSize,
                            color: KelloggColors.darkRed),
                      ),
                      SizedBox(
                        height: minimumPadding,
                      ),
                      TextFormField(
                        style: (TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w400)),
                        obscureText: true,
                        cursorColor: Colors.white,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          errorText: _password_validate
                              ? 'Password Can\'t Be Empty'
                              : null,
                          fillColor: KelloggColors.darkRed,
                          filled: true,
                          prefixIcon: Image.asset('images/padlock.png'),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: KelloggColors.yellow,
                                width: borderWidth),
                            borderRadius: BorderRadius.all(
                                Radius.circular(defaultPadding)),
                          ),
                        ),
                        onChanged: (value) {
                          password = value;
                        },
                        onFieldSubmitted: (value) async {
                          await loginPressed();
                        },
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(minimumPadding),
                  child: Center(
                    child: RoundedButton(
                      btnText: 'LOGIN',
                      color: KelloggColors.darkRed,
                      onPressed: () async {
                        await loginPressed();
                      },
                    ),
                  ),
                ),
                SizedBox(
                  height: defaultPadding,
                ),
                Center(
                  child: Text(
                    'Version : ' + versionNum,
                    style: TextStyle(color: KelloggColors.grey),
                  ),
                ),
                SizedBox(
                  height: pushAwayPadding,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Don\'t have an account?',
                      style: TextStyle(
                          color: KelloggColors.grey,
                          fontWeight: FontWeight.w400),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CreateAccount()));
                      },
                      child: Text('Sign up',
                          style: TextStyle(
                            color: KelloggColors.green,
                          )),
                    )
                  ],
                ),
                SizedBox(
                  height: defaultPadding,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Forgot Password?',
                      style: TextStyle(
                          color: KelloggColors.grey,
                          fontWeight: FontWeight.w400),
                    ),
                    TextButton(
                      onPressed: () async {
                        setState(() {
                          showSpinner = true;
                          _email_validate = emptyField(email);
                        });
                        if (!_email_validate) {
                          await _auth.sendPasswordResetEmail(email: email);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(
                                "Write the email you want to reset its password"),
                          ));
                        }
                        setState(() {
                          showSpinner = false;
                        });
                      },
                      child: Text('Reset',
                          style: TextStyle(
                            color: KelloggColors.darkRed,
                          )),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> loginPressed() async {
    setState(() {
      showSpinner = true;
      _email_validate = emptyField(email);
      _password_validate = emptyField(password);
    });
    try {
      if (isScreen(email, password)) {
        Navigator.push(
            context,
            MaterialPageRoute(
                // builder: (context) => SuccessScreen()
                builder: (context) => FloorChooseArea()));
      } else {
        //normal user
        await _auth.signInWithEmailAndPassword(
            email: email.trim(), password: password.trim());
        Credentials.setCredentialsConfig(email.toString());

        Navigator.push(
            context,
            MaterialPageRoute(
                // builder: (context) => SuccessScreen()
                builder: (context) => HomePage()));
      }
      setState(() {
        showSpinner = false;
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("No user found for that email"),
        ));
      } else if (e.code == 'wrong-password') {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Wrong password provided for that user"),
        ));
      } else if (e.code == 'invalid-email') {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Invalid Email"),
        ));
      }
      setState(() {
        showSpinner = false;
      });
    } catch (e) {
      print(e);
    }
  }
}
