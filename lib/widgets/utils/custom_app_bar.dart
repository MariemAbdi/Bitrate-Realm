import 'package:bitrate_realm/widgets/utils/leading_app_bar_icon.dart';
import 'package:flutter/material.dart';


class CustomAppBar extends StatelessWidget implements PreferredSizeWidget{
  final String title;
  final bool canGoBack;
  const CustomAppBar({Key? key, required this.title, this.canGoBack = true}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: canGoBack,
      leading: canGoBack ? const LeadingAppBarIcon() : null,
      titleTextStyle: AppBarTheme.of(context).titleTextStyle?.copyWith(
        fontSize: 16
      ),
      title: Text(title),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
