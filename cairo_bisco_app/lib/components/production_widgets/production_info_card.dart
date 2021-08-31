import 'package:cairo_bisco_app/components/values/colors.dart';
import 'package:cairo_bisco_app/components/values/constants.dart';
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

  final String title, image, amountInKgs;
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
            width: 2, color: KelloggColors.clearRed.withOpacity(0.15)),
        borderRadius: const BorderRadius.all(
          Radius.circular(defaultPadding),
        ),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10.0), //or 15.0
            child: Container(
              height: 40.0,
              width: 40.0,
              padding: EdgeInsets.all(minimumPadding / 2),
              color: background,
              child: new Image.asset(
                'images/$image.png',
              ),
            ),
          ),
          // SizedBox(
          //   height: 25,
          //   width: 25,
          //   child:
          // CircleAvatar(
          //   backgroundColor: KelloggColors.yellow,
          //   radius: 20,
          //   child: new Image.asset(
          //     'images/$image.png',
          //   ),
          // ), //Text
          // new Image.asset(
          //   'images/$image.png',
          // ),
          // SvgPicture.asset(svgSrc),
          // ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    "$numOfCartons Cartons",
                    style: Theme.of(context)
                        .textTheme
                        .caption!
                        .copyWith(color: KelloggColors.darkRed),
                  ),
                ],
              ),
            ),
          ),
          Text("$amountInKgs")
        ],
      ),
    );
  }
}
