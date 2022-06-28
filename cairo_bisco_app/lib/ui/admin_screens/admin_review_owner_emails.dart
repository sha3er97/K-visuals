import 'package:cairo_bisco_app/classes/Credentials.dart';
import 'package:cairo_bisco_app/classes/utility_funcs/text_utilities.dart';
import 'package:cairo_bisco_app/classes/values/TextStandards.dart';
import 'package:cairo_bisco_app/classes/values/colors.dart';
import 'package:cairo_bisco_app/classes/values/constants.dart';
import 'package:cairo_bisco_app/components/alert_dialog.dart';
import 'package:cairo_bisco_app/components/buttons/back_btn.dart';
import 'package:cairo_bisco_app/components/buttons/rounded_btn.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class ReviewOwnerEmails extends StatefulWidget {
  @override
  _ReviewOwnerEmailsState createState() => _ReviewOwnerEmailsState();
}

class _ReviewOwnerEmailsState extends State<ReviewOwnerEmails> {
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
              color: KelloggColors.darkBlue,
            ),
            title: Text(
              "Edit Owners",
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
                                    Credentials.addOwner(
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
                            itemCount: Credentials.owner_emails.length,
                            itemBuilder: (BuildContext context, int index) {
                              return ListTile(
                                title: adminHeading(
                                    Credentials.owner_emails[index]),
                                leading: IconButton(
                                  icon: const Icon(Icons.close),
                                  color: KelloggColors.cockRed,
                                  onPressed: () {
                                    confirmDeleteOwnerAlertDialog(context,
                                        Credentials.owner_emails[index]);
                                  },
                                ),
                                // leading: deleteBtn(
                                //   email: Credentials.admin_emails[index],
                                // ),
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
