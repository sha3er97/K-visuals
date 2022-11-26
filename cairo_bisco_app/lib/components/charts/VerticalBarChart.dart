import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';

import '/classes/values/colors.dart';
import '/classes/values/constants.dart';
import '../../classes/CauseCount.dart';

class VerticalBarChart extends StatelessWidget {
  final List<charts.Series<dynamic, String>> seriesList;
  final bool animate;
  final num target;

  final String axisTitle;

  const VerticalBarChart(
    this.seriesList, {
    super.key,
    required this.animate,
    required this.target,
    required this.axisTitle,
  });

  /// Creates a [BarChart] with sample data.
  factory VerticalBarChart.withSampleData() {
    return VerticalBarChart(
      _createSampleData(),
      animate: true,
      target: 100,
      axisTitle: "axisTitle",
    );
  }

  /// Creates a [BarChart] with real data.
  factory VerticalBarChart.withRealData(
    List<CauseCount> causesList,
    num total,
    num target,
    String axisTitle,
    // int chartLimit,
  ) {
    return VerticalBarChart(
      _useRealData(
        causesList,
        total,
        // chartLimit,
      ),
      animate: true,
      target: target,
      axisTitle: axisTitle,
    );
  }

  @override
  Widget build(BuildContext context) {
    return charts.BarChart(
      seriesList,
      animate: animate,
      vertical: true,
      behaviors: [
        // charts.ChartTitle(axisTitle, titleStyleSpec: const charts.TextStyleSpec(color: charts.Color.black,)),

        //  charts.ChartTitle('Date',
        //     behaviorPosition: charts.BehaviorPosition.bottom,
        //     titleStyleSpec: charts.TextStyleSpec(fontSize: mediumFontSize.toInt(),color: charts.ColorUtil.fromDartColor(KelloggColors.darkRed)),
        //     titleOutsideJustification:
        //     charts.OutsideJustification.middleDrawArea),
        charts.ChartTitle('Consumption ($axisTitle)',
            behaviorPosition: charts.BehaviorPosition.start,
            titleStyleSpec: charts.TextStyleSpec(
              fontSize: mediumFontSize.toInt(),
              color: charts.ColorUtil.fromDartColor(KelloggColors.darkRed),
              fontFamily: 'MyFont',
            ),
            titleOutsideJustification:
                charts.OutsideJustification.middleDrawArea),
        charts.RangeAnnotation([
          charts.LineAnnotationSegment(
              target, charts.RangeAnnotationAxisType.measure,
              color: charts.ColorUtil.fromDartColor(KelloggColors.yellow),
              dashPattern: [2, 2],
              endLabel: 'Target')
        ])
      ],
      // Set a bar label decorator.
      // Example configuring different styles for inside/outside:
      //       barRendererDecorator:  charts.BarLabelDecorator(
      //          insideLabelStyleSpec:  charts.TextStyleSpec(...),
      //          outsideLabelStyleSpec:  charts.TextStyleSpec(...)),
      barRendererDecorator: charts.BarLabelDecorator<String>(
        outsideLabelStyleSpec: charts.TextStyleSpec(
          color: charts.Color.black,
          fontSize: aboveMediumFontSize.toInt(),
          fontFamily: 'MyFont',
        ),
        insideLabelStyleSpec: charts.TextStyleSpec(
            color: charts.Color.white,
            fontSize: aboveMediumFontSize.toInt(),
            fontFamily: 'MyFont'),
      ),
      domainAxis: charts.OrdinalAxisSpec(
          renderSpec: charts.SmallTickRendererSpec(
        labelStyle: charts.TextStyleSpec(
          color: charts.Color.black,
          fontSize: aboveMediumFontSize.toInt(),
          fontFamily: 'MyFont',
        ),
      )),
    );
  }

  /// Create some series with sample hard coded data.
  static List<charts.Series<CauseCount, String>> _createSampleData() {
    final data = [
      CauseCount('18/11', 5),
      CauseCount('19/11', 25),
      CauseCount('MTD', 100),
    ];

    return [
      charts.Series<CauseCount, String>(
        id: 'Causes',
        domainFn: (CauseCount cause, _) => cause.causeName,
        measureFn: (CauseCount cause, _) => cause.count,
        data: data,
        colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault,
        fillColorFn: (_, __) => charts.MaterialPalette.red.shadeDefault.darker,
        // Set a label accessor to control the text of the bar label.
        labelAccessorFn: (CauseCount cause, _) => cause.count.toString(),
      )
    ];
  }

  static List<charts.Series<CauseCount, String>> _useRealData(
    List<CauseCount> causesList,
    num total,
    // int chartLimit,
  ) {
    // causesList.sort((b, a) => a.count.compareTo(b.count));
    // if (causesList.length > chartLimit) {
    //   causesList.removeRange(chartLimit, causesList.length);
    // }

    return [
      charts.Series<CauseCount, String>(
        id: 'Causes',
        domainFn: (CauseCount cause, _) =>
            "${cause.causeName.split("/")[0]}/${cause.causeName.split("/")[1]}",
        //dd/mm format
        measureFn: (CauseCount cause, _) => cause.count,
        data: causesList,
        colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault,
        fillColorFn: (_, __) => charts.MaterialPalette.red.shadeDefault.darker,
        // Set a label accessor to control the text of the bar label.
        labelAccessorFn: (CauseCount cause, _) =>
            cause.count.toStringAsFixed(1),
        // outsideLabelStyleAccessorFn: (CauseCount cause, _) {
        //   final color = charts.MaterialPalette.yellow.shadeDefault;
        //   return  charts.TextStyleSpec(
        //       color: color, fontSize: largeFontSize.toInt());
        // },
      ),
      charts.Series<CauseCount, String>(
        id: 'TTD',
        domainFn: (CauseCount cause, _) => "TTD",
        //dd/mm format
        measureFn: (CauseCount cause, _) => total,
        data: causesList,
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        fillColorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault.darker,
        // Set a label accessor to control the text of the bar label.
        labelAccessorFn: (CauseCount cause, _) => total.toStringAsFixed(1),
        // outsideLabelStyleAccessorFn: (CauseCount cause, _) {
        //   final color = charts.MaterialPalette.yellow.shadeDefault;
        //   return  charts.TextStyleSpec(
        //       color: color, fontSize: largeFontSize.toInt());
        // },
      ),
    ];
  }
}
