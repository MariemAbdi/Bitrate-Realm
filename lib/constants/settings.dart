import 'package:bitrate_realm/config/routing.dart';
import 'package:bitrate_realm/models/app_setting.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../config/utils.dart';
import '../translations/locale_keys.g.dart';

List<AppSetting> settingsList=[
  AppSetting(
      title: LocaleKeys.language.tr(),
      subtitle: "Select your preferred language",
      iconData: Icons.language,
    onTap: languageSelection
  ),
  AppSetting(
      title: LocaleKeys.aboutUs.tr(),
      subtitle: "Learn more about us",
      iconData: Icons.info,
      navigation: aboutUsNavigation
  ),
  AppSetting(
      title: LocaleKeys.contactUs.tr(),
      subtitle: "Get in touch with us",
      iconData: CupertinoIcons.phone_circle_fill,
      navigation: contactUsNavigation
  ),
  AppSetting(
      title: "Privacy",
      subtitle: "View our privacy policy",
      iconData: CupertinoIcons.phone_circle_fill,
      navigation: privacyPolicyNavigation
  ),
  AppSetting(
      title: LocaleKeys.rateUs.tr(),
      subtitle: "Rate the app with stars",
      iconData: CupertinoIcons.star_circle_fill,
      onTap: ratingBottomSheet
  ),
  AppSetting(
      title: LocaleKeys.logout.tr(),
      subtitle: "Log out of your account",
      iconData: CupertinoIcons.power,
      onTap: signOutPopUp
  )
];