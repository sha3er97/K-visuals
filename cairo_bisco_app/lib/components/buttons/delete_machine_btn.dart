import 'package:cairo_bisco_app/classes/Machine.dart';
import 'package:cairo_bisco_app/classes/values/colors.dart';
import 'package:flutter/material.dart';

class deleteMachineBtn extends StatelessWidget {
  deleteMachineBtn({required this.name});

  final String name;

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
        Machine.deleteMachine(context, name);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Name Deleted"),
        ));
        Navigator.of(context).pop();
      },
    );
  }
}
