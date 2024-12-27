import 'package:bitrate_realm/constants/about_us.dart';
import 'package:flutter/material.dart';

import '../utils/custom_list.dart';
import '../utils/custom_outlined_button.dart';

class AboutUsTab extends StatelessWidget {
  const AboutUsTab({Key? key, required this.onPressed, required this.currentIndex}) : super(key: key);

  final void Function(int) onPressed;
  final int currentIndex;
  @override
  Widget build(BuildContext context) {
    return CustomListView(
        height: 50,
        itemCount: aboutUsList.length,
        itemBuilder: (context, index){
          return CustomOutlinedButton(
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.all(10),
              isSelected: index == currentIndex,
              onPressed: ()=>onPressed(index),
              child: Text(aboutUsList[index].tabTitle)
          );
        }
    );
  }
}
