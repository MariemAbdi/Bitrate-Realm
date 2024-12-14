import 'package:flutter/material.dart';
import 'package:livestream/widgets/profile/profile_app_bar.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>{

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: ProfileAppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0, bottom: 30),
            child: Column(
              children: [



              ],
            ),
          ),
        ),
      ),
    );
  }
}

