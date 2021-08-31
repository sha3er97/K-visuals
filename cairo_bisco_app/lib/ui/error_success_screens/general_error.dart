import 'package:cairo_bisco_app/components/buttons/rounded_btn.dart';
import 'package:cairo_bisco_app/components/values/colors.dart';
import 'package:flutter/material.dart';

class GeneralErrorScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            "images/error_screens/7_Error.png",
            fit: BoxFit.cover,
          ),
          Positioned(
            bottom: MediaQuery.of(context).size.height * 0.15,
            left: MediaQuery.of(context).size.width * 0.3,
            right: MediaQuery.of(context).size.width * 0.3,
            child: Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    offset: Offset(0, 13),
                    blurRadius: 25,
                    color: KelloggColors.grey.withOpacity(0.17),
                  ),
                ],
              ),
              child: RoundedButton(
                color: KelloggColors.darkRed,
                onPressed: () {
                  Navigator.pop(context);
                },
                btnText: "retry".toUpperCase(),
              ),
            ),
          )
        ],
      ),
    );
  }
}
