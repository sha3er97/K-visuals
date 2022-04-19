import 'package:cairo_bisco_app/classes/Credentials.dart';
import 'package:cairo_bisco_app/classes/values/colors.dart';
import 'package:flutter/material.dart';

class deleteKwsBtn extends StatelessWidget {
  deleteKwsBtn({required this.email});

  final String email;

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
        Credentials.deleteKws(context, email);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Email Deleted"),
        ));
        Navigator.of(context).pop();
      },
    );
  }
}
