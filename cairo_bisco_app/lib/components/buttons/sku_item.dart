import 'package:cairo_bisco_app/classes/values/colors.dart';
import 'package:cairo_bisco_app/classes/values/constants.dart';
import 'package:cairo_bisco_app/ui/admin_screens/admin_edit_sku.dart';
import 'package:flutter/material.dart';

class SkuItem extends StatelessWidget {
  SkuItem({
    required this.refNum,
    required this.title,
    // required this.param_onPressed,
    // required this.btn_icon,
  });

  final String title;
  final int refNum;

  // final VoidCallback param_onPressed;
  // final IconData btn_icon;

  @override
  Widget build(BuildContext context) {
    Color gradientColor1 = refNum == BISCUIT_AREA
        ? KelloggColors.yellow
        : refNum == WAFER_AREA
            ? KelloggColors.green
            : KelloggColors.darkRed;
    Color gradientColor2 = KelloggColors.grey;
    Color mainColor = KelloggColors.darkBlue.withOpacity(0.3);
    return Padding(
      padding: const EdgeInsets.all(minimumPadding),
      child: Center(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(BoxImageBorder),
          child: ConstrainedBox(
            constraints: BoxConstraints.tightFor(
                width: TightBoxWidth, height: regularBoxHeight),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment(0.99, 0.0),
                  // 10% of the width, so there are ten blinds.
                  colors: [gradientColor1, gradientColor2],
                  // red to yellow
                  tileMode:
                      TileMode.repeated, // repeats the gradient over the canvas
                ),
              ),
              child: ElevatedButton(
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 3,
                  style: TextStyle(
                    fontSize: aboveMediumFontSize,
                    fontFamily: 'MyFont',
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(
                      horizontal: defaultPadding, vertical: minimumPadding),
                  primary: mainColor,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AdminEditSku(
                        refNum: refNum,
                        skuName: title,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
