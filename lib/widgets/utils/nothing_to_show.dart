import 'package:bitrate_realm/translations/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;

class NothingToShow extends StatelessWidget {
  const NothingToShow({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(LocaleKeys.nothingToShow.tr(), style: context.textTheme.headlineSmall),
    );
  }
}
