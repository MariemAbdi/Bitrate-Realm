import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart' hide Trans;
import 'package:livestream/config/routing.dart';
import 'package:provider/provider.dart';

import '../../constants/spacing.dart';
import '../../services/firebase_auth_services.dart';
import '../../config/app_style.dart';
import '../../config/responsiveness.dart';
import '../../translations/locale_keys.g.dart';
import '../utils/custom_button.dart';

class GoogleSignIn extends StatelessWidget {
  const GoogleSignIn({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        kVerticalSpace,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [

            const Expanded(
              child: Divider(
                color: Colors.black,
              ),
            ),

            kHorizontalSpace,

            Text(
              LocaleKeys.or.tr(),
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
            ),

            kHorizontalSpace,

            const Expanded(
              child: Divider(
                color: Colors.black,
              ),
            ),
          ],
        ),

        kVerticalSpace,

        CustomButton(
            text: LocaleKeys.loginwithgoogle.tr(),
            onPressed: () => context.read<FirebaseAuthServices>().signInWithGoogle(context),
          backgroundColor: MyThemes().googleColor,
          isUppercase: false,
          iconData: FontAwesomeIcons.googlePlusG,
        ),

        kVerticalSpace,

        Visibility(
          visible: Responsiveness.isMobile(context),
            child: FittedBox(
              child: TextButton(
                onPressed: loginNavigation,
                child: Text(
                    LocaleKeys.alreadyamembersigninnow.tr(),
                    style: context.textTheme.displaySmall?.copyWith(fontSize: 16)
                ),
              ),
            ),
        )
      ],
    );
  }
}
