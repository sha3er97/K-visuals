import 'package:cairo_bisco_app/classes/values/constants.dart';
import 'package:flutter/material.dart';

import 'buttons/approve_report_btn.dart';
import 'buttons/cancel_dialog_btn.dart';
import 'buttons/delete_admin_btn.dart';
import 'buttons/delete_cause_btn.dart';
import 'buttons/delete_kws_btn.dart';
import 'buttons/delete_machine_btn.dart';
import 'buttons/delete_machine_detail_btn.dart';
import 'buttons/delete_owner_btn.dart';
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

confirmApproveReport(BuildContext context, String reportID) {
  // Create AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Approve Report"),
    content: Text("Are you sure you want to approve this report"),
    actions: [
      cancelDialogBtn(text: "Cancel"),
      approveReportBtn(reportID: reportID),
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

confirmDeleteCauseAlertDialog(BuildContext context, String type, String cause) {
  // Create AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Root Causes Edit"),
    content:
        Text("Are you sure you want to remove \' $cause \' from causes list"),
    actions: [
      cancelDialogBtn(text: "Cancel"),
      deleteCauseBtn(type: type, cause: cause),
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

confirmDeleteAdminAlertDialog(BuildContext context, String email) {
  // Create AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Admin Edit"),
    content: Text(
        "Are you sure you want to remove \' $email \' from authorized list"),
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

confirmDeleteMachineAlertDialog(BuildContext context, String name) {
  // Create AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Machine Edit"),
    content:
        Text("Are you sure you want to remove \' $name \' from Machines list"),
    actions: [
      cancelDialogBtn(text: "Cancel"),
      deleteMachineBtn(name: name),
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

confirmDeleteMachineDetailAlertDialog(
  BuildContext context,
  int refNum,
  String skuName,
  String detailId,
) {
  // Create AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Machine Detail Edit"),
    content: Text(
        "Are you sure you want to remove this Detail from \' $skuName \' Machine Detail list"),
    actions: [
      cancelDialogBtn(text: "Cancel"),
      deleteMachineDetailBtn(
        refNum: refNum,
        skuName: skuName,
        detailId: detailId,
      ),
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

confirmDeleteOwnerAlertDialog(BuildContext context, String email) {
  // Create AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Owner Edit"),
    content:
        Text("Are you sure you want to remove \' $email \' from owners list"),
    actions: [
      cancelDialogBtn(text: "Cancel"),
      deleteOwnerBtn(email: email),
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

confirmDeleteKwsAlertDialog(BuildContext context, String email) {
  // Create AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Kws User Edit"),
    content: Text(
        "Are you sure you want to remove \' $email \' from Kws Users list"),
    actions: [
      cancelDialogBtn(text: "Cancel"),
      deleteKwsBtn(email: email),
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
