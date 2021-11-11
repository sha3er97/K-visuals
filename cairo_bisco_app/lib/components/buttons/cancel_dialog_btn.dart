import 'package:cairo_bisco_app/classes/values/colors.dart';
import 'package:flutter/material.dart';

class cancelDialogBtn extends StatelessWidget {
  cancelDialogBtn({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      child: Text(
        text,
        style: TextStyle(
          color: KelloggColors.darkBlue,
          fontWeight: FontWeight.bold,
        ),
      ),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
  }
}
