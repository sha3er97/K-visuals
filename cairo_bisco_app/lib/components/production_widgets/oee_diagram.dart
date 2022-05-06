import 'package:cairo_bisco_app/classes/MiniProductionReport.dart';
import 'package:cairo_bisco_app/classes/utility_funcs/calculations_utility.dart';
import 'package:cairo_bisco_app/classes/values/TextStandards.dart';
import 'package:cairo_bisco_app/classes/values/colors.dart';
import 'package:cairo_bisco_app/classes/values/constants.dart';
import 'package:cairo_bisco_app/components/arrows/down_arrow.dart';
import 'package:cairo_bisco_app/components/arrows/left_arrow.dart';
import 'package:cairo_bisco_app/components/arrows/right_arrow.dart';
import 'package:flutter/cupertino.dart';

class OeeDiagram extends StatelessWidget {
  const OeeDiagram({
    Key? key,
    required this.overweight,
    required this.report,
    required this.isWebView,
    required this.circleColor,
  }) : super(key: key);
  final MiniProductionReport report;
  final Color circleColor;

  final double overweight;
  final bool isWebView;

  @override
  Widget build(BuildContext context) {
    double webFactor = isWebView ? 0.75 : 1.0;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: webFactor * aboveMediumIconSize,
            width: webFactor * aboveMediumIconSize,
            decoration: BoxDecoration(
                color: KelloggColors.yellow
                    .withOpacity(misleadingResolvingOpacity),
                borderRadius:
                    BorderRadius.all(Radius.circular(radiusForFullCircle))),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                WebCustomizedHeading(
                    (calculateRate(report, overweight) * 100)
                            .toStringAsFixed(1) +
                        " %",
                    webFactor),
              ],
            ),
          ),
          ConstrainedBox(
            constraints: BoxConstraints.tightFor(
                height: webFactor * mediumIconSize,
                width: webFactor * mediumIconSize),
            child: CustomPaint(
              painter: DownArrow(
                  label: 'R',
                  color: KelloggColors.yellow
                      .withOpacity(misleadingResolvingOpacity)),
            ),
          ),
          Container(
            // margin:
            // EdgeInsets.only(left: minimumPadding, right: minimumPadding),
            // padding: EdgeInsets.all(defaultPadding),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: webFactor * mediumIconSize,
                  width: webFactor * mediumIconSize,
                  decoration: BoxDecoration(
                      color: KelloggColors.darkRed
                          .withOpacity(misleadingResolvingOpacity),
                      borderRadius: BorderRadius.all(
                          Radius.circular(radiusForFullCircle))),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      WebCustomizedHeading(
                          (calculateAvailability(report) * 100)
                                  .toStringAsFixed(1) +
                              " %",
                          webFactor),
                    ],
                  ),
                ),
                ConstrainedBox(
                  constraints: BoxConstraints.tightFor(
                      height: webFactor * mediumIconSize,
                      width: webFactor * mediumIconSize),
                  child: CustomPaint(
                    painter: RightArrow(
                        label: 'A',
                        color: KelloggColors.darkRed
                            .withOpacity(misleadingResolvingOpacity)),
                  ),
                ),
                SizedBox(width: minimumPadding),
                Container(
                  height: webFactor * aboveMediumIconSize,
                  width: webFactor * aboveMediumIconSize,
                  decoration: BoxDecoration(
                      color: circleColor,
                      borderRadius: BorderRadius.all(
                          Radius.circular(radiusForFullCircle))),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      WebCustomizedHeading(
                          calculateOeeFromMiniReport(report, overweight)
                                  .toStringAsFixed(1) +
                              " %",
                          webFactor),
                    ],
                  ),
                ),
                SizedBox(width: minimumPadding),
                ConstrainedBox(
                  constraints: BoxConstraints.tightFor(
                      height: webFactor * mediumIconSize,
                      width: webFactor * mediumIconSize),
                  child: CustomPaint(
                    painter: LeftArrow(
                        label: 'Q',
                        color: KelloggColors.green
                            .withOpacity(misleadingResolvingOpacity)),
                  ),
                ),
                Container(
                  height: webFactor * mediumIconSize,
                  width: webFactor * mediumIconSize,
                  decoration: BoxDecoration(
                      color: KelloggColors.green
                          .withOpacity(misleadingResolvingOpacity),
                      borderRadius: BorderRadius.all(
                          Radius.circular(radiusForFullCircle))),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      WebCustomizedHeading(
                          (calculateQuality(report, overweight) * 100)
                                  .toStringAsFixed(1) +
                              " %",
                          webFactor),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: minimumPadding),
          aboveMediumHeading('OEE%'),
        ],
      ),
    );
  }
}
