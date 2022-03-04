import 'package:cairo_bisco_app/classes/SKU.dart';
import 'package:cairo_bisco_app/classes/values/colors.dart';
import 'package:flutter/material.dart';

class deleteMachineDetailBtn extends StatelessWidget {
  deleteMachineDetailBtn({
    required this.refNum,
    required this.skuName,
    required this.detailId,
  });

  final int refNum;
  final String skuName, detailId;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      child: Text(
        "Delete",
        style: TextStyle(
          color: KelloggColors.cockRed,
          fontWeight: FontWeight.bold,
        ),
      ),
      onPressed: () {
        SKU.deleteMachineDetail(context, refNum, skuName, detailId);
        Navigator.of(context).pop();
      },
    );
  }
}
