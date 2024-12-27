import 'package:crystal_navigation_bar/crystal_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/nav_bar.dart';
import '../providers/navigation_provider.dart';

class NavigationScreen extends StatelessWidget {
  const NavigationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<NavigationProvider>(
      builder: (context, navigationProvider, _) {
        return Scaffold(
          resizeToAvoidBottomInset: true,
          extendBody: true,
          body: navigationScreens[navigationProvider.selectedIndex], // Bind to provider's index
          floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
          floatingActionButton: CrystalNavigationBar(
            currentIndex: navigationProvider.selectedIndex, // Bind to provider
            unselectedItemColor: Colors.white70,
            borderRadius: 10,
            height: 70,
            enableFloatingNavBar: true,
            enablePaddingAnimation: true,
            backgroundColor: Colors.black.withOpacity(0.1),
            outlineBorderColor: Colors.black.withOpacity(0.1),
            onTap: (index) => navigationProvider.updateIndex(index), // Update the index
            items: navigationDestinations,
          ),
        );
      },
    );
  }
}
