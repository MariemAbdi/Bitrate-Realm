import 'package:bitrate_realm/constants/spacing.dart';
import 'package:bitrate_realm/widgets/utils/live_list.dart';
import 'package:bitrate_realm/widgets/profile/profile_header.dart';
import 'package:bitrate_realm/widgets/home/categories_list.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        body: CustomScrollView(
          slivers: [
            // Add your sliver app bar or header
            // SliverToBoxAdapter(
            //   child: ProfileHeader(), // Replace with your profile header widget
            // ),

            ProfileHeader(),

            // CategoriesList wrapped in SliverToBoxAdapter
            SliverToBoxAdapter(
              child: CategoriesList(),
            ),

            // Vertical space
            SliverToBoxAdapter(
              child: kVerticalSpace, // Replace with your spacing widget or constant
            ),

            // LiveList wrapped in SliverList or SliverToBoxAdapter
            SliverList(
              delegate: SliverChildBuilderDelegate(
                    (context, index) {
                  return LiveList(); // Replace with your dynamic list widget
                },
                childCount: 1, // Update child count as needed
              ),
            ),
          ],
        )

    );
  }
}
