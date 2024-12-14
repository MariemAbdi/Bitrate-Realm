import 'package:flutter/material.dart';

class Responsiveness extends StatelessWidget {
  const Responsiveness({Key? key, required this.mobileBody, required this.desktopBody}) : super(key: key);

  final Widget mobileBody;
  final Widget desktopBody;

  static bool isMobile(context)=>MediaQuery.sizeOf(context).width < 900;

  static double deviceWidth(context) => MediaQuery.sizeOf(context).width;
  static double deviceHeight(context) => MediaQuery.sizeOf(context).height;

  @override
  Widget build(BuildContext context) {
    if(isMobile(context)) {
      return mobileBody;
    }else{
      return desktopBody;
    }
  }
}
