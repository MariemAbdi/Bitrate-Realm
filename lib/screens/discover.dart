import 'package:bitrate_realm/constants/spacing.dart';
import 'package:bitrate_realm/widgets/home/categories_list.dart';
import 'package:bitrate_realm/widgets/input/send_input.dart';
import 'package:bitrate_realm/widgets/utils/custom_app_bar.dart';
import 'package:bitrate_realm/widgets/utils/live_list.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../services/firebase_auth_services.dart';
import '../translations/locale_keys.g.dart';

class DiscoverScreen extends StatefulWidget {
  const DiscoverScreen({Key? key}) : super(key: key);

  @override
  State<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> {

  String _selectedCategory = "null";
  late TextEditingController _searchController;
  String _searchText="";

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _makeSearch(String searchText) {
    setState(() {
      _searchText = searchText;
    });
  }

  _updateCategory(String category){
    setState(() {
      _selectedCategory = category;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: LocaleKeys.discover.tr(), canGoBack: false),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            SendInput(
              controller: _searchController,
              onConfirm: _makeSearch,
            ),

           // CustomSearchBar(controller: _searchController, onConfirm: _makeSearch),
            kVerticalSpace,

            CategoriesList(
                updateCategory: _updateCategory,
                selectedCategory: _selectedCategory
            ),
            kSmallVerticalSpace,

            LiveList(
                selectedCategory: _selectedCategory,
                searchedTerm: _searchText,
                userId: FirebaseAuthServices().user!.email!,
            )

          ],
        ),
      ),
    );
  }
}