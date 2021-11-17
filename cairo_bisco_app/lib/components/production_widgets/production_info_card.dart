import 'package:cairo_bisco_app/classes/values/colors.dart';
import 'package:cairo_bisco_app/classes/values/constants.dart';
import 'package:cairo_bisco_app/components/special_components/place_holders.dart';
import 'package:flutter/material.dart';

class ProductionInfoCard extends StatelessWidget {
  const ProductionInfoCard({
    Key? key,
    required this.title,
    required this.image,
    required this.amountInKgs,
    required this.numOfCartons,
    required this.background,
  }) : super(key: key);

  final String title, image;
  final double amountInKgs;
  final Color background;
  final int numOfCartons;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
          top: defaultPadding, left: minimumPadding, right: minimumPadding),
      padding: EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        border: Border.all(
            width: 2, color: KelloggColors.cockRed.withOpacity(0.15)),
        borderRadius: const BorderRadius.all(
          Radius.circular(defaultPadding),
        ),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(iconImageBorder), //or 15.0
            child: Container(
              height: regularIconSize,
              width: regularIconSize,
              padding: EdgeInsets.all(minimumPadding / 2),
              color: background,
              child: new Image.asset(
                'images/$image.png',
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title),
                  numOfCartons > -1
                      ? Text(
                          numOfCartons.toString() + " Cartons",
                          style: Theme.of(context)
                              .textTheme
                              .caption!
                              .copyWith(color: KelloggColors.darkRed),
                        )
                      : EmptyPlaceHolder(),
                ],
              ),
            ),
          ),
          Text("Tonnage : " + (amountInKgs / 1000).toStringAsFixed(1) + " T")
        ],
      ),
    );
  }
}
