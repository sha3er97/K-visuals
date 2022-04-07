import 'package:cairo_bisco_app/classes/OverWeightReport.dart';

/** version configs**/
const versionNum = '3.1.3'; //edit also in pubspec.yaml
const versionCode = 13; //edit also in pubspec.yaml
const playStoreLink =
    'https://play.google.com/store/apps/details?id=com.kellogg.bisco.cairo_bisco_app';

/** ui design constants **/
//customization variables
const dummyChartExtra = 1.0;
const oeeMargin = 1;
const misleadingResolvingOpacity = 0.75;

//padding
const defaultPadding = 16.0;
const mediumPadding = 12.0;
const minimumPadding = 8.0;
const pushAwayPadding = 60.0;

//font sizes
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
const appName = 'K Visuals';

/** string constants **/
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

const PRODUCTION_REPORT = 0; //0,1,2 are left for 3 production areas
const QFS_REPORT = 3;
const EHS_REPORT = 4;
const OVERWEIGHT_REPORT = 5;
const PEOPLE_REPORT = 6;
const NRC_REPORT = 7;
const DOWNTIME_REPORT = 8;

const ADMIN_ADD_SKU = 0;
//const ADMIN_ROOT_CAUSES_EDIT = 1;
const NO = 0;
const YES = 1;
/** Constant Lists **/
List<String> plannedTypes = <String>['Scheduled', 'Unscheduled'];
List<String> biscuitsMachines = <String>[
  'Dough Mixer عجان العجين 1',
  'Dough Mixer عجان العجين 2',
  'Date Mixer مفرم العجوة',
  'Chocolate Consh كونش الشوكلاتة',
  'Extruder',
  'Oven الفرن',
  'Cutter السكينة',
  'Processing Metal Detector جهاز كشف المعادن التصنيع',
  'Packaging Metal Detector جهاز كشف المعادن التغليف',
  'Conveyor السير',
];
List<String> waferMachines = <String>[
  'Dough Mixer عجان العجين 1',
  'Dough Mixer عجان العجين 2',
  'Cream Mixer 1 عجان الكريمة',
  'Cream Mixer 2 عجان الكريمة',
  'Rework Grinder مفرم الريورك',
  'Chocolate Consh كونش الشوكلاتة',
  'Oven الفرن',
  'Brusher الفرشة',
  'Stacking Ladder السلم',
  'Cream Spreader حشو الكريمة',
  'Book Cooler الثلاجة',
  'Cutter السكينة',
  'Packaging Metal Detector جهاز كشف المعادن التغليف',
];
List<String> maamoulMachines = <String>[
  'Dough Mixer عجان العجين 1',
  'Date Mixer مفرم العجوة',
  'Extruder',
  'Stamping التشكيل',
  'Oven الفرن',
  'Packing Machine',
  'Processing Metal Detector جهاز كشف المعادن التصنيع',
  'Packaging Metal Detector جهاز كشف المعادن التغليف',
];
List<List<String>> allMachines = [
  biscuitsMachines,
  waferMachines,
  maamoulMachines
];

