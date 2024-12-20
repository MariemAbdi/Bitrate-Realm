import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../config/app_style.dart';
import '../../constants/spacing.dart';
import '../utils/custom_outlined_button.dart';

class ContactCard extends StatelessWidget {
  const ContactCard({Key? key, required this.title, required this.iconData, required this.onPressed}) : super(key: key);

  final String title;
  final IconData iconData;
  final void Function() onPressed;
  @override
  Widget build(BuildContext context) {
    return CustomOutlinedButton(
      onPressed: onPressed,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Center(
          child: Column(
            children: [
              Container(
                decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: MyThemes.primaryColor
                ),
                padding: const EdgeInsets.all(10),
                child: Icon(iconData, color: Colors.white),
              ),
              kSmallVerticalSpace,
              Text(title, style: Get.textTheme.bodyMedium)
            ],
          ),
        ),
      ),
    );
  }
}
