import 'package:bitrate_realm/config/responsiveness.dart';
import 'package:bitrate_realm/constants/spacing.dart';
import 'package:bitrate_realm/widgets/utils/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../config/routing.dart';
import '../../providers/user_provider.dart';
import '../custom_outlined_button.dart';
import '../utils/loading_wrapper.dart';
import '../utils/user_info_tile.dart';

class ProfileHeader extends StatelessWidget {
const ProfileHeader({Key? key}) : super(key: key);

@override
Widget build(BuildContext context) {
  return SliverAppBar(
    automaticallyImplyLeading: false,
    leading: IconButton(
        onPressed: () => Get.back(),
        icon: const Icon(Icons.arrow_back_ios_new)
    ),
    actions: const [
      Padding(
        padding: EdgeInsets.all(8),
        child: CustomOutlinedButton(
            onPressed: settingsNavigation,
            child: Icon(Icons.more_vert)
        ),
      ),
    ],
    expandedHeight: Responsiveness.deviceHeight(context)*0.9, // Height of the expanded app bar
    floating: true, // AppBar hides when you scroll down
    snap: true,
    flexibleSpace: LoadingWrapper<UserProvider>(
      builder: (context, userProvider) => SizedBox(
      height: Responsiveness.deviceHeight(context)*0.9,
      child: Stack(
        children: [
          Positioned.fill(
            bottom: 85,
            child: Image.network(userProvider.user!.coverURL!,
              fit: BoxFit.cover,
            ),
          ),

          Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  children: [
                    const UserInfoTile(isSmall: false),
                    kVerticalSpace,
                    Text(userProvider.user!.bio, style: const TextStyle(color: Colors.white)),
                    kVerticalSpace,
                    Row(
                      children: [
                        Expanded(
                          child: CustomButton(
                              isUppercase: false,
                              text: "Follow",
                              iconData: Icons.person_add_alt_rounded,
                              onPressed: (){}
                          ),
                        ),
                        kHorizontalSpace,
                        Expanded(
                          child: CustomButton(
                              text: "Message",
                              isUppercase: false,
                              iconData: Icons.chat,
                              onPressed: (){}
                          ),
                        )
                      ],
                    ),

                    kVerticalSpace,

                    const Row(
                      children: [
                        Expanded(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text("256k", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 18)),
                                Text("Posts", style: TextStyle(color: Colors.grey, fontSize: 14))
                              ],
                            )
                        ),

                        Expanded(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text("185", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 18)),
                                Text("Following", style: TextStyle(color: Colors.grey, fontSize: 14))
                              ],
                            )
                        ),

                        Expanded(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text("1.2k", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 18)),
                                Text("Followers", style: TextStyle(color: Colors.grey, fontSize: 14))
                              ],
                            )
                        )
                      ],
                    )

                  ],
                ),
              ))

        ],
      ),
    ),
  ));
}
}
