import 'package:bitrate_realm/widgets/utils/live_list.dart';
import 'package:bitrate_realm/widgets/home/users_list.dart';
import 'package:flutter/material.dart';
import 'package:bitrate_realm/widgets/home/categories_list.dart';

import '../../widgets/custom_outlined_button.dart';
import '../../widgets/home/home_app_bar.dart';
import '../../widgets/utils/custom_list.dart';
import '../config/app_style.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //FirebaseStorageServices _firebaseStorageServices = FirebaseStorageServices();

  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {

    return const Scaffold(
      appBar: HomeAppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              UsersList(),
              CategoriesList(),
              LiveList()
            ],
          ),
        ),
      ),
    );
  }
}
