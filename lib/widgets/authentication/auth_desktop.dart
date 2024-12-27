// Import the new library for web-specific APIs
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bitrate_realm/constants/spacing.dart';
import 'package:rive/rive.dart';

import '../../config/assets_paths.dart';
import '../../config/responsiveness.dart';
import '../utils/custom_button.dart';

class AuthDesktop extends StatelessWidget {
  const AuthDesktop({Key? key, required this.title, required this.formWidget, required this.buttonText, required this.onPressed}) : super(key: key);

  final String title, buttonText;
  final Widget formWidget;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        //---------------------------- THE LEFT SIDE ----------------------------
        Expanded(
            child: Stack(
              children: [
                Positioned(
                  left: 100,
                  bottom: 100,
                  child: Image.asset(AssetsPaths.splineImage),
                ),
                Positioned.fill(
                  child: BackdropFilter(
                    filter: ui.ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                    child: const SizedBox(),
                  ),
                ),
                RiveAnimation.asset(AssetsPaths.riveShapes,
                  fit: BoxFit.cover,
                ),
                Positioned.fill(
                  child: BackdropFilter(
                    filter: ui.ImageFilter.blur(sigmaX: 30, sigmaY: 30),
                    child: const SizedBox(),
                  ),
                ),
                Positioned(
                  top: 50,
                  left: 50,
                  height: Responsiveness.deviceHeight(context),
                  width: Responsiveness.deviceWidth(context),
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Spacer(),

                          SizedBox(
                            width: 350,
                            child: Text(
                                title,
                                style: context.textTheme.headlineLarge
                            ),
                          ),

                          kVerticalSpace,

                          //REGISTRATION | LOGIN BUTTON
                          SizedBox(
                              width: 200,
                              height: 50,
                              child: CustomButton(
                                  text: buttonText,
                                  isUppercase: true,
                                  onPressed: onPressed
                              )
                          ),

                          const Spacer(flex: 2),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            )),

        //---------------------------- THE RIGHT SIDE----------------------------
        Expanded(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 50),
                child: formWidget,
              ),
            )),
      ],
    );
  }
}
