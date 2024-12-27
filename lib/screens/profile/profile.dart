import 'package:bitrate_realm/constants/spacing.dart';
import 'package:bitrate_realm/widgets/utils/live_list.dart';
import 'package:bitrate_realm/widgets/profile/profile_header.dart';
import 'package:bitrate_realm/widgets/home/categories_list.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key, required this.userId}) : super(key: key);

  final String userId;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  String _selectedCategory = "null";

  _updateCategory(String category){
    setState(() {
      _selectedCategory = category;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        body: CustomScrollView(
          slivers: [
            ProfileHeader(userId: widget.userId),

            // Vertical space
            const SliverToBoxAdapter(
              child: kVerticalSpace,
            ),

            //CategoriesList wrapped in SliverToBoxAdapter
            SliverToBoxAdapter(
              child: CategoriesList(
                selectedCategory: _selectedCategory,
                updateCategory: _updateCategory,
              ),
            ),

            // Vertical space
            const SliverToBoxAdapter(
              child: kVerticalSpace,
            ),

            // LiveList wrapped in SliverList or SliverToBoxAdapter
            SliverList(
              delegate: SliverChildBuilderDelegate(
                    (context, index)
                => LiveList(
                  userId: widget.userId,
                  selectedCategory: _selectedCategory,
                  getMine: true,
                ),
                childCount: 1, // Update child count as needed
              ),
            ),
          ],
        )

    );
  }
}
