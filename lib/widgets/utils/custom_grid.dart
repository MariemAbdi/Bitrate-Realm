import 'package:flutter/material.dart';

class CustomGridView extends StatelessWidget {
  const CustomGridView({super.key, this.bottomPadding = true, this.fixedCrossAxis=0, this.aspectRatio=1/1, required this.itemCount, required this.itemBuilder});

  final bool bottomPadding;
  final Widget? Function(BuildContext,int) itemBuilder;
  final int itemCount,fixedCrossAxis;
  final double aspectRatio;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: bottomPadding?const EdgeInsets.only(top: 0, left: 0, right: 0, bottom: 60):EdgeInsets.zero,
        gridDelegate: fixedCrossAxis!=0
            ?SliverGridDelegateWithFixedCrossAxisCount(
          //mainAxisExtent: 110,
            crossAxisCount: fixedCrossAxis,
            mainAxisSpacing: 5,
            crossAxisSpacing: 5
        )
            :SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 200,
            childAspectRatio: aspectRatio,
            crossAxisSpacing: 5,
            mainAxisSpacing: 5),
        itemCount: itemCount,
        itemBuilder: itemBuilder);
  }
}