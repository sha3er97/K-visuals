import 'dart:ui';

import 'package:arrow_path/arrow_path.dart';
import 'package:cairo_bisco_app/classes/values/constants.dart';
import 'package:flutter/material.dart';
import 'package:cairo_bisco_app/classes/values/colors.dart';

class RightArrow extends CustomPainter {
  RightArrow({
    required this.label,
    required this.color,
  });

  final String label;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    TextSpan textSpan;
    TextPainter textPainter;
    Path path;

    // The arrows usually looks better with rounded caps.
    Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..strokeWidth = arrowStrokeWidth;

    /// Draw a single arrow.
    path = Path();
    //path.moveTo(size.width * 0.25, size.height * 0.10);
    path.moveTo(0, size.height * 0.45);

    //path.relativeCubicTo(0, 0, size.width * 0.25, 50, size.width * 0.5, 0);
    path.relativeCubicTo(
        0, 0, size.width, size.height * 0.1, size.width, size.height * 0.1);

    path = ArrowPath.make(path: path);
    canvas.drawPath(path, paint..color = color);

    textSpan = TextSpan(
      text: label,
      style: TextStyle(
        color: color,
        fontSize: mediumFontSize,
        fontWeight: FontWeight.w500,
      ),
    );
    textPainter = TextPainter(
      text: textSpan,
      textAlign: TextAlign.start,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout(minWidth: size.width);
    textPainter.paint(canvas, Offset(size.width * 0.25, 0));
    print("debug arrows :: right width =" + size.width.toString());
    print("debug arrows :: right height =" + size.height.toString());
    //
    // // Draw a double sided arrow.
    // path = Path();
    // path.moveTo(size.width * 0.25, size.height * 0.2);
    // path.relativeCubicTo(0, 0, size.width * 0.25, 50, size.width * 0.5, 0);
    // path = ArrowPath.make(path: path, isDoubleSided: true);
    // canvas.drawPath(path, paint..color = Colors.cyan);
    //
    // textSpan = TextSpan(
    //   text: 'Double sided arrow',
    //   style: TextStyle(color: Colors.cyan),
    // );
    // textPainter = TextPainter(
    //   text: textSpan,
    //   textAlign: TextAlign.center,
    //   textDirection: TextDirection.ltr,
    // );
    // textPainter.layout(minWidth: size.width);
    // textPainter.paint(canvas, Offset(0, size.height * 0.16));
    //
    // /// Use complex path.
    // path = Path();
    // path.moveTo(size.width * 0.25, size.height * 0.3);
    // path.relativeCubicTo(0, 0, size.width * 0.25, 50, size.width * 0.5, 50);
    // path.relativeCubicTo(0, 0, -size.width * 0.25, 0, -size.width * 0.5, 50);
    // path.relativeCubicTo(0, 0, size.width * 0.125, 10, size.width * 0.25, -10);
    // path = ArrowPath.make(path: path, isDoubleSided: true);
    // canvas.drawPath(path, paint..color = Colors.blue);
    //
    // textSpan = TextSpan(
    //   text: 'Complex path',
    //   style: TextStyle(color: Colors.blue),
    // );
    // textPainter = TextPainter(
    //   text: textSpan,
    //   textAlign: TextAlign.center,
    //   textDirection: TextDirection.ltr,
    // );
    // textPainter.layout(minWidth: size.width);
    // textPainter.paint(canvas, Offset(0, size.height * 0.28));
    //
    // /// Draw several arrows on the same path.
    // path = Path();
    // path.moveTo(size.width * 0.25, size.height * 0.53);
    // path.relativeCubicTo(0, 0, size.width * 0.25, 50, size.width * 0.5, 50);
    // path = ArrowPath.make(path: path);
    // path.relativeCubicTo(0, 0, -size.width * 0.25, 0, -size.width * 0.5, 50);
    // path = ArrowPath.make(path: path);
    // Path subPath = Path();
    // subPath.moveTo(size.width * 0.375, size.height * 0.53 + 100);
    // subPath.relativeCubicTo(
    //     0, 0, size.width * 0.125, 10, size.width * 0.25, -10);
    // subPath = ArrowPath.make(path: subPath, isDoubleSided: true);
    // path.addPath(subPath, Offset.zero);
    // canvas.drawPath(path, paint..color = Colors.cyan);
    //
    // textSpan = TextSpan(
    //   text: 'Several arrows on the same path',
    //   style: TextStyle(color: Colors.cyan),
    // );
    // textPainter = TextPainter(
    //   text: textSpan,
    //   textAlign: TextAlign.center,
    //   textDirection: TextDirection.ltr,
    // );
    // textPainter.layout(minWidth: size.width);
    // textPainter.paint(canvas, Offset(0, size.height * 0.49));
    //
    // /// Adjusted
    // path = Path();
    // path.moveTo(size.width * 0.1, size.height * 0.8);
    // path.relativeCubicTo(0, 0, size.width * 0.3, 50, size.width * 0.25, 75);
    // path = ArrowPath.make(path: path, isAdjusted: true);
    // canvas.drawPath(path, paint..color = Colors.blue);
    //
    // textSpan = TextSpan(
    //   text: 'Adjusted',
    //   style: TextStyle(color: Colors.blue),
    // );
    // textPainter = TextPainter(
    //   text: textSpan,
    //   textAlign: TextAlign.left,
    //   textDirection: TextDirection.ltr,
    // );
    // textPainter.layout();
    // textPainter.paint(canvas, Offset(size.width * 0.2, size.height * 0.77));
    //
    // /// Non adjusted.
    // path = Path();
    // path.moveTo(size.width * 0.6, size.height * 0.8);
    // path.relativeCubicTo(0, 0, size.width * 0.3, 50, size.width * 0.25, 75);
    // path = ArrowPath.make(path: path, isAdjusted: false);
    // canvas.drawPath(path, paint..color = Colors.blue);
    //
    // textSpan = TextSpan(
    //   text: 'Non adjusted',
    //   style: TextStyle(color: Colors.blue),
    // );
    // textPainter = TextPainter(
    //   text: textSpan,
    //   textAlign: TextAlign.left,
    //   textDirection: TextDirection.ltr,
    // );
    // textPainter.layout();
    // textPainter.paint(canvas, Offset(size.width * 0.65, size.height * 0.77));
  }

  @override
  bool shouldRepaint(RightArrow oldDelegate) => true;
}
