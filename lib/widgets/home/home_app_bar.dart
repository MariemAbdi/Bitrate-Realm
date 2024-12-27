import 'package:bitrate_realm/widgets/utils/square_image.dart';
import 'package:flutter/material.dart';
import 'package:bitrate_realm/config/routing.dart';

import '../../providers/user_provider.dart';
import '../utils/custom_outlined_button.dart';
import '../utils/loading_wrapper.dart';

class HomeAppBar extends StatefulWidget implements PreferredSizeWidget{
  const HomeAppBar({Key? key}) : super(key: key);

  @override
  HomeAppBarState createState() => HomeAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class HomeAppBarState extends State<HomeAppBar> {
  @override
  Widget build(BuildContext context) {
    return LoadingWrapper<UserProvider>(
        builder: (context, userProvider) => AppBar(
      automaticallyImplyLeading: false,
      leading: InkWell(
        onTap: ()=>profileNavigation(userProvider.user!.email),
        child: Container(
            padding: const EdgeInsets.fromLTRB(8,8,0,8),
            margin: const EdgeInsets.only(left: 10),
            child: SquareImage(photoLink: userProvider.user?.pictureURL)
        ),
      ),
      title: Row(
        ///The title property of AppBar does not accept Expanded directly because it is not a Flex widget (like Row or Column)
        children: [
          Expanded(
            child: Text(
              "Hello,\n${userProvider.user?.username ?? ""}",
            ),
          ),
        ],
      ),
      actions: const [
        CustomOutlinedButton(
            aspectRatio: 1,
            margin: EdgeInsets.all(8),
            onPressed: notificationsNavigation,
            child: Icon(Icons.notifications)
        ),
      ],
    ));
  }
}
