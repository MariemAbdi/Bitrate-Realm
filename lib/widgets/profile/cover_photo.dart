import 'package:bitrate_realm/config/assets_paths.dart';
import 'package:flutter/material.dart';

class CoverPhoto extends StatelessWidget {
  const CoverPhoto({Key? key, required this.photoLink}) : super(key: key);

  final String? photoLink;
  @override
  Widget build(BuildContext context) {
    return Image.network(
      photoLink ?? "https://cdn.pixabay.com/photo/2018/06/21/20/22/lighting-3489394_1280.jpg",
      fit: BoxFit.cover, // Ensures the image covers the area without exceeding
      loadingBuilder: (context, child, loadingProgress) {
        // Show a loading widget while the image is loading
        if (loadingProgress == null) {
          return child; // Image is fully loaded
        }
        return Center(
          child: CircularProgressIndicator(
            value: loadingProgress.expectedTotalBytes != null
                ? loadingProgress.cumulativeBytesLoaded / (loadingProgress.expectedTotalBytes ?? 1)
                : null,
          ),
        );
      },
      errorBuilder: (context, error, stackTrace) {
        // Show an error widget if the image fails to load
        return Image.asset(AssetsPaths.coverPlaceholder);
      },
    );
  }
}
