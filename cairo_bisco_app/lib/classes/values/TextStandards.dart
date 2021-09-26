import 'package:flutter/material.dart';
import 'colors.dart';
import 'constants.dart';

Widget ErrorMessageHeading(String title) {
  return Center(
    child: Text(
      '* ' + title + ' *',
      style: TextStyle(
          color: KelloggColors.green,
          fontSize: largeButtonFont,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.2),
    ),
  );
}

Text subHeading(String title) {
  return Text(
    title,
    style: TextStyle(
        color: KelloggColors.darkRed,
        fontSize: largeFontSize,
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

Text adminHeading(String title) {
  return Text(
    title,
    style: TextStyle(
        fontSize: aboveMediumFontSize,
        fontWeight: FontWeight.w500,
        color: KelloggColors.darkBlue),
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
            color: KelloggColors.darkBlue),
      ),
      SizedBox(height: defaultPadding),
    ],
  );
}
