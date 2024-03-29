import 'package:cairo_bisco_app/components/buttons/back_btn.dart';
import 'package:cairo_bisco_app/components/buttons/line_num_btn.dart';
import 'package:cairo_bisco_app/classes/values/colors.dart';
import 'package:cairo_bisco_app/classes/values/constants.dart';
import 'package:cairo_bisco_app/components/special_components/place_holders.dart';
import 'package:flutter/material.dart';

class FloorChooseLine extends StatelessWidget {
  FloorChooseLine({
    Key? key,
    required this.type,
  }) : super(key: key);

  final String type;

  @override
  Widget build(BuildContext context) {
    bool isMaamoul = type.compareTo(prodType[MAAMOUL_AREA]) == 0;
    Color gradientColor1 = type.compareTo(prodType[BISCUIT_AREA]) == 0
        ? KelloggColors.orange
        : type.compareTo(prodType[WAFER_AREA]) == 0
            ? KelloggColors.cockRed
            : KelloggColors.grey;
    Color gradientColor2 = type.compareTo(prodType[BISCUIT_AREA]) == 0
        ? KelloggColors.yellow
        : type.compareTo(prodType[WAFER_AREA]) == 0
            ? KelloggColors.grey
            : KelloggColors.cockRed;
    Color mainColor = type.compareTo(prodType[BISCUIT_AREA]) == 0
        ? KelloggColors.yellow.withOpacity(0.5)
        : type.compareTo(prodType[WAFER_AREA]) == 0
            ? KelloggColors.green.withOpacity(0.5)
            : KelloggColors.cockRed.withOpacity(0.5);
    return Scaffold(
      backgroundColor: KelloggColors.white,
      resizeToAvoidBottomInset: true,
      appBar: new AppBar(
        backgroundColor: KelloggColors.white.withOpacity(0),
        shadowColor: KelloggColors.white.withOpacity(0),
        leading: MyBackButton(
          color: KelloggColors.darkRed,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              LineNumButton(
                gradientColor1: gradientColor1,
                gradientColor2: gradientColor2,
                mainColor: mainColor,
                type: type,
                lineNum: 1,
              ),
              LineNumButton(
                gradientColor1: gradientColor1,
                gradientColor2: gradientColor2,
                mainColor: mainColor,
                type: type,
                lineNum: 2,
              ),
              !isMaamoul
                  ? LineNumButton(
                      gradientColor1: gradientColor1,
                      gradientColor2: gradientColor2,
                      mainColor: mainColor,
                      type: type,
                      lineNum: 3,
                    )
                  : EmptyPlaceHolder(),
              !isMaamoul
                  ? LineNumButton(
                      gradientColor1: gradientColor1,
                      gradientColor2: gradientColor2,
                      mainColor: mainColor,
                      type: type,
                      lineNum: 4,
                    )
                  : EmptyPlaceHolder(),
              LineNumButton(
                gradientColor1: gradientColor1,
                gradientColor2: gradientColor2,
                mainColor: mainColor,
                type: type,
                lineNum: -1,
              ),
            ]),
      ),
    );
  }
}
