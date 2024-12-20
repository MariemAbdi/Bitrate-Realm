import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../translations/locale_keys.g.dart';
import '../utils/leading_app_bar_icon.dart';

class SettingsAppBar extends StatefulWidget implements PreferredSizeWidget{
  const SettingsAppBar({Key? key}) : super(key: key);

  @override
  SettingsAppBarState createState() => SettingsAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class SettingsAppBarState extends State<SettingsAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
        automaticallyImplyLeading: false,
        leading: const LeadingAppBarIcon(),
        title: Text(LocaleKeys.settings.tr())
    );
  }
}
