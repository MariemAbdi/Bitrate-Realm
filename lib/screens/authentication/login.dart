import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../config/responsiveness.dart';
import '../../config/routing.dart';
import '../../translations/locale_keys.g.dart';
import '../../widgets/authentication/auth_desktop.dart';
import '../../widgets/authentication/auth_mobile.dart';
import '../../widgets/authentication/login_form.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    String title = LocaleKeys.joinourrealm.tr();
    String buttonText = LocaleKeys.signupnow.tr();
    return PopScope(
        canPop: false,
        child: Scaffold(
          resizeToAvoidBottomInset: false,
        body: Responsiveness(
          mobileBody: const AuthMobile(formWidget: LoginForm()),
          desktopBody: AuthDesktop(
              title: title,
              formWidget: const LoginForm(),
              buttonText: buttonText,
              onPressed: signUpNavigation
    ),
        )
    ));
  }
}
