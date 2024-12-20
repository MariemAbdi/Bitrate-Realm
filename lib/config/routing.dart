import 'package:bitrate_realm/screens/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../screens/about_us.dart';
import '../screens/contact_us.dart';
import '../screens/edit_profile.dart';
import '../screens/settings_screen.dart';
import '../screens/navigation.dart';
import '../screens/profile.dart';
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

void homeNavigation(){
  goTo(const NavigationScreen());
}

void profileNavigation(){
  goTo(const ProfileScreen());
}

void editProfileNavigation(){
  goTo(const EditProfile());
}

void aboutUsNavigation(){
  goTo(const AboutUs());
}

void contactUsNavigation(){
  goTo(const ContactUs());
}

void settingsNavigation(){
  goTo(const SettingsScreen());
}

void loginNavigation(){
  goTo(const LoginScreen());
}

void searchNavigation(){
  goTo(const SearchScreen());
}

void signUpNavigation(){
  goTo(const RegistrationScreen());
}

void forgotPasswordNavigation(){
  goTo(const ForgotPasswordScreen());
}


