import 'package:cairo_bisco_app/classes/SKU.dart';
import 'package:cairo_bisco_app/classes/values/colors.dart';
import 'package:cairo_bisco_app/classes/values/constants.dart';
import 'package:cairo_bisco_app/components/buttons/back_btn.dart';
import 'package:cairo_bisco_app/components/buttons/sku_item.dart';
import 'package:flutter/material.dart';

class ShowSkus extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KelloggColors.white,
      resizeToAvoidBottomInset: true,
      appBar: new AppBar(
        backgroundColor: KelloggColors.white.withOpacity(0),
        shadowColor: KelloggColors.white.withOpacity(0),
        leading: MyBackButton(
          admin: true,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
                padding: const EdgeInsets.all(minimumPadding),
                itemCount: SKU.biscuitSKU.length,
                itemBuilder: (BuildContext context, int index) {
                  return SkuItem(
                    title: SKU.biscuitSKU[index],
                    refNum: BISCUIT_AREA,
                  );
                }),
            ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                padding: const EdgeInsets.all(minimumPadding),
                itemCount: SKU.waferSKU.length,
                physics: ClampingScrollPhysics(),
                itemBuilder: (BuildContext context, int index) {
                  return SkuItem(
                    title: SKU.waferSKU[index],
                    refNum: WAFER_AREA,
                  );
                }),
            ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
                padding: const EdgeInsets.all(minimumPadding),
                itemCount: SKU.maamoulSKU.length,
                itemBuilder: (BuildContext context, int index) {
                  return SkuItem(
                    title: SKU.maamoulSKU[index],
                    refNum: MAAMOUL_AREA,
                  );
                }),
          ],
        ),
      ),
    );
  }
}
