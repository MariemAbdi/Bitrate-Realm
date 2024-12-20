import 'package:bitrate_realm/config/app_style.dart';
import 'package:flutter/material.dart';

class CustomOutlinedButton extends StatelessWidget {
  const CustomOutlinedButton({Key? key, this.onPressed, required this.child, this.aspectRatio, this.isSelected = false}) : super(key: key);

  final void Function()? onPressed;
  final Widget child;
  final double? aspectRatio;
  final bool isSelected;
  @override
  Widget build(BuildContext context) {
    return aspectRatio != null
        ? AspectRatio(
      aspectRatio: aspectRatio!,
      child: OutlinedButton(
          onPressed: onPressed,
          style: OutlinedButton.styleFrom(
            padding: EdgeInsets.zero,// Ensure it's a square button
            backgroundColor: isSelected ? MyThemes.primaryColor: null
          ),
          child: child
      ),
    )
    : OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
            backgroundColor: isSelected ? MyThemes.primaryColor: null
        ),
        child: child
    );
  }
}
