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
            const ProfileHeader(),

            // CategoriesList wrapped in SliverToBoxAdapter
            const SliverToBoxAdapter(
              child: CategoriesList(),
            ),

            // Vertical space
            const SliverToBoxAdapter(
              child: kVerticalSpace,
            ),

            // LiveList wrapped in SliverList or SliverToBoxAdapter
            SliverList(
              delegate: SliverChildBuilderDelegate(
                    (context, index) {
                  return const LiveList(); // Replace with your dynamic list widget
                },
                childCount: 1, // Update child count as needed
              ),
            ),
          ],
        )

    );
  }
}
