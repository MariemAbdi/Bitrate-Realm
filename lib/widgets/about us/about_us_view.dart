import 'package:bitrate_realm/constants/spacing.dart';
import 'package:bitrate_realm/models/about_us.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class AboutUsView extends StatelessWidget {
  const AboutUsView({Key? key, required this.aboutUsModel}) : super(key: key);

  final AboutUsModel aboutUsModel;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          //------------------------LOTTIE ASSET------------------------
          Lottie.asset(aboutUsModel.lottieLink,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height*0.3),

          //------------------------TITLE------------------------
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(aboutUsModel.title, style: context.textTheme.displayMedium?.copyWith(fontSize: 30), textAlign: TextAlign.center),
          ),
          kVerticalSpace,

          //------------------------BODY------------------------
          Text(aboutUsModel.content, style: context.textTheme.bodyMedium?.copyWith(fontSize: 15), textAlign: TextAlign.justify),
        ],
      ),
    );
  }
}
