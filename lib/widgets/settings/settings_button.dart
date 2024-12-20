import 'package:bitrate_realm/models/app_setting.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../utils/custom_outlined_button.dart';

class SettingsButton extends StatelessWidget {
  const SettingsButton({Key? key, required this.appSetting}) : super(key: key);
  final AppSetting appSetting;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: CustomOutlinedButton(
          onPressed: appSetting.onTap ?? appSetting.navigation,
          child: ListTile(
              leading: Icon(appSetting.iconData, color: Colors.white),
              title: Text(appSetting.title,
                  style: context.textTheme.bodyMedium),
              subtitle: Text(appSetting.subtitle,
                  style: context.textTheme.bodySmall),
              trailing: Visibility(
                visible: appSetting.navigation != null,
                child: const Icon(Icons.arrow_forward_ios,
                    size: 18, color: Colors.white70),
              ))),
    );
  }
}
