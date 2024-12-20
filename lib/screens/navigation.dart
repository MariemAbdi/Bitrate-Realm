import 'dart:ui';

import 'package:flutter/material.dart';

import '../config/responsiveness.dart';
import '../constants/decorations.dart';
import '../constants/nav_bar.dart';


class NavigationScreen extends StatefulWidget {
  const NavigationScreen({Key? key}) : super(key: key);

  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}
class _NavigationScreenState extends State<NavigationScreen>{
  int selectedIndex = 0;
  updateIndex(int index){
    setState(() {
      selectedIndex = index;
    });
  }
  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: false,
        child: Scaffold(
          extendBody: true,//used to remove white background behind navbar
        body: navigationScreens[selectedIndex],
        bottomNavigationBar: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: 20,
              sigmaY: 20,
            ),
            child: Container(
              margin: const EdgeInsets.all(20),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              alignment: Alignment.center,
              width: Responsiveness.deviceWidth(context),
              height: 70,
              decoration: kBlurryContainerDecoration,
              child: NavigationBar(
                animationDuration: const Duration(seconds: 1),
                selectedIndex: selectedIndex,
                onDestinationSelected: updateIndex,
                destinations: navigationDestinations
              ),
            ),
          ),
        ),
      )
    );
  }
}



