import 'package:bitrate_realm/config/app_style.dart';
import 'package:bitrate_realm/config/responsiveness.dart';
import 'package:bitrate_realm/constants/spacing.dart';
import 'package:bitrate_realm/services/firebase_auth_services.dart';
import 'package:bitrate_realm/services/livestream_services.dart';
import 'package:bitrate_realm/services/user_services.dart';
import 'package:bitrate_realm/translations/locale_keys.g.dart';
import 'package:bitrate_realm/widgets/profile/cover_photo.dart';
import 'package:bitrate_realm/widgets/profile/number_card.dart';
import 'package:bitrate_realm/widgets/utils/custom_button.dart';
import 'package:bitrate_realm/widgets/utils/leading_app_bar_icon.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;

import '../../config/routing.dart';
import '../../models/user.dart';
import '../../providers/user_provider.dart';
import '../utils/custom_async_builder.dart';
import '../utils/custom_outlined_button.dart';
import '../utils/loading_wrapper.dart';
import '../utils/user_info_tile.dart';

class ProfileHeader extends StatelessWidget {
const ProfileHeader({Key? key, required this.userId}) : super(key: key);

final String userId;
@override
Widget build(BuildContext context) {
  final me = FirebaseAuthServices().user?.email;
  bool isMe = userId == me;
  return SliverAppBar(
    automaticallyImplyLeading: false,
    leading: const LeadingAppBarIcon(),
    actions: isMe ? const [
      CustomOutlinedButton(
          aspectRatio: 1,
          margin: EdgeInsets.all(8),
          onPressed: settingsNavigation,
          child: Icon(Icons.more_vert)
      ),
    ]: null,
    expandedHeight: Responsiveness.deviceHeight(context)*0.9, // Height of the expanded app bar
    floating: true, // AppBar hides when you scroll down
    snap: true,
    flexibleSpace: LoadingWrapper<UserProvider>(
        builder: (context, userProvider){
          return CustomAsyncBuilder(
              future: UserServices().getUserData(userId),
              builder: (context, value){
                UserModel? user = isMe ? userProvider.user : value;
                bool following = !isMe ? (userProvider.user!.following.contains(userId)) : false;

                return SizedBox(
                  height: Responsiveness.deviceHeight(context)*0.9,
                  child: Stack(
                    children: [
                      Positioned.fill(
                          bottom: isMe ? 50 : 80,
                          child: CoverPhoto(photoLink: user!.coverURL)
                      ),

                      Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 30),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                UserInfoTile(
                                    user: user,
                                    isSmall: false
                                ),
                                kVerticalSpace,

                                Text(user.bio, style: Get.textTheme.bodySmall),
                                kVerticalSpace,


                                Visibility(
                                  visible: !isMe,
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: CustomButton(
                                            backgroundColor: following ? Colors.grey.shade700 : MyThemes.primaryColor,
                                            text: following ? "Unfollow" : LocaleKeys.follow.tr(),
                                            iconData: following ? Icons.person_remove : Icons.person_add_alt_rounded,
                                            onPressed: ()=>UserServices().followUnfollow(me!, userId, user.username)
                                        ),
                                      ),
                                      kHorizontalSpace,
                                      Expanded(
                                        child: CustomButton(
                                            text: "Message",
                                            iconData: Icons.chat,
                                            onPressed: ()=> discussionNavigation(user)
                                        ),
                                      )
                                    ],
                                  ),
                                ),

                                kVerticalSpace,

                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    CustomAsyncBuilder(
                                        future: LiveStreamServices().getUserLivesCount(userId),
                                        builder: (context, value){
                                          return NumberCard(
                                            title: "Posts",
                                            number: value!,
                                          );
                                        }
                                    ),

                                    CustomAsyncBuilder(
                                        future: UserServices().getFollowersCount(userId: userId),
                                        builder: (context, value){
                                          return NumberCard(
                                            title: LocaleKeys.following.tr(),
                                            number: value!,
                                            onTap: ()=>followingNavigation(user.email),
                                          );
                                        }
                                    ),

                                    CustomAsyncBuilder(
                                        future: UserServices().getFollowersCount(userId: userId),
                                        builder: (context, value){
                                          return NumberCard(
                                            title: LocaleKeys.followers.tr(),
                                            number: value!,
                                            onTap: ()=>followersNavigation(user.email),
                                          );
                                        }
                                    )
                                  ],
                                )

                              ],
                            ),
                          ))

                    ],
                  ),
                );
              }
          );
        }
    )
  );
}
}
