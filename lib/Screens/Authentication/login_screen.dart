import 'package:flutter/material.dart';
import 'package:livestream/Screens/Authentication/authentication_desktop.dart';
import 'package:livestream/Screens/Authentication/authentication_mobile.dart';
import 'package:livestream/Responsive/responsive_layout.dart';

import '../../Services/Themes/my_themes.dart';

class LoginScreen extends StatefulWidget {
  static String routeName = '/login';
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async => false,
        child: Theme(
          data: MyThemes.lightTheme,
          child: const Scaffold(
            resizeToAvoidBottomInset: false,
          body: ResponsiveLayout(
              mobileBody: AuthenticationMobile(isLogin: true,),
              desktopBody: AuthenticationDesktop(isLogin: true,)),
      ),
        )
    );
  }
}
