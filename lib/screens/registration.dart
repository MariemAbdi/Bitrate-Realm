import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../widgets/authentication/signup_form.dart';
import '../config/responsiveness.dart';
import '../config/routing.dart';
import '../../widgets/authentication/auth_desktop.dart';
import '../../widgets/authentication/auth_mobile.dart';
import '../../translations/locale_keys.g.dart';

class RegistrationScreen extends StatelessWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String title = LocaleKeys.alredayamember.tr();
    String buttonText = LocaleKeys.signinnow.tr();
    return Scaffold(
      body: Responsiveness(
        mobileBody: const AuthMobile(formWidget: SignupForm()),
        desktopBody: AuthDesktop(
              title: title,
              formWidget: const SignupForm(),
              buttonText: buttonText,
              onPressed: loginNavigation
          ),
    ),
        );
  }
}
