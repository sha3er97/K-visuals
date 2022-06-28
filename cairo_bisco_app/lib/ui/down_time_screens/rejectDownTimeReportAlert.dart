import 'package:cairo_bisco_app/classes/values/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../classes/DownTimeReport.dart';
import '../../classes/values/colors.dart';
import '../../components/buttons/back_btn.dart';
import '../../components/buttons/cancel_dialog_btn.dart';

class RejectReportAlert extends StatefulWidget {
  RejectReportAlert({
    required this.reportID,
  });

  final String reportID;

  @override
  RejectReportAlertState createState() => new RejectReportAlertState(
        reportID: reportID,
      );
}

class RejectReportAlertState extends State<RejectReportAlert> {
  RejectReportAlertState({
    required this.reportID,
  });

  final String reportID;
  String rejectReason = "";

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        backgroundColor: KelloggColors.white.withOpacity(0),
        shadowColor: KelloggColors.white.withOpacity(0),
        leading: MyBackButton(
          color: KelloggColors.darkRed,
        ),
        title: Text(
          "Reject Report",
          style: TextStyle(
              color: KelloggColors.darkRed,
              fontWeight: FontWeight.w300,
              fontSize: largeFontSize),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
            child: Container(
              margin: EdgeInsets.symmetric(vertical: minimumPadding),
              child: Text(
                "Add a reason why you rejected this report",
                style: TextStyle(
                  color: KelloggColors.darkRed,
                  fontSize: aboveMediumFontSize,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: mediumPadding),
            child: Container(
              margin: EdgeInsets.symmetric(vertical: minimumPadding),
              child: Column(
                children: [
                  TextField(
                    style: TextStyle(
                        color: KelloggColors.darkRed,
                        fontWeight: FontWeight.w400),
                    keyboardType: TextInputType.multiline,
                    cursorColor: Colors.white,
                    obscureText: false,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: KelloggColors.darkRed,
                            width: textFieldBorderRadius),
                        borderRadius:
                            BorderRadius.all(Radius.circular(textFieldRadius)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: KelloggColors.yellow,
                            width: textFieldFocusedBorderRadius),
                        borderRadius:
                            BorderRadius.all(Radius.circular(textFieldRadius)),
                      ),
                    ),
                    onChanged: (value) {
                      rejectReason = value;
                    },
                  ),
                ],
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              cancelDialogBtn(text: "Cancel"),
              new TextButton(
                onPressed: () {
                  DownTimeReport.rejectReport(context, reportID, rejectReason);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text("Report Rejected"),
                  ));
                  Navigator.of(context).pop();
                },
                child: Text(
                  "Confirm",
                  style: TextStyle(
                    color: KelloggColors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
