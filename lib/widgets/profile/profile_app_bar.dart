import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:livestream/config/routing.dart';
import 'package:livestream/widgets/custom_outlined_button.dart';

class ProfileAppBar extends StatefulWidget implements PreferredSizeWidget{
  const ProfileAppBar({Key? key}) : super(key: key);

  @override
  ProfileAppBarState createState() => ProfileAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class ProfileAppBarState extends State<ProfileAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
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
    );
  }
}
