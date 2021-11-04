import 'package:cairo_bisco_app/classes/values/constants.dart';
import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  RoundedButton({required this.color, required this.btnText, required this.onPressed});

  final Color color;
  final String btnText;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: defaultPadding),
      child: Material(
        elevation: buttonElevation,
        color: color,
        borderRadius: BorderRadius.circular(roundedButtonCurvature),
        child: MaterialButton(
          onPressed: onPressed,
          minWidth: buttonWidth,
          height: buttonHeight,
          child: Text(
            btnText,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
