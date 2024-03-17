import 'package:flutter/material.dart';
import 'package:code_wizard/constants/app_colors.dart';

class PriceText extends StatelessWidget {
  const PriceText({
    Key? key,
    required this.price,
    this.color = AppColors.secondaryAccent,
  }) : super(key: key);

  final int price;
  final Color color;

  @override
  Widget build(BuildContext context) {
    var colorToUse =
        MediaQuery.of(context).platformBrightness == Brightness.light
            ? color
            : AppColors.primaryWhiteColor;
    return Row(
      children: [
        Text(
          'EAN',
          style: Theme.of(context)
              .textTheme
              .headline3!
              .copyWith(color: colorToUse),
        ),
        Container(
          margin: EdgeInsets.only(bottom: 12, left: 0),
          child: Text('13',
              style: Theme.of(context)
                  .textTheme
                  .headline3!
                  .copyWith(color: colorToUse, fontSize: 16)),
        ),
      ],
    );
  }
}
