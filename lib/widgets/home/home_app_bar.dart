import 'package:flutter/material.dart';
import 'package:bitrate_realm/config/routing.dart';
import 'package:bitrate_realm/widgets/custom_outlined_button.dart';

import '../../providers/user_provider.dart';
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
        onTap: profileNavigation,
        child: Container(
          padding: const EdgeInsets.fromLTRB(8,8,0,8),
          margin: const EdgeInsets.only(left: 10),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: AspectRatio(
              aspectRatio: 1,
              child: Image.network(
                  userProvider.user!.pictureURL!,
                height: 40,
                width: 40,
                fit: BoxFit.cover, // Ensures the image covers the area without exceeding
              ),
            )
          ),
        ),
      ),
      title: Row(
        ///The title property of AppBar does not accept Expanded directly because it is not a Flex widget (like Row or Column)
        children: [
          Expanded(
            child: Text(
              userProvider.user!.username,
            ),
          ),
        ],
      ),
      actions: const [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: CustomOutlinedButton(
              child: Icon(Icons.search)
          ),
        ),
        Padding(
          padding: EdgeInsets.all(8),
          child: CustomOutlinedButton(
              child: Icon(Icons.notifications)
          ),
        ),
      ],
    ));
  }
}
