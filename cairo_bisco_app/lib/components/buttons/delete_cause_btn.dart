import 'package:cairo_bisco_app/classes/values/colors.dart';
import 'package:flutter/material.dart';

import '../../classes/RootCause.dart';

class deleteCauseBtn extends StatelessWidget {
  deleteCauseBtn({
    required this.type,
    required this.cause,
  });

  final String cause, type;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      child: Text(
        "Delete",
        style: TextStyle(
          color: KelloggColors.cockRed,
          fontWeight: FontWeight.bold,
        ),
      ),
      onPressed: () {
        RootCause.deleteCause(context, type, cause);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Cause Deleted"),
        ));
        Navigator.of(context).pop();
      },
    );
  }
}
