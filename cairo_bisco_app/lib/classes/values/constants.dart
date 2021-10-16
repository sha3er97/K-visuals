/** version number**/
const versionNum = '1.7.1'; //edit also in pubspec.yaml

/** ui design constants **/
const dummyChartExtra = 1.0;
//padding
const defaultPadding = 16.0;
const minimumPadding = 8.0;

//font sizes
const largeButtonFont = 25.0;
const largeFontSize = 20.0;
const aboveMediumFontSize = 16.0;
const mediumFontSize = 14.0;
const minimumFontSize = 12.0;

// curvature radius
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

//line widths
const borderWidth = 2.0;

//image sizes
const regularIconSize = 40.0;
const smallIconSize = 25.0;
const mediumIconSize = 50.0;
const regularBoxHeight = 150.0;
const LargeBoxHeight = 200.0;
const TightBoxWidth = 300.0;
const logoHeight = 175.0;

/** time constants in seconds **/
const splashScreenDuration = 3;
const floorScreenWheelDuration = 30; //30 seconds
const floorScreenDashBoardDuration = 90; //1.5 minutes

/** factory constants **/
const maxScrap = 20.0;
const maxFilmWaste = 20.0;
const monthDays = 28.0; // month is 28 days
const factory_name = "bisco_cairo";
const appName = 'K Visuals';

/** string constants **/
const submissionErrorText = "Error in submission .. incomplete report";
const notPercentErrorText = "النسبة لا يمكن ان تتخطي ال100%";
const missingValueErrorText = 'هذه الخانة ضرورية';
const conditionalMissingValueErrorText =
    'هذه الخانة ضرورية اذا كان العدد اكبر من صفر';
const uneditableLabelText = 'Uneditable';

/** MACROS **/
const BISCUIT_AREA = 0;
const WAFER_AREA = 1;
const MAAMOUL_AREA = 2;

const PRODUCTION_REPORT = 0;
const QFS_REPORT = 1;
const EHS_REPORT = 2;
const OVERWEIGHT_REPORT = 3;
const PEOPLE_REPORT = 4;
const NRC_REPORT = 5;

List<String> prodType = <String>[
  'Biscuits',
  'Wafer',
  'Maamoul',
];

List<String> months = <String>[
  '1',
  '2',
  '3',
  '4',
  '5',
  '6',
  '7',
  '8',
  '9',
  '10',
  '11',
  '12'
];
List<String> days = <String>[
  '1',
  '2',
  '3',
  '4',
  '5',
  '6',
  '7',
  '8',
  '9',
  '10',
  '11',
  '12',
  '13',
  '14',
  '15',
  '16',
  '17',
  '18',
  '19',
  '20',
  '21',
  '22',
  '23',
  '24',
  '25',
  '26',
  '27',
  '28',
  '29',
  '30',
  '31'
];
List<String> years = <String>[
  '2020',
  '2021',
  '2022',
  '2023',
  '2024',
  '2025',
  '2026',
  '2027',
  '2028',
  '2029',
  '2030',
  '2031',
  '2032',
  '2033',
  '2034',
  '2035',
  '2036'
];
