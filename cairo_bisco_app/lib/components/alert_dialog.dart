import 'package:cairo_bisco_app/classes/values/colors.dart';
import 'package:cairo_bisco_app/classes/values/constants.dart';
import 'package:flutter/material.dart';

showExcelAlertDialog(BuildContext context, bool success, String fileName) {
  // Create button
  Widget okButton = TextButton(
    child: Text(
      "OK",
      style: TextStyle(
        color: KelloggColors.darkRed,
        fontWeight: FontWeight.bold,
      ),
    ),
    onPressed: () {
      Navigator.of(context).pop();
    },
  );

  // Create AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Excel Reports"),
    content:
        Text(success ? excelSuccessMsg + " in  $fileName" : excelFailureMsg),
    actions: [
      okButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
