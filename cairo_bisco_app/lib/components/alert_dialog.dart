import 'package:cairo_bisco_app/classes/Credentials.dart';
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

confirmDeleteAlertDialog(BuildContext context, String email) {
  // Create button
  Widget confirmButton = TextButton(
    child: Text(
      "Delete",
      style: TextStyle(
        color: KelloggColors.cockRed,
        fontWeight: FontWeight.bold,
      ),
    ),
    onPressed: () {
      Credentials.deleteAdmin(context, email);
      Navigator.of(context).pop();
    },
  );
  Widget cancelButton = TextButton(
    child: Text(
      "Cancel",
      style: TextStyle(
        color: KelloggColors.darkBlue,
        fontWeight: FontWeight.bold,
      ),
    ),
    onPressed: () {
      Navigator.of(context).pop();
    },
  );
  // Create AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Admin Edit"),
    content:
        Text("Are you sure you want to remove \' $email \' from admins list"),
    actions: [
      confirmButton,
      cancelButton,
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
