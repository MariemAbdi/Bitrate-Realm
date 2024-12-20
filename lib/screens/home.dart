import 'package:flutter/material.dart';

import '../../widgets/home/categories_list.dart';
import '../../widgets/home/home_app_bar.dart';
import '../../widgets/utils/live_list.dart';
import '../../widgets/home/users_list.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
