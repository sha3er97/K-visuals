import 'package:cairo_bisco_app/components/special_components/indicator.dart';
import 'package:cairo_bisco_app/classes/values/colors.dart';
import 'package:cairo_bisco_app/classes/values/constants.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class KPI1GoodBadIndicator extends StatelessWidget {
  KPI1GoodBadIndicator({
    Key? key,
    required this.circleColor,
    required this.circleText,
    required this.title,
  }) : super(key: key);
  final Color circleColor;
  final String title, circleText;
  final opacity = 0.99;

  // int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Indicator(
              color: circleColor.withOpacity(opacity),
              text: title,
              isSquare: false,
              size: 16,
              // size: touchedIndex == 0 ? 18 : 16,
              // textColor: touchedIndex == 0 ? Colors.black : Colors.grey,
              textColor: KelloggColors.grey,
            ),
            // Indicator(
            //   color: const Color(0xfff8b250),
            //   text: 'Two',
            //   isSquare: false,
            //   size: touchedIndex == 1 ? 18 : 16,
            //   textColor: touchedIndex == 1 ? Colors.black : Colors.grey,
            // ),
            // Indicator(
            //   color: const Color(0xff845bef),
            //   text: 'Three',
            //   isSquare: false,
            //   size: touchedIndex == 2 ? 18 : 16,
            //   textColor: touchedIndex == 2 ? Colors.black : Colors.grey,
            // ),
            // Indicator(
            //   color: const Color(0xff13d38e),
            //   text: 'Four',
            //   isSquare: false,
            //   size: touchedIndex == 3 ? 18 : 16,
            //   textColor: touchedIndex == 3 ? Colors.black : Colors.grey,
            // ),
          ],
        ),
        SizedBox(
          height: defaultPadding,
        ),
        Expanded(
          child: AspectRatio(
            aspectRatio: 1,
            child: PieChart(
              PieChartData(
                  // pieTouchData:
                  //     PieTouchData(touchCallback: (pieTouchResponse) {
                  //   // setState(() {
                  //   final desiredTouch =
                  //       pieTouchResponse.touchInput is! PointerExitEvent &&
                  //           pieTouchResponse.touchInput is! PointerUpEvent;
                  //   if (desiredTouch &&
                  //       pieTouchResponse.touchedSection != null) {
                  //     touchedIndex = pieTouchResponse
                  //         .touchedSection!.touchedSectionIndex;
                  //   } else {
                  //     touchedIndex = -1;
                  //   }
                  //   // });
                  // }),
                  startDegreeOffset: 180,
                  borderData: FlBorderData(
                    show: false,
                  ),
                  sectionsSpace: 1,
                  centerSpaceRadius: 0,
                  sections: showingSections()),
            ),
          ),
        ),
      ],
    );
  }

  List<PieChartSectionData> showingSections() {
    return List.generate(
      1,
      (i) {
        // final isTouched = i == touchedIndex;
        // final opacity = isTouched ? 1.0 : 0.6;

        switch (i) {
          case 0: //only 1 kpi
            return PieChartSectionData(
              color: circleColor.withOpacity(opacity),
              value: 25,
              title: circleText,
              radius: kpiCircleRadius,
              titleStyle: TextStyle(
                  fontSize: largeButtonFont,
                  fontWeight: FontWeight.bold,
                  color: KelloggColors.white),
              // titlePositionPercentageOffset: 0.55,
              titlePositionPercentageOffset: 0.0,
              // borderSide: isTouched
              //     ? BorderSide(color: KelloggColors.darkRed, width: 6)
              //     : BorderSide(color: circleColor.withOpacity(0)),
            );
          default:
            throw Error();
        }
      },
    );
  }
}
