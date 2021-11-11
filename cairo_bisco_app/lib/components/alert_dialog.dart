import 'package:cairo_bisco_app/classes/values/constants.dart';
import 'package:flutter/material.dart';

import 'buttons/cancel_dialog_btn.dart';
import 'buttons/delete_admin_btn.dart';
import 'buttons/get_update_btn.dart';

showExcelAlertDialog(BuildContext context, bool success, String fileName) {
  // Create AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Excel Reports"),
    content:
        Text(success ? excelSuccessMsg + " in  $fileName" : excelFailureMsg),
    actions: [
      cancelDialogBtn(text: "OK"),
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
  // Create AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Admin Edit"),
    content:
        Text("Are you sure you want to remove \' $email \' from admins list"),
    actions: [
      cancelDialogBtn(text: "Cancel"),
      deleteAdminBtn(email: email),
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

showForceUpdateAlertDialog(BuildContext context) {
  // Create AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("New Update Available"),
    content:
        Text("your version is outdated please update to the latest version"),
    actions: [
      getUpdateButton(),
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    barrierDismissible: false, //can't be dismissed by touching out of it
    builder: (BuildContext context) {
      return alert;
    },
  );
}
