import 'package:cairo_bisco_app/classes/Credentials.dart';
import 'package:cairo_bisco_app/classes/values/colors.dart';
import 'package:flutter/material.dart';

class deleteOwnerBtn extends StatelessWidget {
  deleteOwnerBtn({required this.email});

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
        Credentials.deleteOwner(context, email);
        Navigator.of(context).pop();
      },
    );
  }
}
