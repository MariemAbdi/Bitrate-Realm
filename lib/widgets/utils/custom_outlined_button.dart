import 'package:bitrate_realm/config/app_style.dart';
import 'package:flutter/material.dart';

class CustomOutlinedButton extends StatelessWidget {
  const CustomOutlinedButton({
    Key? key,
    this.onPressed,
    required this.child,
    this.aspectRatio,
    this.isSelected = false,
    this.borderColor = Colors.white,
    this.padding = EdgeInsets.zero,
    this.margin = EdgeInsets.zero,
  }) : super(key: key);

  final void Function()? onPressed;
  final Widget child;
  final double? aspectRatio;
  final bool isSelected;
  final Color borderColor;
  final EdgeInsetsGeometry padding, margin;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: margin,
      child: aspectRatio != null
          ? AspectRatio(
        aspectRatio: aspectRatio!,
        child: OutlinedButton(
            onPressed: onPressed,
            style: OutlinedButton.styleFrom(
                padding: padding,// Ensure it's a square button
                backgroundColor: isSelected ? MyThemes.primaryColor: null,
                side: BorderSide(color: isSelected ? MyThemes.primaryColor : borderColor)
            ),
            child: child
        ),
      )
          : OutlinedButton(
          onPressed: onPressed,
          style: OutlinedButton.styleFrom(
              padding: padding,
              backgroundColor: isSelected ? MyThemes.primaryColor: null,
              side: BorderSide(color: isSelected ? MyThemes.primaryColor : borderColor)
          ),
          child: child
      ),
    );
  }
}
