import 'package:bitrate_realm/config/routing.dart';
import 'package:bitrate_realm/services/firebase_auth_services.dart';
import 'package:bitrate_realm/services/user_services.dart';
import 'package:bitrate_realm/translations/locale_keys.g.dart';
import 'package:bitrate_realm/widgets/utils/square_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:substring_highlight/substring_highlight.dart';

import '../../config/utils.dart';
import '../../models/user.dart';
import 'custom_async_builder.dart';

class UserInfoTile extends StatelessWidget {
  const UserInfoTile({Key? key, this.isSmall = true, required this.user, this.goToProfile = true, this.searchedTerm}) : super(key: key);

  final UserModel user;
  final bool isSmall, goToProfile;
  final String? searchedTerm;
  @override
  Widget build(BuildContext context) {
    bool isMe = FirebaseAuthServices().user?.email == user.email ;
    return ListTile(
      dense: isSmall,
      contentPadding: EdgeInsets.zero,
      visualDensity: const VisualDensity(vertical: -4), // Reduces vertical spacing
      onTap: ()=> !isMe & goToProfile ? profileNavigation(user.email) : discussionNavigation(user),
      leading: SquareImage(photoLink: user.pictureURL),
      title: searchedTerm!=null
          ? SubstringHighlight(
        text: isSmall && isMe ? "You" : user.username,
        term: searchedTerm,
        overflow: TextOverflow.ellipsis,
        textStyle: context.textTheme.labelSmall!.copyWith(fontSize: isSmall ? 14 : 20),
      )
          :Text(isSmall && isMe ? "You" : user.username,
          style: context.textTheme.labelSmall?.copyWith(
            overflow: TextOverflow.ellipsis,
            fontSize: isSmall ? 14 : 20
          )
      ),
      subtitle: CustomAsyncBuilder(
          future: UserServices().getFollowersCount(userId: user.email),
          builder: (context, value){
            return Text("${formatFollowersNumber(value!)} ${LocaleKeys.followers.tr()}",
                style: context.textTheme.bodySmall?.copyWith(fontSize: isSmall ? 10 : 14));
          }
      ),
    );
  }
}