List<String> wfCategories = <String>[
  'CAPITAL PROJECT المشاريع',
  'CHANGE OVER التغيير',
  'CLEANUP SANITATION التنظيف',
  'Line Downtime توقف الخط',
  'FOOD SAFETY سلامة الغذاء',
  'FUMIGATION التبخير',
  'Equipment Breakdown عطل',
  'PM & Utilities صيانة وقائية',
  'NO DEMAND لا خطة',
  'OPERATION العملية الأنتاجية',
  'SETUP STARTUP البدأ',
  'TEST TRIAL تجارب',
  'UTILITY OUTAGE انقطاع خدمات',
  'MATERIAL المواد',
  'NO CREW لا عمالة',
  'WEATHER الطقس',
];
List<String> downTimeTypes = <String>[
  '-',
  'اعطال صيانة',
  'اعطال انتاج',
  'اعطال تخطيط انتاج',
  'اعطال جوده',
  'اعطال سلامه',
  'اعطال الادارة',
  'اعطال القسم الهندسي',
  'اعطال مخازن'
];
List<String> authorities = <String>[
  '-',
  'Production',
  'Maintenance',
  'Quality',
  'Safety',
  'Other',
];
List<OverWeightReport> overweightDummyList = [];
List<String> prodType = <String>[
  'Biscuits',
  'Wafer',
  'Maamoul',
];
List<String> reportTypeNames = <String>[
  'Production',
  'Production',
  'Production',
  'QFS',
  'EHS',
  '' // more reports
];
List<String> y_nDesc = <String>[
  'Yes نعم',
  'No لا',
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
  // '2026',
  // '2027',
  // '2028',
  // '2029',
  // '2030',
  // '2031',
  // '2032',
  // '2033',
  // '2034',
  // '2035',
  // '2036'
];
List<String> biscuitsHeaders = [
  "Date",
  "القسم",
  "الورديه",
  "عدد ساعات الورديه",
  "اجمالي توقفات الخط بالدقيقة Total line stops in Minutes",
  "نوع الصنف",
  "خط الانتاج",
  "Theoretical Speed rate (kg)/shift",
  "Unit",
  "Production  الانتاج الفعلى",
  "Total Rework اعادة تشغيل",
  "Ext Rework اعادة تشغيل",
  "Ext Scrap هالك التشكيل",
  "Scrap Reason سبب الهالك",
  "Oven Rework اعادة تشغيل",
  "Oven Scrap هالك الفرن",
  "Scrap Reason سبب الهالك",
  "Cutter Rework اعادة تشغيل",
  "Cutter Scrap الهالك",
  "Scrap Reason سبب الهالك",
  "Conv Rework اعادة تشغيل",
  "Conv Scrap الهالك",
  "Scrap Reason سبب الهالك",
  "MC1 Speed",
  "MC2 Speed",
  "MC3 Speed",
  "MC4 Speed",
  "Packing Rework اعادة تشغيل",
  "Packing Scrap هالك بسكويت منطقة التغليف",
  "Scrap Reason سبب الهالك",
  "هالك علب",
  "هالك كرتون",
  "MC1 Waste in Kg",
  "Film Waste% MC1",
  "MC2 Waste in Kg",
  "Film Waste% MC2",
  "MC3 Waste in Kg",
  "Film Waste% MC3",
  "MC4 Waste in Kg",
  "Film Waste% MC4",
  "Overweight%",
  "Scrap kg",
  "Rework%",
  "Scrap%",
  "Rate%",
  "Availability%",
  "Quality%",
  "OEE%",
  "Overweight (Kg)",
  "Cartons",
  "Month",
  "Week",
  "Year"
];
List<String> waferHeaders = [
  "Date",
  "القسم",
  "الورديه",
  "عدد ساعات الورديه",
  "اجمالي توقفات الخط بالدقيقة Total line stops in Minutes",
  "نوع الصنف",
  "خط الانتاج",
  "Theoretical Speed rate (kg)/shift",
  "Unit",
  "Production  الانتاج الفعلى",
  "Total Rework اعادة تشغيل",
  "Oven Rework اعادة تشغيل",
  "Oven Scrap هالك الفرن",
  "Scrap Reason سبب الهالك",
  "Cream Rework اعادة تشغيل",
  "Cream Scrap الهالك",
  "Scrap Reason سبب الهالك",
  "Cooler Rework اعادة تشغيل",
  "Cooler Scrap الهالك",
  "Scrap Reason سبب الهالك",
  "Cutter Rework اعادة تشغيل",
  "Cutter Scrap الهالك",
  "Scrap Reason سبب الهالك",
  "MC1 Speed",
  "MC2 Speed",
  "MC3 Speed",
  "MC4 Speed",
  "Packing Rework اعادة تشغيل",
  "Packing Scrap هالك ويفر منطقة التغليف",
  "Scrap Reason سبب الهالك",
  "هالك علب",
  "هالك كرتون",
  "MC1 Waste in Kg",
  "Film Waste% MC1",
  "MC2 Waste in Kg",
  "Film Waste% MC2",
  "MC3 Waste in Kg",
  "Film Waste% MC3",
  "MC4 Waste in Kg",
  "Film Waste% MC4",
  "Overweight%",
  "Scrap kg",
  "Rework%",
  "Scrap%",
  "Rate%",
  "Availability%",
  "Quality%",
  "OEE%",
  "Overweight (Kg)",
  "Cartons",
  "Month",
  "Week",
  "Year"
];
List<String> maamoulHeaders = [
  "Date",
  "القسم",
  "الورديه",
  "عدد ساعات الورديه",
  "اجمالي توقفات الخط بالدقيقة Total line stops in Minutes",
  "نوع الصنف",
  "خط الانتاج",
  "Theoretical Speed rate (kg)/shift",
  "Unit",
  "Production  الانتاج الفعلى",
  "Total Rework اعادة تشغيل",
  "Mixer Rework اعادة تشغيل",
  "Mixer Scrap الهالك",
  "Scrap Reason سبب الهالك",
  "Stamping Rework اعادة تشغيل",
  "Stamping Scrap الهالك",
  "Scrap Reason سبب الهالك",
  "Oven Rework اعادة تشغيل",
  "Oven Scrap هالك الفرن",
  "Scrap Reason سبب الهالك",
  "MC1 Speed",
  "MC2 Speed",
  "MC3 Speed",
  "MC4 Speed",
  "Packing Rework اعادة تشغيل",
  "Packing Scrap هالك معمول منطقة التغليف",
  "Scrap Reason سبب الهالك",
  "هالك علب",
  "هالك كرتون",
  "MC1 Waste in Kg",
  "Film Waste% MC1",
  "MC2 Waste in Kg",
  "Film Waste% MC2",
  "MC3 Waste in Kg",
  "Film Waste% MC3",
  "MC4 Waste in Kg",
  "Film Waste% MC4",
  "Overweight%",
  "Scrap kg",
  "Rework%",
  "Scrap%",
  "Rate%",
  "Availability%",
  "Quality%",
  "OEE%",
  "Overweight (Kg)",
  "Cartons",
  "Month",
  "Week",
  "Year"
];
List<String> totalPlantHeaders = [
  "Date",
  "Plan in Kg",
  "Production in Kg",
  "Production in Cartons",
  "Total line stops in Minutes",
  "Overweight%",
  "Overweight (Kg)",
  "Scrap kg",
  "Scrap%",
  "Rework%",
  "Film Waste%",
  "Rate%",
  "Availability%",
  "Quality%",
  "OEE%",
  "RM MUV",
  "Month",
  "Week",
  "Year"
];

List<String> QfsHeaders = [
  "Date",
  "Quality Incidents",
  "Food Safety Incidents",
  "CCP Failures",
  "Consumer Complaints",
  "G6 Escalation",
  "Pes",
  "Month",
  "Week",
  "Year"
];

List<String> EhsHeaders = [
  "Date",
  "First Aid Incidents",
  "Lost Time Incidents",
  "Recordable Incidents",
  "Near Miss",
  "Pre-shift risk Assessment",
  "S7 Tours",
  "Month",
  "Week",
  "Year"
];
