import 'package:flutter/material.dart';
import 'package:livestream/Responsive/responsive_layout.dart';
import 'package:livestream/Screens/Authentication/authentication_desktop.dart';
import 'package:livestream/Screens/Authentication/authentication_mobile.dart';

import '../../Services/Themes/my_themes.dart';

class RegistrationScreen extends StatelessWidget {
  static String routeName = '/registration';
  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: MyThemes.lightTheme,
      child: const Scaffold(
        body: ResponsiveLayout(
            mobileBody: AuthenticationMobile(isLogin: false),
            desktopBody: AuthenticationDesktop(isLogin: false,)),
      ),
    );
  }
}
