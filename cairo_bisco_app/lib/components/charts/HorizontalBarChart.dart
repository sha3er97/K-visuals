import 'package:cairo_bisco_app/classes/RootCause.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../classes/CauseCount.dart';
import '../../classes/DownTimeReport.dart';

class HorizontalBarChart extends StatelessWidget {
  final List<charts.Series<dynamic, String>> seriesList;
  final bool animate;

  HorizontalBarChart(this.seriesList, {required this.animate});

  /// Creates a [BarChart] with sample data.
  factory HorizontalBarChart.withSampleData() {
    return new HorizontalBarChart(
      _createSampleData(),
      animate: true,
    );
  }

  /// Creates a [BarChart] with real data.
  factory HorizontalBarChart.withTop10Causes(List<CauseCount> causesList) {
    return new HorizontalBarChart(
      _getTop10Data(causesList),
      animate: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    // For horizontal bar charts, set the [vertical] flag to false.
    return new charts.BarChart(
      seriesList,
      animate: animate,
      vertical: false,
      // Set a bar label decorator.
      // Example configuring different styles for inside/outside:
      //       barRendererDecorator: new charts.BarLabelDecorator(
      //          insideLabelStyleSpec: new charts.TextStyleSpec(...),
      //          outsideLabelStyleSpec: new charts.TextStyleSpec(...)),
      barRendererDecorator: new charts.BarLabelDecorator<String>(),
      // Hide domain axis.
      domainAxis:
          new charts.OrdinalAxisSpec(renderSpec: new charts.NoneRenderSpec()),
    );
  }

  static List<charts.Series<CauseCount, String>> _getTop10Data(
      List<CauseCount> causesList) {
    causesList.sort((b, a) => a.count.compareTo(b.count));
    if (causesList.length > 10) causesList.removeRange(10, causesList.length);

    return [
      new charts.Series<CauseCount, String>(
        id: 'Causes',
        domainFn: (CauseCount cause, _) => cause.causeName,
        measureFn: (CauseCount cause, _) => cause.count,
        data: causesList,
        // Set a label accessor to control the text of the bar label.
        labelAccessorFn: (CauseCount cause, _) =>
            '${cause.causeName}: ${cause.count.toString()}',
      )
    ];
  }

  /// Create some series with sample hard coded data.
  static List<charts.Series<CauseCount, String>> _createSampleData() {
    final data = [
      new CauseCount(RootCause.allCauses[1].trim(), 5),
      new CauseCount(RootCause.allCauses[3].trim(), 25),
      new CauseCount(RootCause.allCauses[7].trim(), 100),
      new CauseCount(RootCause.allCauses[11].trim(), 75),
      new CauseCount(RootCause.allCauses[2].trim(), 5),
      new CauseCount(RootCause.allCauses[5].trim(), 25),
      new CauseCount(RootCause.allCauses[8].trim(), 100),
      new CauseCount(RootCause.allCauses[13].trim(), 75),
      new CauseCount(RootCause.allCauses[9].trim(), 5),
      new CauseCount(RootCause.allCauses[15].trim(), 25),
    ];

    return [
      new charts.Series<CauseCount, String>(
        id: 'Causes',
        domainFn: (CauseCount cause, _) => cause.causeName,
        measureFn: (CauseCount cause, _) => cause.count,
        data: data,
      )
    ];
  }
}
