import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Resources/firebase_auth_methods.dart';
import '../../translations/locale_keys.g.dart';
import 'profile_screen.dart';
import 'discover_screen.dart';
import 'following_screen.dart';
import 'search_screen.dart';

class Home extends StatefulWidget {
  static String routeName = '/home';
  late  int selectedIndex;
  Home({Key? key, required this.selectedIndex}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home>{
  @override
  Widget build(BuildContext context) {
    final screens=[
      const FollowingScreen(),
      const DiscoverScreen(),
      const SearchScreen(),
      ProfileScreen(id: context.read<FirebaseAuthMethods>().user.email!, nickname: "",)
    ];

    return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
        body: screens[widget.selectedIndex],
        bottomNavigationBar:  NavigationBar(
          animationDuration: const Duration(seconds: 1),
          height: 70,
          selectedIndex: widget.selectedIndex,
          onDestinationSelected: (index){
            setState(() {
              widget.selectedIndex = index;
            });
          },
          destinations: [
            NavigationDestination(icon: Image.asset("assets/icons/following-outlined.png",width: 25,),selectedIcon: Image.asset("assets/icons/following.png",width: 20,), label: LocaleKeys.following.tr()),
            NavigationDestination(icon: Image.asset("assets/icons/discover-outlined.png",width: 25,),selectedIcon: Image.asset("assets/icons/discover.png",width: 20,),label: LocaleKeys.discover.tr(),),
            NavigationDestination(icon: Image.asset("assets/icons/search-outlined.png",width: 25,),selectedIcon: Image.asset("assets/icons/search.png",width: 20,), label: LocaleKeys.search.tr()),
            NavigationDestination(icon: Image.asset("assets/icons/avatar-outlined.png",width: 25,), selectedIcon: Image.asset("assets/icons/avatar.png",width: 25,), label: LocaleKeys.profile.tr()),
          ],

        ),
      )
    );
  }


}



