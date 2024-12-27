import 'package:bitrate_realm/models/live_stream.dart';
import 'package:bitrate_realm/models/user.dart';
import 'package:bitrate_realm/screens/chat/discussion.dart';
import 'package:bitrate_realm/screens/chat/list_of_users.dart';
import 'package:bitrate_realm/screens/notifications.dart';
import 'package:bitrate_realm/screens/profile/followers.dart';
import 'package:bitrate_realm/screens/profile/following.dart';
import 'package:bitrate_realm/screens/settings/privacy.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../screens/live/broadcast_screen.dart';
import '../screens/authentication/forgot_password.dart';
import '../screens/authentication/login.dart';
import '../screens/authentication/registration.dart';
import '../screens/settings/about_us.dart';
import '../screens/settings/contact_us.dart';
import '../screens/settings/edit_profile.dart';
import '../screens/settings_screen.dart';
import '../screens/navigation.dart';
import '../screens/profile/profile.dart';

void goTo(Widget route){
  Navigator.push(Get.context!,
      MaterialPageRoute(builder: (context)=> route
      )
  );
}

void homeNavigation(){
  goTo(const NavigationScreen());
}

void notificationsNavigation(){
  goTo(const NotificationsScreen());
}

void seeAllUsers(bool goToProfile){
  goTo( ListOfUsers(goToProfile: goToProfile));
}
void broadcastNavigation(bool isBroadcaster, LiveStream liveStream){
  goTo( BroadcastScreen(isBroadcaster: isBroadcaster, liveStream: liveStream));
}

void profileNavigation(String id){
  goTo( ProfileScreen(userId: id));
}

void followingNavigation(String id){
  goTo( FollowingScreen(userId: id));
}

void followersNavigation(String id){
  goTo( FollowersScreen(userId: id));
}

void discussionNavigation(UserModel receiver){
  goTo( DiscussionScreen(receiver: receiver));
}

void settingsNavigation(){
  goTo(const SettingsScreen());
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

void privacyPolicyNavigation(){
  goTo(const Privacy());
}
void loginNavigation(){
  goTo(const LoginScreen());
}
void signUpNavigation(){
  goTo(const RegistrationScreen());
}

void forgotPasswordNavigation(){
  goTo(const ForgotPasswordScreen());
}


