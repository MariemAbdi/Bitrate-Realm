import 'package:bitrate_realm/screens/chat/chat.dart';
import 'package:crystal_navigation_bar/crystal_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:bitrate_realm/screens/live/go_live_screen.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../screens/discover.dart';
import '../screens/home.dart';

final navigationScreens=[
  const HomeScreen(),
  const DiscoverScreen(),
  const ChatScreen(),
  const GoLiveScreen(),
];

List<CrystalNavigationBarItem> navigationDestinations =[
  CrystalNavigationBarItem(
      icon: Icons.home
  ),
  CrystalNavigationBarItem(
    icon: Icons.search
  ),
  CrystalNavigationBarItem(
      icon: Icons.chat
  ),
  CrystalNavigationBarItem(
      icon: FontAwesomeIcons.headset
  ),
];