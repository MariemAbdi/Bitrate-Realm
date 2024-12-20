import 'package:bitrate_realm/constants/settings.dart';
import 'package:bitrate_realm/models/app_setting.dart';
import 'package:bitrate_realm/widgets/settings/settings_app_bar.dart';
import 'package:bitrate_realm/widgets/settings/settings_button.dart';
import 'package:bitrate_realm/widgets/settings/settings_header.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      appBar: const SettingsAppBar(),
        body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SettingsHeader(),
            for(AppSetting appSetting in settingsList)
              SettingsButton(appSetting: appSetting)
          ],
        ),
      ),
    );
  }
}