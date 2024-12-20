import 'package:bitrate_realm/config/utils.dart';
import 'package:bitrate_realm/models/app_setting.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../utils/custom_outlined_button.dart';

class ContactInfoCard extends StatelessWidget {
  const ContactInfoCard({Key? key, required this.contactInfo}) : super(key: key);

  final AppSetting contactInfo;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: CustomOutlinedButton(
        child: ListTile(
          leading: Icon(contactInfo.iconData, color: Colors.white),
          title: Text(contactInfo.title, style: Get.textTheme.bodyMedium),
          subtitle: Text(contactInfo.subtitle, style: Get.textTheme.bodySmall),
          trailing: IconButton(
            onPressed: ()=>copyToClipboard(contactInfo.subtitle),
            icon: const Icon(Icons.copy, color: Colors.white70),
          ),
        ),
      ),
    );
  }
}
