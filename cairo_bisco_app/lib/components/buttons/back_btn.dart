import 'package:flutter/material.dart';
import 'package:cairo_bisco_app/classes/values/colors.dart';

class MyBackButton extends StatelessWidget {
  MyBackButton({required this.color});

  final Color color;

  // final bool admin;

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'backButton',
      child: GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: Icon(
          Icons.arrow_back_ios,
          color:
              color, //admin ? KelloggColors.darkBlue : KelloggColors.darkRed,
        ),
      ),
    );
  }
}
