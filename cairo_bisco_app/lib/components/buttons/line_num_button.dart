import 'package:cairo_bisco_app/classes/values/constants.dart';
import 'package:cairo_bisco_app/ui/floor_screens/floor_dashboard.dart';
import 'package:flutter/material.dart';

class LineNumButton extends StatelessWidget {
  LineNumButton(
      {required this.gradientColor1,
      required this.gradientColor2,
      required this.mainColor,
      required this.type,
      required this.lineNum});

  final Color gradientColor1;
  final Color gradientColor2;
  final Color mainColor;
  final String type;
  final int lineNum;

  @override
  Widget build(BuildContext context) {
    final boxHeight = 150.0;

    return Padding(
      padding: const EdgeInsets.all(minimumPadding),
      child: Center(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15.0),
          //or 15.0
          child: ConstrainedBox(
            constraints: BoxConstraints.tightFor(width: 300, height: boxHeight),
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
              child: ElevatedButton(
                child: Text(
                  lineNum == -1 ? 'Total' : 'Line $lineNum',
                ),
                style: ElevatedButton.styleFrom(
                  textStyle:
                      TextStyle(fontSize: largeFontSize, fontFamily: 'MyFont'),
                  padding: EdgeInsets.symmetric(
                      horizontal: defaultPadding, vertical: minimumPadding),
                  primary: mainColor,
                ),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => FloorDashBoard(
                                type: type,
                                lineNum: lineNum,
                              )));
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
