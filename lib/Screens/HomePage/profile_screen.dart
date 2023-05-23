import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:livestream/Screens/Profile/profile_body.dart';
import 'package:livestream/Screens/Profile/profile_header.dart';
import 'package:livestream/Widgets/my_appbar.dart';
import 'package:provider/provider.dart';

import '../../Resources/firebase_auth_methods.dart';
import '../../translations/locale_keys.g.dart';
import '../Settings/settings_screen.dart';

class ProfileScreen extends StatefulWidget {
  static String routeName = '/profile';

  final String id;
  final String nickname;
  const ProfileScreen({Key? key, required this.id, required this.nickname}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>{

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
          implyLeading: widget.id == context.read<FirebaseAuthMethods>().user.email!? false : true,
          title: widget.id == context.read<FirebaseAuthMethods>().user.email!?LocaleKeys.profile.tr():widget.nickname,
          action: //SETTINGS BUTTON
          Visibility(
            visible: widget.id == context.read<FirebaseAuthMethods>().user.email!,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(onPressed: () {
                  Navigator.pushNamed(context, SettingsScreen.routeName);
                }, icon: const Icon(Icons.settings)),
              ],
            ),),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0, bottom: 30),
            child: Column(
              children: [

                //HEADER
                ProfileHeader(id: widget.id,),
                const SizedBox(height: 16),

                //BODY
                ProfileBody(id: widget.id,),

              ],
            ),
          ),
        ),
      ),
    );
  }
}

