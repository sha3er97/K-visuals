import 'dart:math';

import 'package:cairo_bisco_app/classes/values/colors.dart';
import 'package:cairo_bisco_app/classes/values/constants.dart';
import 'package:cairo_bisco_app/components/buttons/rounded_btn.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SuccessScreen extends StatefulWidget {
  @override
  _SuccessScreenState createState() => _SuccessScreenState();
}

class _SuccessScreenState extends State<SuccessScreen> {
  late ConfettiController _controllerBottomCenter;

  @override
  void initState() {
    ConfettiController(duration: const Duration(seconds: 5));
    _controllerBottomCenter =
        ConfettiController(duration: const Duration(seconds: 10));
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _controllerBottomCenter.play());
    super.initState();
  }

  @override
  void dispose() {
    _controllerBottomCenter.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KelloggColors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _controllerBottomCenter,
              blastDirection: pi / 2,
              maxBlastForce: 3,
              // set a lower max blast force
              minBlastForce: 2,
              emissionFrequency: 0.3,
              minimumSize: const Size(10, 10),
              // set the minimum potential size for the confetti (width, height)
              maximumSize: const Size(20, 20),
              // set the maximum potential size for the confetti (width, height)
              numberOfParticles: 1,
              gravity: 1,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(
              'Congratulations,',
              style: TextStyle(
                  color: KelloggColors.darkRed,
                  fontWeight: FontWeight.w600,
                  fontSize: 27),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(minimumPadding),
            child: Text(
              'Report Submitted',
              style: TextStyle(
                  color: KelloggColors.darkRed,
                  fontWeight: FontWeight.w600,
                  fontSize: 23),
            ),
          ),
          SizedBox(
              height: 200,
              width: 200,
              child: SvgPicture.asset('images/success.svg')),
          Padding(
            padding: const EdgeInsets.all(minimumPadding),
            child: Center(
              child: RoundedButton(
                  btnText: 'Back To Home Page',
                  color: KelloggColors.darkRed,
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                    Navigator.pop(context);
                  }),
            ),
          ),
        ],
      ),
    );
  }
}
