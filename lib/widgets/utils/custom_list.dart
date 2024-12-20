import 'package:flutter/material.dart';

class CustomListView extends StatelessWidget {
  const CustomListView({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    this.height,
    this.padding = const EdgeInsets.symmetric(horizontal: 20),
    this.physics= const ClampingScrollPhysics(),
  });

  final Widget? Function(BuildContext,int) itemBuilder;
  final int itemCount;
  final EdgeInsetsGeometry padding;
  final double? height;
  final ScrollPhysics physics;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: ListView.builder(
          itemCount: itemCount,
          shrinkWrap: true,
          padding: padding,
          physics: physics,
          scrollDirection: height==null ? Axis.vertical : Axis.horizontal,
          itemBuilder: itemBuilder
      ),
    );
  }
}