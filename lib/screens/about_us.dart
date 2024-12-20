import 'package:bitrate_realm/constants/about_us.dart';
import 'package:bitrate_realm/models/about_us.dart';
import 'package:bitrate_realm/widgets/about%20us/about_us_tab.dart';
import 'package:bitrate_realm/widgets/about%20us/about_us_view.dart';
import 'package:bitrate_realm/widgets/utils/custom_app_bar.dart';
import 'package:bitrate_realm/widgets/utils/custom_list.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:google_fonts/google_fonts.dart';
import 'package:bitrate_realm/translations/locale_keys.g.dart';
import 'package:lottie/lottie.dart';

import '../config/app_style.dart';

class AboutUs extends StatefulWidget {
  const AboutUs({Key? key}) : super(key: key);

  @override
  State<AboutUs> createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> with SingleTickerProviderStateMixin{
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: aboutUsList.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  updateIndex(int index){
    setState(() {
      _tabController.index = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: LocaleKeys.aboutUs.tr(),
      ),
      body: Column(
        children: [
          // Custom TabBar
          AboutUsTab(
              onPressed: updateIndex, currentIndex: _tabController.index),

          // TabBar Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              physics: const NeverScrollableScrollPhysics(),
              children: aboutUsList.map((aboutUsModel) =>
                  AboutUsView(aboutUsModel: aboutUsModel)
              ).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
