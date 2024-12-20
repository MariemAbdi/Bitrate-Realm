import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LeadingAppBarIcon extends StatelessWidget {
  const LeadingAppBarIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () => Get.back(),
        icon: const Icon(Icons.arrow_back_ios_new)
    );
  }
}
