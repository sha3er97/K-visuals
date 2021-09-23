import 'package:cairo_bisco_app/classes/values/colors.dart';
import 'package:cairo_bisco_app/classes/values/constants.dart';
import 'package:flutter/material.dart';

class AdminButton extends StatelessWidget {
  AdminButton({
    required this.gradientColor1,
    required this.gradientColor2,
    required this.mainColor,
    required this.title,
    required this.param_onPressed,
    required this.btn_icon,
  });

  final Color gradientColor1;
  final Color gradientColor2;
  final Color mainColor;
  final String title;
  final VoidCallback param_onPressed;
  final IconData btn_icon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(minimumPadding),
      child: Center(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(BoxImageBorder),
          child: ConstrainedBox(
            constraints: BoxConstraints.tightFor(
                width: TightBoxWidth, height: regularBoxHeight),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment(0.99, 0.0),
                  // 10% of the width, so there are ten blinds.
                  colors: [gradientColor1, gradientColor2],
                  // red to yellow
                  tileMode:
                      TileMode.repeated, // repeats the gradient over the canvas
                ),
              ),
              child: ElevatedButton.icon(
                label: Text(title),
                style: ElevatedButton.styleFrom(
                  textStyle:
                      TextStyle(fontSize: largeFontSize, fontFamily: 'MyFont'),
                  padding: EdgeInsets.symmetric(
                      horizontal: defaultPadding, vertical: minimumPadding),
                  primary: mainColor,
                ),
                icon: Icon(
                  btn_icon,
                  color: KelloggColors.white,
                  size: smallIconSize,
                ),
                onPressed: param_onPressed,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
