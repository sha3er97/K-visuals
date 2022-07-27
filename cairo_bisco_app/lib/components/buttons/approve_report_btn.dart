import 'package:cairo_bisco_app/classes/DownTimeReport.dart';
import 'package:cairo_bisco_app/classes/values/colors.dart';
import 'package:flutter/material.dart';

class approveReportBtn extends StatelessWidget {
  approveReportBtn({required this.reportID});

  final String reportID;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      child: Text(
        "Approve",
        style: TextStyle(
          color: KelloggColors.green,
          fontWeight: FontWeight.bold,
        ),
      ),
      onPressed: () {
        DownTimeReport.approveReport(context, reportID);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Report Approved"),
        ));
        Navigator.of(context).pop();
      },
    );
  }
}
