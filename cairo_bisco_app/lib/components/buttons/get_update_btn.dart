import 'package:cairo_bisco_app/classes/values/constants.dart';
import 'package:flutter/material.dart';
import 'package:cairo_bisco_app/classes/values/colors.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:url_launcher/url_launcher.dart';
import 'package:universal_html/html.dart' as html;

class getUpdateButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TextButton(
      child: Text(
        "Get the update",
        style: TextStyle(
          color: KelloggColors.darkRed,
          fontWeight: FontWeight.bold,
        ),
      ),
      onPressed: () async {
        if (!kIsWeb) {
          if (await canLaunch(playStoreLink)) {
            await launch(playStoreLink);
          } else {
            throw 'Could not launch $playStoreLink';
          }
        } else {
          html.window.location.reload();
        }
        // Navigator.of(context).pop();
      },
    );
  }
}
