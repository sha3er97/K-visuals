import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';

import '../../classes/CauseCount.dart';
import '../../classes/values/form_values.dart';

class PieOutsideLabelChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;

  PieOutsideLabelChart(this.seriesList, {required this.animate});

  /// Creates a [PieChart] with sample data .
  factory PieOutsideLabelChart.withSampleData() {
    return new PieOutsideLabelChart(
      _createSampleData(),
      animate: true,
    );
  }

  /// Creates a [PieChart] with real data.
  factory PieOutsideLabelChart.withRealData(List<CauseCount> causesList) {
    return new PieOutsideLabelChart(
      _get_YN_ClassificationData(causesList),
      animate: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return new charts.PieChart(seriesList,
        animate: animate,
        // Add an [ArcLabelDecorator] configured to render labels outside of the
        // arc with a leader line.
        //
        // Text style for inside / outside can be controlled independently by
        // setting [insideLabelStyleSpec] and [outsideLabelStyleSpec].
        //
        // Example configuring different styles for inside/outside:
        //       new charts.ArcLabelDecorator(
        //          insideLabelStyleSpec: new charts.TextStyleSpec(...),
        //          outsideLabelStyleSpec: new charts.TextStyleSpec(...)),
        defaultRenderer: new charts.ArcRendererConfig(arcRendererDecorators: [
          new charts.ArcLabelDecorator(
              labelPosition: charts.ArcLabelPosition.outside)
        ]));
  }

  static List<charts.Series<CauseCount, String>> _get_YN_ClassificationData(
      List<CauseCount> causesList) {
    return [
      new charts.Series<CauseCount, String>(
        id: 'Y/N',
        domainFn: (CauseCount cause, _) => cause.causeName,
        measureFn: (CauseCount cause, _) => cause.count,
        data: causesList,
        // Set a label accessor to control the text of the arc label.
        labelAccessorFn: (CauseCount row, _) =>
            '${row.causeName}: ${row.count}',
      )
    ];
  }

  /// Create one series with sample hard coded data.
  static List<charts.Series<CauseCount, String>> _createSampleData() {
    final data = [
      new CauseCount(y_nDesc[0], 5),
      new CauseCount(y_nDesc[1], 75),
      new CauseCount(y_nDesc[2], 25),
    ];

    return [
      new charts.Series<CauseCount, String>(
        id: 'Y/N',
        domainFn: (CauseCount cause, _) => cause.causeName,
        measureFn: (CauseCount cause, _) => cause.count,
        data: data,
        // Set a label accessor to control the text of the arc label.
        labelAccessorFn: (CauseCount row, _) =>
            '${row.causeName}: ${row.count}',
      )
    ];
  }
}
