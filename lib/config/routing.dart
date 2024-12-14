import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:livestream/screens/Settings/settings_screen.dart';
import 'package:livestream/screens/navigation.dart';
import 'package:livestream/screens/profile.dart';

import '../screens/forgot_password.dart';
import '../screens/login.dart';
import '../screens/registration.dart';

BuildContext _context = Get.context!;

void popRoute(BuildContext context){
  Navigator.of(context).pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
}

void goTo(Widget route){
  Navigator.push(_context,
      MaterialPageRoute(builder: (context)=> route
      )
  );
}

homeNavigation(){
  goTo(const NavigationScreen());
}

profileNavigation(){
  goTo(const ProfileScreen());
}

settingsNavigation(){
  goTo(const SettingsScreen());
}

loginNavigation(){
  goTo(const LoginScreen());
}

signUpNavigation(){
  goTo(const RegistrationScreen());
}

forgotPasswordNavigation(){
  goTo(const ForgotPasswordScreen());
}


