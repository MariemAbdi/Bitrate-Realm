import 'dart:ui';

import 'package:bitrate_realm/config/app_style.dart';
import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

import '../../config/responsiveness.dart';

class AuthMobile extends StatelessWidget {
const AuthMobile({Key? key, required this.formWidget}) : super(key: key);
final Widget formWidget;
@override
Widget build(BuildContext context) {
return Stack(
  children: [
    Positioned(
      width: Responsiveness.deviceWidth(context) * 1.7,
      left: 100,
      bottom: 100,
      child: Image.asset("assets/images/Spline.png",),
    ),
    Positioned.fill(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: const SizedBox(),
      ),
    ),
    const RiveAnimation.asset("assets/rive/shapes.riv",),
    Positioned.fill(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
        child: const SizedBox(),
      ),
    ),
    Positioned(
      top:  0,
      height: Responsiveness.deviceHeight(context),
      width: Responsiveness.deviceWidth(context),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(20)),
                      color: MyThemes.secondaryColor,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.8),
                          spreadRadius: 3,
                          blurRadius: 7,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: formWidget
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ),
  ],
);
}
}
