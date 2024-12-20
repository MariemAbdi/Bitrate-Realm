import 'package:bitrate_realm/models/app_setting.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../translations/locale_keys.g.dart';

List<AppSetting> contactUsInformation=[
  AppSetting(
      title: LocaleKeys.phone.tr(),
      subtitle: "+216 23 456 789",
      iconData: Icons.phone_android
  ),
  AppSetting(
      title: LocaleKeys.fax.tr(),
      subtitle: "+216 79 456 789",
      iconData: Icons.fax
  ),
  AppSetting(
      title: LocaleKeys.email.tr(),
      subtitle: "bitrate.realm@isetr.tn",
      iconData: Icons.email
  ),
  AppSetting(
      title: LocaleKeys.address.tr(),
      subtitle: "ISET RADES",
      iconData: Icons.map
  )
];
