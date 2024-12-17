import 'package:bitrate_realm/widgets/utils/user_info_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../../config/app_style.dart';

class LiveList extends StatelessWidget {
  const LiveList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<String> imageUrls = [
      "https://cdn.pixabay.com/photo/2022/11/10/07/15/portrait-7582123_640.jpg",
      "https://cdn.pixabay.com/photo/2015/04/23/22/00/tree-736885_960_720.jpg",
      "https://cdn.pixabay.com/photo/2013/07/21/13/00/rose-165819_960_720.jpg",
      "https://cdn.pixabay.com/photo/2022/11/10/07/15/portrait-7582123_640.jpg",
      "https://cdn.pixabay.com/photo/2015/04/23/22/00/tree-736885_960_720.jpg",
      "https://cdn.pixabay.com/photo/2013/07/21/13/00/rose-165819_960_720.jpg",
      "https://cdn.pixabay.com/photo/2022/11/10/07/15/portrait-7582123_640.jpg",
      "https://cdn.pixabay.com/photo/2015/04/23/22/00/tree-736885_960_720.jpg",
      "https://cdn.pixabay.com/photo/2013/07/21/13/00/rose-165819_960_720.jpg",
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: StaggeredGrid.count(
        crossAxisCount: 2, // 2 columns
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        children: imageUrls.map((photo) {
          return Column(
            children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      photo,
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
                            padding: const EdgeInsets.symmetric(
                                horizontal: 5, vertical: 2),
                            decoration: BoxDecoration(
                                color: MyThemes.secondaryColor,
                                borderRadius: BorderRadius.circular(10)),
                            child: const Row(
                              children: [
                                Icon(Icons.remove_red_eye, size: 15),
                                Text(
                                  " 10K",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 12),
                                )
                              ],
                            ),
                          ),

                          const Icon(Icons.circle, color: Colors.red, size: 20)
                        ],
                      )),
                ],
              ),
              Container(
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(vertical: 3),
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: MyThemes.primaryColor.withOpacity(0.75),
                  ),
                  child: const UserInfoTile())
            ],
          );
        }).toList(),
        //staggeredTileBuilder: (index) => StaggeredTile.fit(1), // Adapts to image height
      ),
    );
  }
}
