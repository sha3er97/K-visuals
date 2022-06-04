List<String> shifts = <String>['وردية 1 ', 'وردية 2 ', 'وردية 3 '];
List<String> prod_lines4 = <String>['Line 1', 'Line 2', 'Line 3', 'Line 4'];
List<String> prod_lines2 = <String>['Line 1', 'Line 2'];
List<String> Pes = <String>["S", "A", "B", "C"];
List<String> G6 = <String>["Green", "Yellow", "Red"];
List<String> S7 = <String>["Green", "Red"];
List<String> plannedTypes = <String>[
  '-',
  'Scheduled مخطط',
  'Unscheduled غير مخطط'
];
List<String> biscuitsMachines = <String>[
  '-',
  'Dough Mixer عجان العجين 1',
  'Dough Mixer عجان العجين 2',
  'Date Mixer مفرم العجوة',
  'Chocolate Consh كونش الشوكلاتة',
  'Extruder',
  'Oven الفرن',
  'Cutter المنشار',
  'Processing Metal Detector جهاز كشف المعادن التصنيع',
  'Packaging Metal Detector جهاز كشف المعادن التغليف',
  'Conveyor السير',
  'ماكينة الصلاحية Date Coding Machine',
  'الخط بالكامل ALL Line',
];
List<String> waferMachines = <String>[
  '-',
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
  'Cutter المنشار',
  'Pusher الدافع',
  'Packaging Metal Detector جهاز كشف المعادن التغليف',
  'ماكينة الصلاحية Date Coding Machine',
  'الخط بالكامل ALL Line',
];
List<String> maamoulMachines = <String>[
  '-',
  'Dough Mixer عجان العجين 1',
  'Date Mixer مفرم العجوة',
  'Extruder',
  'Stamping التشكيل',
  'Oven الفرن',
  'Packing Machine',
  'Processing Metal Detector جهاز كشف المعادن التصنيع',
  'Packaging Metal Detector جهاز كشف المعادن التغليف',
  'ماكينة الصلاحية Date Coding Machine',
  'الخط بالكامل ALL Line',
];
List<List<String>> allMachines = [
  biscuitsMachines,
  waferMachines,
  maamoulMachines,
  ['-'],
];

List<String> wfCategories = <String>[
  '-',
  'CAPITAL PROJECT المشاريع',
  'CHANGE OVER التغيير',
  'CLEANUP SANITATION التنظيف',
  'Line Downtime توقف الخط',
  'FOOD SAFETY سلامة الغذاء',
  'FUMIGATION التبخير',
  //'HOLIDAY اجازة',
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
List<String> categoriesDefinition = <String>[
  '-',
  'توقف الأنتاج بسبب المشاريع',
  'توقف الأنتاج للتغير من منتج لمنتج ، او من موبينة تغليف لأخرى ، او لتغيير الحبر...الخ',
  'توقف الأنتاج لتنظيف الخط او ماكينة مثل النظافة العميقة او نظافة اغلاق المصنع ..الخ',
  'توقف الأنتاج لسبب ليس بعطل مثل تكريمات العمال، حضور تدريب ، افطار رمضان...الخ',
  'توقف الأنتاج بسبب مشكلة سلامة غذاء مثل تسريبات الأسقف او وجود اجسام بالمنتج',
  'توقف الانتاج لتبخير السايلو',
  //'الأجازات الأسبوعية مثل الجمعات او الأجازات السنوية',
  'توقف الأنتاج لتعطل ماكينة ',
  'توقف الأنتاج لعمل صيانة وقائية لتجنب حدوث عطل بالماكينة',
  'توقف الأنتاج لأنتهاء الخطة',
  'توقف الأنتاج لأشياء تدار من قبل فريق الأنتاج مثل عدم كفاءة المشغل ، تأخير فى التشغيل ، تضارب المواعيد ، بطئ التواصل ، سوء حالات العجين او اى خامة',
  'توقف الإنتاج فى بداية تشغيل الخطوط بينما ينهي الموظفون أعمال التنظيف ، وتجميع المعدات ، وآلات بدء التشغيل',
  'توقف الأنتاج لعمل تجربة على الخط من قسم البحث والتطوير',
  'انقطاع الكهرباء او الغاز او المياه',
  'توقف الأنتاج لعدم وجود خامات',
  'التوقف لعدم وجود عمالة كافية لتشغيل الخط مثل فى حالات الغياب',
  'توقف الأنتاج لتخفيف الخسائر الناتجة عن احوال الطقس مثلاً التوقف خوفاً من الامطار او الرياح',
];
List<String> downTimeTypes = <String>[
  '-',
  'اعطال صيانة',
  'اعطال انتاج',
  'اعطال الجودة و سلامة الغذاء',
  'اعطال سلامة الافراد',
  'اعطال ادارة التخطيط',
  'اعطال مخازن',
  'اعطال قسم البحث و التطوير R&D',
  'اعطال المشروعات',
];
List<String> displayDownTimeTypes = <String>[
  '-',
  'توقفات صيانة',
  'توقفات انتاج',
  'توقفات الجودة و سلامة الغذاء',
  'توقفات سلامة الافراد',
  'توقفات ادارة التخطيط',
  'توقفات مخازن',
  'توقفات قسم البحث و التطوير R&D',
  'توقفات المشروعات',
];
List<String> authorities = <String>[
  '-',
  'Production',
  'Maintenance',
  'Quality',
  'Safety',
  'Other',
];
List<String> y_nDesc = <String>[
  '-', //0
  'Yes نعم', //1
  'No لا', //2
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
