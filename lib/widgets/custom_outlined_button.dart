import 'package:flutter/material.dart';

class CustomOutlinedButton extends StatelessWidget {
  const CustomOutlinedButton({Key? key, this.onPressed, required this.child, this.aspectRatio = 1}) : super(key: key);

  final void Function()? onPressed;
  final Widget child;
  final double aspectRatio;
  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: aspectRatio,
      child: OutlinedButton(
          onPressed: onPressed,
          style: OutlinedButton.styleFrom(
            padding: EdgeInsets.zero// Ensure it's a square button
          ),
          child: child
      ),
    );
  }
}
