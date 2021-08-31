import 'package:cairo_bisco_app/components/values/colors.dart';
import 'package:flutter/material.dart';

import 'constants.dart';

Text subHeading(String title) {
  return Text(
    title,
    style: TextStyle(
        color: KelloggColors.darkRed,
        fontSize: 20.0,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.2),
  );
}

Text smallerHeading(String title) {
  return Text(
    title,
    style: TextStyle(
        fontSize: mediumFontSize,
        fontWeight: FontWeight.w500,
        color: KelloggColors.darkRed),
  );
}

Widget myDivider() {
  return Divider(
    height: 20,
    thickness: 3,
    indent: 5,
    endIndent: 5,
  );
}

/**
 * darkblue big title with spaces
 */
Widget sectionTitle(String title) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      SizedBox(height: defaultPadding),
      Center(
        child: Text(
          '- ' + title + ' -',
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: largeFontSize,
              color: KelloggColors.darkBlue),
        ),
      ),
      // SizedBox(height: defaultPadding),
    ],
  );
}

/**
 * green big title with space after it included
 */
Widget sectionWithDivider(String title) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      myDivider(),
      Text(
        title,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: largeFontSize,
            color: KelloggColors.green),
      ),
      SizedBox(height: defaultPadding),
    ],
  );
}
