import 'package:bitrate_realm/config/responsiveness.dart';
import 'package:bitrate_realm/config/routing.dart';
import 'package:bitrate_realm/constants/spacing.dart';
import 'package:bitrate_realm/translations/locale_keys.g.dart';
import 'package:bitrate_realm/widgets/utils/custom_button.dart';
import 'package:bitrate_realm/widgets/utils/loading_wrapper.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;

import '../../providers/user_provider.dart';
import '../utils/custom_outlined_button.dart';
import '../utils/square_image.dart';

class SettingsHeader extends StatelessWidget {
  const SettingsHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LoadingWrapper<UserProvider>(
        builder: (context, userProvider)=>
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: 100,
                  margin: const EdgeInsets.only(bottom: 10),
                  child: CustomOutlinedButton(
                    aspectRatio: 1,
                    child: SquareImage(
                        padding: const EdgeInsets.all(8),
                        photoLink: userProvider.user!.pictureURL
                    ),
                  ),
                ),

                Text(userProvider.user!.username, style: context.textTheme.displayMedium),

                Padding(
                  padding: const EdgeInsets.only(top: 5, bottom: 10),
                  child: Text(userProvider.user!.email, style: context.textTheme.displaySmall?.copyWith(decoration: TextDecoration.none)),
                ),

                SizedBox(
                    width: Responsiveness.deviceWidth(context)/3,
                    child: CustomButton(text: LocaleKeys.editProfile.tr(), onPressed: editProfileNavigation)
                ),
                kVerticalSpace,
              ],
            )
    );
  }
}
