import 'package:flutter/material.dart';

class AppSetting{
  final String title, subtitle;
  final IconData iconData;
  final void Function()? navigation;
  final void Function()? onTap;

  AppSetting({required this.title, required this.subtitle, required this.iconData, this.navigation, this.onTap});
}