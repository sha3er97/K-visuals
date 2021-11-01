import 'package:cairo_bisco_app/classes/Credentials.dart';
import 'package:cairo_bisco_app/classes/utility_funcs/text_utilities.dart';
import 'package:cairo_bisco_app/classes/values/TextStandards.dart';
import 'package:cairo_bisco_app/classes/values/colors.dart';
import 'package:cairo_bisco_app/classes/values/constants.dart';
import 'package:cairo_bisco_app/components/buttons/back_btn.dart';
import 'package:cairo_bisco_app/components/buttons/rounded_btn.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class ReviewAdminEmails extends StatefulWidget {
  @override
  _ReviewAdminEmailsState createState() => _ReviewAdminEmailsState();
}

class _ReviewAdminEmailsState extends State<ReviewAdminEmails> {
  bool _valid_email_validate = false;
  bool showSpinner = false;

  String email = "";

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: KelloggColors.white,
          resizeToAvoidBottomInset: true,
          appBar: new AppBar(
            backgroundColor: KelloggColors.white.withOpacity(0),
            shadowColor: KelloggColors.white.withOpacity(0),
            leading: MyBackButton(
              admin: true,
            ),
            title: Text(
              "Edit Admins",
              style: TextStyle(
                  color: KelloggColors.darkBlue,
                  fontWeight: FontWeight.w300,
                  fontSize: largeFontSize),
            ),
          ),
          body: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: defaultPadding),
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: minimumPadding),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            adminHeading('Email :'),
                            SizedBox(width: minimumPadding),
                            Expanded(
                              child: TextFormField(
                                // initialValue:
                                // Plans.targetOverWeightAbove.toString(),
                                style: (TextStyle(
                                    color: KelloggColors.darkBlue,
                                    fontWeight: FontWeight.w400)),
                                keyboardType: TextInputType.emailAddress,
                                cursorColor: Colors.white,
                                obscureText: false,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: KelloggColors.darkBlue,
                                        width: textFieldBorderRadius),
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(textFieldRadius)),
                                  ),
                                  errorText: _valid_email_validate
                                      ? missingValueErrorText
                                      : null,
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: KelloggColors.yellow,
                                        width: textFieldFocusedBorderRadius),
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(textFieldRadius)),
                                  ),
                                ),
                                onChanged: (value) {
                                  email = value;
                                },
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: defaultPadding),
                        ///////////////////////////////////////////////////////////////
                        Padding(
                          padding: const EdgeInsets.all(minimumPadding),
                          child: Center(
                            child: RoundedButton(
                              btnText: 'Add Email',
                              color: KelloggColors.darkBlue,
                              onPressed: () async {
                                setState(() {
                                  showSpinner = true;
                                  _valid_email_validate = emptyField(email);
                                });
                                try {
                                  if (!_valid_email_validate) {
                                    Credentials.addAdmin(
                                      context,
                                      email.trim().toLowerCase(),
                                    );
                                  } else {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                      content: Text(submissionErrorText),
                                    ));
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
                        //////////////////////////////////////////////////////////////////
                        sectionWithDivider('Existing Emails'),
                        /////////////////////////////////////////////////////////////////////////////////
                        ListView.builder(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            physics: ClampingScrollPhysics(),
                            padding: const EdgeInsets.all(minimumPadding),
                            itemCount: Credentials.admin_emails.length,
                            itemBuilder: (BuildContext context, int index) {
                              return ListTile(
                                title: adminHeading(
                                    Credentials.admin_emails[index]),
                              );
                            }),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
