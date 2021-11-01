import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cairo_bisco_app/classes/values/colors.dart';

class LogOutBtn extends StatelessWidget {
  LogOutBtn({required this.admin});

  final bool admin;

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'logOutButton',
      child: GestureDetector(
        onTap: () async {
          Navigator.pop(context);
        },
        child: Icon(
          Icons.close,
          color: admin ? KelloggColors.darkBlue : KelloggColors.darkRed,
        ),
      ),
    );
  }
}
