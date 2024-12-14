import 'package:flutter/material.dart';

class CustomListView extends StatelessWidget {
  const CustomListView({super.key,required this.itemCount, required this.itemBuilder, this.isVertical=true, this.padding= EdgeInsets.zero, this.physics= const BouncingScrollPhysics(), this.controller});

  final Widget? Function(BuildContext,int) itemBuilder;
  final int itemCount;
  final EdgeInsetsGeometry padding;
  final bool isVertical;
  final ScrollPhysics physics;

  final ScrollController? controller;
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: itemCount,
        shrinkWrap: true,
        padding: padding,
        physics: physics,
        controller: controller,
        scrollDirection: isVertical ? Axis.vertical : Axis.horizontal,
        itemBuilder: itemBuilder
    );
  }
}