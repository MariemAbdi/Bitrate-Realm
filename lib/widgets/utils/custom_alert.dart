import 'package:bitrate_realm/models/alert_data.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:lottie/lottie.dart';

import '../../constants/spacing.dart';
import '../../translations/locale_keys.g.dart';
import 'custom_button.dart';

class CustomAlert extends StatelessWidget {
  const CustomAlert({Key? key, required this.alertData}) : super(key: key);

  final AlertData alertData;
  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Top Half: Lottie Animation
            Lottie.asset(
                alertData.lottieAsset,
                repeat: true,
                height: 150
            ),

            // // Middle: Title and Description
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    alertData.title,
                    style: context.textTheme.displayMedium,
                  ),
                  Text(
                    alertData.description,
                    style: context.textTheme.bodySmall,
                  ),
                ],
              ),
            ),

            // Bottom Half: Buttons
            Row(
              children: [
                Expanded(
                  child: CustomButton(
                    backgroundColor: Colors.grey.shade600,
                    onPressed: () => Get.back(),
                    text: LocaleKeys.cancel.tr(),
                  ),
                ),
                kHorizontalSpace,
                Expanded(
                  child: CustomButton(
                    onPressed: alertData.onConfirm,
                    text: LocaleKeys.done.tr(),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
