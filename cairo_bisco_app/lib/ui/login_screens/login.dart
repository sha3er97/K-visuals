// import 'package:firebase_auth/firebase_auth.dart';
import 'package:cairo_bisco_app/components/buttons/rounded_btn.dart';
import 'package:cairo_bisco_app/components/utility_funcs/login_utility.dart';
import 'package:cairo_bisco_app/components/values/colors.dart';
import 'package:cairo_bisco_app/components/values/constants.dart';
import 'package:cairo_bisco_app/ui/floor_screens/floor_choose_area.dart';

// import 'package:cairo_bisco_app/ui/create_account/create_account.dart';
import 'package:cairo_bisco_app/ui/homePage.dart';
import 'package:cairo_bisco_app/ui/supervisor_screens/supervisor_home_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

// import 'package:firebase_database/firebase_database.dart';
// import 'package:firebase_core/firebase_core.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool showSpinner = false;

  // final _auth = FirebaseAuth.instance;
  String email = "";
  String password = "";
  bool _email_validate = false;
  bool _password_validate = false;

  @override
  Widget build(BuildContext context) {
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
                Center(
                  child: SizedBox(
                    width: 300,
                    height: 175,
                    child: new Image.asset(
                      'images/logo.png',
                      width: 300.0,
                      height: 175.0,
                      fit: BoxFit.scaleDown,
                    ),
                    // child: SvgPicture.asset('images/login.svg')
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 15, 20, 8),
                  child: Text(
                    'Login',
                    style: TextStyle(
                        color: KelloggColors.darkRed,
                        fontWeight: FontWeight.w600,
                        fontSize: 20),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text(
                    'Please sign in to continue.',
                    style: TextStyle(
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w400,
                        fontSize: 13),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'E-mail',
                          style: TextStyle(
                              fontWeight: FontWeight.w300,
                              fontSize: 13,
                              color: KelloggColors.darkRed),
                        ),
                        SizedBox(
                          height: 10,
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
                                  color: KelloggColors.yellow, width: 2.0),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20.0)),
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
                  margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Password',
                        style: TextStyle(
                            fontWeight: FontWeight.w300,
                            fontSize: 13,
                            color: KelloggColors.darkRed),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextField(
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
                                color: KelloggColors.yellow, width: 2.0),
                            borderRadius:
                                BorderRadius.all(Radius.circular(20.0)),
                          ),
                        ),
                        onChanged: (value) {
                          password = value;
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
                        // Add login code
                        setState(() {
                          showSpinner = true;
                          _email_validate = emptyField(email);
                          _password_validate = emptyField(password);
                        });
                        try {
                          // final user = await _auth.signInWithEmailAndPassword(
                          //     email: email, password: password);
                          if (noEmptyValues(email, password)) {
                            if (isPlt(email, password)) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      // builder: (context) => SuccessScreen()
                                      builder: (context) => HomePage()));
                            } else if (isScreen(email, password)) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      // builder: (context) => SuccessScreen()
                                      builder: (context) => FloorChooseArea()));
                            } else {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                // content: Text("incorrect E-mail : " +
                                //     Credentials.plt_email +
                                //     " or Password: " +
                                //     Credentials.password),
                                content: Text("incorrect E-mail or Password"),
                              ));
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      // builder: (context) => SuccessScreen()
                                      builder: (context) =>
                                          SupervisorHomePage()));
                            }
                          }
                          setState(() {
                            showSpinner = false;
                          });
                        } catch (e) {
                          print(e);
                        }
                      },
                    ),
                  ),
                ),
                ///////////////////// forget password part
                // Center(
                //   child: Text(
                //     'Forgot Password?',
                //     style: TextStyle(color: KelloggColors.darkRed),
                //   ),
                // ),
                // SizedBox(
                //   height: 25,
                // ),
                ///////////////// for sign up
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: [
                //     Text(
                //       'Dont have an account?',
                //       style: TextStyle(
                //           color: Colors.grey[600], fontWeight: FontWeight.w400),
                //     ),
                //     TextButton(
                //       onPressed: () {
                //         Navigator.push(
                //             context,
                //             MaterialPageRoute(
                //                 builder: (context) => CreateAccount()));
                //       },
                //       child: Text('Sign up',
                //           style: TextStyle(
                //             color: KelloggColors.darkRed,
                //           )),
                //     )
                //   ],
                // )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
