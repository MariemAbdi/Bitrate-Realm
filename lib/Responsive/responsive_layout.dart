import 'package:flutter/material.dart';

class ResponsiveLayout extends StatelessWidget {
  const ResponsiveLayout({Key? key, required this.mobileBody, required this.desktopBody}) : super(key: key);

  final Widget mobileBody;
  final Widget desktopBody;

  static bool isMobile(context)
  {
    return MediaQuery.of(context).size.width < 900;
  }

  @override
  Widget build(BuildContext context) {
    if(isMobile(context)) {
      return mobileBody;
    }else{
      return desktopBody;
    }
  }
}
