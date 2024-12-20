import 'package:bitrate_realm/widgets/utils/square_image.dart';
import 'package:flutter/material.dart';

import '../../providers/user_provider.dart';
import 'loading_wrapper.dart';

class UserInfoTile extends StatelessWidget {
  const UserInfoTile({Key? key, this.isSmall = true}) : super(key: key);

  final bool isSmall;
  @override
  Widget build(BuildContext context) {
    return LoadingWrapper<UserProvider>(
        builder: (context, userProvider) => ListTile(
              dense: isSmall,
              contentPadding: EdgeInsets.zero,
              leading: SquareImage(photoLink: userProvider.user?.pictureURL),
              title: Text(userProvider.user?.username ?? "",
                  style: TextStyle(
                      color: Colors.white,
                      overflow: TextOverflow.ellipsis,
                      fontSize: isSmall ? 14 : 20,
                      fontWeight: FontWeight.w600)),
              subtitle: Text("950 followers",
                  style: TextStyle(
                      color: Colors.grey.withOpacity(0.8),
                      overflow: TextOverflow.ellipsis,
                      fontSize: 12)),
            ));
  }
}
