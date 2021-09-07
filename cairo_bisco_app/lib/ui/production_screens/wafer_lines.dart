import 'package:cairo_bisco_app/components/production_widgets/scroll_production_line.dart';
import 'package:cairo_bisco_app/classes/values/colors.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class WaferLines extends StatefulWidget {
  @override
  _WaferLinesState createState() => _WaferLinesState();
}

class _WaferLinesState extends State<WaferLines> {
  String productName = 'MAMUL معمول';

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: false,
      child: DefaultTabController(
        // The number of tabs / content sections to display.
        length: 5,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: KelloggColors.green,
            bottom: TabBar(
              tabs: [
                Tab(
                  // icon: Icon(Icons.directions_car),
                  text: "Line 1",
                ),
                Tab(
                  // icon: Icon(Icons.directions_car),
                  text: "Line 2",
                ),
                Tab(
                  // icon: Icon(Icons.directions_car),
                  text: "Line 3",
                ),
                Tab(
                  // icon: Icon(Icons.directions_car),
                  text: "Line 4",
                ),
                Tab(
                  // icon: Icon(Icons.directions_car),
                  text: "Total",
                ),
              ],
            ),
          ),
          resizeToAvoidBottomInset: true,
          backgroundColor: KelloggColors.white,
          body: TabBarView(
            children: [
              SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                        child: ProductionLine(
                      cartons: 5.3,
                      oee: 53.3,
                      scrap: 5.3,
                      overweight: 0.5,
                      filmWaste: 5.3,
                      targetProd: 5.1,
                      money: 4.3,
                      productName: productName,
                    )),
                  ],
                ),
              ),
              SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                        child: ProductionLine(
                      cartons: 5.3,
                      oee: 53.3,
                      money: 4.3,
                      scrap: 5.3,
                      overweight: 0.5,
                      filmWaste: 5.3,
                      targetProd: 5.1,
                      productName: productName,
                    )),
                  ],
                ),
              ),
              SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                        child: ProductionLine(
                      cartons: 5.3,
                      oee: 53.3,
                      scrap: 5.3,
                      overweight: 0.5,
                      filmWaste: 5.3,
                      targetProd: 5.1,
                      money: 4.3,
                      productName: productName,
                    )),
                  ],
                ),
              ),
              SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                        child: ProductionLine(
                      cartons: 5.3,
                      oee: 53.3,
                      scrap: 5.3,
                      overweight: 0.5,
                      filmWaste: 5.3,
                      money: 4.3,
                      targetProd: 5.1,
                      productName: productName,
                    )),
                  ],
                ),
              ),
              SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                        child: ProductionLine(
                      cartons: 5.3,
                      oee: 53.3,
                      scrap: 5.3,
                      overweight: 0.5,
                      filmWaste: 5.3,
                      targetProd: 5.1,
                      money: 4.3,
                      productName: productName,
                    )),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
