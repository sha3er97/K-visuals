import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';

import '../../classes/CauseCount.dart';
import '../../classes/values/constants.dart';
import '../../classes/values/form_values.dart';

class PieOutsideLabelChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;

  PieOutsideLabelChart(this.seriesList, {required this.animate});

  /// Creates a [PieChart] with sample data .
  factory PieOutsideLabelChart.withSampleData() {
    return PieOutsideLabelChart(
      _createSampleData(),
      animate: true,
    );
  }

  /// Creates a [PieChart] with real data.
  factory PieOutsideLabelChart.withYNClassificationData(
      List<CauseCount> causesList) {
    return PieOutsideLabelChart(
      _get_YN_ClassificationData(causesList),
      animate: true,
    );
  }

  factory PieOutsideLabelChart.withFiveShades(List<CauseCount> causesList) {
    return PieOutsideLabelChart(
      _FiveShadesData(causesList),
      animate: true,
    );
  }

  factory PieOutsideLabelChart.withTenShades(List<CauseCount> causesList) {
    return PieOutsideLabelChart(
      _TenShadesData(causesList),
      animate: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return charts.PieChart(seriesList,
        animate: animate,
        // Add an [ArcLabelDecorator] configured to render labels outside of the
        // arc with a leader line.
        //
        // Text style for inside / outside can be controlled independently by
        // setting [insideLabelStyleSpec] and [outsideLabelStyleSpec].
        //
        // Example configuring different styles for inside/outside:
        //        charts.ArcLabelDecorator(
        //          insideLabelStyleSpec:  charts.TextStyleSpec(...),
        //          outsideLabelStyleSpec:  charts.TextStyleSpec(...)),
        defaultRenderer: charts.ArcRendererConfig(arcRendererDecorators: [
          charts.ArcLabelDecorator(
            labelPosition: charts.ArcLabelPosition.outside,
            outsideLabelStyleSpec: charts.TextStyleSpec(
              color: charts.Color.black,
              fontSize: aboveMediumFontSize.toInt(),
              fontFamily: 'MyFont',
            ),
          )
        ]));
  }

  static List<charts.Series<CauseCount, String>> _FiveShadesData(
      List<CauseCount> causesList) {
    return [
      charts.Series<CauseCount, String>(
        id: '',
        domainFn: (CauseCount cause, _) => cause.causeName,
        measureFn: (CauseCount cause, _) => cause.count,
        data: causesList,
        colorFn: (_, i) => charts.MaterialPalette.red.makeShades(5)[i!],
        fillColorFn: (_, __) => charts.MaterialPalette.red.shadeDefault.darker,
        // Set a label accessor to control the text of the arc label.
        labelAccessorFn: (CauseCount row, _) =>
            '${row.causeName}: ${row.count}',
      )
    ];
  }

  static List<charts.Series<CauseCount, String>> _TenShadesData(
      List<CauseCount> causesList) {
    return [
      charts.Series<CauseCount, String>(
        id: '',
        domainFn: (CauseCount cause, _) => cause.causeName,
        measureFn: (CauseCount cause, _) => cause.count,
        data: causesList,
        colorFn: (_, i) => charts.MaterialPalette.red.makeShades(10)[i!],
        fillColorFn: (_, __) => charts.MaterialPalette.red.shadeDefault.darker,
        // Set a label accessor to control the text of the arc label.
        labelAccessorFn: (CauseCount row, _) =>
            '${row.causeName}: ${row.count.ceil()} Kg',
      )
    ];
  }

  static List<charts.Series<CauseCount, String>> _get_YN_ClassificationData(
      List<CauseCount> causesList) {
    return [
      charts.Series<CauseCount, String>(
        id: 'Y/N',
        domainFn: (CauseCount cause, _) => cause.causeName,
        measureFn: (CauseCount cause, _) => cause.count,
        data: causesList,
        colorFn: (_, i) => charts.MaterialPalette.red.makeShades(3)[i!],
        fillColorFn: (_, __) => charts.MaterialPalette.red.shadeDefault.lighter,
        // Set a label accessor to control the text of the arc label.
        labelAccessorFn: (CauseCount row, _) =>
            '${row.causeName}: ${row.count}',
      )
    ];
  }

  /// Create one series with sample hard coded data.
  static List<charts.Series<CauseCount, String>> _createSampleData() {
    final data = [
      CauseCount(y_nDesc[0], 5),
      CauseCount(y_nDesc[1], 75),
      CauseCount(y_nDesc[2], 25),
    ];

    return [
      charts.Series<CauseCount, String>(
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
