import 'package:cairo_bisco_app/classes/Credentials.dart';
import 'package:cairo_bisco_app/classes/utility_funcs/text_utilities.dart';
import 'package:cairo_bisco_app/classes/values/colors.dart';
import 'package:cairo_bisco_app/classes/values/constants.dart';
import 'package:cairo_bisco_app/components/buttons/back_btn.dart';
import 'package:cairo_bisco_app/components/buttons/rounded_btn.dart';
import 'package:cairo_bisco_app/ui/homePage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import '../../components/special_components/wave_widget.dart';

class CreateAccount extends StatefulWidget {
  @override
  _CreateAccountState createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
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
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: KelloggColors.white,
        appBar: new AppBar(
          backgroundColor: KelloggColors.darkRed,
          shadowColor: KelloggColors.white.withOpacity(0),
          leading: MyBackButton(
            color: KelloggColors.white,
          ),
        ),
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
              //   child: subHeading('Create Account'),
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
                          'Register',
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
                padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
                child: Text(
                  'Please fill the input below.',
                  style: TextStyle(
                      color: KelloggColors.grey,
                      fontWeight: FontWeight.w400,
                      fontSize: mediumFontSize),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
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
                            color: Colors.white, fontWeight: FontWeight.w400)),
                        keyboardType: TextInputType.emailAddress,
                        cursorColor: Colors.white,
                        obscureText: false,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          errorText:
                              _email_validate ? 'Email Can\'t Be Empty' : null,
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
                              color: KelloggColors.yellow, width: borderWidth),
                          borderRadius:
                              BorderRadius.all(Radius.circular(defaultPadding)),
                        ),
                      ),
                      onChanged: (value) {
                        password = value;
                      },
                      onFieldSubmitted: (value) async {
                        await signUpPressed();
                      },
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(minimumPadding),
                child: Center(
                  child: RoundedButton(
                    btnText: 'SIGN UP',
                    color: KelloggColors.darkRed,
                    onPressed: () async {
                      await signUpPressed();
                    },
                  ),
                ),
              ),
              SizedBox(
                height: pushAwayPadding,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Already have an account?',
                    style: TextStyle(
                        color: KelloggColors.grey, fontWeight: FontWeight.w400),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      // Navigator.push(context,
                      //     MaterialPageRoute(builder: (context) => Login()));
                    },
                    child: Text('Sign in',
                        style: TextStyle(
                          color: KelloggColors.darkRed,
                        )),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> signUpPressed() async {
    setState(() {
      showSpinner = true;
      _email_validate = emptyField(email);
      _password_validate = emptyField(password);
    });
    try {
      await _auth.createUserWithEmailAndPassword(
          email: email.trim(), password: password.trim());
      Credentials.setCredentialsConfig(email.toString());

      Navigator.push(
          context,
          MaterialPageRoute(
              // builder: (context) => SuccessScreen()
              builder: (context) => HomePage()));

      setState(() {
        showSpinner = false;
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("The password provided is too weak"),
        ));
      } else if (e.code == 'email-already-in-use') {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("The account already exists for that email"),
        ));
      }
      setState(() {
        showSpinner = false;
      });
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Something went wrong"),
      ));
    }
  }
}
