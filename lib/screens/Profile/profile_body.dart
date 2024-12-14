import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../config/app_style.dart';
import '../../translations/locale_keys.g.dart';
import 'followers_page.dart';
import 'videos_page.dart';

class ProfileBody extends StatefulWidget {
  final String id;
  const ProfileBody({Key? key, required this.id}) : super(key: key);

  @override
  State<ProfileBody> createState() => _ProfileBodyState();
}

class _ProfileBodyState extends State<ProfileBody> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [

            //TAB BAR
            Container(
              height: 45,
              constraints: const BoxConstraints(maxWidth: 400),
              decoration: BoxDecoration(borderRadius: const BorderRadius.all(Radius.circular(20),),
                border: Border.all(color: const Color(0xFFD5D5D5)),
              ),
              child: TabBar(
                labelColor: Colors.white,
                indicator: BoxDecoration(
                    color: MyThemes.primaryLight,
                    borderRadius:  BorderRadius.circular(25.0)
                ),
                tabs: [
                  Tab(text: LocaleKeys.videosSearch.tr(),),
                  Tab(text: LocaleKeys.followers.tr(),),
                  Tab(text: LocaleKeys.following.tr(),),
                ],
              ),
            ),

            const SizedBox(height: 15,),

            //TAB BAR CONTENT
            Container(
                height: MediaQuery.of(context).size.height, // Full screen size
                constraints: const BoxConstraints(maxWidth: 400),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(borderRadius: const BorderRadius.all(Radius.circular(20),),
                  border: Border.all(color: const Color(0xFFD5D5D5)),
                ),
              child: TabBarView(
                children:  [
                  VideosPage(userId: widget.id,),
                  FollowersPage(userId: widget.id, collection: 'followers',),
                  FollowersPage(userId: widget.id, collection: 'following',),
                ],
              ),
            )

            ],
        ),
      ),
    );
  }
}