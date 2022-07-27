import 'package:cairo_bisco_app/classes/OverWeightReport.dart';

import '../SKU.dart';
import 'form_values.dart';

/** version configs**/
const versionNum = '5.0.1'; //edit also in pubspec.yaml
const versionCode = 21; //edit also in pubspec.yaml
const playStoreLink =
    'https://play.google.com/store/apps/details?id=com.kellogg.bisco.cairo_bisco_app';

/** ui design constants **/
//customization variables
const dummyChartExtra = 1.0;
const oeeMargin = 1;
const misleadingResolvingOpacity = 0.75;
const causesDisplayDefaultLimit = 10;
const defaultChartHeight = 350.0;
const defaultChartWidth = defaultChartHeight * 1.75;
const largeChartHeight = 400.0;
const largeChartWidth = largeChartHeight * 1.85;

//padding
const defaultPadding = 16.0;
const mediumPadding = 12.0;
const minimumPadding = 8.0;
const pushAwayPadding = 60.0;

//font sizes
const titleFontSize = 40.0;
const largeButtonFont = 25.0;
const largeFontSize = 20.0;
const aboveMediumFontSize = 16.0;
const mediumFontSize = 14.0;
const minimumFontSize = 12.0;

// curvature radius
const radiusForFullCircle = 35.0;
const textFieldRadius = 20.0;
const textFieldBorderRadius = 1.0;
const textFieldFocusedBorderRadius = 1.0;
const iconImageBorder = 10.0;
const BoxImageBorder = 15.0;
const radiusDifference = 3;
const chartRadiusCircle1 = 13.0;
const chartRadiusCircle11 = chartRadiusCircle1 + radiusDifference;
const chartRadiusCircle111 = chartRadiusCircle11 + radiusDifference;
const chartRadiusCircle1111 = chartRadiusCircle111 + radiusDifference;
const chartRadiusCircle11111 = chartRadiusCircle1111 + radiusDifference;
const chartInnerRadius = 70.0;
const sectionedCircleRadiusMobile = 150.0;
const sectionedCircleRadiusScreen = 250.0;
const roundedButtonCurvature = 50.0;
const kpiCircleRadius = 50.0;
const alertDialogRadius = 15.0;

//line widths
const borderWidth = 2.0;

//image sizes
const regularIconSize = 40.0;
const smallIconSize = 25.0;
const mediumIconSize = 50.0;
const aboveMediumIconSize = 65.0;
const minimumBoxHeight = 40.0;
const kpiBoxHeight = 100.0;
const regularBoxHeight = 150.0;
const LargeBoxHeight = 200.0;
const TightBoxWidth = 300.0;
const logoHeight = 175.0;

//gauges constants
const gaugeSize = 175.0;
const LargeGaugeSize = 250.0;
const screenGaugeSize = 300.0;
const gaugeNeedleLength = 0.4;
const LargeGaugeNeedleLength = 0.5;
const screenGaugeNeedleLength = 0.6;
const needleEndWidth = 5.0;

//button
const buttonWidth = 200.0;
const buttonHeight = 60.0;
const buttonElevation = 5.0;

//arrow constants
const arrowStrokeWidth = 4.0;

/** time constants in seconds **/
const splashScreenDuration = 3; //3 seconds
const floorScreenWheelDuration = 30; //30 seconds
const floorScreenDashBoardDuration = 60; //1 minute

/** factory constants **/
const maxScrap = 20.0;
const maxFilmWaste = 20.0;
const monthDays = 28.0; // month is 28 days
const standardShiftHours = 8.0;
const factory_name = "bisco_cairo";
// const appName = 'K Visuals';
const appName = 'Factory Tracker';

/** string constants **/
const dropDownSelectionErrorText = "Please select all fields";
const submissionErrorText = "Error in submission .. incomplete report";
const notPercentErrorText = "النسبة لا يمكن ان تتخطي ال100%";
const missingValueErrorText = 'هذه الخانة ضرورية';
const conditionalMissingValueErrorText =
    'هذه الخانة ضرورية اذا كان العدد اكبر من صفر';
const uneditableLabelText = 'Uneditable';
const excelSuccessMsg = "File Downloaded Successfully";
const excelFailureMsg = "Something went wrong in Exporting Report";
const unauthorizedEditMsg =
    "Unauthorized Access please contact your administrator";

/** MACROS **/
const BISCUIT_AREA = 0;
const WAFER_AREA = 1;
const MAAMOUL_AREA = 2;
const TOTAL_PLANT = -1;

const ALL_LINES = -1;
const ALL_SHIFTS = -1;

const PRODUCTION_REPORT = 0; //0,1,2 are left for 3 production areas
const QFS_REPORT = 3;
const EHS_REPORT = 4;
const DOWNTIME_REPORT = 5;
const PEOPLE_REPORT = 6;
const NRC_REPORT = 7;
const OVERWEIGHT_REPORT = 8;

const ADMIN_ADD_SKU = 0;
//const ADMIN_ROOT_CAUSES_EDIT = 1;
const NO = 0;
const YES = 1;

const FROM = 0;
const TO = 1;
/** Constant Lists **/
List<OverWeightReport> overweightDummyList = [];
List<String> prodType = <String>[
  'Biscuits',
  'Wafer',
  'Maamoul',
  'Total Plant',
];
List<List<String>> correspondingLines = [
  ['-'].followedBy(prod_lines4).toList(), //biscuits
  ['-'].followedBy(prod_lines4).toList(), //wafer
  ['-'].followedBy(prod_lines2).toList(), //maamoul
  ['-'], //total plant
];
List<List<String>> correspondingSkus = [
  ['-'].followedBy(SKU.allSkus[0]).toList(), //biscuits
  ['-'].followedBy(SKU.allSkus[1]).toList(), //wafer
  ['-'].followedBy(SKU.allSkus[2]).toList(), //maamoul
  ['-'], //total plant
];
List<String> reportTypeNames = <String>[
  'Production',
  'Production',
  'Production',
  'QFS',
  'EHS',
  'Down Time',
  '' // more reports
];
Map<String, String> downTimeAuthoritiesMap = {
  downTimeTypes[0]: authorities[0], //-
  downTimeTypes[1]: authorities[2], //maintenance
  downTimeTypes[2]: authorities[1], //production
  downTimeTypes[3]: authorities[3], //quality
  downTimeTypes[4]: authorities[4], //safety
  downTimeTypes[5]: authorities[5], //other
  downTimeTypes[6]: authorities[5], //other
  downTimeTypes[7]: authorities[5], //other
  downTimeTypes[8]: authorities[5], //other
};
List<String> commonScrapAreas = <String>[
  'Oven',
  'Packing',
];
List<String> waferScrapAreas = <String>[
  'Cream',
  'Cooler',
  'Cutter',
];
List<String> biscuitsScrapAreas = <String>[
  'Extrusion',
  'Conveyor',
  'Cutter',
];
List<String> maamoulScrapAreas = <String>[
  'Mixer',
  'Stamping',
];

List<List<String>> scrapAreas = [
  commonScrapAreas.followedBy(biscuitsScrapAreas).toList(),
  commonScrapAreas.followedBy(waferScrapAreas).toList(),
  commonScrapAreas.followedBy(maamoulScrapAreas).toList(),
];
