import 'package:flutter/material.dart';

class CustomListView extends StatelessWidget {
  const CustomListView({super.key,required this.itemCount, required this.itemBuilder, this.isVertical, this.padding= EdgeInsets.zero, this.physics= const BouncingScrollPhysics(), this.controller});

  final Widget? Function(BuildContext,int) itemBuilder;
  final int itemCount;
  final EdgeInsetsGeometry padding;
  final double? isVertical;
  final ScrollPhysics physics;

  final ScrollController? controller;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: isVertical ?? 200,
      child: ListView.builder(
          itemCount: itemCount,
          shrinkWrap: true,
          padding: padding,
          physics: physics,
          controller: controller,
          scrollDirection: isVertical==null ? Axis.vertical : Axis.horizontal,
          itemBuilder: itemBuilder
      ),
    );
  }
}