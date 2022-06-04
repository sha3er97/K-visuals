import 'package:flutter/material.dart';
import 'colors.dart';
import 'constants.dart';

Widget ErrorMessageHeading(String title) {
  return Center(
    child: Text(
      '* ' + title + ' *',
      textAlign: TextAlign.center,
      style: TextStyle(
        color: KelloggColors.cockRed,
        fontSize: largeButtonFont,
        fontWeight: FontWeight.w700,
        wordSpacing: 1.5,
      ),
    ),
  );
}

Widget NormalMessageHeading(String title) {
  return Center(
    child: Text(
      '* ' + title + ' *',
      textAlign: TextAlign.center,
      style: TextStyle(
        color: KelloggColors.darkBlue,
        fontSize: largeButtonFont,
        fontWeight: FontWeight.w700,
        wordSpacing: 1.5,
      ),
    ),
  );
}

Text subHeading(String title) {
  return Text(
    title,
    textAlign: TextAlign.center,
    style: TextStyle(
      color: KelloggColors.darkRed,
      fontSize: largeFontSize,
      fontWeight: FontWeight.bold,
    ),
  );
}

Text aboveMediumHeading(String title) {
  return Text(
    title,
    style: TextStyle(
        fontSize: aboveMediumFontSize,
        fontWeight: FontWeight.bold,
        color: KelloggColors.darkRed),
  );
}

Text WebCustomizedHeading(String title, double webFactor) {
  return Text(
    title,
    style: TextStyle(
        fontSize: webFactor * aboveMediumFontSize,
        fontWeight: FontWeight.bold,
        color: KelloggColors.white),
  );
}

Text smallerHeading(String title) {
  return Text(
    title,
    textAlign: TextAlign.center,
    style: TextStyle(
        fontSize: mediumFontSize,
        fontWeight: FontWeight.w500,
        color: KelloggColors.darkRed),
  );
}

Text greyHint(String title) {
  return Text(
    title + ' * ',
    textAlign: TextAlign.center,
    style: TextStyle(
        fontSize: mediumFontSize,
        fontWeight: FontWeight.w500,
        color: KelloggColors.grey),
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

Widget myHorizontalDivider() {
  return Divider(
    height: 20,
    thickness: 3,
    indent: 5,
    endIndent: 5,
  );
}

Widget myVerticalDivider(Color? lineColor) {
  return VerticalDivider(
    width: 15,
    thickness: 3,
    color: lineColor,
    indent: 5,
    endIndent: 5,
  );
}

/**
 * blue big title with dashes on the side and spaces
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
 * blue big title with space after it included
 */
Widget sectionWithDivider(String title) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      myHorizontalDivider(),
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
