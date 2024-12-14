import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:livestream/config/app_style.dart';
import 'package:livestream/screens/Going%20Live/go_live_screen.dart';

import '../screens/discover_screen.dart';
import '../screens/home.dart';
import '../translations/locale_keys.g.dart';

final navigationScreens=[
  const HomeScreen(),
  const DiscoverScreen(),
  const HomeScreen(),
  const GoLiveScreen(),
];

List<Widget> navigationDestinations =[
  const NavigationDestination(
      icon: Icon(Icons.home),
      label: "Home"
  ),
  NavigationDestination(
    icon: const Icon(Icons.list_alt),
    label: LocaleKeys.discover.tr(),
  ),
  const NavigationDestination(
      icon: Icon(Icons.chat),
      label: "Chat"
  ),
  const NavigationDestination(
      icon: Icon(Icons.live_tv),
      label: "Live"
  ),
];