import 'package:flutter/material.dart';

///Prefix constants with k (e.g., kDefaultPadding) to distinguish them from variables.
final kBlurryContainerDecoration = BoxDecoration(
  borderRadius: BorderRadius.circular(20),
  gradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Colors.white.withOpacity(0.1),
        Colors.white.withOpacity(0.05),
      ],
      stops: const [0.1, 1]
  ),
);