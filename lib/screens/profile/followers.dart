import 'package:bitrate_realm/services/user_services.dart';
import 'package:bitrate_realm/translations/locale_keys.g.dart';
import 'package:bitrate_realm/widgets/utils/custom_app_bar.dart';
import 'package:bitrate_realm/widgets/utils/custom_list.dart';
import 'package:bitrate_realm/widgets/utils/custom_outlined_button.dart';
import 'package:bitrate_realm/widgets/utils/user_info_tile.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../models/user.dart';
import '../../widgets/utils/custom_async_builder.dart';

class FollowersScreen extends StatelessWidget {
  const FollowersScreen({Key? key, required this.userId}) : super(key: key);

  final String userId;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: LocaleKeys.followers.tr()),
      body: CustomAsyncBuilder(
        future: UserServices().getFollowersDetails(userId: userId),
        builder: (context,  value) {
          List<UserModel> followersList = value!;
          return CustomListView(
              itemCount: followersList.length,
              itemBuilder: (context, index)
              => CustomOutlinedButton(
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.only(bottom: 10),
                child: UserInfoTile(
                  user: followersList[index],
                ),
              )
          );
        }
      ),
    );
  }
}
