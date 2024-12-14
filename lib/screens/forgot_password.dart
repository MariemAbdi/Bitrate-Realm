import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:livestream/widgets/authentication/auth_desktop.dart';
import 'package:livestream/widgets/authentication/auth_mobile.dart';
import 'package:livestream/widgets/authentication/reset_password_form.dart';
import 'package:livestream/config/responsiveness.dart';
import 'package:livestream/config/routing.dart';

import '../translations/locale_keys.g.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  @override
  Widget build(BuildContext context) {
    String title = LocaleKeys.signinnow.tr();
    String buttonText = LocaleKeys.signinnow.tr();

    return Scaffold(
      body: Responsiveness(
          mobileBody: const AuthMobile(formWidget: ResetPasswordForm()),
          desktopBody: AuthDesktop(
              title: title,
              formWidget: const ResetPasswordForm(),
              buttonText: buttonText,
              onPressed: loginNavigation
          )),
    );
  }
}
