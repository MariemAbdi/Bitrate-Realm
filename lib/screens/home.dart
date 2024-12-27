import 'package:bitrate_realm/services/firebase_auth_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../widgets/home/categories_list.dart';
import '../../widgets/home/home_app_bar.dart';
import '../../widgets/utils/live_list.dart';
import '../../widgets/home/users_list.dart';
import '../providers/navigation_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  String _selectedCategory = "null";

  _updateCategory(String category){
    setState(() {
      _selectedCategory = category;
    });
  }

  _seeAllLives()=>context.read<NavigationProvider>().updateIndex(1);

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: const HomeAppBar(),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const UsersList(),
              CategoriesList(
                  selectedCategory: _selectedCategory,
                  updateCategory: _updateCategory
              ),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                    onPressed: _seeAllLives,
                    child: Text("See All", style: context.textTheme.displaySmall?.copyWith(fontSize: 12))
                ),
              ),
              LiveList(
                userId: FirebaseAuthServices().user!.email!,
                selectedCategory: _selectedCategory,
                limit: 20,
              )
            ],
          ),
        ),
      ),
    );
  }
}
