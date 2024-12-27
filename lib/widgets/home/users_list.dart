import 'package:bitrate_realm/config/assets_paths.dart';
import 'package:bitrate_realm/config/routing.dart';
import 'package:bitrate_realm/models/user.dart';
import 'package:bitrate_realm/services/firebase_auth_services.dart';
import 'package:bitrate_realm/services/user_services.dart';
import 'package:bitrate_realm/widgets/utils/square_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../config/app_style.dart';
import '../utils/custom_async_builder.dart';
import '../utils/custom_list.dart';
import '../utils/custom_outlined_button.dart';

class UsersList extends StatefulWidget {
  const UsersList({Key? key, this.goToProfile = true}) : super(key: key);

  final bool goToProfile;
  @override
  UsersListState createState() => UsersListState();
}

class UsersListState extends State<UsersList> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
              onPressed: ()=>seeAllUsers(widget.goToProfile),
              child: Text("See All", style: context.textTheme.displaySmall?.copyWith(fontSize: 12))
          ),
        ),

        CustomAsyncBuilder(
            stream: UserServices().getAllUsers(FirebaseAuthServices().user!.email!),
            builder: (context, users){
              List<UserModel> usersList = users!;
              return CustomListView(
                  height: 100,
                  itemCount: usersList.length,
                  itemBuilder: (context, index){
                    UserModel user = usersList[index];
                    return InkWell(
                      onTap: ()=> widget.goToProfile ? profileNavigation(user.email) : discussionNavigation(user),
                      child: Padding(
                          padding: const EdgeInsets.only(right: 5),
                          child: Column(
                            children: [
                              Expanded(
                                  child: Stack(
                                    clipBehavior: Clip.none,
                                    children: [
                                      CustomOutlinedButton(
                                        aspectRatio: 1,
                                        borderColor: user.isLive ? Colors.redAccent : Colors.white,
                                        child: SquareImage(
                                            padding: const EdgeInsets.all(5),
                                            photoLink: user.pictureURL
                                        ),
                                      ),

                                      Visibility(
                                        visible: user.isLive,
                                        child: Positioned(
                                          top: -20,//-10
                                          left: 10, // 20
                                          child: Image.network(AssetsPaths.liveIcon, width: 50),
                                        ),
                                      )
                                    ],
                                  )
                              ),

                              Container(
                                width: 75,
                                margin: const EdgeInsets.symmetric(vertical: 3),
                                padding: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: MyThemes.primaryColor.withOpacity(0.75),
                                ),
                                child: Text(user.username, style: context.textTheme.titleSmall?.copyWith(overflow: TextOverflow.ellipsis, fontSize: 10), textAlign: TextAlign.center),
                              )
                            ],
                          )
                      ),
                    );
                  }
              );
            }
        ),
      ],
    );
  }
}
