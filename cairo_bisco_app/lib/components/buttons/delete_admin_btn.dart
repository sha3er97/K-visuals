import 'package:cairo_bisco_app/classes/Credentials.dart';
import 'package:cairo_bisco_app/classes/values/colors.dart';
import 'package:flutter/material.dart';

class deleteAdminBtn extends StatelessWidget {
  deleteAdminBtn({required this.email});

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
        Credentials.deleteAdmin(context, email);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Email Deleted"),
        ));
        Navigator.of(context).pop();
      },
    );
  }
}
