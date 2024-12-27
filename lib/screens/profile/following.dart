import 'package:bitrate_realm/widgets/utils/custom_outlined_button.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../models/user.dart';
import '../../services/user_services.dart';
import '../../translations/locale_keys.g.dart';
import '../../widgets/utils/custom_app_bar.dart';
import '../../widgets/utils/custom_async_builder.dart';
import '../../widgets/utils/custom_list.dart';
import '../../widgets/utils/user_info_tile.dart';

class FollowingScreen extends StatelessWidget {
  const FollowingScreen({Key? key, required this.userId}) : super(key: key);

  final String userId;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: LocaleKeys.following.tr()),
      body: CustomAsyncBuilder(
          future: UserServices().getFollowersDetails(userId: userId, getFollowers: false),
          builder: (context,  value) {
            List<UserModel> followingList = value!;
            return CustomListView(
                itemCount: followingList.length,
                itemBuilder: (context, index)
                => CustomOutlinedButton(
                  padding: const EdgeInsets.all(16),
                  margin: const EdgeInsets.only(bottom: 10),
                  child: UserInfoTile(
                    user: followingList[index],
                  ),
                )
            );
          }
      ),
    );
  }
}
