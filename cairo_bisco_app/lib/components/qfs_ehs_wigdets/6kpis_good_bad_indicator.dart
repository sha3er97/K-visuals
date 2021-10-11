import 'package:cairo_bisco_app/classes/values/colors.dart';
import 'package:cairo_bisco_app/classes/values/constants.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class KPI6GoodBadIndicator extends StatelessWidget {
  KPI6GoodBadIndicator({
    Key? key,
    required this.color1,
    required this.color2,
    required this.color3,
    required this.color4,
    required this.color5,
    required this.color6,
    required this.title1,
    required this.title2,
    required this.title3,
    required this.title4,
    required this.title5,
    required this.title6,
    required this.isScreenOnly,
  }) : super(key: key);
  final Color color1, color2, color3, color4, color5, color6;
  final String title1, title2, title3, title4, title5, title6;
  final opacity = 1.0;
  final bool isScreenOnly;

  // int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: isScreenOnly ? 2.0 : 1.05,
      child: Card(
        // color: Colors.white,
        child: Row(
          children: <Widget>[
            Expanded(
              child: AspectRatio(
                aspectRatio: 1,
                child: PieChart(
                  PieChartData(
                      // pieTouchData:
                      // PieTouchData(touchCallback: (FlTouchEvent event, pieTouchResponse) {
                      //   setState(() {
                      //     if (!event.isInterestedForInteractions ||
                      //         pieTouchResponse == null ||
                      //         pieTouchResponse.touchedSection == null) {
                      //       touchedIndex = -1;
                      //       return;
                      //     }
                      //     touchedIndex = pieTouchResponse.touchedSection!.touchedSectionIndex;
                      //   });
                      // }),
                      borderData: FlBorderData(
                        show: false,
                      ),
                      sectionsSpace: 1,
                      centerSpaceRadius: 5,
                      sections: showingSections()),
                ),
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const <Widget>[
                // Indicator(
                //   color: Color(0xff0293ee),
                //   text: 'First',
                //   isSquare: true,
                // ),
                // SizedBox(
                //   height: 4,
                // ),
                // Indicator(
                //   color: Color(0xfff8b250),
                //   text: 'Second',
                //   isSquare: true,
                // ),
                // SizedBox(
                //   height: 4,
                // ),
                // Indicator(
                //   color: Color(0xff845bef),
                //   text: 'Third',
                //   isSquare: true,
                // ),
                // SizedBox(
                //   height: 4,
                // ),
                // Indicator(
                //   color: Color(0xff13d38e),
                //   text: 'Fourth',
                //   isSquare: true,
                // ),
                // SizedBox(
                //   height: 18,
                // ),
                // Indicator(
                //   color: Color(0xff845bef),
                //   text: 'Fifth',
                //   isSquare: true,
                // ),
                // SizedBox(
                //   height: 4,
                // ),
                // Indicator(
                //   color: Color(0xff13d38e),
                //   text: 'Sixth',
                //   isSquare: true,
                // ),
                // SizedBox(
                //   height: 18,
                // ),
              ],
            ),
            // const SizedBox(
            //   width: 28,
            // ),
          ],
        ),
      ),
    );
  }

  List<PieChartSectionData> showingSections() {
    return List.generate(6, (i) {
      final fontSize = isScreenOnly ? largeFontSize : mediumFontSize;
      final radius = isScreenOnly
          ? sectionedCircleRadiusScreen
          : sectionedCircleRadiusMobile;
      final offset = 0.65;
      final weight = isScreenOnly ? FontWeight.bold : FontWeight.w500;
      switch (i) {
        case 0:
          return PieChartSectionData(
            color: color1.withOpacity(opacity),
            value: 16,
            title: title1,
            titlePositionPercentageOffset: offset,
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              color: KelloggColors.white,
              fontWeight: weight,
            ),
          );
        case 1:
          return PieChartSectionData(
            color: color2.withOpacity(opacity),
            value: 16,
            title: title2,
            radius: radius,
            titlePositionPercentageOffset: offset,
            titleStyle: TextStyle(
              fontSize: fontSize,
              color: KelloggColors.white,
              fontWeight: weight,
            ),
          );
        case 2:
          return PieChartSectionData(
            color: color3.withOpacity(opacity),
            value: 16,
            titlePositionPercentageOffset: offset,
            title: title3,
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              color: KelloggColors.white,
              fontWeight: weight,
            ),
          );
        case 3:
          return PieChartSectionData(
            color: color4.withOpacity(opacity),
            value: 16,
            titlePositionPercentageOffset: offset,
            title: title4,
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              color: KelloggColors.white,
              fontWeight: weight,
            ),
          );
        case 4:
          return PieChartSectionData(
            color: color5.withOpacity(opacity),
            value: 16,
            title: title5,
            titlePositionPercentageOffset: offset,
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              color: KelloggColors.white,
              fontWeight: weight,
            ),
          );
        case 5:
          return PieChartSectionData(
            color: color6.withOpacity(opacity),
            value: 16,
            title: title6,
            titlePositionPercentageOffset: offset,
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              color: KelloggColors.white,
              fontWeight: weight,
            ),
            // borderSide: BorderSide(color: KelloggColors.white, width: 1),
          );
        default:
          throw Error();
      }
    });
  }
}
