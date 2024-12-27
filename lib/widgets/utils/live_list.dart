import 'package:bitrate_realm/config/responsiveness.dart';
import 'package:bitrate_realm/config/utils.dart';
import 'package:bitrate_realm/constants/decorations.dart';
import 'package:bitrate_realm/constants/spacing.dart';
import 'package:bitrate_realm/models/live_stream.dart';
import 'package:bitrate_realm/services/category_services.dart';
import 'package:bitrate_realm/services/livestream_services.dart';
import 'package:bitrate_realm/services/user_services.dart';
import 'package:bitrate_realm/widgets/utils/custom_async_builder.dart';
import 'package:bitrate_realm/widgets/utils/nothing_to_show.dart';
import 'package:bitrate_realm/widgets/utils/user_info_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:substring_highlight/substring_highlight.dart';

import '../../config/app_style.dart';

class LiveList extends StatelessWidget {
  const LiveList({Key? key, required this.selectedCategory, this.getMine = false, required this.userId, this.limit, this.searchedTerm = ""}) : super(key: key);

  final String userId, selectedCategory, searchedTerm;
  final bool getMine;
  final int? limit;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
      child: CustomAsyncBuilder(
        stream: getMine
            ? LiveStreamServices().getUserLives(userId, selectedCategory)
            : LiveStreamServices().getAllLives(userId, selectedCategory, limit: limit),
        builder: (context, liveStreams) {
          List<LiveStream> livesList = liveStreams ?? [];

          // Filter the list based on the searched term in the title
          var filteredList = livesList.where((liveStream) {
            return liveStream.title.toLowerCase().contains(searchedTerm.toLowerCase());
          }).toList();

          if (filteredList.isEmpty) {
            return const NothingToShow();
          }

          // Display the filtered results in a staggered grid
          return StaggeredGrid.count(
            crossAxisCount: Responsiveness.isMobile(context) ? 2 : 4, // Number of columns
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            children: filteredList.map((liveStream) {
              return Column(
                children: [
                  Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          liveStream.thumbnailLink!,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        top: 10,
                        right: 10,
                        left: 10,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                              decoration: kGrayContainer,
                              child: Row(
                                children: [
                                  Text(
                                    "${formatFollowersNumber(liveStream.views)} ",
                                    style: context.textTheme.headlineSmall,
                                  ),
                                  const Icon(Icons.remove_red_eye, size: 14),
                                ],
                              ),
                            ),
                            Visibility(
                              visible: liveStream.isLive,
                              child: const Icon(Icons.circle, color: Colors.red, size: 20),
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        bottom: 10,
                        left: 10,
                        right: 10,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomAsyncBuilder(
                              future: CategoryServices().getCategory(liveStream.category),
                              builder: (context, category) {
                                return Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                                  decoration: kGrayContainer,
                                  child: Text(
                                    category!.title,
                                    style: context.textTheme.headlineSmall?.copyWith(fontSize: 12),
                                  ),
                                );
                              },
                            ),
                            kSmallVerticalSpace,
                            SubstringHighlight(
                              text: liveStream.title,
                              term: searchedTerm,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              textStyle: context.textTheme.bodySmall!,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  CustomAsyncBuilder(
                    future: UserServices().getUserData(liveStream.streamer!),
                    builder: (context, user) {
                      return Container(
                        width: double.infinity,
                        margin: const EdgeInsets.symmetric(vertical: 3),
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: MyThemes.primaryColor.withOpacity(0.75),
                        ),
                        child: UserInfoTile(
                          user: user!,
                        ),
                      );
                    },
                  ),
                ],
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
