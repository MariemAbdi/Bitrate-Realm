import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../config/utils.dart';

class NumberCard extends StatelessWidget {
  const NumberCard({Key? key, required this.title, required this.number, this.onTap}) : super(key: key);

  final String title;
  final int number;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: InkWell(
          onTap: onTap,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(formatFollowersNumber(number), style: context.textTheme.displayMedium),
              Text(title, style: context.textTheme.bodySmall)
            ],
          ),
        )
    );
  }
}
